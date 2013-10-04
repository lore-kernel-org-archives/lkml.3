Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab3JDPQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 11:16:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49058 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab3JDPQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 11:16:29 -0400
Date: Fri, 4 Oct 2013 17:16:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Huang Ying <ying.huang@intel.com>, lkp@linux.intel.com
Subject: Re: [PATCH] ftrace, sched: Add TRACE_FLAG_PREEMPT_RESCHED
Message-ID: <20131004151618.GO3081@twins.programming.kicks-ass.net>
References: <tip-7a7m5qqbn5pmwnd4wko9u6da@git.kernel.org>
 <20130927091427.GE24743@yliu-dev.sh.intel.com>
 <20130927152908.GE15690@laptop.programming.kicks-ass.net>
 <20131004080909.GP26785@twins.programming.kicks-ass.net>
 <20131004105342.20c00a41@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004105342.20c00a41@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 10:53:42AM -0400, Steven Rostedt wrote:
> On Fri, 4 Oct 2013 10:09:09 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Fri, Sep 27, 2013 at 05:29:08PM +0200, Peter Zijlstra wrote:
> > > Subject: ftrace, sched: Add TRACE_FLAG_PREEMPT_RESCHED
> > > From: Peter Zijlstra <peterz@infradead.org>
> > > Date: Fri Sep 27 17:11:00 CEST 2013
> > > 
> > > Since we now have two need_resched states; trace the two so we can
> > > observe discrepancies.
> > > 
> > > Cc: Steven Rostedt <rostedt@goodmis.org>
> > > Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> > 
> > Steve, if you're done conferencing.. any objections?
> > 
> 
> Taking a quick look, my only objection so far is that the change log is
> rather flimsy. What are the two states and what are their dependencies?
> 
> In other words, what does these flags in the trace actually mean?
> Probably need to add comments in the code and/or update the
> Documentation section

Ah, you missed the preemption series?

1a338ac32ca6 sched, x86: Optimize the preempt_schedule() call
c2daa3bed53a sched, x86: Provide a per-cpu preempt_count implementation
a233f1120c37 sched: Prepare for per-cpu preempt_count
bdb438065890 sched: Extract the basic add/sub preempt_count modifiers
01028747559a sched: Create more preempt_count accessors
a787870924db sched, arch: Create asm/preempt.h
f27dde8deef3 sched: Add NEED_RESCHED to the preempt_count
4a2b4b222743 sched: Introduce preempt_count accessor functions
ea8117478918 sched, idle: Fix the idle polling state logic
315039862646 sched: Remove {set,clear}_need_resched
b021fe3e2509 sched, rcu: Make RCU use resched_cpu()
0c44c2d0f459 x86: Use asm goto to implement better modify_and_test() functions

preempt_count now includes a NEED_RESCHED and this patch shows which
is set: N both PREEMPT_NEED_RESCHED and TIF_NEED_RESCHED, n for TIF only
and p for preempt only.
