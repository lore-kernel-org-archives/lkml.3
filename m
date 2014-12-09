Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbaLIKoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:44:46 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:41749 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbaLIKok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:44:40 -0500
Date: Tue, 9 Dec 2014 11:44:34 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU tree changes for v3.19
Message-ID: <20141209104434.GA20176@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-rcu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-rcu-for-linus

   # HEAD: d360b78f99e5d1724279644c8eb51d5cf0de4027 Merge branch 'rcu/next' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/rcu

These are the main changes in this cycle:

     - Streamline RCU's use of per-CPU variables, shifting from "cpu"
       arguments to functions to "this_"-style per-CPU variable accessors.
    
     - Signal-handling RCU updates.
    
     - Real-time updates.
    
     - Torture-test updates.
    
     - Miscellaneous fixes.
    
     - Documentation updates.

Thanks,

	Ingo

------------------>
Christoph Lameter (1):
      rcu: Remove rcu_dynticks * parameters when they are always this_cpu_ptr(&rcu_dynticks)

Clark Williams (1):
      rcu: Unify boost and kthread priorities

Oleg Nesterov (2):
      signal: Document the RCU protection of ->sighand
      rcu: More info about potential deadlocks with rcu_read_unlock()

Paul E. McKenney (21):
      rcu: Remove CONFIG_RCU_CPU_STALL_VERBOSE
      rcu: Move RCU_BOOST variable declarations, eliminating #ifdef
      rcu: Avoid IPIing idle CPUs from synchronize_sched_expedited()
      signal: Exit RCU read-side critical section on each pass through loop
      rcu: Kick rcuo kthreads after their CPU goes offline
      rcu: Fix for rcuo online-time-creation reorganization bug
      rcu: Use DEFINE_PER_CPU_SHARED_ALIGNED for rcu_data
      rcu: Remove "cpu" argument to rcu_check_callbacks()
      rcu: Remove "cpu" argument to rcu_pending()
      rcu: Remove "cpu" argument to rcu_preempt_check_callbacks()
      rcu: Remove "cpu" argument to rcu_note_context_switch()
      rcu: Remove "cpu" argument to rcu_needs_cpu()
      rcu: Remove "cpu" argument to rcu_prepare_for_idle()
      rcu: Remove "cpu" argument to rcu_cleanup_after_idle()
      cpu: Avoid puts_pending overflow
      torture: Run Linux-kernel binary out of results directory
      rcutorture: Fix rcu_torture_cbflood() memory leak
      documentation: Additional restriction for control dependencies
      documentation: Add atomic_long_t to atomic_ops.txt
      rcu: Optimize cond_resched_rcu_qs()
      rcu: Fix FIXME in rcu_tasks_kthread()

Pranith Kumar (8):
      rcu: Remove redundant TREE_PREEMPT_RCU config option
      rcutorture: Add early boot self tests
      rcutorture: Enable RCU self test in configs
      rcutorture: Remove stale test configurations
      rcutorture: Remove obsolete kversion param in kvm.sh
      documentation: Document RCU self test boot params
      documentation: memory-barriers.txt: Correct example for reorderings
      rcu: Add sparse check for RCU_INIT_POINTER()

Stefan Hengelein (1):
      init/Kconfig: move RCU_NOCB_CPU dependencies to choice


 Documentation/RCU/rcu.txt                          |   4 +-
 Documentation/RCU/stallwarn.txt                    |  14 +--
 Documentation/RCU/trace.txt                        |   4 +-
 Documentation/RCU/whatisRCU.txt                    |   2 +-
 Documentation/atomic_ops.txt                       |  12 ++-
 Documentation/kernel-parameters.txt                |  16 +++
 Documentation/memory-barriers.txt                  |  40 ++++++--
 include/linux/init_task.h                          |   2 +-
 include/linux/rcupdate.h                           |  19 ++--
 include/linux/rcutiny.h                            |   2 +-
 include/linux/rcutree.h                            |   6 +-
 include/linux/sched.h                              |   4 +-
 include/trace/events/rcu.h                         |   4 +-
 init/Kconfig                                       |  49 ++++-----
 kernel/cpu.c                                       |  19 ++--
 kernel/fork.c                                      |   5 +-
 kernel/rcu/Makefile                                |   2 +-
 kernel/rcu/rcu.h                                   |   2 +
 kernel/rcu/rcutorture.c                            |   1 +
 kernel/rcu/tiny.c                                  |   6 +-
 kernel/rcu/tree.c                                  |  97 ++++++++++--------
 kernel/rcu/tree.h                                  |  22 ++--
 kernel/rcu/tree_plugin.h                           | 111 +++++++++++----------
 kernel/rcu/update.c                                |  89 ++++++++++++++++-
 kernel/sched/core.c                                |   2 +-
 kernel/signal.c                                    |  42 ++++----
 kernel/softirq.c                                   |   2 +-
 kernel/time/tick-sched.c                           |   2 +-
 kernel/time/timer.c                                |   3 +-
 lib/Kconfig.debug                                  |  14 +--
 .../selftests/rcutorture/bin/kvm-test-1-run.sh     |   6 +-
 tools/testing/selftests/rcutorture/bin/kvm.sh      |  19 +---
 .../selftests/rcutorture/configs/rcu/TINY02        |   2 +
 .../selftests/rcutorture/configs/rcu/TINY02.boot   |   2 +
 .../selftests/rcutorture/configs/rcu/TREE01        |   3 +-
 .../selftests/rcutorture/configs/rcu/TREE02        |   3 +-
 .../selftests/rcutorture/configs/rcu/TREE02-T      |   3 +-
 .../selftests/rcutorture/configs/rcu/TREE03        |   5 +-
 .../selftests/rcutorture/configs/rcu/TREE04        |   1 -
 .../selftests/rcutorture/configs/rcu/TREE05        |   1 -
 .../selftests/rcutorture/configs/rcu/TREE05.boot   |   1 +
 .../selftests/rcutorture/configs/rcu/TREE06        |   1 -
 .../selftests/rcutorture/configs/rcu/TREE06.boot   |   3 +
 .../selftests/rcutorture/configs/rcu/TREE07        |   1 -
 .../selftests/rcutorture/configs/rcu/TREE08        |   5 +-
 .../selftests/rcutorture/configs/rcu/TREE08-T      |   3 +-
 .../selftests/rcutorture/configs/rcu/TREE08.boot   |   2 +
 .../selftests/rcutorture/configs/rcu/TREE09        |   3 +-
 .../selftests/rcutorture/configs/rcu/v0.0/CFLIST   |  14 ---
 .../configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP           |  18 ----
 .../configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp           |  20 ----
 .../configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp           |  22 ----
 .../configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP           |  18 ----
 .../configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp           |  22 ----
 .../selftests/rcutorture/configs/rcu/v0.0/NT1-nh   |  23 -----
 .../selftests/rcutorture/configs/rcu/v0.0/NT3-NH   |  20 ----
 .../configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP           |  19 ----
 .../configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp           |  20 ----
 .../configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp           |  20 ----
 .../configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP           |  22 ----
 .../configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp           |  27 -----
 .../selftests/rcutorture/configs/rcu/v0.0/PT1-nh   |  23 -----
 .../selftests/rcutorture/configs/rcu/v0.0/PT2-NH   |  22 ----
 .../rcutorture/configs/rcu/v0.0/ver_functions.sh   |  33 ------
 .../selftests/rcutorture/configs/rcu/v3.12/CFLIST  |  17 ----
 .../configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP          |  19 ----
 .../configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp          |  20 ----
 .../configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp          |  22 ----
 .../configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP          |  18 ----
 .../configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp          |  22 ----
 .../configs/rcu/v3.12/N6---t-nh-SD-smp-hp          |  19 ----
 .../configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP          |  26 -----
 .../configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP          |  22 ----
 .../selftests/rcutorture/configs/rcu/v3.12/NT1-nh  |  23 -----
 .../selftests/rcutorture/configs/rcu/v3.12/NT3-NH  |  20 ----
 .../configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP          |  20 ----
 .../configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp          |  20 ----
 .../configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp          |  20 ----
 .../configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP          |  22 ----
 .../configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp          |  27 -----
 .../configs/rcu/v3.12/P6---t-nh-SD-smp-hp          |  18 ----
 .../configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP          |  30 ------
 .../configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all      |  30 ------
 .../configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none     |  30 ------
 .../configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp          |  30 ------
 .../selftests/rcutorture/configs/rcu/v3.12/PT1-nh  |  23 -----
 .../selftests/rcutorture/configs/rcu/v3.12/PT2-NH  |  22 ----
 .../selftests/rcutorture/configs/rcu/v3.3/CFLIST   |  14 ---
 .../configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP           |  19 ----
 .../configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp           |  20 ----
 .../configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp           |  22 ----
 .../configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP           |  18 ----
 .../configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp           |  22 ----
 .../selftests/rcutorture/configs/rcu/v3.3/NT1-nh   |  23 -----
 .../selftests/rcutorture/configs/rcu/v3.3/NT3-NH   |  20 ----
 .../configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP           |  20 ----
 .../configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp           |  20 ----
 .../configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp           |  20 ----
 .../configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP           |  22 ----
 .../configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp           |  27 -----
 .../selftests/rcutorture/configs/rcu/v3.3/PT1-nh   |  23 -----
 .../selftests/rcutorture/configs/rcu/v3.3/PT2-NH   |  22 ----
 .../rcutorture/configs/rcu/v3.3/ver_functions.sh   |  44 --------
 .../selftests/rcutorture/configs/rcu/v3.5/CFLIST   |  14 ---
 .../configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP           |  19 ----
 .../configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp           |  20 ----
 .../configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp           |  22 ----
 .../configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP           |  18 ----
 .../configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp           |  22 ----
 .../selftests/rcutorture/configs/rcu/v3.5/NT1-nh   |  23 -----
 .../selftests/rcutorture/configs/rcu/v3.5/NT3-NH   |  20 ----
 .../configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP           |  20 ----
 .../configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp           |  20 ----
 .../configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp           |  20 ----
 .../configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP           |  22 ----
 .../configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp           |  27 -----
 .../selftests/rcutorture/configs/rcu/v3.5/PT1-nh   |  23 -----
 .../selftests/rcutorture/configs/rcu/v3.5/PT2-NH   |  22 ----
 .../rcutorture/configs/rcu/v3.5/ver_functions.sh   |  57 -----------
 .../testing/selftests/rcutorture/doc/TINY_RCU.txt  |   2 +-
 .../selftests/rcutorture/doc/TREE_RCU-kconfig.txt  |  15 ++-
 121 files changed, 408 insertions(+), 1858 deletions(-)
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TINY02.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TREE06.boot
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/CFLIST
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT3-NH
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT2-NH
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/ver_functions.sh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/CFLIST
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N6---t-nh-SD-smp-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT3-NH
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT2-NH
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/CFLIST
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT3-NH
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT2-NH
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/ver_functions.sh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/CFLIST
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT3-NH
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT2-NH
 delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/ver_functions.sh

diff --git a/Documentation/RCU/rcu.txt b/Documentation/RCU/rcu.txt
index bf778332a28f..745f429fda79 100644
--- a/Documentation/RCU/rcu.txt
+++ b/Documentation/RCU/rcu.txt
@@ -36,7 +36,7 @@ o	How can the updater tell when a grace period has completed
 	executed in user mode, or executed in the idle loop, we can
 	safely free up that item.
 
-	Preemptible variants of RCU (CONFIG_TREE_PREEMPT_RCU) get the
+	Preemptible variants of RCU (CONFIG_PREEMPT_RCU) get the
 	same effect, but require that the readers manipulate CPU-local
 	counters.  These counters allow limited types of blocking within
 	RCU read-side critical sections.  SRCU also uses CPU-local
@@ -81,7 +81,7 @@ o	I hear that RCU is patented?  What is with that?
 o	I hear that RCU needs work in order to support realtime kernels?
 
 	This work is largely completed.  Realtime-friendly RCU can be
-	enabled via the CONFIG_TREE_PREEMPT_RCU kernel configuration
+	enabled via the CONFIG_PREEMPT_RCU kernel configuration
 	parameter.  However, work is in progress for enabling priority
 	boosting of preempted RCU read-side critical sections.	This is
 	needed if you have CPU-bound realtime threads.
diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index ef5a2fd4ff70..ed186a902d31 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -26,12 +26,6 @@ CONFIG_RCU_CPU_STALL_TIMEOUT
 	Stall-warning messages may be enabled and disabled completely via
 	/sys/module/rcupdate/parameters/rcu_cpu_stall_suppress.
 
-CONFIG_RCU_CPU_STALL_VERBOSE
-
-	This kernel configuration parameter causes the stall warning to
-	also dump the stacks of any tasks that are blocking the current
-	RCU-preempt grace period.
-
 CONFIG_RCU_CPU_STALL_INFO
 
 	This kernel configuration parameter causes the stall warning to
@@ -77,7 +71,7 @@ This message indicates that CPU 5 detected that it was causing a stall,
 and that the stall was affecting RCU-sched.  This message will normally be
 followed by a stack dump of the offending CPU.  On TREE_RCU kernel builds,
 RCU and RCU-sched are implemented by the same underlying mechanism,
-while on TREE_PREEMPT_RCU kernel builds, RCU is instead implemented
+while on PREEMPT_RCU kernel builds, RCU is instead implemented
 by rcu_preempt_state.
 
 On the other hand, if the offending CPU fails to print out a stall-warning
