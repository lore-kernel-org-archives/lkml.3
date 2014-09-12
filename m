Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaILUze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:55:34 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:36566 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaILUzb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:55:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140912204823.GA23114@vmdeb7>
References: <1410492145-9049-1-git-send-email-coproscefalo@gmail.com>
	<20140912204823.GA23114@vmdeb7>
Date: Fri, 12 Sep 2014 14:55:29 -0600
Message-ID: <CAGdLNWHnCEPnfuy67UGfK-Bf_xyp0CYGxRhVgLWfL25OnTH_+g@mail.gmail.com>
Subject: Re: [PATCH v3] toshiba_acpi: Support new keyboard backlight type
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darren,

2014-09-12 14:48 GMT-06:00 Darren Hart <dvhart@infradead.org>:
> On Thu, Sep 11, 2014 at 09:22:25PM -0600, Azael Avalos wrote:
>> Newer Toshiba models now come with a new (and different) keyboard
>> backlight implementation with three modes of operation: TIMER,
>> ON and OFF, and the LED is controlled internally by the firmware.
>>
>> This patch adds support for that type of backlight, changing the
>> existing code to accomodate the new implementation.
>>
>> The timeout value range is now 1-60 seconds, and the accepted
>> modes are now: 1 (FN-Z), 2 (AUTO or TIMER), 8(ON) and 10 (OFF),
>> this adds two new entries keyboard_type and available_kbd_modes,
>
>                             ^ update for new naming
>
>> the first shows the keyboard type and the latter shows the
>> supported modes depending on the type.
>>
>> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
>> ---
>
> Note you can update your v2,v3 changes here after the ---
>
> See Documentation/SubmittingPatches L639,649
>
>> @@ -1293,12 +1420,34 @@ static ssize_t toshiba_kbd_bl_mode_show(struct device *dev,
>>                                       char *buf)
>>  {
>>       struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
>> -     u32 time;
>>
>> -     if (toshiba_kbd_illum_status_get(toshiba, &time) < 0)
>> -             return -EIO;
>> +     if (toshiba == NULL)
>> +             return -ENXIO;
>
> If this testing is necessary for this sysfs callback, it is needed for all of them. Looking at the code more closely, I think this is out of scope for this patch. The entire file assumes a valid toshiba_acpi_dev. If this is a problem, it needs a separate patch to address it. So, let's drop this change, update the commit log to match the new sysfs filenames, and this should be ready to go.

Ok, I'll leave this function as it is for this patch. I'll send an updated
(and hopefuly final) patch.

I have some "cleanup" changes comming, so that might be a good
place for them.

>
>
> --
> Darren Hart
> Intel Open Source Technology Center

Cheers
Azael


-- 
-- El mundo apesta y vosotros apestais tambien --
