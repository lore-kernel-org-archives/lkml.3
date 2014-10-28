Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbaJ1WNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:13:41 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58257 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136AbaJ1WNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:13:38 -0400
Date: Tue, 28 Oct 2014 15:09:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: [PATCH tip/core/rcu 0/9] Miscellaneous fixes for 3.19
Message-ID: <20141028220944.GA26114@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0025-0000-0000-000000F05F10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series provides miscellaneous fixes:

1.	Removes the CONFIG_RCU_CPU_STALL_VERBOSE, so that RCU CPU stall
	warnings are henceforth unconditionally verbose.  (Another RCU
	Kconfig variable bites the dust!)

2.	Allow 1- and 2-byte smp_load_acquire() and smp_store_release().
	This has the side effect of removing support for pre-EV56 Alpha
	CPUs, and the official Alpha maintainers have thus far been
	silent on this issue.

3.	Use rcu_dereference() for accessing struct mapped_device,
	courtesy of Pranith Kumar.

4.	Annotate the dm_table's ->map field with __rcu, courtesy of
	Pranith Kumar.

5.	Add sparse checking for use of RCU_INIT_POINTER() on a non-__rcu
	pointer, courtesy of Pranith Kumar.

6.	Prevent cond_resched_rcu_qs() from doing gratuitous call to
	rcu_note_voluntary_context_switch().

7.	Update the list of rcu_read_unlock() potential deadlocks, courtesy
	of Oleg Nesterov.

8.	Bind rcu_tasks_kthread() to housekeeping CPUs in CONFIG_NO_HZ_FULL
	builds.

9.	Provide lockless_dereference() for times when you want
	rcu_dereference(), but without the sparse and lockdep-RCU noise.

							Thanx, Paul

------------------------------------------------------------------------

 b/Documentation/RCU/stallwarn.txt                             |    6 --
 b/drivers/md/dm.c                                             |   10 ++--
 b/include/linux/compiler.h                                    |    2 
 b/include/linux/rcupdate.h                                    |   24 ++++++++--
 b/kernel/rcu/tree_plugin.h                                    |   13 -----
 b/kernel/rcu/update.c                                         |    3 -
 b/lib/Kconfig.debug                                           |   12 -----
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE01       |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE02       |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE02-T     |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE03       |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE04       |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE05       |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE06       |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE07       |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE08       |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T     |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE09       |    1 
 b/tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt |    3 -
 19 files changed, 30 insertions(+), 54 deletions(-)

