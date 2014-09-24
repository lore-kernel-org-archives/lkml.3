Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbaIXNNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:13:09 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55433 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaIXNNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:13:07 -0400
Date: Wed, 24 Sep 2014 15:13:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kan.liang@intel.com
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        paulus@samba.org, acme@kernel.org, ak@linux.intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH V5 02/16] perf, core: introduce pmu context switch
 callback
Message-ID: <20140924131302.GC2805@worktop.programming.kicks-ass.net>
References: <1410358153-421-1-git-send-email-kan.liang@intel.com>
 <1410358153-421-3-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410358153-421-3-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:08:59AM -0400, kan.liang@intel.com wrote:
> @@ -2446,6 +2499,9 @@ void __perf_event_task_sched_out(struct task_struct *task,
>  {
>  	int ctxn;
>  
> +	if (__get_cpu_var(perf_sched_cb_usages))
> +		perf_pmu_sched_task(task, next, false);
> +
>  	for_each_task_context_nr(ctxn)
>  		perf_event_context_sched_out(task, ctxn, next);
>  
> @@ -2703,6 +2759,9 @@ void __perf_event_task_sched_in(struct task_struct *prev,
>  	/* check for system-wide branch_stack events */
>  	if (atomic_read(&__get_cpu_var(perf_branch_stack_events)))
>  		perf_branch_stack_sched_in(prev, task);
> +
> +	if (__get_cpu_var(perf_sched_cb_usages))
> +		perf_pmu_sched_task(prev, task, true);
>  }
>  

I think the general idea was to get rid of __get_cpu_var() and co,
please consider using __this_cpu_read().
