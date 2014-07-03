Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509AbaGCSNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 14:13:34 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:45870 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbaGCSNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 14:13:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140703173421.GO16590@localhost>
References: <20140703082830.GB16590@localhost> <1404407829-1815-1-git-send-email-janne.kanniainen@gmail.com>
 <20140703173421.GO16590@localhost>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 3 Jul 2014 11:13:09 -0700
Message-ID: <CAK5ve-+gmOEAKjSnKaWz2K_xs6LzDUP6LN2Y33J-22UV=eFM2Q@mail.gmail.com>
Subject: Re: [PATCH 1/2 v6] HID: gt683r: fix race condition
To: Johan Hovold <johan@kernel.org>
Cc: Janne Kanniainen <janne.kanniainen@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <greg@kroah.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2014 at 10:34 AM, Johan Hovold <johan@kernel.org> wrote:
> On Thu, Jul 03, 2014 at 08:17:08PM +0300, Janne Kanniainen wrote:
>> This will fix race condition noticed by Oliver Neukum. Sysfs files are
>> created before mutex and work are initialized.
>>
>> Signed-off-by: Janne Kanniainen <janne.kanniainen@gmail.com>
>
> Reviewed-by: Johan Hovold <johan@kernel.org>
>

Good, merged to my tree.
-Bryan

>> ---
>>  drivers/hid/hid-gt683r.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/hid/hid-gt683r.c b/drivers/hid/hid-gt683r.c
>> index 077f7a1..073bd80 100644
>> --- a/drivers/hid/hid-gt683r.c
>> +++ b/drivers/hid/hid-gt683r.c
>> @@ -227,6 +227,9 @@ static int gt683r_led_probe(struct hid_device *hdev,
>>       if (!led)
>>               return -ENOMEM;
>>
>> +     mutex_init(&led->lock);
>> +     INIT_WORK(&led->work, gt683r_led_work);
>> +
>>       led->mode = GT683R_LED_NORMAL;
>>       led->hdev = hdev;
>>       hid_set_drvdata(hdev, led);
>> @@ -271,9 +274,6 @@ static int gt683r_led_probe(struct hid_device *hdev,
>>               goto fail;
>>       }
>>
>> -     mutex_init(&led->lock);
>> -     INIT_WORK(&led->work, gt683r_led_work);
>> -
>>       return 0;
>>
>>  fail:
