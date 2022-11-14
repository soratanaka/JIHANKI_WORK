class Replenishment
  def plus(drink_name,drink_price,drink_stock)
    @drink.push({name:drink_name,price:drink_price,stock:drink_stock})
  end

  def drink_stock
    @drink.each {|hash| 
    p hash.values_at(:name,:stock)
  }
  end

  def replenishment(drink_name)
    @drink.each{|hash|
      if hash[:name] == drink_name
        puts "補充する数を入力してください。"
        drink_stock = gets.to_i
        loop{
        if drink_stock.positive?
          hash[:stock] = hash[:stock] + drink_stock
          break
        else
          puts "入力が違います。再度入力して下さい"
          drink_stock = gets.to_i
        end
        }
      end
    }
  end

  def set_drink
    loop{
      puts "ようこそ。下記が現在の在庫となります。"
      drink_stock
      p "行う動作を下記の1.2.3から入力してください(入力はナンバーでお願いします)"
      p "1:ドリンクを補充する"
      p "2:ドリンクを追加する"
      p "3:ドリンクを削除する"
      p "4:終了する"
      selection = gets.chomp
      case selection
      when "1"
        puts "ドリンクリスト："
        @drink.each {|hash|
          p hash[:name]
        }
        puts "どのドリンクを補充しますか？"
        add_drink = gets.chomp
        replenishment(add_drink)
      when "2"
        while true do
          p "追加するドリンク名を入力してください"
          name = gets.chomp
          p "ドリンクの値段を記入してください"
          price = gets.to_i
          p "ドリンクの補充数を記入してください"
          stock = gets.to_i
          p "ドリンク名:#{name}、値段：#{price}、在庫数#{stock}"
          p "上記の情報で間違い無いですか(y/n)"
          answer = gets.chomp
          if (answer == "y") then
            break
          end
        end
        plus(name,price,stock)
      when "3"
        p "削除するドリンク名を記入してください"
        delete_drink = gets.chomp
        p "#{delete_drink}でよろしいですか(y/n)"
        answer = gets.chomp
        loop{
        if answer == "y"
          @drink.delete(date_catch(delete_drink)[0])
          break
        elsif answer == "n"
          p "終了します"
          break
        else
          p "入力が違います。再度入力してください"
          answer = gets.chomp
        end
      }
      when "4"
        return "お疲れ様でした"
      else
      p "入力が違います"
      p "もう一度入力して下さい"  
      selection = gets.chomp
      end   
    }
  end
end

class  Buyandsell < Replenishment
  def drink_list #ステップ３のため作成
    @drink.each {|hash| 
    if hash[:price] <= @slot_money && hash[:stock] > 0
    p hash[:name]
    end
    }
  end

  def date_catch(drink_name)
    @drink.select{|hash| hash[:name] == drink_name }
  end

  def sell_drink(drink_name)
    hash = @drink.find {|h| h[:name].include?(drink_name)}
    if hash[:price] <= @slot_money && hash[:stock] > 0
      hash[:stock] = hash[:stock] - 1
      @slot_money -= hash[:price]
      @money_all += hash[:price]
      puts hash[:name] + "のお買い上げありがとうございます。"
    else
      puts "買えません"
    end
    puts "残り:#{@slot_money}円"
  end

  def get_judge(drink_name)
    @drink.each {|hash| 
      p hash
    if hash[:name] == drink_name && hash[:price] <= @slot_money && hash[:stock] > 0
    p "ok"
    else
    p "NO"
    end
  }
  end

  def please_choose_drink
    puts "|ドリンクリスト|"
    drink_names = @drink.map { |hash| hash[:name]}
    puts drink_names
    puts "\n"
    puts "飲み物を選んでください"
    input_drink = gets.chomp
    loop{
      if drink_names.include?(input_drink)
        return input_drink
      else
        puts "飲み物を選んでください"
        puts drink_names
        input_drink = gets.chomp
      end
    } 
  end

  def please_putting_money
    loop{
      puts "お金を投入してください。10, 50, 100, 500, 1000 が使えます。"
      input_money = gets.to_i
      loop{
        if slot_money(input_money)
          break
        else
          puts "もう一度入力してください。10, 50, 100, 500, 1000 が使えます。"
          input_money = gets.to_i
        end
      }  
      puts "続けてお金を投入する場合は「y」を押してください。しない場合はそれ以外を押してください。"
      if gets.chomp != "y"
        puts "#{current_slot_money}円投入しました"
        break
      end
    } 
  end

  def return_money
    puts @slot_money.to_s + "円のお返しです。"
    @slot_money = 0
    puts "またのご利用をお待ちしております"
  end

  def buy_drink
    please_putting_money
    loop{
      choosed_drink_name = please_choose_drink
      sell_drink(choosed_drink_name)
      puts "続けて購入する場合は「y」を押してください。しない場合はそれ以外を押してください。 "
      continue = gets.chomp
      unless continue == "y" 
        break
      end
    }
    return_money
    puts @money_all
  end
end

class VendingMachine < Buyandsell
  MONEY = [10, 50, 100, 500, 1000].freeze
  def initialize
    @drink = [{name:"cola",price:120,stock:5}]
    @money_all = 0
    @slot_money = 0
  end

  def current_slot_money
    @slot_money
  end

  def slot_money(money)
    return false unless MONEY.include?(money)
    @slot_money += money
  end

  def default
    plus("water",100,5)
    plus("redblue",200,5)
  end
end

aaa = VendingMachine.new
aaa.default
puts "購入のデモ"
aaa.buy_drink
puts "補充のデモ"
aaa.set_drink