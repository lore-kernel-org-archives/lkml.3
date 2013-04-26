Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877Ab3DZKeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 06:34:22 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:40128 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759832Ab3DZKeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 06:34:21 -0400
Message-ID: <517A57BB.8000009@linux.vnet.ibm.com>
Date: Fri, 26 Apr 2013 16:02:27 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        mingo@kernel.org, linux@arm.linux.org.uk, pjt@google.com,
        santosh.shilimkar@ti.com, morten.rasmussen@arm.com,
        chander.kashyap@linaro.org, cmetcalf@tilera.com, tony.luck@intel.com,
        alex.shi@intel.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        len.brown@intel.com, arjan@linux.intel.com, amit.kucheria@linaro.org,
        corbet@lwn.net
Subject: Re: [RFC PATCH v3 3/6] sched: pack small tasks
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org> <1363955155-18382-4-git-send-email-vincent.guittot@linaro.org> <1364300782.5053.6.camel@laptop> <5152C83F.6060509@linux.vnet.ibm.com> <20130426101849.GD8669@dyad.programming.kicks-ass.net>
In-Reply-To: <20130426101849.GD8669@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042610-7014-0000-0000-000002EA33C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 04/26/2013 03:48 PM, Peter Zijlstra wrote:
> On Wed, Mar 27, 2013 at 03:51:51PM +0530, Preeti U Murthy wrote:
>> Hi,
>>
>> On 03/26/2013 05:56 PM, Peter Zijlstra wrote:
>>> On Fri, 2013-03-22 at 13:25 +0100, Vincent Guittot wrote:
>>>> +static bool is_buddy_busy(int cpu)
>>>> +{
>>>> +       struct rq *rq = cpu_rq(cpu);
>>>> +
>>>> +       /*
>>>> +        * A busy buddy is a CPU with a high load or a small load with
>>>> a lot of
>>>> +        * running tasks.
>>>> +        */
>>>> +       return (rq->avg.runnable_avg_sum >
>>>> +                       (rq->avg.runnable_avg_period / (rq->nr_running
>>>> + 2)));
>>>> +}
>>>
>>> Why does the comment talk about load but we don't see it in the
>>> equation. Also, why does nr_running matter at all? I thought we'd
>>> simply bother with utilization, if fully utilized we're done etc..
>>>
>>
>> Peter, lets say the run-queue has 50% utilization and is running 2
>> tasks. And we wish to find out if it is busy. We would compare this
>> metric with the cpu power, which lets say is 100.
>>
>> rq->util * 100 < cpu_of(rq)->power.
>>
>> In the above scenario would we declare the cpu _not_busy? Or would we do
>> the following:
>>
>> (rq->util * 100) * #nr_running <  cpu_of(rq)->power and conclude that it
>> is just enough _busy_ to not take on more processes?
> 
> That is just confused... ->power doesn't have anything to do with a per-cpu
> measure. ->power is a inter-cpu measure of relative compute capacity.

Ok.

> 
> Mixing in nr_running confuses things even more; it doesn't matter how many
> tasks it takes to push utilization up to 100%; once its there the cpu simply
> cannot run more.

True, this is from the perspective of the CPU. But will not the tasks on
this CPU get throttled if, you find the utilization of this CPU < 100%
and decide to put more tasks on it?

Regards
Preeti U Murthy


