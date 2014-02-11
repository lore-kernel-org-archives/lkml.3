Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaBKPsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:48:54 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61439 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaBKPsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:48:53 -0500
Message-ID: <52FA4663.60806@linaro.org>
Date: Tue, 11 Feb 2014 16:48:51 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH] sched/fair: Remove idle_balance() declaration in sched.h
References: <1392130864-4416-1-git-send-email-daniel.lezcano@linaro.org> <20140211151148.GP27965@twins.programming.kicks-ass.net> <52FA42D4.9050401@linaro.org> <20140211154614.GQ27965@twins.programming.kicks-ass.net>
In-Reply-To: <20140211154614.GQ27965@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 04:46 PM, Peter Zijlstra wrote:
> On Tue, Feb 11, 2014 at 04:33:40PM +0100, Daniel Lezcano wrote:
>> On 02/11/2014 04:11 PM, Peter Zijlstra wrote:
>>> On Tue, Feb 11, 2014 at 04:01:04PM +0100, Daniel Lezcano wrote:
>>>> The idle_balance() function is called within a #ifdef CONFIG_SMP section.
>>>>
>>>> Remove its declaration in sched.h for !CONFIG_SMP because it is pointless.
>>>>
>>>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>>>
>>> The below again makes a horrible mess of idle_balance() -- which you
>>> tried to clean up.. but it does rid us of some #ifdef goo.
>>>
>>> Hmmm?
>>
>> Yes, it sounds ok.
>>
>> Why is idle_enter_fair() called unconditionally in idle_balance() ?
>> Isn't the call in pick_next_task_idle enough ?  Shouldn't be called when we
>> will go to idle effectively ?
>>
>> If I am not wrong idle_enter_fair() is called from idle_balance() but a task
>> may be pulled, so we the next task won't be the idle task and idle_exit_fair
>> won't be called at put_prev_task.
>>
>> May be I missed this change which was done at purpose in the previous
>> patchset you sent...
>
> lkml.kernel.org/r/CAKfTPtAMmhq0tBpu+pk_uzwrfUM-6Fz4Do1yrzc4NRQS4cZ_-A@mail.gmail.com
>
> I seem to be terminally confused on the subject, but Vincent explains it
> there I think.

Ok, thanks. I will read again the thread carefully.

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

