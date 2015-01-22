Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750956AbbAVAvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 19:51:09 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:58238 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbbAVAvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 19:51:02 -0500
MIME-Version: 1.0
In-Reply-To: <54B0881D.9090004@codeaurora.org>
References: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
	<1420850068-27828-11-git-send-email-john.stultz@linaro.org>
	<54B0881D.9090004@codeaurora.org>
Date: Wed, 21 Jan 2015 16:51:00 -0800
Message-ID: <CALAqxLXdTarm94oOKBoUWPUPQK4-B+EvwTxZkuV_2np3UA8bEQ@mail.gmail.com>
Subject: Re: [PATCH 10/10] clocksource: Add some debug info about clocksources
 being registered
From: John Stultz <john.stultz@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2015 at 6:02 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 01/09/2015 04:34 PM, John Stultz wrote:
>> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
>> index 9a0b951..c641aa7 100644
>> --- a/kernel/time/clocksource.c
>> +++ b/kernel/time/clocksource.c
>> @@ -770,6 +770,10 @@ void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
>>       cs->max_idle_ns = clocks_calc_max_nsecs(cs->mult, cs->shift,
>>                                                cs->maxadj, cs->mask,
>>                                                &cs->max_cycles);
>> +
>> +     pr_info("clocksource %s: mask: 0x%llx max_cycles: 0x%llx, max_idle_ns: %lld ns\n",
>> +                     cs->name, cs->mask, cs->max_cycles, cs->max_idle_ns);
>
> Is this intentionally info level? Or was it supposed to be debug level
> per $subject?

Sorry for not getting back on this sooner. Since this is a
one-time-at-bootup message, I think enabling the pr_debug output is a
little too finicky for most folks to boot with. So I left it at
pr_info. If folks object, I can change it, but it just seems less
likely we'd get any useful data if it was so hidden by default.

thanks
-john
