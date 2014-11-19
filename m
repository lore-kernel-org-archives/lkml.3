Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551AbaKSX3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:29:30 -0500
Received: from mga03.intel.com ([134.134.136.65]:22034 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932537AbaKSX3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:29:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="488917920"
Date: Thu, 20 Nov 2014 07:08:57 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Juri Lelli <juri.lelli@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Kirill Tkhai <ktkhai@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: Re: [PATCH v5] sched/deadline: support dl task migration during cpu
 hotplug
Message-ID: <20141119230857.GA15664@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1415754413-13988-1-git-send-email-wanpeng.li@linux.intel.com>
 <546377FC.4090408@arm.com>
 <546BD3DB.7050207@gmail.com>
 <546C6D53.2020007@arm.com>
 <546C8D7C.4040808@gmail.com>
 <546C9FE0.9010407@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546C9FE0.9010407@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Juri,
On Wed, Nov 19, 2014 at 01:49:20PM +0000, Juri Lelli wrote:
[...]
>>>>>> @@ -1185,8 +1223,9 @@ static int find_later_rq(struct task_struct *task)
>>>>>>    	 * We have to consider system topology and task affinity
>>>>>>    	 * first, then we can look for a suitable cpu.
>>>>>>    	 */
>>>>>> -	cpumask_copy(later_mask, task_rq(task)->rd->span);
>>>>>> -	cpumask_and(later_mask, later_mask, cpu_active_mask);
>>>>>> +	cpumask_copy(later_mask, cpu_active_mask);
>>>>>> +	if (likely(task_rq(task)->online))
>>>>>> +		cpumask_and(later_mask, later_mask, task_rq(task)->rd->span);
>>>>> So, here you consider the span only when the task_rq is online,
>>>>> but there might be others cpus still online belonging to the same
>>>>> rd->span. And you have to consider them when migrating. Actually,
>>>>> migration must still be restricted to the online cpus of task's
>>>>> original rd->span, or I fear you can break clustered scheduling.
>>>> Sorry, what's clustered scheduling?
>>>>
>>> It's a scheduling configuration in which you restrict tasks to run in
>>> disjoint subsets of system CPUs. Translated to what we have, it's what
>>> you get when you create exclusive cpusets (each one gets a rd) and
>>> associate tasks to them.
>>>
>>> My concern in what above is that you may end up breaking this setup
>>> if you don't consider the sd->span when one of the CPUs of your
>>> cpuset is off. But, Pang Xunlei patches may solve this, I still have to
>>> check :/.
>> 
>> Thanks for your explanation. Could you point out which one of Pang's 
>> patchset solve this? ;-)
>> 
>
>https://lkml.org/lkml/2014/11/17/443 may help with this, although I
>still have to properly look at it.
>

Thanks for your pointing out. Btw, could you review below patches of
mine for deadline? Great thanks for your time. ;-)

https://lkml.org/lkml/2014/11/18/1006
https://lkml.org/lkml/2014/11/19/182
https://lkml.org/lkml/2014/11/19/187

Regards,
Wanpeng Li 