@@ -89,7 +83,7 @@ INFO: rcu_bh_state detected stalls on CPUs/tasks: { 3 5 } (detected by 2, 2502 j
 This message indicates that CPU 2 detected that CPUs 3 and 5 were both
 causing stalls, and that the stall was affecting RCU-bh.  This message
 will normally be followed by stack dumps for each CPU.  Please note that
-TREE_PREEMPT_RCU builds can be stalled by tasks as well as by CPUs,
+PREEMPT_RCU builds can be stalled by tasks as well as by CPUs,
 and that the tasks will be indicated by PID, for example, "P3421".
 It is even possible for a rcu_preempt_state stall to be caused by both
 CPUs -and- tasks, in which case the offending CPUs and tasks will all
@@ -205,10 +199,10 @@ o	A CPU-bound real-time task in a CONFIG_PREEMPT kernel, which might
 o	A CPU-bound real-time task in a CONFIG_PREEMPT_RT kernel that
 	is running at a higher priority than the RCU softirq threads.
 	This will prevent RCU callbacks from ever being invoked,
-	and in a CONFIG_TREE_PREEMPT_RCU kernel will further prevent
+	and in a CONFIG_PREEMPT_RCU kernel will further prevent
 	RCU grace periods from ever completing.  Either way, the
 	system will eventually run out of memory and hang.  In the
-	CONFIG_TREE_PREEMPT_RCU case, you might see stall-warning
+	CONFIG_PREEMPT_RCU case, you might see stall-warning
 	messages.
 
 o	A hardware or software issue shuts off the scheduler-clock
diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 910870b15acd..b63b9bb3bc0c 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -8,7 +8,7 @@ The following sections describe the debugfs files and formats, first
 for rcutree and next for rcutiny.
 
 
-CONFIG_TREE_RCU and CONFIG_TREE_PREEMPT_RCU debugfs Files and Formats
+CONFIG_TREE_RCU and CONFIG_PREEMPT_RCU debugfs Files and Formats
 
 These implementations of RCU provide several debugfs directories under the
 top-level directory "rcu":
@@ -18,7 +18,7 @@ rcu/rcu_preempt
 rcu/rcu_sched
 
 Each directory contains files for the corresponding flavor of RCU.
-Note that rcu/rcu_preempt is only present for CONFIG_TREE_PREEMPT_RCU.
+Note that rcu/rcu_preempt is only present for CONFIG_PREEMPT_RCU.
 For CONFIG_TREE_RCU, the RCU flavor maps onto the RCU-sched flavor,
 so that activity for both appears in rcu/rcu_sched.
 
diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index e48c57f1943b..88dfce182f66 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -137,7 +137,7 @@ rcu_read_lock()
 	Used by a reader to inform the reclaimer that the reader is
 	entering an RCU read-side critical section.  It is illegal
 	to block while in an RCU read-side critical section, though
-	kernels built with CONFIG_TREE_PREEMPT_RCU can preempt RCU
+	kernels built with CONFIG_PREEMPT_RCU can preempt RCU
 	read-side critical sections.  Any RCU-protected data structure
 	accessed during an RCU read-side critical section is guaranteed to
 	remain unreclaimed for the full duration of that critical section.
diff --git a/Documentation/atomic_ops.txt b/Documentation/atomic_ops.txt
index 68542fe13b85..183e41bdcb69 100644
--- a/Documentation/atomic_ops.txt
+++ b/Documentation/atomic_ops.txt
@@ -7,12 +7,13 @@
 maintainers on how to implement atomic counter, bitops, and spinlock
 interfaces properly.
 
-	The atomic_t type should be defined as a signed integer.
-Also, it should be made opaque such that any kind of cast to a normal
-C integer type will fail.  Something like the following should
-suffice:
+	The atomic_t type should be defined as a signed integer and
+the atomic_long_t type as a signed long integer.  Also, they should
+be made opaque such that any kind of cast to a normal C integer type
+will fail.  Something like the following should suffice:
 
 	typedef struct { int counter; } atomic_t;
+	typedef struct { long counter; } atomic_long_t;
 
 Historically, counter has been declared volatile.  This is now discouraged.
 See Documentation/volatile-considered-harmful.txt for the complete rationale.
@@ -37,6 +38,9 @@ initializer is used before runtime.  If the initializer is used at runtime, a
 proper implicit or explicit read memory barrier is needed before reading the
 value with atomic_read from another thread.
 
+As with all of the atomic_ interfaces, replace the leading "atomic_"
+with "atomic_long_" to operate on atomic_long_t.
+
 The second interface can be used at runtime, as in:
 
 	struct foo { atomic_t counter; };
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 479f33204a37..838f3776c924 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2940,6 +2940,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			quiescent states.  Units are jiffies, minimum
 			value is one, and maximum value is HZ.
 
+	rcutree.kthread_prio= 	 [KNL,BOOT]
+			Set the SCHED_FIFO priority of the RCU
+			per-CPU kthreads (rcuc/N). This value is also
+			used for the priority of the RCU boost threads
+			(rcub/N). Valid values are 1-99 and the default
+			is 1 (the least-favored priority).
+
 	rcutree.rcu_nocb_leader_stride= [KNL]
 			Set the number of NOCB kthread groups, which
 			defaults to the square root of the number of
@@ -3089,6 +3096,15 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			messages.  Disable with a value less than or equal
 			to zero.
 
+	rcupdate.rcu_self_test= [KNL]
+			Run the RCU early boot self tests
+
+	rcupdate.rcu_self_test_bh= [KNL]
+			Run the RCU bh early boot self tests
+
+	rcupdate.rcu_self_test_sched= [KNL]
+			Run the RCU sched early boot self tests
+
 	rdinit=		[KNL]
 			Format: <full_path>
 			Run specified binary instead of /init from the ramdisk,
diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 22a969cdd476..f7fa63508aba 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -121,22 +121,22 @@ interface between the CPU and rest of the system (the dotted lines).
 The set of accesses as seen by the memory system in the middle can be arranged
 in 24 different combinations:
 
-	STORE A=3,	STORE B=4,	x=LOAD A->3,	y=LOAD B->4
-	STORE A=3,	STORE B=4,	y=LOAD B->4,	x=LOAD A->3
-	STORE A=3,	x=LOAD A->3,	STORE B=4,	y=LOAD B->4
-	STORE A=3,	x=LOAD A->3,	y=LOAD B->2,	STORE B=4
-	STORE A=3,	y=LOAD B->2,	STORE B=4,	x=LOAD A->3
-	STORE A=3,	y=LOAD B->2,	x=LOAD A->3,	STORE B=4
-	STORE B=4,	STORE A=3,	x=LOAD A->3,	y=LOAD B->4
+	STORE A=3,	STORE B=4,	y=LOAD A->3,	x=LOAD B->4
+	STORE A=3,	STORE B=4,	x=LOAD B->4,	y=LOAD A->3
+	STORE A=3,	y=LOAD A->3,	STORE B=4,	x=LOAD B->4
+	STORE A=3,	y=LOAD A->3,	x=LOAD B->2,	STORE B=4
+	STORE A=3,	x=LOAD B->2,	STORE B=4,	y=LOAD A->3
+	STORE A=3,	x=LOAD B->2,	y=LOAD A->3,	STORE B=4
+	STORE B=4,	STORE A=3,	y=LOAD A->3,	x=LOAD B->4
 	STORE B=4, ...
 	...
 
 and can thus result in four different combinations of values:
 
-	x == 1, y == 2
-	x == 1, y == 4
-	x == 3, y == 2
-	x == 3, y == 4
+	x == 2, y == 1
+	x == 2, y == 3
+	x == 4, y == 1
+	x == 4, y == 3
 
 
 Furthermore, the stores committed by a CPU to the memory system may not be
@@ -694,6 +694,24 @@ Please note once again that the stores to 'b' differ.  If they were
 identical, as noted earlier, the compiler could pull this store outside
 of the 'if' statement.
 
+You must also be careful not to rely too much on boolean short-circuit
+evaluation.  Consider this example:
+
+	q = ACCESS_ONCE(a);
+	if (a || 1 > 0)
+		ACCESS_ONCE(b) = 1;
+
+Because the second condition is always true, the compiler can transform
+this example as following, defeating control dependency:
+
+	q = ACCESS_ONCE(a);
+	ACCESS_ONCE(b) = 1;
+
+This example underscores the need to ensure that the compiler cannot
+out-guess your code.  More generally, although ACCESS_ONCE() does force
+the compiler to actually emit code for a given load, it does not force
+the compiler to use the results.
+
 Finally, control dependencies do -not- provide transitivity.  This is
 demonstrated by two related examples, with the initial values of
 x and y both being zero:
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 77fc43f8fb72..d996aef8044f 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -102,7 +102,7 @@ extern struct group_info init_groups;
 #define INIT_IDS
 #endif
 
-#ifdef CONFIG_TREE_PREEMPT_RCU
+#ifdef CONFIG_PREEMPT_RCU
 #define INIT_TASK_RCU_TREE_PREEMPT()					\
 	.rcu_blocked_node = NULL,
 #else
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 53ff1a752d7e..ed4f5939a452 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -57,7 +57,7 @@ enum rcutorture_type {
 	INVALID_RCU_FLAVOR
 };
 
-#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
+#if defined(CONFIG_TREE_RCU) || defined(CONFIG_PREEMPT_RCU)
 void rcutorture_get_gp_data(enum rcutorture_type test_type, int *flags,
 			    unsigned long *gpnum, unsigned long *completed);
 void rcutorture_record_test_transition(void);
@@ -260,7 +260,7 @@ static inline int rcu_preempt_depth(void)
 void rcu_init(void);
 void rcu_sched_qs(void);
 void rcu_bh_qs(void);
-void rcu_check_callbacks(int cpu, int user);
+void rcu_check_callbacks(int user);
 struct notifier_block;
 void rcu_idle_enter(void);
 void rcu_idle_exit(void);
@@ -348,8 +348,8 @@ extern struct srcu_struct tasks_rcu_exit_srcu;
  */
 #define cond_resched_rcu_qs() \
 do { \
-	rcu_note_voluntary_context_switch(current); \
-	cond_resched(); \
+	if (!cond_resched()) \
+		rcu_note_voluntary_context_switch(current); \
 } while (0)
 
 #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP)
@@ -365,7 +365,7 @@ typedef void call_rcu_func_t(struct rcu_head *head,
 			     void (*func)(struct rcu_head *head));
 void wait_rcu_gp(call_rcu_func_t crf);
 
-#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
+#if defined(CONFIG_TREE_RCU) || defined(CONFIG_PREEMPT_RCU)
 #include <linux/rcutree.h>
 #elif defined(CONFIG_TINY_RCU)
 #include <linux/rcutiny.h>
@@ -867,7 +867,7 @@ static inline void rcu_preempt_sleep_check(void)
  *
  * In non-preemptible RCU implementations (TREE_RCU and TINY_RCU),
  * it is illegal to block while in an RCU read-side critical section.
- * In preemptible RCU implementations (TREE_PREEMPT_RCU) in CONFIG_PREEMPT
+ * In preemptible RCU implementations (PREEMPT_RCU) in CONFIG_PREEMPT
  * kernel builds, RCU read-side critical sections may be preempted,
  * but explicit blocking is illegal.  Finally, in preemptible RCU
  * implementations in real-time (with -rt patchset) kernel builds, RCU
@@ -902,7 +902,9 @@ static inline void rcu_read_lock(void)
  * Unfortunately, this function acquires the scheduler's runqueue and
  * priority-inheritance spinlocks.  This means that deadlock could result
  * if the caller of rcu_read_unlock() already holds one of these locks or
- * any lock that is ever acquired while holding them.
+ * any lock that is ever acquired while holding them; or any lock which
+ * can be taken from interrupt context because rcu_boost()->rt_mutex_lock()
+ * does not disable irqs while taking ->wait_lock.
  *
  * That said, RCU readers are never priority boosted unless they were
  * preempted.  Therefore, one way to avoid deadlock is to make sure
@@ -1062,6 +1064,7 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
  */
 #define RCU_INIT_POINTER(p, v) \
 	do { \
+		rcu_dereference_sparse(p, __rcu); \
 		p = RCU_INITIALIZER(v); \
 	} while (0)
 
@@ -1118,7 +1121,7 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 	__kfree_rcu(&((ptr)->rcu_head), offsetof(typeof(*(ptr)), rcu_head))
 
 #if defined(CONFIG_TINY_RCU) || defined(CONFIG_RCU_NOCB_CPU_ALL)
-static inline int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
+static inline int rcu_needs_cpu(unsigned long *delta_jiffies)
 {
 	*delta_jiffies = ULONG_MAX;
 	return 0;
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 38cc5b1e252d..0e5366200154 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -78,7 +78,7 @@ static inline void kfree_call_rcu(struct rcu_head *head,
 	call_rcu(head, func);
 }
 
-static inline void rcu_note_context_switch(int cpu)
+static inline void rcu_note_context_switch(void)
 {
 	rcu_sched_qs();
 }
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 3e2f5d432743..52953790dcca 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -30,9 +30,9 @@
 #ifndef __LINUX_RCUTREE_H
 #define __LINUX_RCUTREE_H
 
-void rcu_note_context_switch(int cpu);
+void rcu_note_context_switch(void);
 #ifndef CONFIG_RCU_NOCB_CPU_ALL
-int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies);
+int rcu_needs_cpu(unsigned long *delta_jiffies);
 #endif /* #ifndef CONFIG_RCU_NOCB_CPU_ALL */
 void rcu_cpu_stall_reset(void);
 
@@ -43,7 +43,7 @@ void rcu_cpu_stall_reset(void);
  */
 static inline void rcu_virt_note_context_switch(int cpu)
 {
-	rcu_note_context_switch(cpu);
+	rcu_note_context_switch();
 }
 
 void synchronize_rcu_bh(void);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5e344bbe63ec..706a9f744909 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1278,9 +1278,9 @@ struct task_struct {
 	union rcu_special rcu_read_unlock_special;
 	struct list_head rcu_node_entry;
 #endif /* #ifdef CONFIG_PREEMPT_RCU */
-#ifdef CONFIG_TREE_PREEMPT_RCU
+#ifdef CONFIG_PREEMPT_RCU
 	struct rcu_node *rcu_blocked_node;
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#endif /* #ifdef CONFIG_PREEMPT_RCU */
 #ifdef CONFIG_TASKS_RCU
 	unsigned long rcu_tasks_nvcsw;
 	bool rcu_tasks_holdout;
diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index e335e7d8c6c2..c78e88ce5ea3 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -36,7 +36,7 @@ TRACE_EVENT(rcu_utilization,
 
 #ifdef CONFIG_RCU_TRACE
 
-#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
+#if defined(CONFIG_TREE_RCU) || defined(CONFIG_PREEMPT_RCU)
 
 /*
  * Tracepoint for grace-period events.  Takes a string identifying the
@@ -345,7 +345,7 @@ TRACE_EVENT(rcu_fqs,
 		  __entry->cpu, __entry->qsevent)
 );
 
-#endif /* #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU) */
+#endif /* #if defined(CONFIG_TREE_RCU) || defined(CONFIG_PREEMPT_RCU) */
 
 /*
  * Tracepoint for dyntick-idle entry/exit events.  These take a string
diff --git a/init/Kconfig b/init/Kconfig
index 2081a4d3d917..903505e66d1d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -477,7 +477,7 @@ config TREE_RCU
 	  thousands of CPUs.  It also scales down nicely to
 	  smaller systems.
 
-config TREE_PREEMPT_RCU
+config PREEMPT_RCU
 	bool "Preemptible tree-based hierarchical RCU"
 	depends on PREEMPT
 	select IRQ_WORK
@@ -501,12 +501,6 @@ config TINY_RCU
 
 endchoice
 
-config PREEMPT_RCU
-	def_bool TREE_PREEMPT_RCU
-	help
-	  This option enables preemptible-RCU code that is common between
-	  TREE_PREEMPT_RCU and, in the old days, TINY_PREEMPT_RCU.
-
 config TASKS_RCU
 	bool "Task_based RCU implementation using voluntary context switch"
 	default n
@@ -518,7 +512,7 @@ config TASKS_RCU
 	  If unsure, say N.
 
 config RCU_STALL_COMMON
-	def_bool ( TREE_RCU || TREE_PREEMPT_RCU || RCU_TRACE )
+	def_bool ( TREE_RCU || PREEMPT_RCU || RCU_TRACE )
 	help
 	  This option enables RCU CPU stall code that is common between
 	  the TINY and TREE variants of RCU.  The purpose is to allow
@@ -576,7 +570,7 @@ config RCU_FANOUT
 	int "Tree-based hierarchical RCU fanout value"
 	range 2 64 if 64BIT
 	range 2 32 if !64BIT
-	depends on TREE_RCU || TREE_PREEMPT_RCU
+	depends on TREE_RCU || PREEMPT_RCU
 	default 64 if 64BIT
 	default 32 if !64BIT
 	help
@@ -596,7 +590,7 @@ config RCU_FANOUT_LEAF
 	int "Tree-based hierarchical RCU leaf-level fanout value"
 	range 2 RCU_FANOUT if 64BIT
 	range 2 RCU_FANOUT if !64BIT
-	depends on TREE_RCU || TREE_PREEMPT_RCU
+	depends on TREE_RCU || PREEMPT_RCU
 	default 16
 	help
 	  This option controls the leaf-level fanout of hierarchical
@@ -621,7 +615,7 @@ config RCU_FANOUT_LEAF
 
 config RCU_FANOUT_EXACT
 	bool "Disable tree-based hierarchical RCU auto-balancing"
-	depends on TREE_RCU || TREE_PREEMPT_RCU
+	depends on TREE_RCU || PREEMPT_RCU
 	default n
 	help
 	  This option forces use of the exact RCU_FANOUT value specified,
@@ -652,11 +646,11 @@ config RCU_FAST_NO_HZ
 	  Say N if you are unsure.
 
 config TREE_RCU_TRACE
-	def_bool RCU_TRACE && ( TREE_RCU || TREE_PREEMPT_RCU )
+	def_bool RCU_TRACE && ( TREE_RCU || PREEMPT_RCU )
 	select DEBUG_FS
 	help
 	  This option provides tracing for the TREE_RCU and
-	  TREE_PREEMPT_RCU implementations, permitting Makefile to
+	  PREEMPT_RCU implementations, permitting Makefile to
 	  trivially select kernel/rcutree_trace.c.
 
 config RCU_BOOST
@@ -672,30 +666,31 @@ config RCU_BOOST
 	  Say Y here if you are working with real-time apps or heavy loads
 	  Say N here if you are unsure.
 
-config RCU_BOOST_PRIO
-	int "Real-time priority to boost RCU readers to"
+config RCU_KTHREAD_PRIO
+	int "Real-time priority to use for RCU worker threads"
 	range 1 99
 	depends on RCU_BOOST
 	default 1
 	help
-	  This option specifies the real-time priority to which long-term
-	  preempted RCU readers are to be boosted.  If you are working
-	  with a real-time application that has one or more CPU-bound
-	  threads running at a real-time priority level, you should set
-	  RCU_BOOST_PRIO to a priority higher then the highest-priority
-	  real-time CPU-bound thread.  The default RCU_BOOST_PRIO value
-	  of 1 is appropriate in the common case, which is real-time
+	  This option specifies the SCHED_FIFO priority value that will be
+	  assigned to the rcuc/n and rcub/n threads and is also the value
+	  used for RCU_BOOST (if enabled). If you are working with a
+	  real-time application that has one or more CPU-bound threads
+	  running at a real-time priority level, you should set
+	  RCU_KTHREAD_PRIO to a priority higher than the highest-priority
+	  real-time CPU-bound application thread.  The default RCU_KTHREAD_PRIO
+	  value of 1 is appropriate in the common case, which is real-time
 	  applications that do not have any CPU-bound threads.
 
 	  Some real-time applications might not have a single real-time
 	  thread that saturates a given CPU, but instead might have
 	  multiple real-time threads that, taken together, fully utilize
-	  that CPU.  In this case, you should set RCU_BOOST_PRIO to
+	  that CPU.  In this case, you should set RCU_KTHREAD_PRIO to
 	  a priority higher than the lowest-priority thread that is
 	  conspiring to prevent the CPU from running any non-real-time
 	  tasks.  For example, if one thread at priority 10 and another
 	  thread at priority 5 are between themselves fully consuming
-	  the CPU time on a given CPU, then RCU_BOOST_PRIO should be
+	  the CPU time on a given CPU, then RCU_KTHREAD_PRIO should be
 	  set to priority 6 or higher.
 
 	  Specify the real-time priority, or take the default if unsure.
@@ -715,7 +710,7 @@ config RCU_BOOST_DELAY
 
 config RCU_NOCB_CPU
 	bool "Offload RCU callback processing from boot-selected CPUs"
-	depends on TREE_RCU || TREE_PREEMPT_RCU
+	depends on TREE_RCU || PREEMPT_RCU
 	default n
 	help
 	  Use this option to reduce OS jitter for aggressive HPC or
@@ -739,6 +734,7 @@ config RCU_NOCB_CPU
 choice
 	prompt "Build-forced no-CBs CPUs"
 	default RCU_NOCB_CPU_NONE
+	depends on RCU_NOCB_CPU
 	help
 	  This option allows no-CBs CPUs (whose RCU callbacks are invoked
 	  from kthreads rather than from softirq context) to be specified
@@ -747,7 +743,6 @@ choice
 
 config RCU_NOCB_CPU_NONE
 	bool "No build_forced no-CBs CPUs"
-	depends on RCU_NOCB_CPU
 	help
 	  This option does not force any of the CPUs to be no-CBs CPUs.
 	  Only CPUs designated by the rcu_nocbs= boot parameter will be
@@ -761,7 +756,6 @@ config RCU_NOCB_CPU_NONE
 
 config RCU_NOCB_CPU_ZERO
 	bool "CPU 0 is a build_forced no-CBs CPU"
-	depends on RCU_NOCB_CPU
 	help
 	  This option forces CPU 0 to be a no-CBs CPU, so that its RCU
 	  callbacks are invoked by a per-CPU kthread whose name begins
@@ -776,7 +770,6 @@ config RCU_NOCB_CPU_ZERO
 
 config RCU_NOCB_CPU_ALL
 	bool "All CPUs are build_forced no-CBs CPUs"
-	depends on RCU_NOCB_CPU
 	help
 	  This option forces all CPUs to be no-CBs CPUs.  The rcu_nocbs=
 	  boot parameter will be ignored.  All CPUs' RCU callbacks will
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 90a3d017b90c..5d220234b3ca 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -86,6 +86,16 @@ static struct {
 #define cpuhp_lock_acquire()      lock_map_acquire(&cpu_hotplug.dep_map)
 #define cpuhp_lock_release()      lock_map_release(&cpu_hotplug.dep_map)
 
+static void apply_puts_pending(int max)
+{
+	int delta;
+
+	if (atomic_read(&cpu_hotplug.puts_pending) >= max) {
+		delta = atomic_xchg(&cpu_hotplug.puts_pending, 0);
+		cpu_hotplug.refcount -= delta;
+	}
+}
+
 void get_online_cpus(void)
 {
 	might_sleep();
@@ -93,6 +103,7 @@ void get_online_cpus(void)
 		return;
 	cpuhp_lock_acquire_read();
 	mutex_lock(&cpu_hotplug.lock);
+	apply_puts_pending(65536);
 	cpu_hotplug.refcount++;
 	mutex_unlock(&cpu_hotplug.lock);
 }
@@ -105,6 +116,7 @@ bool try_get_online_cpus(void)
 	if (!mutex_trylock(&cpu_hotplug.lock))
 		return false;
 	cpuhp_lock_acquire_tryread();
+	apply_puts_pending(65536);
 	cpu_hotplug.refcount++;
 	mutex_unlock(&cpu_hotplug.lock);
 	return true;
@@ -161,12 +173,7 @@ void cpu_hotplug_begin(void)
 	cpuhp_lock_acquire();
 	for (;;) {
 		mutex_lock(&cpu_hotplug.lock);
-		if (atomic_read(&cpu_hotplug.puts_pending)) {
-			int delta;
-
-			delta = atomic_xchg(&cpu_hotplug.puts_pending, 0);
-			cpu_hotplug.refcount -= delta;
-		}
+		apply_puts_pending(1);
 		if (likely(!cpu_hotplug.refcount))
 			break;
 		__set_current_state(TASK_UNINTERRUPTIBLE);
diff --git a/kernel/fork.c b/kernel/fork.c
index 9b7d746d6d62..9ca84189cfc2 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1022,11 +1022,14 @@ void __cleanup_sighand(struct sighand_struct *sighand)
 {
 	if (atomic_dec_and_test(&sighand->count)) {
 		signalfd_cleanup(sighand);
+		/*
+		 * sighand_cachep is SLAB_DESTROY_BY_RCU so we can free it
+		 * without an RCU grace period, see __lock_task_sighand().
+		 */
 		kmem_cache_free(sighand_cachep, sighand);
 	}
 }
 
-
 /*
  * Initialize POSIX timer handling for a thread group.
  */
diff --git a/kernel/rcu/Makefile b/kernel/rcu/Makefile
index 807ccfbf69b3..e6fae503d1bc 100644
--- a/kernel/rcu/Makefile
+++ b/kernel/rcu/Makefile
@@ -1,6 +1,6 @@
 obj-y += update.o srcu.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_TREE_RCU) += tree.o
