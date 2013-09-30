Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab3I3SSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 14:18:10 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:63398 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab3I3SSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 14:18:09 -0400
Message-ID: <5249C05D.5050606@linaro.org>
Date: Mon, 30 Sep 2013 11:18:05 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
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
References: <5249B7E2.5060201@linaro.org> <5249B9AC.8050209@linaro.org> <5249BE42.90605@linaro.org>
In-Reply-To: <5249BE42.90605@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2013 11:09 AM, Daniel Lezcano wrote:
> On 09/30/2013 07:49 PM, John Stultz wrote:
>> On 09/30/2013 10:41 AM, Daniel Lezcano wrote:
>>>
>>> Hi Thomas,
>>>
>>> this pull request is based on 3.12-rc3 with the following content:
>>>
>>>   - Miroslav improved the RTC update by increasing the interval
>>> acceptable for an update in the sync_cmos_clock workqueue callback
>>>
>>>   - Prarit added a missing function declaration to fix a compilation
>>> issue on x86. Please *note*, this patch is coming from a pull from
>>> John's tree, it would make sense to cherry-pick this fix into
>>> timers/urgent
>>>
>>>   - Soren added FEAT_PERCPU to a clock device when it is local per cpu.
>>> This feature prevents the clock framework to choose a per cpu timer as
>>> a broadcast timer. This problem arised when the ARM global timer is
>>> used which is the case now on Xillinx.
>>>
>>>   - Stephen extended the generic sched_clock code to support 64bit
>>> counters and removes the setup_sched_clock deprecation, as that causes
>>> lots of warnings since there's still users in the arch/arm tree.
>>>
>>>   - Will and Sudeep implemented the event stream for architected timer.
>>> The event streams can be used to impose a timeout on a wfe, to
>>> safeguard against any programming error in case an expected event is
>>> not generated or even to implement wfe-based timeouts for userspace
>>> locking implementations.
>>>
>>>   - Zoran prevents to enter suspend mode if there are pending RTC
>>> timers to be handled, avoiding these ones to be delayed as well as the
>>> subsequent possible time critical code tied with them.
>>>
>>
>>
>> Hey Daniel,
>>      So this looks like a strange pull request. You based it on 3.12-rc3
>> instead of the current tip/timers/core (which is what your submitting
>> this to). Unfortunately since the branch you pulled from me was based on
>> tip/timers/core, this pull request seems to be submitting items that are
>> already in tip/timers/core (like the changes from Prarit, Miroslav and
>> Zoran).
>
> Aah right !
>
>> Does any of the changes here actually depend on 3.12-rc3? If not you
>> might just re-generate the branch against tip/timers/core, and you'll
>> end up with a much cleaner pull request.
>
> Ok, I think I misunderstood Thomas's email [1] :s
>

Right, so you want to avoid rebasing other's work, but you also want to
avoid unnecssary merges.

Its requires a change in thinking, since so often we're preeoccupied
with "keeping up" with Linus' HEAD. But when it comes to submitting
branches for others to pull, we want to preserve the history of the
patches, and submit them as they were applied to the git tree
originally. Thus submitting "old" branches isn't really problematic.

Thus you only want to do merges if you know there will be complex
collisions with future work (which you can easily test in a private
temporary branch), or you are adding new work that depends on recent
changes. Otherwise leave it to the person pulling your branch to do the
merge with their tree.


> No changes depend on 3.12-rc3, I will generate a pull request against
> tip/timers/core. 

No problem.

thanks
-john

