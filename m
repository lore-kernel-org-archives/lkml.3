Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbaBMKiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:38:05 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:60453 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbaBMKiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:38:03 -0500
MIME-Version: 1.0
In-Reply-To: <20140213111530.2a2b4982@endymion.delvare>
References: <1392281438-31836-1-git-send-email-lpapp@kde.org>
	<20140213095817.GD32508@lee--X1>
	<20140213111530.2a2b4982@endymion.delvare>
Date: Thu, 13 Feb 2014 10:38:02 +0000
X-Google-Sender-Auth: Z5bO_KpLJhdIIubEGS0LTY7_MwQ
Message-ID: <CAOMwXhML8LvDCzmk1ZVT+7cARj9C3VtxERWBgOPM9vTc6qQXZQ@mail.gmail.com>
Subject: Re: [lm-sensors] [RFC PATCH] hwmon: (max6650) Convert to be a
 platform driver
From: Laszlo Papp <lpapp@kde.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: Lee Jones <lee.jones@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org, Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 10:15 AM, Jean Delvare <jdelvare@suse.de> wrote:
> On Thu, 13 Feb 2014 09:58:17 +0000, Lee Jones wrote:
>> > The MFD driver has now been added, so this driver is now being adopted to be a
>> > subdevice driver on top of it. This means, the i2c driver usage is being
>> > converted to platform driver usage all around.
>> >
>> > Signed-off-by: Laszlo Papp <lpapp@kde.org>
>> > ---
>> > This patch has been compile tested only and will be tested with real hardware,
>> > but early reviews to catch any trivial issues would be welcome.
>> >  drivers/hwmon/Kconfig   |   2 +-
>> >  drivers/hwmon/max6650.c | 155 ++++++++++++++++++++++++------------------------
>> >  2 files changed, 79 insertions(+), 78 deletions(-)
>>
>> <snip>
>>
>> >  /*
>> >   * Insmod parameters
>> > @@ -105,24 +108,23 @@ module_param(clock, int, S_IRUGO);
>> >
>> >  #define DIV_FROM_REG(reg) (1 << (reg & 7))
>> >
>> > -static int max6650_probe(struct i2c_client *client,
>> > -                    const struct i2c_device_id *id);
>> > -static int max6650_init_client(struct i2c_client *client);
>> > -static int max6650_remove(struct i2c_client *client);
>> > +static int max6650_probe(struct platform_device *pdev);
>> > +static int max6650_init_client(struct platform_device *pdev);
>> > +static int max6650_remove(struct platform_device *pdev);
>> >  static struct max6650_data *max6650_update_device(struct device *dev);
>>
>> It would be good to remove these forward declarations in the future.
>>
>> If no one volunteers I'll happily do it.
>
> Guenter just did:
>
> http://lists.lm-sensors.org/pipermail/lm-sensors/2014-February/041224.html
>
> Any change to the max6650 driver should go on top of his patch series
> to avoid conflicts:
>
> http://lists.lm-sensors.org/pipermail/lm-sensors/2014-February/041223.html

As far as I can see, that patch set was not even tested, so how can it
go in? I was told that any patch should be _runtime_ tested, too.
Fwiw, I do not have time to test those personally, he would need to
find someone else if that requirement really holds true.

I would not really like to fix bugs appearing in that code to get my
features in.
