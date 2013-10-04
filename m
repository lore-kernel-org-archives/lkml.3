Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab3JDPZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 11:25:23 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:9595 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754396Ab3JDPZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 11:25:22 -0400
Date: Fri, 4 Oct 2013 11:25:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Huang Ying <ying.huang@intel.com>, lkp@linux.intel.com
Subject: Re: [PATCH] ftrace, sched: Add TRACE_FLAG_PREEMPT_RESCHED
Message-ID: <20131004112520.38f6f648@gandalf.local.home>
In-Reply-To: <20131004151618.GO3081@twins.programming.kicks-ass.net>
References: <tip-7a7m5qqbn5pmwnd4wko9u6da@git.kernel.org>
	<20130927091427.GE24743@yliu-dev.sh.intel.com>
	<20130927152908.GE15690@laptop.programming.kicks-ass.net>
	<20131004080909.GP26785@twins.programming.kicks-ass.net>
	<20131004105342.20c00a41@gandalf.local.home>
	<20131004151618.GO3081@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Oct 2013 17:16:18 +0200
Peter Zijlstra <peterz@infradead.org> wrote:
 > Documentation section
> 
> Ah, you missed the preemption series?

Yeah, I've seen them, just haven't looked at them too deeply yet.

> 
> 1a338ac32ca6 sched, x86: Optimize the preempt_schedule() call
> c2daa3bed53a sched, x86: Provide a per-cpu preempt_count implementation
> a233f1120c37 sched: Prepare for per-cpu preempt_count
> bdb438065890 sched: Extract the basic add/sub preempt_count modifiers
> 01028747559a sched: Create more preempt_count accessors
> a787870924db sched, arch: Create asm/preempt.h
> f27dde8deef3 sched: Add NEED_RESCHED to the preempt_count
> 4a2b4b222743 sched: Introduce preempt_count accessor functions
> ea8117478918 sched, idle: Fix the idle polling state logic
> 315039862646 sched: Remove {set,clear}_need_resched
> b021fe3e2509 sched, rcu: Make RCU use resched_cpu()
> 0c44c2d0f459 x86: Use asm goto to implement better modify_and_test() functions
> 
> preempt_count now includes a NEED_RESCHED and this patch shows which
> is set: N both PREEMPT_NEED_RESCHED and TIF_NEED_RESCHED, n for TIF only
> and p for preempt only.

You still need to update Documentation/trace/ftrace.txt. Search for
"need-resched" and that part will need to be updated.

Thanks,

-- Steve