-obj-$(CONFIG_TREE_PREEMPT_RCU) += tree.o
+obj-$(CONFIG_PREEMPT_RCU) += tree.o
 obj-$(CONFIG_TREE_RCU_TRACE) += tree_trace.o
 obj-$(CONFIG_TINY_RCU) += tiny.o
diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
index ff1a6de62f17..07bb02eda844 100644
--- a/kernel/rcu/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -135,4 +135,6 @@ int rcu_jiffies_till_stall_check(void);
  */
 #define TPS(x)  tracepoint_string(x)
 
+void rcu_early_boot_tests(void);
+
 #endif /* __LINUX_RCU_H */
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 240fa9094f83..4d559baf06e0 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -812,6 +812,7 @@ rcu_torture_cbflood(void *arg)
 		cur_ops->cb_barrier();
 		stutter_wait("rcu_torture_cbflood");
 	} while (!torture_must_stop());
+	vfree(rhp);
 	torture_kthread_stopping("rcu_torture_cbflood");
 	return 0;
 }
diff --git a/kernel/rcu/tiny.c b/kernel/rcu/tiny.c
index c0623fc47125..0db5649f8817 100644
--- a/kernel/rcu/tiny.c
+++ b/kernel/rcu/tiny.c
@@ -247,7 +247,7 @@ void rcu_bh_qs(void)
  * be called from hardirq context.  It is normally called from the
  * scheduling-clock interrupt.
  */
-void rcu_check_callbacks(int cpu, int user)
+void rcu_check_callbacks(int user)
 {
 	RCU_TRACE(check_cpu_stalls());
 	if (user || rcu_is_cpu_rrupt_from_idle())
@@ -380,7 +380,9 @@ void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
 
-void rcu_init(void)
+void __init rcu_init(void)
 {
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
+
+	rcu_early_boot_tests();
 }
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 9815447d22e0..7680fc275036 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -105,7 +105,7 @@ struct rcu_state sname##_state = { \
 	.name = RCU_STATE_NAME(sname), \
 	.abbr = sabbr, \
 }; \
