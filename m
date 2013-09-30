Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab3I3SJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 14:09:11 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:51776 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab3I3SJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 14:09:10 -0400
Message-ID: <5249BE42.90605@linaro.org>
Date: Mon, 30 Sep 2013 20:09:06 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@kernel.org>, mlichvar@redhat.com, prarit@redhat.com,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        zoran markovic <zoran.markovic@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL]: clocksource: new material for 3.13
References: <5249B7E2.5060201@linaro.org> <5249B9AC.8050209@linaro.org>
In-Reply-To: <5249B9AC.8050209@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2013 07:49 PM, John Stultz wrote:
> On 09/30/2013 10:41 AM, Daniel Lezcano wrote:
>>
>> Hi Thomas,
>>
>> this pull request is based on 3.12-rc3 with the following content:
>>
>>   - Miroslav improved the RTC update by increasing the interval
>> acceptable for an update in the sync_cmos_clock workqueue callback
>>
>>   - Prarit added a missing function declaration to fix a compilation
>> issue on x86. Please *note*, this patch is coming from a pull from
>> John's tree, it would make sense to cherry-pick this fix into
>> timers/urgent
>>
>>   - Soren added FEAT_PERCPU to a clock device when it is local per cpu.
>> This feature prevents the clock framework to choose a per cpu timer as
>> a broadcast timer. This problem arised when the ARM global timer is
>> used which is the case now on Xillinx.
>>
>>   - Stephen extended the generic sched_clock code to support 64bit
>> counters and removes the setup_sched_clock deprecation, as that causes
>> lots of warnings since there's still users in the arch/arm tree.
>>
>>   - Will and Sudeep implemented the event stream for architected timer.
>> The event streams can be used to impose a timeout on a wfe, to
>> safeguard against any programming error in case an expected event is
>> not generated or even to implement wfe-based timeouts for userspace
>> locking implementations.
>>
>>   - Zoran prevents to enter suspend mode if there are pending RTC
>> timers to be handled, avoiding these ones to be delayed as well as the
>> subsequent possible time critical code tied with them.
>>
>
>
> Hey Daniel,
>      So this looks like a strange pull request. You based it on 3.12-rc3
> instead of the current tip/timers/core (which is what your submitting
> this to). Unfortunately since the branch you pulled from me was based on
> tip/timers/core, this pull request seems to be submitting items that are
> already in tip/timers/core (like the changes from Prarit, Miroslav and
> Zoran).

Aah right !

> Does any of the changes here actually depend on 3.12-rc3? If not you
> might just re-generate the branch against tip/timers/core, and you'll
> end up with a much cleaner pull request.

Ok, I think I misunderstood Thomas's email [1] :s

No changes depend on 3.12-rc3, I will generate a pull request against 
tip/timers/core.

Thanks for spotting this.

   -- Daniel

[1] https://lkml.org/lkml/2013/8/21/269


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

