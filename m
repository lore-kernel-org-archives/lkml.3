Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbaIVWEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 18:04:48 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:40748 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbaIVWEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 18:04:46 -0400
Date: Mon, 22 Sep 2014 14:46:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, bobby.prani@gmail.com, oleg@redhat.com,
        ard.biesheuvel@linaro.org, joe@perches.com, rostedt@goodmis.org,
        dave@stgolabs.net
Subject: [GIT PULL rcu/next] RCU commits for 3.18
Message-ID: <20140922214603.GA6356@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092222-9332-0000-0000-000002198C04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

The changes in this series include:

1.	Update RCU documentation.  These were posted to LKML at
	https://lkml.org/lkml/2014/8/28/378.

2.	Miscellaneous fixes.  These were posted to LKML at
	https://lkml.org/lkml/2014/8/28/386.  An additional fix that
	eliminates a documented (but now inconvenient) deadlock between
	RCU hotplug and expedited grace periods was posted at
	https://lkml.org/lkml/2014/8/28/573.

3.	Changes related to No-CBs CPUs and NO_HZ_FULL.  These were posted
	to LKML at https://lkml.org/lkml/2014/8/28/412.

4.	Torture-test updates.  These were posted to LKML at
	https://lkml.org/lkml/2014/8/28/546 and at
	https://lkml.org/lkml/2014/9/11/1114.

5.	RCU-tasks implementation.  These were posted to LKML at
	https://lkml.org/lkml/2014/8/28/540.

All of these have been exposed to -next testing.
These changes are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next

for you to fetch changes up to dd56af42bd829c6e770ed69812bd65a04eaeb1e4:

  rcu: Eliminate deadlock between CPU hotplug and expedited grace periods (2014-09-18 16:22:27 -0700)

----------------------------------------------------------------
Ard Biesheuvel (1):
      rcu: Define tracepoint strings only if CONFIG_TRACING is set

Davidlohr Bueso (9):
      locktorture: Rename locktorture_runnable parameter
      locktorture: Add documentation
      locktorture: Support mutexes
      locktorture: Teach about lock debugging
      locktorture: Make statistics generic
      torture: Address race in module cleanup
      locktorture: Add infrastructure for torturing read locks
      locktorture: Support rwsems
      locktorture: Introduce torture context

Joe Perches (1):
      rcu: Use pr_alert/pr_cont for printing logs

Oleg Nesterov (1):
      rcu: Uninline rcu_read_lock_held()

