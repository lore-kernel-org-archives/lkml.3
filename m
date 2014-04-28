Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaD1X4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:56:10 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56418 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaD1X4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:56:08 -0400
Date: Mon, 28 Apr 2014 16:56:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/3] Miscellaneous fixes for 3.16
Message-ID: <20140428235600.GA12200@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042823-0928-0000-0000-000001807F88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series provides miscellaneous fixes:

1.	Apply ACCESS_ONCE() to unprotected ->gp_flags accesses.

2.	Fix typo in comment, courtesy of Liu Ping Fan.

3.	Make RCU CPU stall warnings print grace-period numbers in
	signed format to improve readability of stall-warning output.

4.	Make cpu_needs_another_gp() take future grace-period needs
	into account.

5.	Remove unused ->preemptible field from the rcu_data structure,
	courtesty of Iulia Manda.

6.	Apply ACCESS_ONCE() to unprotected ->jiffies_stall accesses,
	courtesty of Iulia Manda.

7.	Make callers responsible for grace-period kthread wakeup in
	order to avoid potential silent grace-period stalls.

8.	Remove "extern" from RCU function declarations, courtesy of
	Iulia Manda.

9.	Apply ACCESS_ONCE() to additional ->jiffies_stall accesses,
	courtesy of Himangi Saraogi.

10.	Add event tracing to dyntick_save_progress_counter(), courtesy
	of Andreea-Cristina Bernat.

11.	Make rcu_init_one() use nr_cpu_ids instead of NR_CPUS for
	data-structure setup limit check, courtesy of Himangi Saraogi.

12.	Remove redundant kfree_call_rcu() definition by using the
	rcu_state pointer, courtesy of Andreea-Cristina Bernat.

13.	Merge rcu_sched_force_quiescent_state() definition with
	rcu_force_quiescent_state() by using the rcu_state pointer,
	courtesy of Andreea-Cristina Bernat.

14.	Document RCU_INIT_POINTER()'s lack of ordering guarantees.

15.	Automatically bind RCU's grace-period kthreads to timekeeping
	CPU for NO_HZ_FULL builds.

16.	Make large and small sysidle systems use equivalent state machine.

17.	Remove duplicate resched_cpu() declaration, courtesy of
	Pranith Kumar.

18.	Replace deprecated __this_cpu_ptr() uses with raw_cpu_ptr(),
	courtesy of Christoph Lameter.

19.	Make softirq processing provide a quiescent state only once
	per full pass over all softirqs rather than once per action,
	courtesy of Eric Dumazet.

							Thanx, Paul

------------------------------------------------------------------------

 b/include/linux/rcupdate.h |    5 
 b/kernel/rcu/tiny_plugin.h |    8 -
 b/kernel/rcu/tree.c        |  261 ++++++++++++++++++++++++++++-----------------
 b/kernel/rcu/tree.h        |    3 
 b/kernel/rcu/tree_plugin.h |  120 +++++---------------
 b/kernel/softirq.c         |    4 
 6 files changed, 206 insertions(+), 195 deletions(-)

