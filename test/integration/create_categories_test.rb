require 'test_helper'

class CreateCategoriesTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(username: "john", email: "john@example.com", password: "password", admin: true)
    sign_in_as(@user, "password")
  end

  test "get new category form and create category" do
    get "/categories/new"
    assert_response :success

    assert_difference 'Category.count', 1 do
      post "/categories",
            params: {category: {name: "sports"}}
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_match "sports", response.body
  end

  test "invalid category submission results in failure"  do
    get "/categories/new"
    assert_response :success

    assert_no_difference 'Category.count' do
      post "/categories",
            params: {category: {name: " "}}
    end
    assert_template 'categories/new'
    assert_select "div.card-header"
    assert_select "div.card-body"
  end
end
