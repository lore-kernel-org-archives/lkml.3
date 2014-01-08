Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbaAHOjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:39:33 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:62903 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069AbaAHOja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:39:30 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdZVDYgLSW9vbauptb0p_nnhUfrgtVkSx_wMRbpP1XPybQ@mail.gmail.com>
References: <1387814889-16670-1-git-send-email-lpapp@kde.org>
	<1387814889-16670-2-git-send-email-lpapp@kde.org>
	<CACRpkdZVDYgLSW9vbauptb0p_nnhUfrgtVkSx_wMRbpP1XPybQ@mail.gmail.com>
Date: Wed, 8 Jan 2014 14:39:28 +0000
X-Google-Sender-Auth: ABQJRODsLfMc4Cyuk1ZNo3Lc7Ks
Message-ID: <CAOMwXhOhWScR0PpewNdTXqDCWpHZWC9a6u-vNAK0cO0gk6Xm=g@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: MAX6650/6651 support
From: Laszlo Papp <lpapp@kde.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 7, 2014 at 2:11 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Dec 23, 2013 at 5:08 PM, Laszlo Papp <lpapp@kde.org> wrote:
>
>> MAX6650/MAX6651 chip is a multi-function device with I2C busses. The
>> chip includes fan-speed regulators and monitors, GPIO, and alarm.
>>
>> This patch is an initial release of a MAX6650/6651 MFD driver that
>> supports to enable the chip with its primary I2C bus that will connect
>> the hwmon, and then the gpio devices for now.
>>
>> Signed-off-by: Laszlo Papp <lpapp@kde.org>
> (...)
>> +++ b/include/linux/mfd/max6651-private.h
>> +struct max6651_dev {
>> +    struct device *dev;
>> +    struct mutex iolock;
>> +
>> +    struct i2c_client *i2c;
>> +
>> +       int type;
>> +};
>> +
>> +enum max6651_types {
>> +       TYPE_MAX6650,
>> +       TYPE_MAX6651,
>> +};
>> +
>> +extern int max6651_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest);
>> +extern int max6651_write_reg(struct i2c_client *i2c, u8 reg, u8 value);
>
> It looks like you're reinventing regmap.
>
> - In the Kconfig entry for the MFD device:
>   select REGMAP_I2C
>
> - Look in drivers/mfd/stw481x.c for an example using
>   <linux/regmap.h>
>
> - Look into
>   drivers/regulator/stw481x-vmmc.c
>   for an example regmap MFD spawned child cell.

Oh, thanks, Linus!

I will have a look.
