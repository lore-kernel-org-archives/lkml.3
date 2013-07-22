Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205Ab3GVWDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 18:03:34 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:54562 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab3GVWDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 18:03:32 -0400
Message-ID: <51EDAC31.8090306@linaro.org>
Date: Mon, 22 Jul 2013 15:03:29 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [PATCH -v2] RTC: Add an alarm disable quirk
References: <1374162294-29726-1-git-send-email-bp@alien8.de> <51E8194E.1030704@linaro.org> <20130718225349.GD15992@pd.tnic> <20130719142628.GC19581@pd.tnic> <20130719151321.GD19581@pd.tnic> <20130719213458.GF19581@pd.tnic> <20130720170023.GB13731@pd.tnic> <51ED9D7A.1050201@linaro.org> <20130722211927.GD4613@pd.tnic>
In-Reply-To: <20130722211927.GD4613@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 02:19 PM, Borislav Petkov wrote:
> On Mon, Jul 22, 2013 at 02:00:42PM -0700, John Stultz wrote:
>> Also, just to clarify, on the affected machines, with this patch,
>> wake-up alarm's will in effect be disabled, right?
> See below.
>
>>> @@ -385,6 +418,9 @@ static int cmos_alarm_irq_enable(struct device *dev, unsigned int enabled)
>>>   	if (!is_valid_irq(cmos->irq))
>>>   		return -EINVAL;
>>> +	if (!disable_alarm)
>>> +		return 0;
>>> +
>> Did you want this in cmos_alarm_irq_enable? Or cmos_irq_disable?
> You're right - the first version did call it only in rtc_alarm_disable()
> so I should move it to cmos_alarm_disable(). Will fix.
>
> Btw, I did some more runs on the weekend. It seems, the setting of the
> alarm interrupt bit in RTC_CONTROL doesn't matter. I dumped its contents
> on shutdown and I had cases where it was 0x22 (bit 5 set) and 0x2.

It doesn't matter in what way?  I get you're saying you had cases where 
the alarm irq was set and non-set on shutdown, but I'm confused as to 
what the result was. Did it boot up immediately on shutdown in both cases?

> So my hunch currently is us *not* disabling the alarm, doesn't make it
> reboot the box.
Just to avoid the double negatives, you're saying:
* Disabling the alarm seems to cause it power on immediately on shutdown.
* Leaving the alarm alone (even if its set?) doesn't seem to cause the 
immediate power-on

Does leaving it alone, cause eventual power-on if the wakeup alarm was 
set for some time (say 5 mins) in the future?

thanks
-john

