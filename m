Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbbAVM2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 07:28:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbbAVM2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 07:28:32 -0500
Message-ID: <54C0ECC7.1070308@redhat.com>
Date: Thu, 22 Jan 2015 07:27:51 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 10/10] clocksource: Add some debug info about clocksources
 being registered
References: <1420850068-27828-1-git-send-email-john.stultz@linaro.org> <1420850068-27828-11-git-send-email-john.stultz@linaro.org> <54B0881D.9090004@codeaurora.org> <CALAqxLXdTarm94oOKBoUWPUPQK4-B+EvwTxZkuV_2np3UA8bEQ@mail.gmail.com>
In-Reply-To: <CALAqxLXdTarm94oOKBoUWPUPQK4-B+EvwTxZkuV_2np3UA8bEQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/21/2015 07:51 PM, John Stultz wrote:
> On Fri, Jan 9, 2015 at 6:02 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> On 01/09/2015 04:34 PM, John Stultz wrote:
>>> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
>>> index 9a0b951..c641aa7 100644
>>> --- a/kernel/time/clocksource.c
>>> +++ b/kernel/time/clocksource.c
>>> @@ -770,6 +770,10 @@ void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
>>>       cs->max_idle_ns = clocks_calc_max_nsecs(cs->mult, cs->shift,
>>>                                                cs->maxadj, cs->mask,
>>>                                                &cs->max_cycles);
>>> +
>>> +     pr_info("clocksource %s: mask: 0x%llx max_cycles: 0x%llx, max_idle_ns: %lld ns\n",
>>> +                     cs->name, cs->mask, cs->max_cycles, cs->max_idle_ns);
>>
>> Is this intentionally info level? Or was it supposed to be debug level
>> per $subject?
> 
> Sorry for not getting back on this sooner. Since this is a
> one-time-at-bootup message, I think enabling the pr_debug output is a
> little too finicky for most folks to boot with. So I left it at
> pr_info. If folks object, I can change it, but it just seems less
> likely we'd get any useful data if it was so hidden by default.
> 

John, I've found in the past that when a user has a problem with the kernel the
first thing that support tells them to do is boot with "ignore_loglevel" so that
support can take a look at the full boot log.  So while I understand your
comment that this is a "one-time-at-bootup message" I wonder if this really
should be debug.  It only will be useful in debug scenarios and doesn't really
provide any true information to the user about their system.

... IMO.

P.
