Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631Ab3IYBmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:42:23 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:56600 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab3IYBmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:42:19 -0400
Date: Tue, 24 Sep 2013 18:42:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/10] Grace-period-related changes for 3.13
Message-ID: <20130925014210.GA31690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-8236-0000-0000-000002123FD3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains updates to RCU's grace-period processsing, mostly
to improve debuggability of RCU itself.

1.	Add consistency checks to the grace-period initialization logic.

2.	Prevent spurious-wakeup DoS attack on rcu_gp_kthread.

3.	Flag lockless accesses to ->gp_flags with ACCESS_ONCE().

4-6.	Add event tracing to various aspects of RCU grace period processing.

7.	Distinguish between NOCB and non-NOCB rcu_callback trace events.

8.	Add event tracing to track rcu_nocb_kthread() sleeping and awakening.

9.	Avoid sparse warnings in rcu_nocb_wake trace event.

10.	Make RCU use resched_cpu() instead of the current set_need_resched(),
	courtesy of Peter Zijlstra.

							Thanx, Paul


 b/include/trace/events/rcu.h |   80 +++++++++++++++++++++++++++++++++++--------
 b/kernel/rcutiny.c           |    2 -
 b/kernel/rcutree.c           |   71 ++++++++++++++++++++++++++++++++------
 b/kernel/rcutree_plugin.h    |   35 ++++++++++++++++--
 b/kernel/sched/core.c        |   10 +----
 5 files changed, 160 insertions(+), 38 deletions(-)