-DEFINE_PER_CPU(struct rcu_data, sname##_data)
+DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_data, sname##_data)
 
 RCU_STATE_INITIALIZER(rcu_sched, 's', call_rcu_sched);
 RCU_STATE_INITIALIZER(rcu_bh, 'b', call_rcu_bh);
@@ -152,19 +152,6 @@ EXPORT_SYMBOL_GPL(rcu_scheduler_active);
  */
 static int rcu_scheduler_fully_active __read_mostly;
 
-#ifdef CONFIG_RCU_BOOST
-
-/*
- * Control variables for per-CPU and per-rcu_node kthreads.  These
- * handle all flavors of RCU.
- */
-static DEFINE_PER_CPU(struct task_struct *, rcu_cpu_kthread_task);
-DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
-DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
-DEFINE_PER_CPU(char, rcu_cpu_has_work);
-
-#endif /* #ifdef CONFIG_RCU_BOOST */
-
 static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu);
 static void invoke_rcu_core(void);
 static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp);
@@ -286,11 +273,11 @@ static void rcu_momentary_dyntick_idle(void)
  * and requires special handling for preemptible RCU.
  * The caller must have disabled preemption.
  */
-void rcu_note_context_switch(int cpu)
+void rcu_note_context_switch(void)
 {
 	trace_rcu_utilization(TPS("Start context switch"));
 	rcu_sched_qs();
-	rcu_preempt_note_context_switch(cpu);
+	rcu_preempt_note_context_switch();
 	if (unlikely(raw_cpu_read(rcu_sched_qs_mask)))
 		rcu_momentary_dyntick_idle();
 	trace_rcu_utilization(TPS("End context switch"));
@@ -325,7 +312,7 @@ static void force_qs_rnp(struct rcu_state *rsp,
 				  unsigned long *maxj),
 			 bool *isidle, unsigned long *maxj);
 static void force_quiescent_state(struct rcu_state *rsp);
-static int rcu_pending(int cpu);
+static int rcu_pending(void);
 
 /*
  * Return the number of RCU-sched batches processed thus far for debug & stats.
@@ -510,11 +497,11 @@ cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
  * we really have entered idle, and must do the appropriate accounting.
  * The caller must have disabled interrupts.
  */
-static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
-				bool user)
+static void rcu_eqs_enter_common(long long oldval, bool user)
 {
 	struct rcu_state *rsp;
 	struct rcu_data *rdp;
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 
 	trace_rcu_dyntick(TPS("Start"), oldval, rdtp->dynticks_nesting);
 	if (!user && !is_idle_task(current)) {
@@ -531,7 +518,7 @@ static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
 		rdp = this_cpu_ptr(rsp->rda);
 		do_nocb_deferred_wakeup(rdp);
 	}
-	rcu_prepare_for_idle(smp_processor_id());
+	rcu_prepare_for_idle();
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
 	smp_mb__before_atomic();  /* See above. */
 	atomic_inc(&rdtp->dynticks);
@@ -565,7 +552,7 @@ static void rcu_eqs_enter(bool user)
 	WARN_ON_ONCE((oldval & DYNTICK_TASK_NEST_MASK) == 0);
 	if ((oldval & DYNTICK_TASK_NEST_MASK) == DYNTICK_TASK_NEST_VALUE) {
 		rdtp->dynticks_nesting = 0;
-		rcu_eqs_enter_common(rdtp, oldval, user);
+		rcu_eqs_enter_common(oldval, user);
 	} else {
 		rdtp->dynticks_nesting -= DYNTICK_TASK_NEST_VALUE;
 	}
@@ -589,7 +576,7 @@ void rcu_idle_enter(void)
 
 	local_irq_save(flags);
 	rcu_eqs_enter(false);
-	rcu_sysidle_enter(this_cpu_ptr(&rcu_dynticks), 0);
+	rcu_sysidle_enter(0);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
@@ -639,8 +626,8 @@ void rcu_irq_exit(void)
 	if (rdtp->dynticks_nesting)
 		trace_rcu_dyntick(TPS("--="), oldval, rdtp->dynticks_nesting);
 	else
-		rcu_eqs_enter_common(rdtp, oldval, true);
-	rcu_sysidle_enter(rdtp, 1);
+		rcu_eqs_enter_common(oldval, true);
+	rcu_sysidle_enter(1);
 	local_irq_restore(flags);
 }
 
@@ -651,16 +638,17 @@ void rcu_irq_exit(void)
  * we really have exited idle, and must do the appropriate accounting.
  * The caller must have disabled interrupts.
  */
-static void rcu_eqs_exit_common(struct rcu_dynticks *rdtp, long long oldval,
-			       int user)
+static void rcu_eqs_exit_common(long long oldval, int user)
 {
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
+
 	rcu_dynticks_task_exit();
 	smp_mb__before_atomic();  /* Force ordering w/previous sojourn. */
 	atomic_inc(&rdtp->dynticks);
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
 	smp_mb__after_atomic();  /* See above. */
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
-	rcu_cleanup_after_idle(smp_processor_id());
+	rcu_cleanup_after_idle();
 	trace_rcu_dyntick(TPS("End"), oldval, rdtp->dynticks_nesting);
 	if (!user && !is_idle_task(current)) {
 		struct task_struct *idle __maybe_unused =
@@ -691,7 +679,7 @@ static void rcu_eqs_exit(bool user)
 		rdtp->dynticks_nesting += DYNTICK_TASK_NEST_VALUE;
 	} else {
 		rdtp->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
-		rcu_eqs_exit_common(rdtp, oldval, user);
+		rcu_eqs_exit_common(oldval, user);
 	}
 }
 
@@ -712,7 +700,7 @@ void rcu_idle_exit(void)
 
 	local_irq_save(flags);
 	rcu_eqs_exit(false);
-	rcu_sysidle_exit(this_cpu_ptr(&rcu_dynticks), 0);
+	rcu_sysidle_exit(0);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_exit);
@@ -763,8 +751,8 @@ void rcu_irq_enter(void)
 	if (oldval)
 		trace_rcu_dyntick(TPS("++="), oldval, rdtp->dynticks_nesting);
 	else
-		rcu_eqs_exit_common(rdtp, oldval, true);
-	rcu_sysidle_exit(rdtp, 1);
+		rcu_eqs_exit_common(oldval, true);
+	rcu_sysidle_exit(1);
 	local_irq_restore(flags);
 }
 
@@ -2387,7 +2375,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
  * invoked from the scheduling-clock interrupt.  If rcu_pending returns
  * false, there is no point in invoking rcu_check_callbacks().
  */
-void rcu_check_callbacks(int cpu, int user)
+void rcu_check_callbacks(int user)
 {
 	trace_rcu_utilization(TPS("Start scheduler-tick"));
 	increment_cpu_stall_ticks();
@@ -2419,8 +2407,8 @@ void rcu_check_callbacks(int cpu, int user)
 
 		rcu_bh_qs();
 	}
-	rcu_preempt_check_callbacks(cpu);
-	if (rcu_pending(cpu))
+	rcu_preempt_check_callbacks();
+	if (rcu_pending())
 		invoke_rcu_core();
 	if (user)
 		rcu_note_voluntary_context_switch(current);
@@ -2963,6 +2951,9 @@ static int synchronize_sched_expedited_cpu_stop(void *data)
  */
 void synchronize_sched_expedited(void)
 {
+	cpumask_var_t cm;
+	bool cma = false;
+	int cpu;
 	long firstsnap, s, snap;
 	int trycount = 0;
 	struct rcu_state *rsp = &rcu_sched_state;
@@ -2997,11 +2988,26 @@ void synchronize_sched_expedited(void)
 	}
 	WARN_ON_ONCE(cpu_is_offline(raw_smp_processor_id()));
 
+	/* Offline CPUs, idle CPUs, and any CPU we run on are quiescent. */
+	cma = zalloc_cpumask_var(&cm, GFP_KERNEL);
+	if (cma) {
+		cpumask_copy(cm, cpu_online_mask);
+		cpumask_clear_cpu(raw_smp_processor_id(), cm);
+		for_each_cpu(cpu, cm) {
+			struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
+
+			if (!(atomic_add_return(0, &rdtp->dynticks) & 0x1))
+				cpumask_clear_cpu(cpu, cm);
+		}
+		if (cpumask_weight(cm) == 0)
+			goto all_cpus_idle;
+	}
+
 	/*
 	 * Each pass through the following loop attempts to force a
 	 * context switch on each CPU.
 	 */
-	while (try_stop_cpus(cpu_online_mask,
+	while (try_stop_cpus(cma ? cm : cpu_online_mask,
 			     synchronize_sched_expedited_cpu_stop,
 			     NULL) == -EAGAIN) {
 		put_online_cpus();
@@ -3013,6 +3019,7 @@ void synchronize_sched_expedited(void)
 			/* ensure test happens before caller kfree */
 			smp_mb__before_atomic(); /* ^^^ */
 			atomic_long_inc(&rsp->expedited_workdone1);
+			free_cpumask_var(cm);
 			return;
 		}
 
@@ -3022,6 +3029,7 @@ void synchronize_sched_expedited(void)
 		} else {
 			wait_rcu_gp(call_rcu_sched);
 			atomic_long_inc(&rsp->expedited_normal);
+			free_cpumask_var(cm);
 			return;
 		}
 
@@ -3031,6 +3039,7 @@ void synchronize_sched_expedited(void)
 			/* ensure test happens before caller kfree */
 			smp_mb__before_atomic(); /* ^^^ */
 			atomic_long_inc(&rsp->expedited_workdone2);
+			free_cpumask_var(cm);
 			return;
 		}
 
@@ -3045,6 +3054,7 @@ void synchronize_sched_expedited(void)
 			/* CPU hotplug operation in flight, use normal GP. */
 			wait_rcu_gp(call_rcu_sched);
 			atomic_long_inc(&rsp->expedited_normal);
+			free_cpumask_var(cm);
 			return;
 		}
 		snap = atomic_long_read(&rsp->expedited_start);
@@ -3052,6 +3062,9 @@ void synchronize_sched_expedited(void)
 	}
 	atomic_long_inc(&rsp->expedited_stoppedcpus);
 
+all_cpus_idle:
+	free_cpumask_var(cm);
+
 	/*
 	 * Everyone up to our most recent fetch is covered by our grace
 	 * period.  Update the counter, but only if our work is still
@@ -3143,12 +3156,12 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
  * by the current CPU, returning 1 if so.  This function is part of the
  * RCU implementation; it is -not- an exported member of the RCU API.
  */
-static int rcu_pending(int cpu)
+static int rcu_pending(void)
 {
 	struct rcu_state *rsp;
 
 	for_each_rcu_flavor(rsp)
-		if (__rcu_pending(rsp, per_cpu_ptr(rsp->rda, cpu)))
+		if (__rcu_pending(rsp, this_cpu_ptr(rsp->rda)))
 			return 1;
 	return 0;
 }
@@ -3158,7 +3171,7 @@ static int rcu_pending(int cpu)
  * non-NULL, store an indication of whether all callbacks are lazy.
  * (If there are no callbacks, all of them are deemed to be lazy.)
  */
-static int __maybe_unused rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
+static int __maybe_unused rcu_cpu_has_callbacks(bool *all_lazy)
 {
 	bool al = true;
 	bool hc = false;
@@ -3166,7 +3179,7 @@ static int __maybe_unused rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
 	struct rcu_state *rsp;
 
 	for_each_rcu_flavor(rsp) {
-		rdp = per_cpu_ptr(rsp->rda, cpu);
+		rdp = this_cpu_ptr(rsp->rda);
 		if (!rdp->nxtlist)
 			continue;
 		hc = true;
@@ -3485,8 +3498,10 @@ static int rcu_cpu_notify(struct notifier_block *self,
 	case CPU_DEAD_FROZEN:
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
-		for_each_rcu_flavor(rsp)
+		for_each_rcu_flavor(rsp) {
 			rcu_cleanup_dead_cpu(cpu, rsp);
+			do_nocb_deferred_wakeup(per_cpu_ptr(rsp->rda, cpu));
+		}
 		break;
 	default:
 		break;
@@ -3766,6 +3781,8 @@ void __init rcu_init(void)
 	pm_notifier(rcu_pm_notify, 0);
 	for_each_online_cpu(cpu)
 		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
+
+	rcu_early_boot_tests();
 }
 
 #include "tree_plugin.h"
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index bbdc45d8d74f..8e7b1843896e 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -139,7 +139,7 @@ struct rcu_node {
 	unsigned long expmask;	/* Groups that have ->blkd_tasks */
 				/*  elements that need to drain to allow the */
 				/*  current expedited grace period to */
-				/*  complete (only for TREE_PREEMPT_RCU). */
+				/*  complete (only for PREEMPT_RCU). */
 	unsigned long qsmaskinit;
 				/* Per-GP initial value for qsmask & expmask. */
 	unsigned long grpmask;	/* Mask to apply to parent qsmask. */
@@ -530,10 +530,10 @@ DECLARE_PER_CPU(struct rcu_data, rcu_sched_data);
 extern struct rcu_state rcu_bh_state;
 DECLARE_PER_CPU(struct rcu_data, rcu_bh_data);
 
-#ifdef CONFIG_TREE_PREEMPT_RCU
+#ifdef CONFIG_PREEMPT_RCU
 extern struct rcu_state rcu_preempt_state;
 DECLARE_PER_CPU(struct rcu_data, rcu_preempt_data);
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#endif /* #ifdef CONFIG_PREEMPT_RCU */
 
 #ifdef CONFIG_RCU_BOOST
 DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
@@ -547,7 +547,7 @@ DECLARE_PER_CPU(char, rcu_cpu_has_work);
 /* Forward declarations for rcutree_plugin.h */
 static void rcu_bootup_announce(void);
 long rcu_batches_completed(void);
-static void rcu_preempt_note_context_switch(int cpu);
+static void rcu_preempt_note_context_switch(void);
 static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
 static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
@@ -561,12 +561,12 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 				     struct rcu_node *rnp,
 				     struct rcu_data *rdp);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
-static void rcu_preempt_check_callbacks(int cpu);
+static void rcu_preempt_check_callbacks(void);
 void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
-#if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_TREE_PREEMPT_RCU)
+#if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_PREEMPT_RCU)
 static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
 			       bool wake);
-#endif /* #if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_TREE_PREEMPT_RCU) */
+#endif /* #if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_PREEMPT_RCU) */
 static void __init __rcu_init_preempt(void);
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags);
 static void rcu_preempt_boost_start_gp(struct rcu_node *rnp);
