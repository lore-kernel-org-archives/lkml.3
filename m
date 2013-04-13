Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab3DMSa7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 14:30:59 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:59291 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab3DMSa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 14:30:57 -0400
X-Originating-IP: 50.43.39.152
Date: Sat, 13 Apr 2013 11:30:49 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/12] TINY_RCU changes for 3.11
Message-ID: <20130413183049.GC12096@leaf>
References: <20130412234810.GA23678@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130412234810.GA23678@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 04:48:10PM -0700, Paul E. McKenney wrote:
> This series removes TINY_PREEMPT_RCU, as promised/threatened at
> http://lwn.net/Articles/541037/ and https://lkml.org/lkml/2012/11/12/545.
> 
> 1.	Remove TINY_PREEMPT_RCU.  This is a straight syntactic removal,
> 	with no attempt at cleanup.  The remaining patches do the cleanup.
> 
> 2.	Inline the now-empty show_tiny_preempt_stats() function.
> 
> 3.	Inline the now-empty rcu_preempt_check_callbacks() function.
> 
> 4.	Inline the now-empty rcu_preempt_remove_callbacks() function.
> 
> 5.	Inline the now-empty rcu_preempt_process_callbacks() function.
> 
> 6.	Because TINY_RCU no longer has kthreads, remove the code that
> 	used to abstract away kthread vs. softirq invocation.
> 
> 7.	Inline the now-empty check_cpu_stall_preempt() function.
> 
> 8.	Remove CONFIG_TINY_RCU ifdefs from include/linux/rcutiny.h
> 
> 9.	Inline the now-empty rcu_preempt_note_context_switch() function.
> 
> 10.	Move code to allow consolidating ifdefs in kernel/rcutiny_plugin.h.
> 
> 11.	Remove TINY_PREEMPT_RCU's tracing formats from documentation.
> 
> 12.	Shrink TINY_RCU a bit by moving exit_rcu() to TREE_RCU, leaving
> 	TINY_RCU with a static inline empty function.

For 2-7 and 9-12:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

I responded to patch 8 with a note about moving part of it to patch 1;
with that changed,
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
for those two as well.