Paul E. McKenney (46):
      memory-barriers: Fix control-ordering no-transitivity example
      memory-barriers: Retain barrier() in fold-to-zero example
      memory-barriers: Fix description of 2-legged-if-based control dependencies
      rcu: Break more call_rcu() deadlock involving scheduler and perf
      rcu: Make TINY_RCU tinier by putting error checks under #ifdef
      rcu: Replace flush_signals() with WARN_ON(signal_pending())
      rcu: Add step to initrd documentation
      rcutorture: Test partial nohz_full= configuration
      rcutorture: Specify MAXSMP=y for TREE01
      rcutorture: Specify CONFIG_CPUMASK_OFFSTACK=y for TREE07
      rcutorture: Add callback-flood test
      torture: Print PID in hung-kernel diagnostic message
      torture: Check for nul bytes in console output
      rcu: Add call_rcu_tasks()
      rcu: Provide cond_resched_rcu_qs() to force quiescent states in long loops
      rcu: Add synchronous grace-period waiting for RCU-tasks
      rcu: Make TASKS_RCU handle tasks that are almost done exiting
      rcutorture: Add torture tests for RCU-tasks
      rcutorture: Add RCU-tasks test cases
      rcu: Add stall-warning checks for RCU-tasks
      rcu: Improve RCU-tasks energy efficiency
      documentation: Add verbiage on RCU-tasks stall warning messages
      rcu: Defer rcu_tasks_kthread() creation till first call_rcu_tasks()
      rcu: Make TASKS_RCU handle nohz_full= CPUs
      rcu: Make rcu_tasks_kthread()'s GP-wait loop allow preemption
      rcu: Remove redundant preempt_disable() from rcu_note_voluntary_context_switch()
      rcu: Additional information on RCU-tasks stall-warning messages
      rcu: Remove local_irq_disable() in rcu_preempt_note_context_switch()
      rcu: Per-CPU operation cleanups to rcu_*_qs() functions
      rcutorture: Add RCU-tasks tests to default rcutorture list
      rcu: Fix attempt to avoid unsolicited offloading of callbacks
      rcu: Rationalize kthread spawning
      rcu: Create rcuo kthreads only for onlined CPUs
      rcu: Eliminate redundant rcu_sysidle_state variable
      rcu: Don't track sysidle state if no nohz_full= CPUs
      rcu: Avoid misordering in __call_rcu_nocb_enqueue()
      rcu: Handle NOCB callbacks from irq-disabled idle code
      rcu: Avoid misordering in nocb_leader_wait()
      Merge branches 'doc.2014.09.07a', 'fixes.2014.09.10a', 'nocb-nohz.2014.09.16b' and 'torture.2014.09.07a' into HEAD
      Merge branch 'rcu-tasks.2014.09.10a' into HEAD
      locktorture: Make torture scripting account for new _runnable name
      locktorture: Add test scenario for mutex_lock
      locktorture: Add test scenario for rwsem_lock
      rcutorture: Rename rcutorture_runnable parameter
      locktorture: Document boot/module parameters
      rcu: Eliminate deadlock between CPU hotplug and expedited grace periods

Pranith Kumar (18):
      rcu: Remove remaining read-modify-write ACCESS_ONCE() calls
      rcu: Fix sparse warning about rcu_batches_completed_preempt() being non-static
      rcu: Use bool type for return value in rcu_is_watching()
      rcu: Return bool type for rcu_try_advance_all_cbs()
      rcu: Return bool type in rcu_lockdep_current_cpu_online()
      rcu: Use true/false instead of 1/0 for a bool type
      rcu: Update tiny.c references to tree.c
      rcu: Remove stale comment in tree.c
      rcu: Use rcu_gp_kthread_wake() to wake up grace period kthreads
      rcutorture: Fix a sparse warning by marking boost_mutex static
      rcutorture: Use bash shell for all the test scripts
      rcutorture: Set executable bit and drop bash from Usage
      rcu: Check the return value of zalloc_cpumask_var()
      rcu: Use true/false for return in __call_rcu_nocb()
      rcu: Use true/false for return in rcu_nocb_adopt_orphan_cbs()
      rcu: Use false for return in __call_rcu_nocb()
      rcu: Return false instead of 0 in rcu_nocb_adopt_orphan_cbs()
      rcu: Check for have_rcu_nocb_mask instead of rcu_nocb_mask

