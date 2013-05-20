Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab3ETRRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 13:17:17 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:62106 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685Ab3ETRRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 13:17:15 -0400
MIME-Version: 1.0
In-Reply-To: <1368961914.5122.1.camel@phoenix>
References: <1368961914.5122.1.camel@phoenix>
Date: Mon, 20 May 2013 19:17:14 +0200
Message-ID: <CACRpkdbpVRgZ8r8FK6gZivcaKVeYOpG5aWEtZjWn8n99GPtS4g@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: mcp23s08: Fix build error when
 CONFIG_SPI_MASTER=y && CONFIG_I2C=m
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Lars Poeschel <poeschel@lemonage.de>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 19, 2013 at 1:11 PM, Axel Lin <axel.lin@ingics.com> wrote:

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

Applied for fixes with Andy's ACK.

Yours,
Linus Walleij