@@ -579,8 +579,8 @@ static int rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 #endif /* #ifdef CONFIG_RCU_BOOST */
 static void __init rcu_spawn_boost_kthreads(void);
 static void rcu_prepare_kthreads(int cpu);
-static void rcu_cleanup_after_idle(int cpu);
-static void rcu_prepare_for_idle(int cpu);
+static void rcu_cleanup_after_idle(void);
+static void rcu_prepare_for_idle(void);
 static void rcu_idle_count_callbacks_posted(void);
 static void print_cpu_stall_info_begin(void);
 static void print_cpu_stall_info(struct rcu_state *rsp, int cpu);
@@ -606,8 +606,8 @@ static void __init rcu_organize_nocb_kthreads(struct rcu_state *rsp);
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 static void __maybe_unused rcu_kick_nohz_cpu(int cpu);
 static bool init_nocb_callback_list(struct rcu_data *rdp);
-static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq);
-static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq);
+static void rcu_sysidle_enter(int irq);
+static void rcu_sysidle_exit(int irq);
 static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
 				  unsigned long *maxj);
 static bool is_sysidle_rcu_state(struct rcu_state *rsp);
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index c1d7f27bd38f..3ec85cb5d544 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -30,14 +30,24 @@
 #include <linux/smpboot.h>
 #include "../time/tick-internal.h"
 
-#define RCU_KTHREAD_PRIO 1
-
 #ifdef CONFIG_RCU_BOOST
+
 #include "../locking/rtmutex_common.h"
-#define RCU_BOOST_PRIO CONFIG_RCU_BOOST_PRIO
-#else
-#define RCU_BOOST_PRIO RCU_KTHREAD_PRIO
-#endif
+
+/* rcuc/rcub kthread realtime priority */
+static int kthread_prio = CONFIG_RCU_KTHREAD_PRIO;
+module_param(kthread_prio, int, 0644);
+
+/*
+ * Control variables for per-CPU and per-rcu_node kthreads.  These
+ * handle all flavors of RCU.
+ */
+static DEFINE_PER_CPU(struct task_struct *, rcu_cpu_kthread_task);
+DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
+DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
+DEFINE_PER_CPU(char, rcu_cpu_has_work);
+
+#endif /* #ifdef CONFIG_RCU_BOOST */
 
 #ifdef CONFIG_RCU_NOCB_CPU
 static cpumask_var_t rcu_nocb_mask; /* CPUs to have callbacks offloaded. */
@@ -72,9 +82,6 @@ static void __init rcu_bootup_announce_oddness(void)
 #ifdef CONFIG_RCU_TORTURE_TEST_RUNNABLE
 	pr_info("\tRCU torture testing starts during boot.\n");
 #endif
-#if defined(CONFIG_TREE_PREEMPT_RCU) && !defined(CONFIG_RCU_CPU_STALL_VERBOSE)
-	pr_info("\tDump stacks of tasks blocking RCU-preempt GP.\n");
-#endif
 #if defined(CONFIG_RCU_CPU_STALL_INFO)
 	pr_info("\tAdditional per-CPU info printed with stalls.\n");
 #endif
@@ -85,9 +92,12 @@ static void __init rcu_bootup_announce_oddness(void)
 		pr_info("\tBoot-time adjustment of leaf fanout to %d.\n", rcu_fanout_leaf);
 	if (nr_cpu_ids != NR_CPUS)
 		pr_info("\tRCU restricting CPUs from NR_CPUS=%d to nr_cpu_ids=%d.\n", NR_CPUS, nr_cpu_ids);
+#ifdef CONFIG_RCU_BOOST
+	pr_info("\tRCU kthread priority: %d.\n", kthread_prio);
+#endif
 }
 
-#ifdef CONFIG_TREE_PREEMPT_RCU
+#ifdef CONFIG_PREEMPT_RCU
 
 RCU_STATE_INITIALIZER(rcu_preempt, 'p', call_rcu);
 static struct rcu_state *rcu_state_p = &rcu_preempt_state;
@@ -156,7 +166,7 @@ static void rcu_preempt_qs(void)
  *
  * Caller must disable preemption.
  */
-static void rcu_preempt_note_context_switch(int cpu)
+static void rcu_preempt_note_context_switch(void)
 {
 	struct task_struct *t = current;
 	unsigned long flags;
@@ -167,7 +177,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 	    !t->rcu_read_unlock_special.b.blocked) {
 
 		/* Possibly blocking in an RCU read-side critical section. */
-		rdp = per_cpu_ptr(rcu_preempt_state.rda, cpu);
+		rdp = this_cpu_ptr(rcu_preempt_state.rda);
 		rnp = rdp->mynode;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		smp_mb__after_unlock_lock();
@@ -415,8 +425,6 @@ void rcu_read_unlock_special(struct task_struct *t)
 	}
 }
 
-#ifdef CONFIG_RCU_CPU_STALL_VERBOSE
-
 /*
  * Dump detailed information for all tasks blocking the current RCU
  * grace period on the specified rcu_node structure.
@@ -451,14 +459,6 @@ static void rcu_print_detail_task_stall(struct rcu_state *rsp)
 		rcu_print_detail_task_stall_rnp(rnp);
 }
 
-#else /* #ifdef CONFIG_RCU_CPU_STALL_VERBOSE */
-
-static void rcu_print_detail_task_stall(struct rcu_state *rsp)
-{
-}
-
-#endif /* #else #ifdef CONFIG_RCU_CPU_STALL_VERBOSE */
-
 #ifdef CONFIG_RCU_CPU_STALL_INFO
 
 static void rcu_print_task_stall_begin(struct rcu_node *rnp)
@@ -621,7 +621,7 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
  *
  * Caller must disable hard irqs.
  */
-static void rcu_preempt_check_callbacks(int cpu)
+static void rcu_preempt_check_callbacks(void)
 {
 	struct task_struct *t = current;
 
@@ -630,8 +630,8 @@ static void rcu_preempt_check_callbacks(int cpu)
 		return;
 	}
 	if (t->rcu_read_lock_nesting > 0 &&
-	    per_cpu(rcu_preempt_data, cpu).qs_pending &&
-	    !per_cpu(rcu_preempt_data, cpu).passed_quiesce)
+	    __this_cpu_read(rcu_preempt_data.qs_pending) &&
+	    !__this_cpu_read(rcu_preempt_data.passed_quiesce))
 		t->rcu_read_unlock_special.b.need_qs = true;
 }
 
@@ -919,7 +919,7 @@ void exit_rcu(void)
 	__rcu_read_unlock();
 }
 
-#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#else /* #ifdef CONFIG_PREEMPT_RCU */
 
 static struct rcu_state *rcu_state_p = &rcu_sched_state;
 
@@ -945,7 +945,7 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed);
  * Because preemptible RCU does not exist, we never have to check for
  * CPUs being in quiescent states.
  */
-static void rcu_preempt_note_context_switch(int cpu)
+static void rcu_preempt_note_context_switch(void)
 {
 }
 
@@ -1017,7 +1017,7 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
  * Because preemptible RCU does not exist, it never has any callbacks
  * to check.
  */
-static void rcu_preempt_check_callbacks(int cpu)
+static void rcu_preempt_check_callbacks(void)
 {
 }
 
@@ -1070,7 +1070,7 @@ void exit_rcu(void)
 {
 }
 
-#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
+#endif /* #else #ifdef CONFIG_PREEMPT_RCU */
 
 #ifdef CONFIG_RCU_BOOST
 
@@ -1326,7 +1326,7 @@ static int rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	smp_mb__after_unlock_lock();
 	rnp->boost_kthread_task = t;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	sp.sched_priority = RCU_BOOST_PRIO;
+	sp.sched_priority = kthread_prio;
 	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
 	wake_up_process(t); /* get to TASK_INTERRUPTIBLE quickly. */
 	return 0;
@@ -1343,7 +1343,7 @@ static void rcu_cpu_kthread_setup(unsigned int cpu)
 {
 	struct sched_param sp;
 
-	sp.sched_priority = RCU_KTHREAD_PRIO;
+	sp.sched_priority = kthread_prio;
 	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
 }
 
@@ -1512,10 +1512,10 @@ static void rcu_prepare_kthreads(int cpu)
  * any flavor of RCU.
  */
 #ifndef CONFIG_RCU_NOCB_CPU_ALL
-int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
+int rcu_needs_cpu(unsigned long *delta_jiffies)
 {
 	*delta_jiffies = ULONG_MAX;
-	return rcu_cpu_has_callbacks(cpu, NULL);
+	return rcu_cpu_has_callbacks(NULL);
 }
 #endif /* #ifndef CONFIG_RCU_NOCB_CPU_ALL */
 
@@ -1523,7 +1523,7 @@ int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
  * Because we do not have RCU_FAST_NO_HZ, don't bother cleaning up
  * after it.
  */
-static void rcu_cleanup_after_idle(int cpu)
+static void rcu_cleanup_after_idle(void)
 {
 }
 
@@ -1531,7 +1531,7 @@ static void rcu_cleanup_after_idle(int cpu)
  * Do the idle-entry grace-period work, which, because CONFIG_RCU_FAST_NO_HZ=n,
  * is nothing.
  */
-static void rcu_prepare_for_idle(int cpu)
+static void rcu_prepare_for_idle(void)
 {
 }
 
@@ -1624,15 +1624,15 @@ static bool __maybe_unused rcu_try_advance_all_cbs(void)
  * The caller must have disabled interrupts.
  */
 #ifndef CONFIG_RCU_NOCB_CPU_ALL
