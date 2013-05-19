Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab3ESLPC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 07:15:02 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:46677 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab3ESLPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 07:15:00 -0400
MIME-Version: 1.0
X-Originating-IP: [1.167.67.37]
In-Reply-To: <CAHp75Vc6U00XvTN91Q=NFKncZSuVNdbC8wPPH-0DdpxQV7UZAA@mail.gmail.com>
References: <1368943851.3455.8.camel@phoenix>
	<CAHp75Vc6U00XvTN91Q=NFKncZSuVNdbC8wPPH-0DdpxQV7UZAA@mail.gmail.com>
Date: Sun, 19 May 2013 19:14:59 +0800
Message-ID: <CAFRkauCDBtubvZs7nZ9-jAJmiJbKWJFZ0OaO_5ofYt17udV0Zw@mail.gmail.com>
Subject: Re: [PATCH] gpio: mcp23s08: Fix build error when CONFIG_SPI_MASTER=y
 && CONFIG_I2C=m
From: Axel Lin <axel.lin@ingics.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <poeschel@lemonage.de>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> --- a/drivers/gpio/Kconfig
>> +++ b/drivers/gpio/Kconfig
>> @@ -636,7 +636,7 @@ config GPIO_MAX7301
>>
>>  config GPIO_MCP23S08
>>         tristate "Microchip MCP23xxx I/O expander"
>> -       depends on SPI_MASTER || I2C
>> +       depends on (SPI_MASTER && I2C!=m) || I2C
>
> For me it looks like the result of the following will be the same
>   depends on (SPI_MASTER && !I2C) || I2C

Yes, I think the result is the same.

I just send a v2.
So you can Ack the version you prefer.

Thanks for the review.
Axel
