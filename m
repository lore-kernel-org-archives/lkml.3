Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab3DLXsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 19:48:24 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:38186 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab3DLXsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 19:48:23 -0400
Date: Fri, 12 Apr 2013 16:48:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/12] TINY_RCU changes for 3.11
Message-ID: <20130412234810.GA23678@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041223-2398-0000-0000-000013401289
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series removes TINY_PREEMPT_RCU, as promised/threatened at
http://lwn.net/Articles/541037/ and https://lkml.org/lkml/2012/11/12/545.

1.	Remove TINY_PREEMPT_RCU.  This is a straight syntactic removal,
	with no attempt at cleanup.  The remaining patches do the cleanup.

2.	Inline the now-empty show_tiny_preempt_stats() function.

3.	Inline the now-empty rcu_preempt_check_callbacks() function.

4.	Inline the now-empty rcu_preempt_remove_callbacks() function.

5.	Inline the now-empty rcu_preempt_process_callbacks() function.

6.	Because TINY_RCU no longer has kthreads, remove the code that
	used to abstract away kthread vs. softirq invocation.

7.	Inline the now-empty check_cpu_stall_preempt() function.

8.	Remove CONFIG_TINY_RCU ifdefs from include/linux/rcutiny.h

9.	Inline the now-empty rcu_preempt_note_context_switch() function.

10.	Move code to allow consolidating ifdefs in kernel/rcutiny_plugin.h.

11.	Remove TINY_PREEMPT_RCU's tracing formats from documentation.

12.	Shrink TINY_RCU a bit by moving exit_rcu() to TREE_RCU, leaving
	TINY_RCU with a static inline empty function.

							Thanx, Paul


 b/Documentation/RCU/trace.txt |  100 ----
 b/include/linux/hardirq.h     |    2 
 b/include/linux/rcupdate.h    |    5 
 b/include/linux/rcutiny.h     |   41 -
 b/include/linux/rcutree.h     |    3 
 b/init/Kconfig                |   10 
 b/kernel/rcupdate.c           |   26 -
 b/kernel/rcutiny.c            |   17 
 b/kernel/rcutiny_plugin.h     | 1017 +-----------------------------------------
 b/kernel/rcutree_plugin.h     |   26 +
 10 files changed, 90 insertions(+), 1157 deletions(-)

