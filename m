Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaAPMQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 07:16:20 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:50316 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaAPMQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 07:16:17 -0500
Message-ID: <52D7CD8C.3010506@linaro.org>
Date: Thu, 16 Jan 2014 13:16:12 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Alex Shi <alex.shi@linaro.org>, mingo@redhat.com, tglx@linutronix.de,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org,
        Michael wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] sched: find the latest idle cpu
References: <1389758879-19951-1-git-send-email-alex.shi@linaro.org> <20140115073533.GU31570@twins.programming.kicks-ass.net> <52D69D44.4090504@linaro.org> <52D7BC71.9010908@linaro.org> <20140116113801.GN31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140116113801.GN31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 12:38 PM, Peter Zijlstra wrote:
> On Thu, Jan 16, 2014 at 12:03:13PM +0100, Daniel Lezcano wrote:
>> Hi Alex,
>>
>> it is a nice optimization attempt but I agree with Peter we should focus on
>> integrating cpuidle.
>>
>> The question is "how do we integrate cpuidle ?"
>>
>> IMHO, the main problem are the governors, especially the menu governor.
>
> Yah.
>
>> The menu governor tries to predict the events per cpu. This approach which
>> gave us a nice benefit for the power saving may not fit well for the
>> scheduler.
>
> So the way to start all this is I think to gradually share more and
> more.
>
> Start by pulling in the actual idle state; such that we can indeed
> observe what the relative cost is of waking a cpu (against another), and
> maybe even the predicted wakeup time.

Ok, I will send a patch for this.

> Then pull in the various statistics gathering bits -- without improving
> them.
>
> Then improve the statistics; try and remove duplicate statistics -- if
> there's such things, try and use the extra information the scheduler has
> etc..
>
> Then worry about the governors, or what's left of them.
>
>> In order to finish integrating the cpuidle framework in the scheduler, there
>> are pending questions about the impact in the current design.
>>
>> Peter or Ingo, if you have time, could you have a look at the email I sent
>> previously [1] ?
>
> I read it once, it didn't make sense at the time, I just read it again,
> still doesn't make sense.

:)

The question raised when I looked closely how to fully integrate cpuidle 
with the scheduler; in particular, the idle time.
The scheduler idle time is not the same than the cpuidle idle time.
A cpu can be idle for the scheduler 1s but it could be interrupted 
several times by an interrupt thus the idle time for cpuidle is 
different. But anyway ...

> We need the idle task, since we need to DO something to go idle, the
> scheduler needs to pick a task to go do that something. This is the idle
> task.
>
> You cannot get rid of that.
>
> In fact, the 'doing' of that task is running much of the cpuidle code,
> so by getting rid of it, there's nobody left to execute that code.
>
> Also, since its already running that cpuidle stuff, integrating it more
> closely with the scheduler will not in fact change much, it will still
> run it.
>
> Could of course be I'm not reading what you meant to write, if so, do
> try again ;-)

Well, I wanted to have a clarification of what was your feeling about 
how to integrate cpuidle in the scheduler. If removing the idle task (in 
the future) does not make sense for you, I will not insist. Let's see 
how the code evolves by integrating cpuidle and we will figure out what 
will be the impact on the idle task.

Thanks for your feedbacks

   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

