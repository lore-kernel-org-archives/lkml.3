Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaBJMCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:02:39 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:53581 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaBJMCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:02:38 -0500
MIME-Version: 1.0
In-Reply-To: <1391859219-3102-1-git-send-email-lpapp@kde.org>
References: <1391859219-3102-1-git-send-email-lpapp@kde.org>
Date: Mon, 10 Feb 2014 17:32:36 +0530
Message-ID: <CAK9yfHx2W3KXzBJavpDwXqBUxM8Uw6tWLRGBLjUq1jS_yWYw-Q@mail.gmail.com>
Subject: Re: [PATCH v2] mfd: MAX6650/6651 support
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laszlo,

If you are considering re-spinning this patch based on Lee's comments, please
also consider my comments inline.

On 8 February 2014 17:03, Laszlo Papp <lpapp@kde.org> wrote:
> MAX6650/MAX6651 chip is a multi-function device with I2C busses. The
> chip includes fan-speed regulators and monitors, GPIO, and alarm.
>
> This patch is an initial release of a MAX6650/6651 MFD driver that
> supports to enable the chip with its primary I2C bus that will connect
> the hwmon, and then the gpio devices for now.
>
> Signed-off-by: Laszlo Papp <lpapp@kde.org>
> ---
>  drivers/mfd/Kconfig                 | 11 +++++
>  drivers/mfd/Makefile                |  1 +
>  drivers/mfd/max665x.c               | 88 +++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/max665x-private.h | 42 ++++++++++++++++++
>  4 files changed, 142 insertions(+)
>  create mode 100644 drivers/mfd/max665x.c
>  create mode 100644 include/linux/mfd/max665x-private.h
>
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 49bb445..e25be62 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -368,6 +368,17 @@ config MFD_MAX8907
>           accessing the device; additional drivers must be enabled in order
>           to use the functionality of the device.
>
> +config MFD_MAX665X
> +       bool "Maxim Semiconductor MAX6650/MAX6651 Support"
> +       select MFD_CORE
> +       depends on I2C
> +       select REGMAP_I2C

Move the "depends on" before the select MFD_CORE.

> +       help
> +         Say yes here to support for Maxim Semiconductor MAX6650/MAX6651.

 s/here to support/here to add support

>This is
> +         a fan speed regulator and monitor IC. This driver provies common support
> +         for accessing the device, additional drivers must be enabled in order to
> +         use the functionality of the device.
> +
>  config MFD_MAX8925
>         bool "Maxim Semiconductor MAX8925 PMIC Support"
>         depends on I2C=y
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 5aea5ef..63668c5 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -111,6 +111,7 @@ obj-$(CONFIG_MFD_DA9055)    += da9055.o
>  da9063-objs                    := da9063-core.o da9063-irq.o da9063-i2c.o
>  obj-$(CONFIG_MFD_DA9063)       += da9063.o
>
> +obj-$(CONFIG_MFD_MAX665X)      += max665x.o
>  obj-$(CONFIG_MFD_MAX14577)     += max14577.o
>  obj-$(CONFIG_MFD_MAX77686)     += max77686.o max77686-irq.o
>  obj-$(CONFIG_MFD_MAX77693)     += max77693.o max77693-irq.o
> diff --git a/drivers/mfd/max665x.c b/drivers/mfd/max665x.c
> new file mode 100644
> index 0000000..395373fe
> --- /dev/null
> +++ b/drivers/mfd/max665x.c
> @@ -0,0 +1,88 @@
> +/*
> + * Device access for MAX6650-MAX6651
> + *
> + * Copyright(c) 2013 Polatis Ltd.
> + *
> + * Author: Laszlo Papp <laszlo.papp@polatis.com>
> + *
> + *  This program is free software; you can redistribute  it and/or modify it
> + *  under  the terms of  the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the  License, or (at your
> + *  option) any later version.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/mfd/core.h>
> +#include <linux/module.h>
> +#include <linux/i2c.h>

Please arrange these alphabetically.

[snip]
> +
> +struct max665x_dev {
> +       struct device *dev;
> +       struct mutex iolock;
> +
> +       struct i2c_client *i2c;
> +       struct regmap     *map;
> +
> +       int type;

Unnecessary extra lines above could be removed.


-- 
With warm regards,
Sachin
