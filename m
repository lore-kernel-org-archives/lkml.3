Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaKPXT6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 18:19:58 -0500
Received: from mga03.intel.com ([134.134.136.65]:64026 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbaKPXT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 18:19:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="487896462"
Date: Mon, 17 Nov 2014 06:59:14 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@arm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] sched/deadline: support dl task migration during cpu
 hotplug
Message-ID: <20141116225914.GA6951@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1415754413-13988-1-git-send-email-wanpeng.li@linux.intel.com>
 <1415809626.15631.35.camel@tkhai>
 <20141112225636.GA23249@kernel>
 <1415873444.15631.42.camel@tkhai>
 <546485A2.7050501@gmail.com>
 <1415874091.15631.44.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415874091.15631.44.camel@tkhai>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill,
On Thu, Nov 13, 2014 at 01:21:31PM +0300, Kirill Tkhai wrote:
>> >>>> @@ -1185,8 +1223,9 @@ static int find_later_rq(struct task_struct *task)
>> >>>>   	 * We have to consider system topology and task affinity
>> >>>>   	 * first, then we can look for a suitable cpu.
>> >>>>   	 */
>> >>>> -	cpumask_copy(later_mask, task_rq(task)->rd->span);
>> >>>> -	cpumask_and(later_mask, later_mask, cpu_active_mask);
>> >>>> +	cpumask_copy(later_mask, cpu_active_mask);
>> >>>> +	if (likely(task_rq(task)->online))
>> >>>> +		cpumask_and(later_mask, later_mask, task_rq(task)->rd->span);
>> >>>>   	cpumask_and(later_mask, later_mask, &task->cpus_allowed);
>> >>>>   	best_cpu = cpudl_find(&task_rq(task)->rd->cpudl,
>> >>>>   			task, later_mask);
>> > Also, we should think about the following situation.
>> >
>> > DL task is left on dead rq. In your scheme it will be moved by the timer.
>> > But what will be if somebody changes the class of the task (before timer)?
>> 
>> I think timer will be cancelled in switched_from_dl().
>
>Yeah, but nobody will move this task to alive rq.
>
>> 
>> Regards,
>> Wanpeng Li
>> 
>> > In this case the task still remains on dead rq.
>> >
>> > We should handle this situation in some way.

Your proposal is a great appreciated. 

Regards,
Wanpeng Li 

>> >
>> > Kirill
>> >
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>> 
>
