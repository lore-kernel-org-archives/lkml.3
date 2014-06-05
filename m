Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbaFEKq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 06:46:28 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60940 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaFEKq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 06:46:27 -0400
Message-ID: <53904A97.1070105@linaro.org>
Date: Thu, 05 Jun 2014 12:46:47 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: Move enum CPU_[xxx_]IDLE to private sched.h
References: <1401800345-29468-1-git-send-email-daniel.lezcano@linaro.org> <20140604080214.GJ30445@twins.programming.kicks-ass.net> <20140605101709.GA24277@gmail.com> <53904760.8000808@linaro.org> <20140605103540.GB25232@gmail.com>
In-Reply-To: <20140605103540.GB25232@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 12:35 PM, Ingo Molnar wrote:
>
> * Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>
>> On 06/05/2014 12:17 PM, Ingo Molnar wrote:
>>>
>>> * Peter Zijlstra <peterz@infradead.org> wrote:
>>>
>>>> On Tue, Jun 03, 2014 at 02:59:05PM +0200, Daniel Lezcano wrote:
>>>>> The different enum CPU_IDLE, CPU_NOT_IDLE, CPU_NEWLY_IDLE and
>>>>> CPU_MAX_IDLE_TYPES are only used in kernel/sched/fair.c and
>>>>> kernel/sched/stats.c.
>>>>>
>>>>> Move their definitions in the private 'sched.h' file located in the
>>>>> same place than the files above.
>>>>>
>>>>
>>>> Thanks!
>>>
>>>
>>> So this patch breaks x86 64-bit and 32-bit defconfigs:
>>>
>>> In file included from
>>> /home/mingo/tip/arch/x86/kernel/asm-offsets.c:9:0:
>>> /home/mingo/tip/include/linux/sched.h:939:24: error:
>>> ‘CPU_MAX_IDLE_TYPES’ undeclared here (not in a function)
>>>    unsigned int lb_count[CPU_MAX_IDLE_TYPES];
>>>                          ^
>>> make[2]: *** [arch/x86/kernel/asm-offsets.s] Error 1
>>> make[1]: *** [prepare0] Error 2
>>> make: *** [sub-make] Error 2
>>
>>
>> Gah ! That deserves -10 points to my karma :(
>>
>> I did not enabled CONFIG_SCHEDSTATS.
>>
>> Sorry for the inconvenience.
>
> No problem. sched.h is a bit of a mess when it comes to data structure
> dependencies, due to all of 'struct task_struct' having to be defined
> by the time random kernel code references task->.
>
> But this is about 'struct sched_domain', and I think we might be able
> to move that out of sched.h and into a separate header... In theory
> only scheduler internals (arch topology definitions and cores cheduler
> code) should know about it.

Ok, I will look at it.

Thanks
   -- Daniel



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

