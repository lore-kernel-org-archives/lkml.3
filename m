Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab3GANZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 09:25:31 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:56367 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab3GANZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 09:25:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130701124407.GB21726@dyad.programming.kicks-ass.net>
References: <1372662634-12833-1-git-send-email-leiwen@marvell.com>
	<1372682002-15373-1-git-send-email-leiwen@marvell.com>
	<1372682002-15373-2-git-send-email-leiwen@marvell.com>
	<20130701124407.GB21726@dyad.programming.kicks-ass.net>
Date: Mon, 1 Jul 2013 21:25:26 +0800
Message-ID: <CALZhoSR0S1M_9Fu1GjPxYw4LXe-Z0k7TjSUPZKZm6m_scTnnxw@mail.gmail.com>
Subject: Re: [V2 1/2] sched: add trace events for task and rq usage tracking
From: Lei Wen <adrian.wenl@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lei Wen <leiwen@marvell.com>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@elte.hu>,
        mingo@redhat.com, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, Jul 1, 2013 at 8:44 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Jul 01, 2013 at 08:33:21PM +0800, Lei Wen wrote:
>> Since we could track task in the entity level now, we may want to
>> investigate tasks' running status by recording the trace info, so that
>> could make some tuning if needed.
>
> Why would I want to merge this?

With the merged trace point like those, we could then draw the load
distribution picture easily.

>
>
>> +     trace_sched_task_weighted_load(task_of(se), se->avg.load_avg_contrib, se->load.weight);
>> +     trace_sched_task_weighted_load(task_of(se), se->avg.load_avg_contrib, se->load.weight);
>
>> +             trace_sched_cfs_rq_runnable_load(cpu_of(rq_of(cfs_rq)),
>> +                             cfs_rq->runnable_load_avg, cfs_rq->load.weight);
>
>> +             trace_sched_cfs_rq_blocked_load(cpu_of(rq_of(cfs_rq)),
>> +                             cfs_rq->blocked_load_avg,
>> +                             cfs_rq->blocked_load_avg + cfs_rq->runnable_load_avg);
>
>> +     trace_sched_cfs_rq_blocked_load(cpu_of(rq_of(cfs_rq)),
>> +                     cfs_rq->blocked_load_avg,
>> +                     cfs_rq->blocked_load_avg + cfs_rq->runnable_load_avg);
>
>> +             trace_sched_cfs_rq_blocked_load(cpu_of(rq_of(cfs_rq)),
>> +                             cfs_rq->blocked_load_avg,
>> +                             cfs_rq->blocked_load_avg + cfs_rq->runnable_load_avg);
>
>> +     trace_sched_cfs_rq_runnable_load(cpu_of(rq_of(cfs_rq)),
>> +                     cfs_rq->runnable_load_avg, cfs_rq->load.weight);
>
>> +             trace_sched_cfs_rq_blocked_load(cpu_of(rq_of(cfs_rq)),
>> +                             cfs_rq->blocked_load_avg,
>> +                             cfs_rq->blocked_load_avg + cfs_rq->runnable_load_avg);
>
>> +             trace_sched_cfs_rq_blocked_load(cpu_of(rq_of(cfs_rq)),
>> +                             cfs_rq->blocked_load_avg,
>> +                             cfs_rq->blocked_load_avg + cfs_rq->runnable_load_avg);
>
>> +             trace_sched_cfs_rq_blocked_load(cpu_of(rq_of(cfs_rq)),
>> +                             cfs_rq->blocked_load_avg,
>> +                             cfs_rq->blocked_load_avg + cfs_rq->runnable_load_avg);
>
> You're not lazy enough by far, you seem to delight in endless repetition :/

Yep, I already notice this duplicated...


>
> How about you first convince me we actually want to merge this; big hint,
> there's a significant lack of tracepoints in the entire balancer.

You already said what I want to say. :)
With the pre-embedded tracepoint, we could make our life easy over tracking
the system load, especially since the per-entity load tracking is
recently added,
people may want to use those trace point to get better understanding for
this new feature.

>
> Secondly; WTH didn't you do:
>
>   trace_sched_task_weighted_load(se);
>   trace_sched_cfs_rq_runnable_load(cfs_rq);
>   trace_sched_cfs_rq_blocked_load(cfs_rq);

So cleaner than my previous one!

>
> The tracepoints themselves could very well extract whatever they want from
> that; no need to actually write it out.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
