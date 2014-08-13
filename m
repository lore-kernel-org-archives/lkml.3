Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbaHMONG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 10:13:06 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:54255 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751749AbaHMONE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 10:13:04 -0400
Date: Wed, 13 Aug 2014 10:13:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: Re: [PATCH v5 tip/core/rcu 15/16] rcu: Make RCU-tasks wait for idle
 tasks
Message-ID: <20140813101301.08019895@gandalf.local.home>
In-Reply-To: <20140813140705.GO9918@twins.programming.kicks-ass.net>
References: <20140811224840.GA25594@linux.vnet.ibm.com>
	<1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
	<1407797345-28227-15-git-send-email-paulmck@linux.vnet.ibm.com>
	<20140813081215.GB9918@twins.programming.kicks-ass.net>
	<20140813124818.GQ4752@linux.vnet.ibm.com>
	<20140813134025.GN9918@twins.programming.kicks-ass.net>
	<20140813095132.56d288f2@gandalf.local.home>
	<20140813140705.GO9918@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2014 16:07:05 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Aug 13, 2014 at 09:51:32AM -0400, Steven Rostedt wrote:
> 
> > I still need to look at the patches, but if this is just for the idle
> > case, then we don't need it. The idle case can be solved with a simple
> > sched_on_each_cpu(). I need a way to solve waiting for processes to
> > finish from a preemption point.
> > 
> > That's all I want, and if we can remove the "idle" case and document it
> > well that it's not covered and a sched_on_each_cpu() may be needed,
> > then I'm fine with that.
> > 
> > 	sched_on_each_cpu(dummy_op);
> > 	call_rcu_tasks(free_tramp);
> 
> Sure, but why not dtrt and push rcu_idle hooks all the way down into the
> idle drivers if and where appropriate?
> 
> There isn't _that_ much idle driver code. Also, some stuff should be
> cleaned up; we're already calling stop_critical_timings() in the generic
> idle code, and then calling it again in the cpuidle drivers.
> 
> 

True, perhaps the rcu code should hook into the stop_critical_timings
code?

-- Steve
