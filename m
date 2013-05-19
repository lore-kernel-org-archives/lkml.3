Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab3ESMbt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 08:31:49 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:63547 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab3ESMbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 08:31:47 -0400
MIME-Version: 1.0
In-Reply-To: <1368961914.5122.1.camel@phoenix>
References: <1368961914.5122.1.camel@phoenix>
Date: Sun, 19 May 2013 15:31:45 +0300
Message-ID: <CAHp75Vdwzvoa_s=LPbVDogGaTX-6YOu9z8rN8NtDb8EapYY8bQ@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: mcp23s08: Fix build error when
 CONFIG_SPI_MASTER=y && CONFIG_I2C=m
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

This one I like a bit more.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

On Sun, May 19, 2013 at 2:11 PM, Axel Lin <axel.lin@ingics.com> wrote:
> This patch fixes below build error when CONFIG_SPI_MASTER=y && CONFIG_I2C=m &&
> CONFIG_GPIO_MCP23S08=y.
>
>   LD      init/built-in.o
> drivers/built-in.o: In function `mcp23017_write':
> clkdev.c:(.text+0x1e14): undefined reference to `i2c_smbus_write_word_data'
> drivers/built-in.o: In function `mcp23017_read':
> clkdev.c:(.text+0x1e24): undefined reference to `i2c_smbus_read_word_data'
> drivers/built-in.o: In function `mcp23008_write':
> clkdev.c:(.text+0x1e8c): undefined reference to `i2c_smbus_write_byte_data'
> drivers/built-in.o: In function `mcp23008_read':
> clkdev.c:(.text+0x1e98): undefined reference to `i2c_smbus_read_byte_data'
> drivers/built-in.o: In function `mcp23008_read_regs':
> clkdev.c:(.text+0x1ed0): undefined reference to `i2c_smbus_read_byte_data'
> drivers/built-in.o: In function `mcp23s08_init':
> clkdev.c:(.init.text+0x30): undefined reference to `i2c_register_driver'
> drivers/built-in.o: In function `mcp23s08_exit':
> clkdev.c:(.exit.text+0x30): undefined reference to `i2c_del_driver'
> make: *** [vmlinux] Error 1
>
> When CONFIG_I2C=m, meaning we can't build the drivers in with I2C support.
> Thus don't allow the drivers to be compiled as built-in when CONFIG_I2C=m.
>
> The real fix though is to break the driver apart into a SPI part, an I2C part
> and a common part. But that's something for 3.11 while this is something for
> 3.10/stable.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/gpio/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 87d5670..6575d77 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -636,7 +636,7 @@ config GPIO_MAX7301
>
>  config GPIO_MCP23S08
>         tristate "Microchip MCP23xxx I/O expander"
> -       depends on SPI_MASTER || I2C
> +       depends on (SPI_MASTER && !I2C) || I2C
>         help
>           SPI/I2C driver for Microchip MCP23S08/MCP23S17/MCP23008/MCP23017
>           I/O expanders.
> --
> 1.8.1.2
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



--
With Best Regards,
Andy Shevchenko
