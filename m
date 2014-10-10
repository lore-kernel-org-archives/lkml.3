Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbaJJUc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 16:32:28 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42563 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbaJJUc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 16:32:26 -0400
Date: Fri, 10 Oct 2014 22:32:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH 1/1] sched: make finish_task_switch() return struct rq *
Message-ID: <20141010203220.GC3343@worktop.programming.kicks-ass.net>
References: <20141007195046.GA28002@redhat.com>
 <20141009193207.GA5408@redhat.com>
 <20141009193232.GB5408@redhat.com>
 <20141010100643.GI10832@worktop.programming.kicks-ass.net>
 <20141010170641.GB14401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141010170641.GB14401@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 07:06:42PM +0200, Oleg Nesterov wrote:
> On 10/10, Peter Zijlstra wrote:
> >
> > On Thu, Oct 09, 2014 at 09:32:32PM +0200, Oleg Nesterov wrote:
> > > @@ -2802,15 +2802,8 @@ need_resched:
> > >  		rq->curr = next;
> > >  		++*switch_count;
> > >
> > > -		context_switch(rq, prev, next); /* unlocks the rq */
> > > -		/*
> > > -		 * The context switch have flipped the stack from under us
> > > -		 * and restored the local variables which were saved when
> > > -		 * this task called schedule() in the past. prev == current
> > > -		 * is still correct, but it can be moved to another cpu/rq.
> > > -		 */
> > > -		cpu = smp_processor_id();
> > > -		rq = cpu_rq(cpu);
> > > +		rq = context_switch(rq, prev, next); /* unlocks the rq */
> > > +		cpu = rq->cpu;
> >
> > This won't compile on UP, cpu_of(rq) works though.
> 
> Heh ;) and I swear I was going to write cpu_of().
> 
> and I agree with BUG_ON() in __trace_sched_switch() if CONFIG_SCHED_DEBUG.
> 
> I am travelling till next Wednesday, will resend everything once I return.

Not towards DUS by any chance? I fixed up the patches, they should be in
here:
  https://git.kernel.org/cgit/linux/kernel/git/peterz/queue.git/log/?h=sched/core

If I missed some, please do resend (or ping me on) those.
