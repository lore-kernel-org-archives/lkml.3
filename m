Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaGGWiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:38:04 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:43710 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaGGWiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:38:02 -0400
Date: Mon, 7 Jul 2014 15:37:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/17] Miscellaneous fixes for 3.17
Message-ID: <20140707223756.GA7187@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-1344-0000-0000-000002A9C221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series provides miscellaneous fixes:

1.	Document deadlock-avoidance information in rcu_read_unlock()'s
	docbook comment header.

2.	Remove obsolete references to TINY_PREEMPT_RCU.

3.	Add deadlock explanation to local_irq_save() call in
	__lock_task_sighand().

4.	Make the rcu_node arrays be static const char * const,
	courtesy of Fabian Frederick.

5.	Remove redundant ACCESS_ONCE() from tick_do_timer_cpu under
	#ifdef CONFIG_NO_HZ_FULL.

6.	Eliminate read-modify-write ACCESS_ONCE() calls.

7.	Loosen __call_rcu()'s rcu_head alignment constraint to handle
	m68k's 16-bit alignment.

8.	Allow post-unlock reference for rt_mutex.

9.	Check both root and current rcu_node structures when setting up
	future grace periods, courtesy of Pranith Kumar.

10.	Simplify priority boosting by putting rt_mutex in rcu_node
	structure.

11.	Bind grace-period kthreads to no-NO_HZ_FULL CPUs instead of the
	timekeeping CPU, at least for CONFIG_NO_HZ_FULL_SYSIDLE=n.

12.	Don't use NMIs to dump other CPUs' stacks.

13.	Use __this_cpu_read() instead of per_cpu_ptr(), courtesy of Shan Wei.

14.	Remove CONFIG_PROVE_RCU_DELAY.

15.	Fix __rcu_reclaim to use true/false instead of 1/0.

16.	Fix sparse warning in rcu_initiate_boost(), courtesy of Pranith
	Kumar.

17.	Fix sparse warning in rcu_report_unblock_qs_rnp(), again courtesy
	of Pranith Kumar.

							Thanx, Paul

------------------------------------------------------------------------

 b/include/linux/init_task.h                               |    9 --
 b/include/linux/rcupdate.h                                |   45 ++++++++--
 b/include/linux/sched.h                                   |    6 -
 b/include/linux/tick.h                                    |   19 ++++
 b/init/Kconfig                                            |    2 
 b/kernel/rcu/rcu.h                                        |    8 +
 b/kernel/rcu/srcu.c                                       |    4 
 b/kernel/rcu/tree.c                                       |   59 ++++++--------
 b/kernel/rcu/tree.h                                       |    8 +
 b/kernel/rcu/tree_plugin.h                                |   52 +++++++-----
 b/kernel/rcu/update.c                                     |    3 
 b/kernel/signal.c                                         |    4 
 b/kernel/time/tick-sched.c                                |   10 ++
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE01   |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE02   |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE02-T |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE03   |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE04   |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE05   |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE06   |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE07   |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE08   |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE09   |    1 
 24 files changed, 147 insertions(+), 93 deletions(-)

