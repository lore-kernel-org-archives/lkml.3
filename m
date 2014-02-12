Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbaBLEmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 23:42:14 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:36959 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaBLEmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 23:42:12 -0500
MIME-Version: 1.0
In-Reply-To: <1392177760-17959-1-git-send-email-lpapp@kde.org>
References: <1392177760-17959-1-git-send-email-lpapp@kde.org>
Date: Wed, 12 Feb 2014 10:12:12 +0530
Message-ID: <CAK9yfHztuCSBSJUjc1xcf-f+O+kaKQQ=ExpWB-LoCkLoaZPfWA@mail.gmail.com>
Subject: Re: [PATCH v6] mfd: MAX6650/6651 support
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>, jdelvare@suse.de,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laszlo,

Sorry for missing out on a couple of points during my earlier review.
Please see inline.

On 12 February 2014 09:32, Laszlo Papp <lpapp@kde.org> wrote:
> MAX6650/MAX6651 chip is a multi-function device with I2C busses. The
> chip includes fan-speed regulators and monitors, GPIO, and alarm.
>
> This patch is an initial release of a MAX6650/6651 MFD driver that
> supports to enable the chip with its primary I2C bus that will connect
> the hwmon, and then the gpio devices for now.
>
> Signed-off-by: Laszlo Papp <lpapp@kde.org>
> ---
[snip]

> --- /dev/null
> +++ b/drivers/mfd/max665x.c
> @@ -0,0 +1,87 @@
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
> +
> +#include <linux/mfd/max665x-private.h>
> +
> +static struct mfd_cell max665x_devs[] = {
> +       { .name = "max6651-gpio", },
> +       { .name = "max6650", }, /* hwmon driver */
> +       {},
> +};
> +
> +const struct regmap_config max665x_regmap_config = {
> +       .reg_bits = 5,
> +};

This should be static.

> +static int max665x_probe(struct i2c_client *i2c,
> +                           const struct i2c_device_id *id)
> +{
> +       struct max665x_dev *max665x;
> +       int ret;
> +
> +       max665x = devm_kzalloc(&i2c->dev, sizeof(*max665x), GFP_KERNEL);
> +       if (!max665x)
> +               return -ENOMEM;
> +
> +       i2c_set_clientdata(i2c, max665x);
> +       max665x->dev = &i2c->dev;
> +       max665x->i2c = i2c;
> +       max665x->map = devm_regmap_init_i2c(i2c, &max665x_regmap_config);

Don't you need to check the return value of devm_regmap_init_i2c?

-- 
With warm regards,
Sachin
