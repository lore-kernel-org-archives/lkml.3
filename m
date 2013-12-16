Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab3LPNxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 08:53:48 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:51817 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab3LPNxr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 08:53:47 -0500
MIME-Version: 1.0
In-Reply-To: <20131216134633.GI18769@lee--X1>
References: <1387194424-2701-1-git-send-email-lpapp@kde.org>
	<20131216134633.GI18769@lee--X1>
Date: Mon, 16 Dec 2013 13:53:47 +0000
X-Google-Sender-Auth: 9nmh-YelxvgzuuTpWbwgST5xqF8
Message-ID: <CAOMwXhOnHNrzEvf0+QRn6dGb42xR9a33joZcou3ancwSYe36Ug@mail.gmail.com>
Subject: Re: [PATCH] mfd: (max8997) Handle the potential error for mfd_add_devices
From: Laszlo Papp <lpapp@kde.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think you commented on the wrong patch. There has been a newer submitted.

On Mon, Dec 16, 2013 at 1:46 PM, Lee Jones <lee.jones@linaro.org> wrote:
> The $SUBJECT line is wrong. To see how a subsystem usually formats
> theirs you must do something like `git log --oneline -- <subsystem>`.
> And duplicate the format.
>
> Commit message?
>
>> Signed-off-by: Laszlo Papp <lpapp@kde.org>
>> ---
>>  drivers/mfd/max8997.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
>> index 791aea3..c7cc235 100644
>> --- a/drivers/mfd/max8997.c
>> +++ b/drivers/mfd/max8997.c
>> @@ -227,19 +227,19 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
>>       pm_runtime_set_active(max8997->dev);
>>
>>       max8997_irq_init(max8997);
>> -
>> -     mfd_add_devices(max8997->dev, -1, max8997_devs,
>> +     ret = mfd_add_devices(max8997->dev, -1, max8997_devs,
>>                       ARRAY_SIZE(max8997_devs),
>>                       NULL, 0, NULL);
>> +     if (ret < 0) {
>> +             dev_err(dev, "cannot add mfd cells\n");
>> +             goto err_mfd;
>> +     }
>
> Have you tested this patch on h/w? Did you even compile it?
>
>>       /*
>>        * TODO: enable others (flash, muic, rtc, battery, ...) and
>>        * check the return value
>>        */
>>
>> -     if (ret < 0)
>> -             goto err_mfd;
>> -
>>       /* MAX8997 has a power button input. */
>>       device_init_wakeup(max8997->dev, pdata->wakeup);
>>
>
> --
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