Steven Rostedt (1):
      rcu: Export RCU-tasks APIs to GPL modules

 Documentation/RCU/stallwarn.txt                    |  33 +-
 Documentation/kernel-parameters.txt                |  68 +++-
 Documentation/locking/locktorture.txt              | 142 ++++++++
 Documentation/memory-barriers.txt                  | 128 +++----
 fs/file.c                                          |   2 +-
 include/linux/cpu.h                                |   2 +
 include/linux/init_task.h                          |  12 +-
 include/linux/lockdep.h                            |   1 +
 include/linux/rcupdate.h                           | 106 +++---
 include/linux/rcutiny.h                            |   2 +-
 include/linux/sched.h                              |  39 +-
 include/linux/torture.h                            |   5 +-
 include/trace/events/rcu.h                         |   3 +
 init/Kconfig                                       |  14 +-
 init/main.c                                        |   1 +
 kernel/cpu.c                                       |  16 +-
 kernel/exit.c                                      |   3 +
 kernel/locking/locktorture.c                       | 392 ++++++++++++++++----
 kernel/rcu/rcutorture.c                            | 278 ++++++++++----
 kernel/rcu/tiny.c                                  |  20 +-
 kernel/rcu/tree.c                                  | 115 +++---
 kernel/rcu/tree.h                                  |  18 +-
 kernel/rcu/tree_plugin.h                           | 404 ++++++++++++++-------
 kernel/rcu/update.c                                | 345 +++++++++++++++++-
 kernel/softirq.c                                   |   2 +-
 kernel/sysctl.c                                    |   9 -
 kernel/torture.c                                   |  32 +-
 mm/mlock.c                                         |   2 +-
 .../selftests/rcutorture/bin/config2frag.sh        |   4 +-
 .../selftests/rcutorture/bin/configcheck.sh        |   4 +-
 .../testing/selftests/rcutorture/bin/configinit.sh |   4 +-
 .../testing/selftests/rcutorture/bin/functions.sh  |  20 +
 .../testing/selftests/rcutorture/bin/kvm-build.sh  |   2 +-
 .../selftests/rcutorture/bin/kvm-recheck-lock.sh   |   2 +-
 .../selftests/rcutorture/bin/kvm-recheck-rcu.sh    |   2 +-
 .../selftests/rcutorture/bin/kvm-recheck.sh        |   2 +-
 .../selftests/rcutorture/bin/kvm-test-1-run.sh     |   5 +-
 tools/testing/selftests/rcutorture/bin/kvm.sh      |   6 +-
 .../selftests/rcutorture/bin/parse-build.sh        |   5 +-
 .../selftests/rcutorture/bin/parse-console.sh      |   9 +-
 .../selftests/rcutorture/bin/parse-torture.sh      |   5 +-
 .../selftests/rcutorture/configs/lock/CFLIST       |   2 +
 .../selftests/rcutorture/configs/lock/LOCK02       |   6 +
 .../selftests/rcutorture/configs/lock/LOCK02.boot  |   1 +
 .../selftests/rcutorture/configs/lock/LOCK03       |   6 +
 .../selftests/rcutorture/configs/lock/LOCK03.boot  |   1 +
 .../rcutorture/configs/lock/ver_functions.sh       |   2 +-
 .../selftests/rcutorture/configs/rcu/CFLIST        |   3 +
 .../selftests/rcutorture/configs/rcu/TASKS01       |   9 +
 .../selftests/rcutorture/configs/rcu/TASKS01.boot  |   1 +
 .../selftests/rcutorture/configs/rcu/TASKS02       |   5 +
 .../selftests/rcutorture/configs/rcu/TASKS02.boot  |   1 +
 .../selftests/rcutorture/configs/rcu/TASKS03       |  13 +
 .../selftests/rcutorture/configs/rcu/TASKS03.boot  |   1 +
 .../selftests/rcutorture/configs/rcu/TREE01        |   4 +-
 .../selftests/rcutorture/configs/rcu/TREE01.boot   |   2 +-
 .../selftests/rcutorture/configs/rcu/TREE07        |   3 +-
 .../selftests/rcutorture/configs/rcu/TREE07.boot   |   1 +
 .../rcutorture/configs/rcu/ver_functions.sh        |   2 +-
 tools/testing/selftests/rcutorture/doc/initrd.txt  |   1 +
 60 files changed, 1798 insertions(+), 530 deletions(-)
 create mode 100644 Documentation/locking/locktorture.txt
 mode change 100644 => 100755 tools/testing/selftests/rcutorture/bin/config2frag.sh
 mode change 100644 => 100755 tools/testing/selftests/rcutorture/bin/kvm.sh
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/LOCK02
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/LOCK02.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/LOCK03
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/LOCK03.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TASKS01
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TASKS01.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TASKS02
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TASKS02.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TASKS03
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TASKS03.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TREE07.boot

