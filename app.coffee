moment = require 'moment'
rest = require 'restler'

# USER INPUTS
days = 7
access_token = 'INSERT_ACCESS_TOKEN'
output = []

# Calculate time period
period = 1000 * 60 * 60 * 24 * days
now = moment().valueOf()
start = now - period

# Get all the data, and then process it
rest.get('https://api.trycelery.com/v1/orders?access_token=' + access_token + "&since=" + start).on 'complete', (data) ->
  filter order for order in data.orders
  console.log output.reduce (x, y) ->
    if not x[y.date]
      x[y.date] = {}
    x[y.date][y.name] = x[y.date][y.name] + y.count || 0
    x
  , {}

# Function to process the giant JSON of data coming in from Celery, so Librato doesn't choke on it.
filter = (order) ->

  for product in order.products
    output.push
      name: product.slug
      count: product.quantity
      date: moment(order.created_date).format("MMM Do YY")