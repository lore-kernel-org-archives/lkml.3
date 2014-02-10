Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaBJNRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:17:09 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:60559 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbaBJNRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:17:05 -0500
MIME-Version: 1.0
In-Reply-To: <20140210112242.GB21522@lee--X1>
References: <1392019497-12440-1-git-send-email-lpapp@kde.org>
	<20140210112242.GB21522@lee--X1>
Date: Mon, 10 Feb 2014 13:17:04 +0000
X-Google-Sender-Auth: _pzJc4dOICHapDK6S3XtKQZK2dw
Message-ID: <CAOMwXhMJTeO8ev++dzXKtz8En9pK+3CkjmweuLsb5aoU+e=Aqw@mail.gmail.com>
Subject: Re: [PATCH v3] mfd: MAX6650/6651 support
From: Laszlo Papp <lpapp@kde.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +static struct mfd_cell max665x_devs[] = {
>> +     { .name = "max6651-gpio", },
>> +     { .name = "max6650", }, /* hwmon driver */
>
> What happened to renaming the hwmon driver, so we can have
> "max6650-hwmon" here?

I will add the alias in the next patch (e.g. hwmon change). I can come
back to this and rename then.

>> +static const struct i2c_device_id max665x_id[] = {
>> +     { "max6650", TYPE_MAX6650 },
>> +     { "max6651", TYPE_MAX6651 },
>> +     {},
>
> Can you remind me where these IDs are being used?

Strictly speaking, not in this change, so I can remove it and add
later if needed.

>> +};
>> +MODULE_DEVICE_TABLE(i2c, max665x_id);
>> +
>> +static struct i2c_driver max665x_driver = {
>> +     .driver = {
>> +             .name = "max665x",
>> +             .owner = THIS_MODULE,
>
> All new drivers are required to support Device Tree.

Do you have some recommendation for documentation, examples, etc? I am
new to this.

> <snip>
>
>> +#ifndef __LINUX_MFD_MAX665X_PRIVATE_H
>> +#define __LINUX_MFD_MAX665X_PRIVATE_H
>> +
>> +#include <linux/i2c.h>
>> +#include <linux/export.h>
>
> What's this here for?

Good catch, the export line is a left-over.
