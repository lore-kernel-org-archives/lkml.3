Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab3DWEil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 00:38:41 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:52233 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3DWEik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 00:38:40 -0400
Message-ID: <51760FE9.3030607@linux.vnet.ibm.com>
Date: Tue, 23 Apr 2013 10:06:57 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Turner <pjt@google.com>, Santosh <santosh.shilimkar@ti.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Alex Shi <alex.shi@intel.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC PATCH v3 5/6] sched: pack the idle load balance
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org> <1363955155-18382-6-git-send-email-vincent.guittot@linaro.org> <1364302359.5053.21.camel@laptop> <CAKfTPtD=_oS5gJeynUG=ft-Y1zEdxZEMhUPH9hSXx+H2pi4xgA@mail.gmail.com> <1364308932.5053.46.camel@laptop> <CAKfTPtArtgkH5MU_xFAKjLDS-i32g2qQMdvyW=LLkG84tH8Hhg@mail.gmail.com> <5174CE96.3060805@linux.vnet.ibm.com> <CAKfTPtCCCifC=c+xjjnAH_HSqkR80PiQoddQKXPHuZwZawbvcA@mail.gmail.com>
In-Reply-To: <CAKfTPtCCCifC=c+xjjnAH_HSqkR80PiQoddQKXPHuZwZawbvcA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042304-3864-0000-0000-000007D2FD7A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

Thank you very much for bringing about the differences between your
goals and the working of the power aware scheduler patchset.This was
essential for us to understand the various requirements from a power
aware scheduler.After you post out the patchset we could try and
evaluate the following points again.

Thanks

Regards
Preeti U Murthy

On 04/23/2013 01:27 AM, Vincent Guittot wrote:
> On Monday, 22 April 2013, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
>> Hi Vincent,
>>
>> On 04/05/2013 04:38 PM, Vincent Guittot wrote:
>>> Peter,
>>>
>>> After some toughts about your comments,I can update the buddy cpu
>>> during ILB or periofdic LB to a new idle core and extend the packing
>>> mechanism  Does this additional mechanism sound better for you ?
>>
> 
> Hi Preeti,
> 
> I have had a look at Alex patches but i have some concerns with his patches
> -There no notion of power domain which is quite important when we speak
> about power saving IMHO. Packing tasks has got an interest if the idle CPUs
> can reach a useful low power state independently from busy CPUs.
> Architectures have different low power state capabilities which must be
> taken into account. In addition, you can have system which have CPUs with
> better power efficiency and this kind of system are not taken into account.
> -There are some computation of statistics on a potentially large number of
> cpus and groups at each task wake up. This overhead concerns me and such
> amount of computation should only be done when we have more time like the
> periodic load balance.
> -There are some heuristics that will be hard to tune:
>  *powersaving balance period set as 8*max_interval
>  *power saving can do some performance load balance if there was no
> performance load balance in the last 32 balances with no more than 4 perf
> balance in the last 64 balance
>  *sched_burst_threshold
> 
> I'm going to send a proposal for a more aggressive and scalable mode of my
> patches which will take care of my concerns. Let see how this new patchset
> can fit with Alex's ones
> 
> Regards,
> Vincent
> 
>> If the primary goal of this patchset is to pack small tasks in fewer
>> power domains then why not see if the power aware scheduler patchset by
>> Alex does the same for you? The reason being:
>>
>> a.The power aware scheduler also checks if a task is small enough to be
>> packed on a cpu which has just enough capacity to take on that
>> task(leader cpu). This cpu belongs to a scheduler group which is nearly
>> full(group_leader),so we end up packing tasks.
>>
>> b.The overhead of assigning a buddy cpu gets eliminated because the best
>> cpu for packing is decided during wake up.
>>
>> c.This is a scalable solution because if the leader cpu is busy,then any
>> other idle cpu from that group_leader is chosen.Eventually you end up
>> packing anyway.
>>
>> The reason that I am suggesting this is that we could unify the power
>> awareness of the scheduler under one umbrella.And i believe that the
>> current power aware scheduler patchset is flexible enough to do this and
>> that we must cash in on it.
>>
>> Thanks
>>
>> Regards
>> Preeti U Murthy
>>>
>>> Vincent
>>>
>>> On 26 March 2013 15:42, Peter Zijlstra <peterz@infradead.org> wrote:
>>>> On Tue, 2013-03-26 at 15:03 +0100, Vincent Guittot wrote:
>>>>>> But ha! here's your NO_HZ link.. but does the above DTRT and ensure
>>>>>> that the ILB is a little core when possible?
>>>>>
>>>>> The loop looks for an idle CPU as close as possible to the buddy CPU
>>>>> and the buddy CPU is the 1st CPU has been chosen. So if your buddy is
>>>>> a little and there is an idle little, the ILB will be this idle
>>>>> little.
>>>>
>>>> Earlier you wrote:
>>>>
>>>>>       | Cluster 0   | Cluster 1   |
>>>>>       | CPU0 | CPU1 | CPU2 | CPU3 |
>>>>> -----------------------------------
>>>>> buddy | CPU0 | CPU0 | CPU0 | CPU2 |
>>>>
>>>> So extrapolating that to a 4+4 big-little you'd get something like:
>>>>
>>>>       |   little  A9  ||   big A15     |
>>>>       | 0 | 1 | 2 | 3 || 4 | 5 | 6 | 7 |
>>>> ------+---+---+---+---++---+---+---+---+
>>>> buddy | 0 | 0 | 0 | 0 || 0 | 4 | 4 | 4 |
>>>>
>>>> Right?
>>>>
>>>> So supposing the current ILB is 6, we'll only check 4, not 0-3, even
>>>> though there might be a perfectly idle cpu in there.
>>>>
>>>> Also, your scheme fails to pack when cpus 0,4 are filled, even when
>>>> there's idle cores around.
>>>>
>>>> If we'd use the ILB as packing cpu, we would simply select a next pack
>>>> target once the old one fills up.
>>>>
>>>
>>
>>
> 

