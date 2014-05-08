Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbaEHJQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 05:16:48 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54128 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566AbaEHJQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 05:16:46 -0400
Message-ID: <536B4A23.5080304@linux.vnet.ibm.com>
Date: Thu, 08 May 2014 14:40:59 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Preeti Murthy <preeti.lkml@gmail.com>, Alex Shi <alex.shi@linaro.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>, mingo@redhat.com,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mike Galbraith <efault@gmx.de>, wangyun@linux.vnet.ibm.com,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: [RESEND PATCH V5 0/8] remove cpu_load idx
References: <1397616209-27275-1-git-send-email-alex.shi@linaro.org> <20140424162029.GV11096@twins.programming.kicks-ass.net> <5361982F.3080307@linaro.org> <CAM4v1pPH54OHehb1i-esXTMsGJ-n7ck3V8yDK_rwajVCSmdU1A@mail.gmail.com> <20140506113936.GF11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140506113936.GF11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050809-0320-0000-0000-0000033416CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 05:09 PM, Peter Zijlstra wrote:
> On Tue, May 06, 2014 at 03:24:13PM +0530, Preeti Murthy wrote:
>> Hi Morten, Peter, Alex,
>>
>> In a similar context, I noticed that /proc/loadavg makes use of
>> avenrun[] array which keeps track of the history of the global
>> load average. This however makes use of the sum of
>> nr_running + nr_uninterruptible per cpu. Why are we not
>> using the cpu_load[] array here which also keeps track
>> of the history of per-cpu load and then return a sum of it?
> 
> Entirely different kind of 'load'. Note that you cannot use
> ->nr_uninterruptible per-cpu, also note that sched/proc.c doesn't.

True, I worded it wrong above. It uses the per_cpu nr_running and a
global nr_uninterruptible.

> 
>> Using nr_running to show the global load average would
>> be misleading when entire load balancing is being done on the
>> basis of the history of cfs_rq->runnable_load_avg/cpu_load[]
>> right? IOW, to the best of my understanding we do not use
>> nr_running anywhere to directly determine cpu load in the kernel.
>>
>> My idea was that the global/per_cpu load that we reflect via
>> proc/sys interfaces must be consistent. I haven't really
>> looked at what /proc/schedstat, /proc/stat, top are all reading
>> from. But /proc/loadavg is reading out global nr_running +
>> waiting tasks when this will not give us the accurate picture
>> of the system load especially when there are many short running
>> tasks.
> 
> Nobody said /proc/loadavg is a sane number, but its what it is and since
> its a global number its entirely unsuited for balancing -- not to
> mention all other reasons its crap.

I agree its not meant for balancing. My point was that since its
inaccurate why don't we correct it. But if your argument is that we can
live with /proc/loadavg showing a reasonable view of system load then it
shouldn't be a problem.

Regards
Preeti U Murthy
> 

