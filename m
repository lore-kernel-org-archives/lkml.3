Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbaAGOLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:11:20 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:49406 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaAGOLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:11:12 -0500
MIME-Version: 1.0
In-Reply-To: <1387814889-16670-2-git-send-email-lpapp@kde.org>
References: <1387814889-16670-1-git-send-email-lpapp@kde.org>
	<1387814889-16670-2-git-send-email-lpapp@kde.org>
Date: Tue, 7 Jan 2014 15:11:11 +0100
Message-ID: <CACRpkdZVDYgLSW9vbauptb0p_nnhUfrgtVkSx_wMRbpP1XPybQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: MAX6650/6651 support
From: Linus Walleij <linus.walleij@linaro.org>
To: Laszlo Papp <lpapp@kde.org>, Mark Brown <broonie@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 5:08 PM, Laszlo Papp <lpapp@kde.org> wrote:

> MAX6650/MAX6651 chip is a multi-function device with I2C busses. The
> chip includes fan-speed regulators and monitors, GPIO, and alarm.
>
> This patch is an initial release of a MAX6650/6651 MFD driver that
> supports to enable the chip with its primary I2C bus that will connect
> the hwmon, and then the gpio devices for now.
>
> Signed-off-by: Laszlo Papp <lpapp@kde.org>
(...)
> +++ b/include/linux/mfd/max6651-private.h
> +struct max6651_dev {
> +    struct device *dev;
> +    struct mutex iolock;
> +
> +    struct i2c_client *i2c;
> +
> +       int type;
> +};
> +
> +enum max6651_types {
> +       TYPE_MAX6650,
> +       TYPE_MAX6651,
> +};
> +
> +extern int max6651_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest);
> +extern int max6651_write_reg(struct i2c_client *i2c, u8 reg, u8 value);

It looks like you're reinventing regmap.

- In the Kconfig entry for the MFD device:
  select REGMAP_I2C

- Look in drivers/mfd/stw481x.c for an example using
  <linux/regmap.h>

- Look into
  drivers/regulator/stw481x-vmmc.c
  for an example regmap MFD spawned child cell.

Yours,
Linus Walleij
