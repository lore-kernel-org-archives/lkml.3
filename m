Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbaKLXXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 18:23:15 -0500
Received: from mga03.intel.com ([134.134.136.65]:22961 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbaKLXXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 18:23:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="487028924"
Date: Thu, 13 Nov 2014 07:02:17 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, Wanpeng Li <wanpeng.li@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Kirill Tkhai <ktkhai@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] sched/deadline: support dl task migration during cpu
 hotplug
Message-ID: <20141112230217.GB23249@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1415754413-13988-1-git-send-email-wanpeng.li@linux.intel.com>
 <546377FC.4090408@arm.com>
 <20141112153906.GL29390@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141112153906.GL29390@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,
On Wed, Nov 12, 2014 at 04:39:06PM +0100, Peter Zijlstra wrote:
>On Wed, Nov 12, 2014 at 03:08:44PM +0000, Juri Lelli wrote:
>> > @@ -1185,8 +1223,9 @@ static int find_later_rq(struct task_struct *task)
>> >  	 * We have to consider system topology and task affinity
>> >  	 * first, then we can look for a suitable cpu.
>> >  	 */
>> > -	cpumask_copy(later_mask, task_rq(task)->rd->span);
>> > -	cpumask_and(later_mask, later_mask, cpu_active_mask);
>> > +	cpumask_copy(later_mask, cpu_active_mask);
>> > +	if (likely(task_rq(task)->online))
>> > +		cpumask_and(later_mask, later_mask, task_rq(task)->rd->span);
>> 
>> So, here you consider the span only when the task_rq is online,
>> but there might be others cpus still online belonging to the same
>> rd->span. And you have to consider them when migrating. Actually,
>> migration must still be restricted to the online cpus of task's
>> original rd->span, or I fear you can break clustered scheduling.
>
>Ah, good point that, we must somehow find the right root domain to
>'restore' the task to. Now I'm not entirely sure we still have this.
>Lemme ponder that.

Any idea is a great appreciated. :-)

Regards,
Wanpeng Li 
