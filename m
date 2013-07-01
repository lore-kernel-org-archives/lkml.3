Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab3GAMov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 08:44:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49358 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab3GAMou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 08:44:50 -0400
Date: Mon, 1 Jul 2013 14:44:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lei Wen <leiwen@marvell.com>
Cc: Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [V2 1/2] sched: add trace events for task and rq usage tracking
Message-ID: <20130701124407.GB21726@dyad.programming.kicks-ass.net>
References: <1372662634-12833-1-git-send-email-leiwen@marvell.com>
 <1372682002-15373-1-git-send-email-leiwen@marvell.com>
 <1372682002-15373-2-git-send-email-leiwen@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372682002-15373-2-git-send-email-leiwen@marvell.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 08:33:21PM +0800, Lei Wen wrote:
> Since we could track task in the entity level now, we may want to
> investigate tasks' running status by recording the trace info, so that
> could make some tuning if needed.

Why would I want to merge this?


> +	trace_sched_task_weighted_load(task_of(se), se->avg.load_avg_contrib, se->load.weight);
> +	trace_sched_task_weighted_load(task_of(se), se->avg.load_avg_contrib, se->load.weight);

> +		trace_sched_cfs_rq_runnable_load(cpu_of(rq_of(cfs_rq)),
> +				cfs_rq->runnable_load_avg, cfs_rq->load.weight);

> +		trace_sched_cfs_rq_blocked_load(cpu_of(rq_of(cfs_rq)),
> +				cfs_rq->blocked_load_avg,
> +				cfs_rq->blocked_load_avg + cfs_rq->runnable_load_avg);

> +	trace_sched_cfs_rq_blocked_load(cpu_of(rq_of(cfs_rq)),
> +			cfs_rq->blocked_load_avg,
> +			cfs_rq->blocked_load_avg + cfs_rq->runnable_load_avg);

> +		trace_sched_cfs_rq_blocked_load(cpu_of(rq_of(cfs_rq)),
> +				cfs_rq->blocked_load_avg,
> +				cfs_rq->blocked_load_avg + cfs_rq->runnable_load_avg);

> +	trace_sched_cfs_rq_runnable_load(cpu_of(rq_of(cfs_rq)),
> +			cfs_rq->runnable_load_avg, cfs_rq->load.weight);

> +		trace_sched_cfs_rq_blocked_load(cpu_of(rq_of(cfs_rq)),
> +				cfs_rq->blocked_load_avg,
> +				cfs_rq->blocked_load_avg + cfs_rq->runnable_load_avg);

> +		trace_sched_cfs_rq_blocked_load(cpu_of(rq_of(cfs_rq)),
> +				cfs_rq->blocked_load_avg,
> +				cfs_rq->blocked_load_avg + cfs_rq->runnable_load_avg);

> +		trace_sched_cfs_rq_blocked_load(cpu_of(rq_of(cfs_rq)),
> +				cfs_rq->blocked_load_avg,
> +				cfs_rq->blocked_load_avg + cfs_rq->runnable_load_avg);

You're not lazy enough by far, you seem to delight in endless repetition :/

How about you first convince me we actually want to merge this; big hint,
there's a significant lack of tracepoints in the entire balancer.

Secondly; WTH didn't you do:

  trace_sched_task_weighted_load(se);
  trace_sched_cfs_rq_runnable_load(cfs_rq);
  trace_sched_cfs_rq_blocked_load(cfs_rq);

The tracepoints themselves could very well extract whatever they want from
that; no need to actually write it out.
