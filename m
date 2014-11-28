Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaK1QUD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:20:03 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:44311 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaK1QUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:20:01 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1411280019590.3961@nanos>
References: <1417089760-26848-1-git-send-email-pang.xunlei@linaro.org>
	<1417089760-26848-5-git-send-email-pang.xunlei@linaro.org>
	<alpine.DEB.2.11.1411280019590.3961@nanos>
Date: Sat, 29 Nov 2014 00:20:00 +0800
Message-ID: <CADcy93X+XoKruoS6LJsGevjKpQCNX4BVvjh0rYdGivShGLQfGw@mail.gmail.com>
Subject: Re: [RFC PATCH 4/4] rtc/imxdi: Update driver to address time issues
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Sven Schnelle <svens@stackframe.org>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 November 2014 at 07:24, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 27 Nov 2014, Xunlei Pang wrote:
>> @@ -213,17 +213,16 @@ static int dryice_rtc_set_mmss(struct device *dev, time64_t secs)
>>  {
>>       struct imxdi_dev *imxdi = dev_get_drvdata(dev);
>>       int rc;
>> +     u32 hwtime;
>> +
>> +     rc = rtc_time64_to_hw32(secs, &hwtime);
>> +     if (rc < 0)
>> +             return rc;
>>
>>       /* zero the fractional part first */
>>       rc = di_write_wait(imxdi, 0, DTCLR);
>>       if (rc == 0)
>> -             /*
>> -              * y2106 issue:
>> -              *   On 32bit systems the time64_t secs value gets cast to
>> -              *   a 32bit long, and thus we can only write a maximum value
>> -              *   of y2016
>> -              */
>> -             rc = di_write_wait(imxdi, secs, DTCMR);
>> +             rc = di_write_wait(imxdi, hwtime, DTCMR);
>
> So you repeat the same thing what I complained about last time. First
> you add crap to a driver then you remove it again instead of analyzing
> the necessary conversions in the first place, provide the
> infrastructure and then do a per driver conversion. It's not that
> hard, really and I'm getting tired of your approach.
>
> Step 1:      Provide rtc.set_mmss64
>
> Step 2:      Implement the epoch helper functions for 32bit hardware
>
> Step 3:      Convert drivers
>
> Step 4:      Remove obsolete interfaces
>
> I wont explain that once more, really.

Actually, I want to do this eariler, just thought that the "y2106 issue"
tags aren't something my patches brought about, they are more like
reminders help me with future patches.

Anyway, they are ungraceful being there. I'll refine this patchset carefully
according to your valuable suggestions, and will send out another version.

Thanks for your review!

Regards,
Xunlei

>
> Thanks,
>
>         tglx
>
