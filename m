Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbaKDPLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:11:20 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:49710 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbaKDPLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:11:16 -0500
Date: Tue, 4 Nov 2014 16:11:09 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "pang.xunlei" <pang.xunlei@linaro.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH v2 5/6] sched/dl: Optimize select_task_rq_dl() for non-DL
 curr task
Message-ID: <20141104151109.GI10501@worktop.programming.kicks-ass.net>
References: <1415099585-31174-1-git-send-email-pang.xunlei@linaro.org>
 <1415099585-31174-5-git-send-email-pang.xunlei@linaro.org>
 <20141104094549.59acebb6@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104094549.59acebb6@gandalf.local.home>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 09:45:49AM -0500, Steven Rostedt wrote:
> > +++ b/kernel/sched/deadline.c
> > @@ -954,6 +954,9 @@ select_task_rq_dl(struct task_struct *p, int cpu, int sd_flag, int flags)
> >  	struct task_struct *curr;
> >  	struct rq *rq;
> >  
> > +	if (p->nr_cpus_allowed == 1)
> > +		goto out;
> > +
> 
> This looks fine, and I'm wondering if we shouldn't just move this into
> kernel/sched/core.c: select_task_rq(). Why bother calling the select_rq
> code if the task is pinned?
> 
> This change will make fair.c, rt.c, and deadline.c all start with the
> same logic. If this should be an optimization, just move it to core.c
> and be done with it.

Yeah, that makes sense. Back when, in the olden days, nr_cpus_allowed
was specific to the rt class, but we fixed that.