-int rcu_needs_cpu(int cpu, unsigned long *dj)
+int rcu_needs_cpu(unsigned long *dj)
 {
-	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 
 	/* Snapshot to detect later posting of non-lazy callback. */
 	rdtp->nonlazy_posted_snap = rdtp->nonlazy_posted;
 
 	/* If no callbacks, RCU doesn't need the CPU. */
-	if (!rcu_cpu_has_callbacks(cpu, &rdtp->all_lazy)) {
+	if (!rcu_cpu_has_callbacks(&rdtp->all_lazy)) {
 		*dj = ULONG_MAX;
 		return 0;
 	}
@@ -1666,12 +1666,12 @@ int rcu_needs_cpu(int cpu, unsigned long *dj)
  *
  * The caller must have disabled interrupts.
  */
-static void rcu_prepare_for_idle(int cpu)
+static void rcu_prepare_for_idle(void)
 {
 #ifndef CONFIG_RCU_NOCB_CPU_ALL
 	bool needwake;
 	struct rcu_data *rdp;
-	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 	struct rcu_node *rnp;
 	struct rcu_state *rsp;
 	int tne;
@@ -1679,7 +1679,7 @@ static void rcu_prepare_for_idle(int cpu)
 	/* Handle nohz enablement switches conservatively. */
 	tne = ACCESS_ONCE(tick_nohz_active);
 	if (tne != rdtp->tick_nohz_enabled_snap) {
-		if (rcu_cpu_has_callbacks(cpu, NULL))
+		if (rcu_cpu_has_callbacks(NULL))
 			invoke_rcu_core(); /* force nohz to see update. */
 		rdtp->tick_nohz_enabled_snap = tne;
 		return;
@@ -1688,7 +1688,7 @@ static void rcu_prepare_for_idle(int cpu)
 		return;
 
 	/* If this is a no-CBs CPU, no callbacks, just return. */
-	if (rcu_is_nocb_cpu(cpu))
+	if (rcu_is_nocb_cpu(smp_processor_id()))
 		return;
 
 	/*
@@ -1712,7 +1712,7 @@ static void rcu_prepare_for_idle(int cpu)
 		return;
 	rdtp->last_accelerate = jiffies;
 	for_each_rcu_flavor(rsp) {
-		rdp = per_cpu_ptr(rsp->rda, cpu);
+		rdp = this_cpu_ptr(rsp->rda);
 		if (!*rdp->nxttail[RCU_DONE_TAIL])
 			continue;
 		rnp = rdp->mynode;
@@ -1731,10 +1731,10 @@ static void rcu_prepare_for_idle(int cpu)
  * any grace periods that elapsed while the CPU was idle, and if any
  * callbacks are now ready to invoke, initiate invocation.
  */
-static void rcu_cleanup_after_idle(int cpu)
+static void rcu_cleanup_after_idle(void)
 {
 #ifndef CONFIG_RCU_NOCB_CPU_ALL
-	if (rcu_is_nocb_cpu(cpu))
+	if (rcu_is_nocb_cpu(smp_processor_id()))
 		return;
 	if (rcu_try_advance_all_cbs())
 		invoke_rcu_core();
@@ -2573,9 +2573,13 @@ static void rcu_spawn_one_nocb_kthread(struct rcu_state *rsp, int cpu)
 			rdp->nocb_leader = rdp_spawn;
 			if (rdp_last && rdp != rdp_spawn)
 				rdp_last->nocb_next_follower = rdp;
-			rdp_last = rdp;
-			rdp = rdp->nocb_next_follower;
-			rdp_last->nocb_next_follower = NULL;
+			if (rdp == rdp_spawn) {
+				rdp = rdp->nocb_next_follower;
+			} else {
+				rdp_last = rdp;
+				rdp = rdp->nocb_next_follower;
+				rdp_last->nocb_next_follower = NULL;
+			}
 		} while (rdp);
 		rdp_spawn->nocb_next_follower = rdp_old_leader;
 	}
@@ -2761,9 +2765,10 @@ static int full_sysidle_state;		/* Current system-idle state. */
  * to detect full-system idle states, not RCU quiescent states and grace
  * periods.  The caller must have disabled interrupts.
  */
-static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq)
+static void rcu_sysidle_enter(int irq)
 {
 	unsigned long j;
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 
 	/* If there are no nohz_full= CPUs, no need to track this. */
 	if (!tick_nohz_full_enabled())
@@ -2832,8 +2837,10 @@ void rcu_sysidle_force_exit(void)
  * usermode execution does -not- count as idle here!  The caller must
  * have disabled interrupts.
  */
-static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
+static void rcu_sysidle_exit(int irq)
 {
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
+
 	/* If there are no nohz_full= CPUs, no need to track this. */
 	if (!tick_nohz_full_enabled())
 		return;
@@ -3127,11 +3134,11 @@ static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
 
 #else /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
 
-static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq)
+static void rcu_sysidle_enter(int irq)
 {
 }
 
-static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
+static void rcu_sysidle_exit(int irq)
 {
 }
 
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 3ef8ba58694e..e0d31a345ee6 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -306,7 +306,7 @@ struct debug_obj_descr rcuhead_debug_descr = {
 EXPORT_SYMBOL_GPL(rcuhead_debug_descr);
 #endif /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 
-#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU) || defined(CONFIG_RCU_TRACE)
+#if defined(CONFIG_TREE_RCU) || defined(CONFIG_PREEMPT_RCU) || defined(CONFIG_RCU_TRACE)
 void do_trace_rcu_torture_read(const char *rcutorturename, struct rcu_head *rhp,
 			       unsigned long secs,
 			       unsigned long c_old, unsigned long c)
@@ -531,7 +531,8 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 	struct rcu_head *next;
 	LIST_HEAD(rcu_tasks_holdouts);
 
-	/* FIXME: Add housekeeping affinity. */
+	/* Run on housekeeping CPUs by default.  Sysadm can move if desired. */
+	housekeeping_affine(current);
 
 	/*
 	 * Each pass through the following loop makes one check for
@@ -690,3 +691,87 @@ static void rcu_spawn_tasks_kthread(void)
 }
 
 #endif /* #ifdef CONFIG_TASKS_RCU */
+
+#ifdef CONFIG_PROVE_RCU
+
+/*
+ * Early boot self test parameters, one for each flavor
+ */
+static bool rcu_self_test;
+static bool rcu_self_test_bh;
+static bool rcu_self_test_sched;
+
+module_param(rcu_self_test, bool, 0444);
+module_param(rcu_self_test_bh, bool, 0444);
+module_param(rcu_self_test_sched, bool, 0444);
+
+static int rcu_self_test_counter;
+
+static void test_callback(struct rcu_head *r)
+{
+	rcu_self_test_counter++;
+	pr_info("RCU test callback executed %d\n", rcu_self_test_counter);
+}
+
+static void early_boot_test_call_rcu(void)
+{
+	static struct rcu_head head;
+
+	call_rcu(&head, test_callback);
+}
+
+static void early_boot_test_call_rcu_bh(void)
+{
+	static struct rcu_head head;
+
+	call_rcu_bh(&head, test_callback);
+}
+
+static void early_boot_test_call_rcu_sched(void)
+{
+	static struct rcu_head head;
+
+	call_rcu_sched(&head, test_callback);
+}
+
+void rcu_early_boot_tests(void)
+{
+	pr_info("Running RCU self tests\n");
+
+	if (rcu_self_test)
+		early_boot_test_call_rcu();
+	if (rcu_self_test_bh)
+		early_boot_test_call_rcu_bh();
+	if (rcu_self_test_sched)
+		early_boot_test_call_rcu_sched();
+}
+
+static int rcu_verify_early_boot_tests(void)
+{
+	int ret = 0;
+	int early_boot_test_counter = 0;
+
+	if (rcu_self_test) {
+		early_boot_test_counter++;
+		rcu_barrier();
+	}
+	if (rcu_self_test_bh) {
+		early_boot_test_counter++;
+		rcu_barrier_bh();
+	}
+	if (rcu_self_test_sched) {
+		early_boot_test_counter++;
+		rcu_barrier_sched();
+	}
+
+	if (rcu_self_test_counter != early_boot_test_counter) {
+		WARN_ON(1);
+		ret = -1;
+	}
+
+	return ret;
+}
+late_initcall(rcu_verify_early_boot_tests);
+#else
+void rcu_early_boot_tests(void) {}
+#endif /* CONFIG_PROVE_RCU */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 240157c13ddc..05e5c1ebc73b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2802,7 +2802,7 @@ static void __sched __schedule(void)
 	preempt_disable();
 	cpu = smp_processor_id();
 	rq = cpu_rq(cpu);
-	rcu_note_context_switch(cpu);
+	rcu_note_context_switch();
 	prev = rq->curr;
 
 	schedule_debug(prev);
diff --git a/kernel/signal.c b/kernel/signal.c
index 8f0876f9f6dd..19e35135fc60 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1275,7 +1275,17 @@ struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
 			local_irq_restore(*flags);
 			break;
 		}
-
+		/*
+		 * This sighand can be already freed and even reused, but
+		 * we rely on SLAB_DESTROY_BY_RCU and sighand_ctor() which
+		 * initializes ->siglock: this slab can't go away, it has
+		 * the same object type, ->siglock can't be reinitialized.
+		 *
+		 * We need to ensure that tsk->sighand is still the same
+		 * after we take the lock, we can race with de_thread() or
+		 * __exit_signal(). In the latter case the next iteration
+		 * must see ->sighand == NULL.
+		 */
 		spin_lock(&sighand->siglock);
 		if (likely(sighand == tsk->sighand)) {
 			rcu_read_unlock();
@@ -1331,23 +1341,21 @@ int kill_pid_info(int sig, struct siginfo *info, struct pid *pid)
 	int error = -ESRCH;
 	struct task_struct *p;
 
-	rcu_read_lock();
-retry:
-	p = pid_task(pid, PIDTYPE_PID);
-	if (p) {
-		error = group_send_sig_info(sig, info, p);
-		if (unlikely(error == -ESRCH))
-			/*
-			 * The task was unhashed in between, try again.
-			 * If it is dead, pid_task() will return NULL,
-			 * if we race with de_thread() it will find the
-			 * new leader.
-			 */
-			goto retry;
-	}
-	rcu_read_unlock();
+	for (;;) {
+		rcu_read_lock();
+		p = pid_task(pid, PIDTYPE_PID);
+		if (p)
+			error = group_send_sig_info(sig, info, p);
+		rcu_read_unlock();
+		if (likely(!p || error != -ESRCH))
+			return error;
 
-	return error;
+		/*
+		 * The task was unhashed in between, try again.  If it
+		 * is dead, pid_task() will return NULL, if we race with
+		 * de_thread() it will find the new leader.
+		 */
+	}
 }
 
 int kill_proc_info(int sig, struct siginfo *info, pid_t pid)
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 0699add19164..501baa9ac1be 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -656,7 +656,7 @@ static void run_ksoftirqd(unsigned int cpu)
 		 * in the task stack here.
 		 */
 		__do_softirq();
-		rcu_note_context_switch(cpu);
+		rcu_note_context_switch();
 		local_irq_enable();
 		cond_resched();
 		return;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 7b5741fc4110..1f4356037a7d 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -585,7 +585,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 		last_jiffies = jiffies;
 	} while (read_seqretry(&jiffies_lock, seq));
 
-	if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) ||
+	if (rcu_needs_cpu(&rcu_delta_jiffies) ||
 	    arch_needs_cpu() || irq_work_needs_cpu()) {
 		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 3260ffdb368f..2d3f5c504939 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1377,12 +1377,11 @@ unsigned long get_next_timer_interrupt(unsigned long now)
 void update_process_times(int user_tick)
 {
 	struct task_struct *p = current;
-	int cpu = smp_processor_id();
 
 	/* Note: this timer irq context must be accounted for as well. */
 	account_process_tick(p, user_tick);
 	run_local_timers();
-	rcu_check_callbacks(cpu, user_tick);
+	rcu_check_callbacks(user_tick);
 #ifdef CONFIG_IRQ_WORK
 	if (in_irq())
 		irq_work_tick();
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 4e35a5d767ed..d780351835e9 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1238,21 +1238,9 @@ config RCU_CPU_STALL_TIMEOUT
 	  RCU grace period persists, additional CPU stall warnings are
 	  printed at more widely spaced intervals.
 
-config RCU_CPU_STALL_VERBOSE
-	bool "Print additional per-task information for RCU_CPU_STALL_DETECTOR"
-	depends on TREE_PREEMPT_RCU
-	default y
-	help
-	  This option causes RCU to printk detailed per-task information
-	  for any tasks that are stalling the current RCU grace period.
-
-	  Say N if you are unsure.
-
-	  Say Y if you want to enable such checks.
-
 config RCU_CPU_STALL_INFO
 	bool "Print additional diagnostics on RCU CPU stall"
-	depends on (TREE_RCU || TREE_PREEMPT_RCU) && DEBUG_KERNEL
+	depends on (TREE_RCU || PREEMPT_RCU) && DEBUG_KERNEL
 	default n
 	help
 	  For each stalled CPU that is aware of the current RCU grace
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
index f6b2b4771b78..8ca9f21f2efc 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
@@ -45,7 +45,7 @@ trap 'rm -rf $T' 0
 touch $T
 
 . $KVM/bin/functions.sh
-. $KVPATH/ver_functions.sh
+. $CONFIGFRAG/ver_functions.sh
 
 config_template=${1}
 config_dir=`echo $config_template | sed -e 's,/[^/]*$,,'`
@@ -168,8 +168,8 @@ then
 	touch $resdir/buildonly
 	exit 0
 fi
-echo $QEMU $qemu_args -m 512 -kernel $builddir/$BOOT_IMAGE -append \"$qemu_append $boot_args\" > $resdir/qemu-cmd
-( $QEMU $qemu_args -m 512 -kernel $builddir/$BOOT_IMAGE -append "$qemu_append $boot_args"; echo $? > $resdir/qemu-retval ) &
+echo $QEMU $qemu_args -m 512 -kernel $resdir/bzImage -append \"$qemu_append $boot_args\" > $resdir/qemu-cmd
+( $QEMU $qemu_args -m 512 -kernel $resdir/bzImage -append "$qemu_append $boot_args"; echo $? > $resdir/qemu-retval ) &
 qemu_pid=$!
 commandcompleted=0
 echo Monitoring qemu job at pid $qemu_pid
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index e527dc952eb0..368d64ac779e 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -47,7 +47,6 @@ resdir=""
 configs=""
 cpus=0
 ds=`date +%Y.%m.%d-%H:%M:%S`
-kversion=""
 
 . functions.sh
 
@@ -64,7 +63,6 @@ usage () {
 	echo "       --duration minutes"
 	echo "       --interactive"
 	echo "       --kmake-arg kernel-make-arguments"
-	echo "       --kversion vN.NN"
 	echo "       --mac nn:nn:nn:nn:nn:nn"
 	echo "       --no-initrd"
 	echo "       --qemu-args qemu-system-..."
@@ -128,11 +126,6 @@ do
 		TORTURE_KMAKE_ARG="$2"
 		shift
 		;;
-	--kversion)
-		checkarg --kversion "(kernel version)" $# "$2" '^v[0-9.]*$' '^error'
-		kversion=$2
-		shift
-		;;
 	--mac)
 		checkarg --mac "(MAC address)" $# "$2" '^\([0-9a-fA-F]\{2\}:\)\{5\}[0-9a-fA-F]\{2\}$' error
 		TORTURE_QEMU_MAC=$2
@@ -170,11 +163,10 @@ do
 done
 
 CONFIGFRAG=${KVM}/configs/${TORTURE_SUITE}; export CONFIGFRAG
-KVPATH=${CONFIGFRAG}/$kversion; export KVPATH
 
 if test -z "$configs"
 then
-	configs="`cat $CONFIGFRAG/$kversion/CFLIST`"
+	configs="`cat $CONFIGFRAG/CFLIST`"
 fi
 
 if test -z "$resdir"
@@ -186,10 +178,10 @@ fi
 touch $T/cfgcpu
 for CF in $configs
 do
-	if test -f "$CONFIGFRAG/$kversion/$CF"
+	if test -f "$CONFIGFRAG/$CF"
 	then
-		cpu_count=`configNR_CPUS.sh $CONFIGFRAG/$kversion/$CF`
-		cpu_count=`configfrag_boot_cpus "$TORTURE_BOOTARGS" "$CONFIGFRAG/$kversion/$CF" "$cpu_count"`
+		cpu_count=`configNR_CPUS.sh $CONFIGFRAG/$CF`
+		cpu_count=`configfrag_boot_cpus "$TORTURE_BOOTARGS" "$CONFIGFRAG/$CF" "$cpu_count"`
 		echo $CF $cpu_count >> $T/cfgcpu
 	else
 		echo "The --configs file $CF does not exist, terminating."
@@ -252,7 +244,6 @@ END {
 cat << ___EOF___ > $T/script
 CONFIGFRAG="$CONFIGFRAG"; export CONFIGFRAG
 KVM="$KVM"; export KVM
-KVPATH="$KVPATH"; export KVPATH
 PATH="$PATH"; export PATH
 TORTURE_BOOT_IMAGE="$TORTURE_BOOT_IMAGE"; export TORTURE_BOOT_IMAGE
 TORTURE_BUILDONLY="$TORTURE_BUILDONLY"; export TORTURE_BUILDONLY
@@ -285,7 +276,7 @@ then
 fi
 ___EOF___
 awk < $T/cfgcpu.pack \
-	-v CONFIGDIR="$CONFIGFRAG/$kversion/" \
+	-v CONFIGDIR="$CONFIGFRAG/" \
 	-v KVM="$KVM" \
 	-v ncpus=$cpus \
 	-v rd=$resdir/$ds/ \
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TINY02 b/tools/testing/selftests/rcutorture/configs/rcu/TINY02
index f4feaee40776..36e41df3d27a 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TINY02
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TINY02
@@ -7,6 +7,8 @@ CONFIG_HZ_PERIODIC=y
 CONFIG_NO_HZ_IDLE=n
 CONFIG_NO_HZ_FULL=n
 CONFIG_RCU_TRACE=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
 CONFIG_DEBUG_LOCK_ALLOC=y
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
 CONFIG_PREEMPT_COUNT=y
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TINY02.boot b/tools/testing/selftests/rcutorture/configs/rcu/TINY02.boot
new file mode 100644
index 000000000000..0f0802730014
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TINY02.boot
@@ -0,0 +1,2 @@
+rcupdate.rcu_self_test=1
+rcupdate.rcu_self_test_bh=1
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE01 b/tools/testing/selftests/rcutorture/configs/rcu/TREE01
index 38e3895759dd..f8a10a7500c6 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE01
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE01
@@ -2,7 +2,7 @@ CONFIG_SMP=y
 CONFIG_PREEMPT_NONE=n
 CONFIG_PREEMPT_VOLUNTARY=n
 CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+#CHECK#CONFIG_PREEMPT_RCU=y
 CONFIG_HZ_PERIODIC=n
 CONFIG_NO_HZ_IDLE=y
 CONFIG_NO_HZ_FULL=n
@@ -14,6 +14,5 @@ CONFIG_RCU_NOCB_CPU=y
 CONFIG_RCU_NOCB_CPU_ZERO=y
 CONFIG_DEBUG_LOCK_ALLOC=n
 CONFIG_RCU_CPU_STALL_INFO=n
-CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE02 b/tools/testing/selftests/rcutorture/configs/rcu/TREE02
index ea119ba2f7d4..629122fb8b4a 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE02
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE02
@@ -3,7 +3,7 @@ CONFIG_NR_CPUS=8
 CONFIG_PREEMPT_NONE=n
 CONFIG_PREEMPT_VOLUNTARY=n
 CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+#CHECK#CONFIG_PREEMPT_RCU=y
 CONFIG_HZ_PERIODIC=n
 CONFIG_NO_HZ_IDLE=y
 CONFIG_NO_HZ_FULL=n
@@ -19,6 +19,5 @@ CONFIG_RCU_NOCB_CPU=n
 CONFIG_DEBUG_LOCK_ALLOC=y
 CONFIG_PROVE_LOCKING=n
 CONFIG_RCU_CPU_STALL_INFO=n
-CONFIG_RCU_CPU_STALL_VERBOSE=y
 CONFIG_RCU_BOOST=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE02-T b/tools/testing/selftests/rcutorture/configs/rcu/TREE02-T
index 19cf9485f48a..a25de47888a4 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE02-T
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE02-T
@@ -3,7 +3,7 @@ CONFIG_NR_CPUS=8
 CONFIG_PREEMPT_NONE=n
 CONFIG_PREEMPT_VOLUNTARY=n
 CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+#CHECK#CONFIG_PREEMPT_RCU=y
 CONFIG_HZ_PERIODIC=n
 CONFIG_NO_HZ_IDLE=y
 CONFIG_NO_HZ_FULL=n
@@ -19,6 +19,5 @@ CONFIG_RCU_NOCB_CPU=n
 CONFIG_DEBUG_LOCK_ALLOC=y
 CONFIG_PROVE_LOCKING=n
 CONFIG_RCU_CPU_STALL_INFO=n
-CONFIG_RCU_CPU_STALL_VERBOSE=y
 CONFIG_RCU_BOOST=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE03 b/tools/testing/selftests/rcutorture/configs/rcu/TREE03
index f4567fb3e332..53f24e0a0ab6 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE03
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE03
@@ -3,7 +3,7 @@ CONFIG_NR_CPUS=8
 CONFIG_PREEMPT_NONE=n
 CONFIG_PREEMPT_VOLUNTARY=n
 CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+#CHECK#CONFIG_PREEMPT_RCU=y
 CONFIG_HZ_PERIODIC=y
 CONFIG_NO_HZ_IDLE=n
 CONFIG_NO_HZ_FULL=n
@@ -15,7 +15,6 @@ CONFIG_RCU_FANOUT_EXACT=n
 CONFIG_RCU_NOCB_CPU=n
 CONFIG_DEBUG_LOCK_ALLOC=n
 CONFIG_RCU_CPU_STALL_INFO=n
-CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
+CONFIG_RCU_KTHREAD_PRIO=2
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE04 b/tools/testing/selftests/rcutorture/configs/rcu/TREE04
index 0a262fbb0c12..0f84db35b36d 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE04
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE04
@@ -19,5 +19,4 @@ CONFIG_RCU_FANOUT_EXACT=n
 CONFIG_RCU_NOCB_CPU=n
 CONFIG_DEBUG_LOCK_ALLOC=n
 CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_RCU_CPU_STALL_VERBOSE=y
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE05 b/tools/testing/selftests/rcutorture/configs/rcu/TREE05
index 3a06b97e9a73..212e3bfd2b2a 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE05
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE05
@@ -19,5 +19,4 @@ CONFIG_DEBUG_LOCK_ALLOC=y
 CONFIG_PROVE_LOCKING=y
 CONFIG_PROVE_RCU=y
 CONFIG_RCU_CPU_STALL_INFO=n
-CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE05.boot b/tools/testing/selftests/rcutorture/configs/rcu/TREE05.boot
index 3b42b8b033cd..15b3e1a86f74 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE05.boot
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE05.boot
@@ -1 +1,2 @@
 rcutorture.torture_type=sched
+rcupdate.rcu_self_test_sched=1
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE06 b/tools/testing/selftests/rcutorture/configs/rcu/TREE06
index 8f084cca91bf..7eee63b44218 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE06
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE06
@@ -20,5 +20,4 @@ CONFIG_DEBUG_LOCK_ALLOC=y
 CONFIG_PROVE_LOCKING=y
 CONFIG_PROVE_RCU=y
 CONFIG_RCU_CPU_STALL_INFO=n
-CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE06.boot b/tools/testing/selftests/rcutorture/configs/rcu/TREE06.boot
new file mode 100644
index 000000000000..da9a03a398db
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE06.boot
@@ -0,0 +1,3 @@
+rcupdate.rcu_self_test=1
+rcupdate.rcu_self_test_bh=1
+rcupdate.rcu_self_test_sched=1
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE07 b/tools/testing/selftests/rcutorture/configs/rcu/TREE07
index 8f1017666aa7..92a97fa97dec 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE07
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE07
@@ -19,5 +19,4 @@ CONFIG_RCU_FANOUT_EXACT=n
 CONFIG_RCU_NOCB_CPU=n
 CONFIG_DEBUG_LOCK_ALLOC=n
 CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE08 b/tools/testing/selftests/rcutorture/configs/rcu/TREE08
index 69a2e255bf98..5812027d6f9f 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE08
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE08
@@ -3,7 +3,7 @@ CONFIG_NR_CPUS=16
 CONFIG_PREEMPT_NONE=n
 CONFIG_PREEMPT_VOLUNTARY=n
 CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+#CHECK#CONFIG_PREEMPT_RCU=y
 CONFIG_HZ_PERIODIC=n
 CONFIG_NO_HZ_IDLE=y
 CONFIG_NO_HZ_FULL=n
@@ -18,7 +18,8 @@ CONFIG_RCU_FANOUT_LEAF=2
 CONFIG_RCU_NOCB_CPU=y
 CONFIG_RCU_NOCB_CPU_ALL=y
 CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
 CONFIG_RCU_CPU_STALL_INFO=n
-CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T b/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T
index a0f32fb8f17e..3eaeccacb083 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T
@@ -3,7 +3,7 @@ CONFIG_NR_CPUS=16
 CONFIG_PREEMPT_NONE=n
 CONFIG_PREEMPT_VOLUNTARY=n
 CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+#CHECK#CONFIG_PREEMPT_RCU=y
 CONFIG_HZ_PERIODIC=n
 CONFIG_NO_HZ_IDLE=y
 CONFIG_NO_HZ_FULL=n
@@ -19,6 +19,5 @@ CONFIG_RCU_NOCB_CPU=y
 CONFIG_RCU_NOCB_CPU_ALL=y
 CONFIG_DEBUG_LOCK_ALLOC=n
 CONFIG_RCU_CPU_STALL_INFO=n
-CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE08.boot b/tools/testing/selftests/rcutorture/configs/rcu/TREE08.boot
index 3b42b8b033cd..2561daf605ad 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE08.boot
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE08.boot
@@ -1 +1,3 @@
 rcutorture.torture_type=sched
+rcupdate.rcu_self_test=1
+rcupdate.rcu_self_test_sched=1
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE09 b/tools/testing/selftests/rcutorture/configs/rcu/TREE09
index b7a62a540ad1..6076b36f6c0b 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE09
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE09
@@ -3,7 +3,7 @@ CONFIG_NR_CPUS=1
 CONFIG_PREEMPT_NONE=n
 CONFIG_PREEMPT_VOLUNTARY=n
 CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+#CHECK#CONFIG_PREEMPT_RCU=y
 CONFIG_HZ_PERIODIC=n
 CONFIG_NO_HZ_IDLE=y
 CONFIG_NO_HZ_FULL=n
@@ -14,6 +14,5 @@ CONFIG_HIBERNATION=n
 CONFIG_RCU_NOCB_CPU=n
 CONFIG_DEBUG_LOCK_ALLOC=n
 CONFIG_RCU_CPU_STALL_INFO=n
-CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/CFLIST b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/CFLIST
deleted file mode 100644
index 18223947bbcb..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/CFLIST
+++ /dev/null
@@ -1,14 +0,0 @@
-P1-S-T-NH-SD-SMP-HP
-P2-2-t-nh-sd-SMP-hp
-P3-3-T-nh-SD-SMP-hp
-P4-A-t-NH-sd-SMP-HP
-P5-U-T-NH-sd-SMP-hp
-N1-S-T-NH-SD-SMP-HP
-N2-2-t-nh-sd-SMP-hp
-N3-3-T-nh-SD-SMP-hp
-N4-A-t-NH-sd-SMP-HP
-N5-U-T-NH-sd-SMP-hp
-PT1-nh
-PT2-NH
-NT1-nh
-NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index d3ef873eb6e7..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,18 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 02e418572b1b..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b3100f69c8cf..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index c56b44530725..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,18 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index 90d924fea9e9..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT1-nh
deleted file mode 100644
index 023f312a931c..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT3-NH b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT3-NH
deleted file mode 100644
index 6fd0235dae73..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT3-NH
+++ /dev/null
@@ -1,20 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index f72402d7c13d..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,19 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 0f3b667d2a9f..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b035e141bf2a..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index 3ccf6a9447f5..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index a55c00877fe4..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,27 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT1-nh
deleted file mode 100644
index e3361c3894a1..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT2-NH b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT2-NH
deleted file mode 100644
index 64abfc3b4d94..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT2-NH
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/ver_functions.sh
deleted file mode 100644
index 5ace37a89780..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/ver_functions.sh
+++ /dev/null
@@ -1,33 +0,0 @@
-#!/bin/bash
-#
-# Kernel-version-dependent shell functions for the rest of the scripts.
-#
-# This program is free software; you can redistribute it and/or modify
-# it under the terms of the GNU General Public License as published by
-# the Free Software Foundation; either version 2 of the License, or
-# (at your option) any later version.
-#
-# This program is distributed in the hope that it will be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, you can access it online at
-# http://www.gnu.org/licenses/gpl-2.0.html.
-#
-# Copyright (C) IBM Corporation, 2013
-#
-# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
-
-# per_version_boot_params bootparam-string config-file seconds
-#
-# Adds per-version torture-module parameters to kernels supporting them.
-# Which old kernels do not.
-per_version_boot_params () {
-	echo	rcutorture.stat_interval=15 \
-		rcutorture.shutdown_secs=$3 \
-		rcutorture.rcutorture_runnable=1 \
-		rcutorture.test_no_idle_hz=1 \
-		rcutorture.verbose=1
-}
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/CFLIST b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/CFLIST
deleted file mode 100644
index da4cbc668f2a..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/CFLIST
+++ /dev/null
@@ -1,17 +0,0 @@
-sysidleY.2013.06.19a
-sysidleN.2013.06.19a
-P1-S-T-NH-SD-SMP-HP
-P2-2-t-nh-sd-SMP-hp
-P3-3-T-nh-SD-SMP-hp
-P4-A-t-NH-sd-SMP-HP
-P5-U-T-NH-sd-SMP-hp
-P6---t-nh-SD-smp-hp
-N1-S-T-NH-SD-SMP-HP
-N2-2-t-nh-sd-SMP-hp
-N3-3-T-nh-SD-SMP-hp
-N4-A-t-NH-sd-SMP-HP
-N5-U-T-NH-sd-SMP-hp
-PT1-nh
-PT2-NH
-NT1-nh
-NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index d81e11d280aa..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,19 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_FAST_NO_HZ=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 02e418572b1b..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b3100f69c8cf..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index c56b44530725..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,18 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index 90d924fea9e9..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N6---t-nh-SD-smp-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N6---t-nh-SD-smp-hp
deleted file mode 100644
index 0ccc36d72738..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N6---t-nh-SD-smp-hp
+++ /dev/null
@@ -1,19 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_NR_CPUS=1
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP
deleted file mode 100644
index 3f640cf84973..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,26 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=16
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_RCU_NOCB_CPU=y
-CONFIG_RCU_NOCB_CPU_NONE=y
-CONFIG_RCU_NOCB_CPU_ZERO=n
-CONFIG_RCU_NOCB_CPU_ALL=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP
deleted file mode 100644
index 285da2dd8ac3..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=14
-CONFIG_NR_CPUS=16
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT1-nh
deleted file mode 100644
index 023f312a931c..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT3-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT3-NH
deleted file mode 100644
index 6fd0235dae73..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT3-NH
+++ /dev/null
@@ -1,20 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index 9647c44cf4b7..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_RCU_FAST_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 0f3b667d2a9f..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b035e141bf2a..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index 3ccf6a9447f5..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index a55c00877fe4..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,27 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp
deleted file mode 100644
index f4c9175828bf..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp
+++ /dev/null
@@ -1,18 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=n
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP
deleted file mode 100644
index 77a8c5b75763..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,30 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=16
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_RCU_NOCB_CPU=y
-CONFIG_RCU_NOCB_CPU_NONE=n
-CONFIG_RCU_NOCB_CPU_ZERO=n
-CONFIG_RCU_NOCB_CPU_ALL=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_SLUB=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all
deleted file mode 100644
index 0eecebc6e95f..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all
+++ /dev/null
@@ -1,30 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=16
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_RCU_NOCB_CPU=y
-CONFIG_RCU_NOCB_CPU_NONE=y
-CONFIG_RCU_NOCB_CPU_ZERO=n
-CONFIG_RCU_NOCB_CPU_ALL=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_SLUB=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none
deleted file mode 100644
index 0eecebc6e95f..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none
+++ /dev/null
@@ -1,30 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=16
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_RCU_NOCB_CPU=y
-CONFIG_RCU_NOCB_CPU_NONE=y
-CONFIG_RCU_NOCB_CPU_ZERO=n
-CONFIG_RCU_NOCB_CPU_ALL=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_SLUB=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp
deleted file mode 100644
index 588bc70420cd..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp
+++ /dev/null
@@ -1,30 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=16
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_RCU_NOCB_CPU=y
-CONFIG_RCU_NOCB_CPU_NONE=n
-CONFIG_RCU_NOCB_CPU_ZERO=y
-CONFIG_RCU_NOCB_CPU_ALL=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_SLUB=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT1-nh
deleted file mode 100644
index e3361c3894a1..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT2-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT2-NH
deleted file mode 100644
index 64abfc3b4d94..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT2-NH
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/CFLIST b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/CFLIST
deleted file mode 100644
index 18223947bbcb..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/CFLIST
+++ /dev/null
@@ -1,14 +0,0 @@
-P1-S-T-NH-SD-SMP-HP
-P2-2-t-nh-sd-SMP-hp
-P3-3-T-nh-SD-SMP-hp
-P4-A-t-NH-sd-SMP-HP
-P5-U-T-NH-sd-SMP-hp
-N1-S-T-NH-SD-SMP-HP
-N2-2-t-nh-sd-SMP-hp
-N3-3-T-nh-SD-SMP-hp
-N4-A-t-NH-sd-SMP-HP
-N5-U-T-NH-sd-SMP-hp
-PT1-nh
-PT2-NH
-NT1-nh
-NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index d81e11d280aa..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,19 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_FAST_NO_HZ=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 02e418572b1b..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b3100f69c8cf..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index c56b44530725..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,18 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index 90d924fea9e9..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT1-nh
deleted file mode 100644
index 023f312a931c..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT3-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT3-NH
deleted file mode 100644
index 6fd0235dae73..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT3-NH
+++ /dev/null
@@ -1,20 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index 9647c44cf4b7..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_RCU_FAST_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 0f3b667d2a9f..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b035e141bf2a..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index 3ccf6a9447f5..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index a55c00877fe4..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,27 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT1-nh
deleted file mode 100644
index e3361c3894a1..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT2-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT2-NH
deleted file mode 100644
index 64abfc3b4d94..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT2-NH
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/ver_functions.sh
deleted file mode 100644
index bae55692ce6e..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/ver_functions.sh
+++ /dev/null
@@ -1,44 +0,0 @@
-#!/bin/bash
-#
-# Kernel-version-dependent shell functions for the rest of the scripts.
-#
-# This program is free software; you can redistribute it and/or modify
-# it under the terms of the GNU General Public License as published by
-# the Free Software Foundation; either version 2 of the License, or
-# (at your option) any later version.
-#
-# This program is distributed in the hope that it will be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, you can access it online at
-# http://www.gnu.org/licenses/gpl-2.0.html.
-#
-# Copyright (C) IBM Corporation, 2013
-#
-# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
-
-# rcutorture_param_onoff bootparam-string config-file
-#
-# Adds onoff rcutorture module parameters to kernels having it.
-rcutorture_param_onoff () {
-	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
-	then
-		echo CPU-hotplug kernel, adding rcutorture onoff. 1>&2
-		echo rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
-	fi
-}
-
-# per_version_boot_params bootparam-string config-file seconds
-#
-# Adds per-version torture-module parameters to kernels supporting them.
-per_version_boot_params () {
-	echo $1 `rcutorture_param_onoff "$1" "$2"` \
-		rcutorture.stat_interval=15 \
-		rcutorture.shutdown_secs=$3 \
-		rcutorture.rcutorture_runnable=1 \
-		rcutorture.test_no_idle_hz=1 \
-		rcutorture.verbose=1
-}
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/CFLIST b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/CFLIST
deleted file mode 100644
index 18223947bbcb..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/CFLIST
+++ /dev/null
@@ -1,14 +0,0 @@
-P1-S-T-NH-SD-SMP-HP
-P2-2-t-nh-sd-SMP-hp
-P3-3-T-nh-SD-SMP-hp
-P4-A-t-NH-sd-SMP-HP
-P5-U-T-NH-sd-SMP-hp
-N1-S-T-NH-SD-SMP-HP
-N2-2-t-nh-sd-SMP-hp
-N3-3-T-nh-SD-SMP-hp
-N4-A-t-NH-sd-SMP-HP
-N5-U-T-NH-sd-SMP-hp
-PT1-nh
-PT2-NH
-NT1-nh
-NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index d81e11d280aa..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,19 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_FAST_NO_HZ=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 02e418572b1b..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b3100f69c8cf..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index c56b44530725..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,18 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index 90d924fea9e9..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT1-nh
deleted file mode 100644
index 023f312a931c..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT3-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT3-NH
deleted file mode 100644
index 6fd0235dae73..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT3-NH
+++ /dev/null
@@ -1,20 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index 9647c44cf4b7..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_RCU_FAST_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 0f3b667d2a9f..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b035e141bf2a..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index 3ccf6a9447f5..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index a55c00877fe4..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,27 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT1-nh
deleted file mode 100644
index e3361c3894a1..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT2-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT2-NH
deleted file mode 100644
index 64abfc3b4d94..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT2-NH
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/ver_functions.sh
deleted file mode 100644
index 8977d8d31b19..000000000000
--- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/ver_functions.sh
+++ /dev/null
@@ -1,57 +0,0 @@
-#!/bin/bash
-#
-# Kernel-version-dependent shell functions for the rest of the scripts.
-#
-# This program is free software; you can redistribute it and/or modify
-# it under the terms of the GNU General Public License as published by
-# the Free Software Foundation; either version 2 of the License, or
-# (at your option) any later version.
-#
-# This program is distributed in the hope that it will be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, you can access it online at
-# http://www.gnu.org/licenses/gpl-2.0.html.
-#
-# Copyright (C) IBM Corporation, 2013
-#
-# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
-
-# rcutorture_param_n_barrier_cbs bootparam-string
-#
-# Adds n_barrier_cbs rcutorture module parameter to kernels having it.
-rcutorture_param_n_barrier_cbs () {
-	if echo $1 | grep -q "rcutorture\.n_barrier_cbs"
-	then
-		:
-	else
-		echo rcutorture.n_barrier_cbs=4
-	fi
-}
-
-# rcutorture_param_onoff bootparam-string config-file
-#
-# Adds onoff rcutorture module parameters to kernels having it.
-rcutorture_param_onoff () {
-	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
-	then
-		echo CPU-hotplug kernel, adding rcutorture onoff. 1>&2
-		echo rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
-	fi
-}
-
-# per_version_boot_params bootparam-string config-file seconds
-#
-# Adds per-version torture-module parameters to kernels supporting them.
-per_version_boot_params () {
-	echo $1 `rcutorture_param_onoff "$1" "$2"` \
-		`rcutorture_param_n_barrier_cbs "$1"` \
-		rcutorture.stat_interval=15 \
-		rcutorture.shutdown_secs=$3 \
-		rcutorture.rcutorture_runnable=1 \
-		rcutorture.test_no_idle_hz=1 \
-		rcutorture.verbose=1
-}
diff --git a/tools/testing/selftests/rcutorture/doc/TINY_RCU.txt b/tools/testing/selftests/rcutorture/doc/TINY_RCU.txt
index 28db67b54e55..9ef33a743b73 100644
--- a/tools/testing/selftests/rcutorture/doc/TINY_RCU.txt
+++ b/tools/testing/selftests/rcutorture/doc/TINY_RCU.txt
@@ -34,7 +34,7 @@ CONFIG_PREEMPT
 CONFIG_PREEMPT_RCU
 CONFIG_SMP
 CONFIG_TINY_RCU
-CONFIG_TREE_PREEMPT_RCU
+CONFIG_PREEMPT_RCU
 CONFIG_TREE_RCU
 
 	All forced by CONFIG_TINY_RCU.
diff --git a/tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt b/tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt
index 3e588db86a17..ec03c883db00 100644
--- a/tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt
+++ b/tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt
@@ -1,5 +1,5 @@
 This document gives a brief rationale for the TREE_RCU-related test
-cases, a group that includes TREE_PREEMPT_RCU.
+cases, a group that includes PREEMPT_RCU.
 
 
 Kconfig Parameters:
@@ -14,10 +14,9 @@ CONFIG_NO_HZ_FULL_SYSIDLE -- Do one.
 CONFIG_PREEMPT -- Do half.  (First three and #8.)
 CONFIG_PROVE_LOCKING -- Do all but two, covering CONFIG_PROVE_RCU and not.
 CONFIG_PROVE_RCU -- Do all but one under CONFIG_PROVE_LOCKING.
-CONFIG_RCU_BOOST -- one of TREE_PREEMPT_RCU.
-CONFIG_RCU_BOOST_PRIO -- set to 2 for _BOOST testing.
-CONFIG_RCU_CPU_STALL_INFO -- do one with and without _VERBOSE.
-CONFIG_RCU_CPU_STALL_VERBOSE -- do one with and without _INFO.
+CONFIG_RCU_BOOST -- one of PREEMPT_RCU.
+CONFIG_RCU_KTHREAD_PRIO -- set to 2 for _BOOST testing.
+CONFIG_RCU_CPU_STALL_INFO -- Do one.
 CONFIG_RCU_FANOUT -- Cover hierarchy as currently, but overlap with others.
 CONFIG_RCU_FANOUT_EXACT -- Do one.
 CONFIG_RCU_FANOUT_LEAF -- Do one non-default.
@@ -27,7 +26,7 @@ CONFIG_RCU_NOCB_CPU_ALL -- Do one.
 CONFIG_RCU_NOCB_CPU_NONE -- Do one.
 CONFIG_RCU_NOCB_CPU_ZERO -- Do one.
 CONFIG_RCU_TRACE -- Do half.
-CONFIG_SMP -- Need one !SMP for TREE_PREEMPT_RCU.
+CONFIG_SMP -- Need one !SMP for PREEMPT_RCU.
 RCU-bh: Do one with PREEMPT and one with !PREEMPT.
 RCU-sched: Do one with PREEMPT but not BOOST.
 
@@ -77,7 +76,7 @@ CONFIG_RCU_CPU_STALL_TIMEOUT
 
 CONFIG_RCU_STALL_COMMON
 
-	Implied by TREE_RCU and TREE_PREEMPT_RCU.
+	Implied by TREE_RCU and PREEMPT_RCU.
 
 CONFIG_RCU_TORTURE_TEST
 CONFIG_RCU_TORTURE_TEST_RUNNABLE
@@ -88,7 +87,7 @@ CONFIG_RCU_USER_QS
 
 	Redundant with CONFIG_NO_HZ_FULL.
 
-CONFIG_TREE_PREEMPT_RCU
+CONFIG_PREEMPT_RCU
 CONFIG_TREE_RCU
 
 	These are controlled by CONFIG_PREEMPT.
