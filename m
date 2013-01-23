Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab3AWR1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 12:27:50 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:58520 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab3AWR1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 12:27:49 -0500
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E1C2B9@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E1C2B9@DQHE02.ent.ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 23 Jan 2013 09:27:26 -0800
Message-ID: <CAK5ve-+5SUeNq4UtUZ3T=dt0Ak_NMH7sW+_-nbB9TfyBJ0mzVA@mail.gmail.com>
Subject: Re: [PATCH v2] leds: fix build error for LP55xx Common driver
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 1:38 AM, Kim, Milo <Milo.Kim@ti.com> wrote:
> To solve undefined symbols for LED class and I2C, lp55xx-common driver should
> support a module build as well.
>
> In case of CONFIG_I2C=m, CONFIG_LEDS_LP5521/5523=m, it still has undefined
> symbol problems because CONFIG_LEDS_LP55XX_COMMON can be selected as 'y'.
> Moreover, I2C functions are used in both LP5521 and LP5523 drivers.
> Therefore, each LP55xx driver should have an 'I2C' dependency.
>
> make x86_64 allmodconfig failed like this:
>
> drivers/built-in.o: In function `lp55xx_unregister_leds':
> (.text+0x161dab): undefined reference to `led_classdev_unregister'
>
> drivers/built-in.o: In function `lp55xx_init_led':
> leds-lp55xx-common.c:(.text+0x161f23): undefined reference to `led_classdev_register'
> leds-lp55xx-common.c:(.text+0x161f9f): undefined reference to `led_classdev_unregister'
>
> drivers/built-in.o: In function `lp55xx_read':
> (.text+0x1621b3): undefined reference to `i2c_smbus_read_byte_data'
> drivers/built-in.o: In function `lp55xx_init_device':
> (.text+0x1622f0): undefined reference to `i2c_smbus_write_byte_data'
> drivers/built-in.o: In function `lp55xx_init_device':
> (.text+0x162331): undefined reference to `i2c_smbus_write_byte_data'
> drivers/built-in.o: In function `lp55xx_update_bits':
> (.text+0x162492): undefined reference to `i2c_smbus_write_byte_data'
> drivers/built-in.o: In function `lp55xx_write':
> (.text+0x1624c5): undefined reference to `i2c_smbus_write_byte_data'
>

Thanks, Merged already

-Bryan

> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/leds/Kconfig |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index c7c5280..09a6984 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -194,9 +194,8 @@ config LEDS_LP3944
>           module will be called leds-lp3944.
>
>  config LEDS_LP55XX_COMMON
> -       bool "Common Driver for TI/National LP5521 and LP5523/55231"
> +       tristate "Common Driver for TI/National LP5521 and LP5523/55231"
>         depends on LEDS_LP5521 || LEDS_LP5523
> -       depends on I2C
>         select FW_LOADER
>         help
>           This option supports common operations for LP5521 and LP5523/55231
> @@ -205,6 +204,7 @@ config LEDS_LP55XX_COMMON
>  config LEDS_LP5521
>         tristate "LED Support for N.S. LP5521 LED driver chip"
>         depends on LEDS_CLASS
> +       depends on I2C
>         select LEDS_LP55XX_COMMON
>         help
>           If you say yes here you get support for the National Semiconductor
> @@ -215,6 +215,7 @@ config LEDS_LP5521
>  config LEDS_LP5523
>         tristate "LED Support for TI/National LP5523/55231 LED driver chip"
>         depends on LEDS_CLASS
> +       depends on I2C
>         select LEDS_LP55XX_COMMON
>         help
>           If you say yes here you get support for TI/National Semiconductor
> --
> 1.7.9.5
>
>
> Best Regards,
> Milo
>
>
