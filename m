Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab3ESHzj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 03:55:39 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:45077 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab3ESHzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 03:55:38 -0400
MIME-Version: 1.0
In-Reply-To: <1368943851.3455.8.camel@phoenix>
References: <1368943851.3455.8.camel@phoenix>
Date: Sun, 19 May 2013 10:55:37 +0300
Message-ID: <CAHp75Vc6U00XvTN91Q=NFKncZSuVNdbC8wPPH-0DdpxQV7UZAA@mail.gmail.com>
Subject: Re: [PATCH] gpio: mcp23s08: Fix build error when CONFIG_SPI_MASTER=y
 && CONFIG_I2C=m
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <poeschel@lemonage.de>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 19, 2013 at 9:10 AM, Axel Lin <axel.lin@ingics.com> wrote:
> This patch fixes below build error when CONFIG_SPI_MASTER=y && CONFIG_I2C=m &&
> CONFIG_GPIO_MCP23S08=y.

> When CONFIG_I2C=m, meaning we can't build the drivers in with I2C support.
> Thus don't allow the drivers to be compiled as built-in when CONFIG_I2C=m.

> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -636,7 +636,7 @@ config GPIO_MAX7301
>
>  config GPIO_MCP23S08
>         tristate "Microchip MCP23xxx I/O expander"
> -       depends on SPI_MASTER || I2C
> +       depends on (SPI_MASTER && I2C!=m) || I2C

For me it looks like the result of the following will be the same
  depends on (SPI_MASTER && !I2C) || I2C

--
With Best Regards,
Andy Shevchenko
