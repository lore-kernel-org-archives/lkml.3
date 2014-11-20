Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbaKTH7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:59:49 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:52443 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaKTH7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:59:48 -0500
Date: Thu, 20 Nov 2014 08:59:42 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, cl@linux.com, bobby.prani@gmail.com,
        oleg@redhat.com, stefan.hengelein@fau.d, clark.williams@gmail.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.19
Message-ID: <20141120075942.GA4423@gmail.com>
References: <20141117191635.GA17648@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141117191635.GA17648@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> The changes in this series include:
> 
> 1.	Streamline RCU's use of per-CPU variables, shifting from "cpu"
> 	arguments to functions to "this_"-style per-CPU variable accessors.
> 	These were posted to LKML at https://lkml.org/lkml/2014/10/28/1130.
> 
> 2.	Documentation updates.  These were posted to LKML at
> 	https://lkml.org/lkml/2014/10/28/1145.
> 
> 3.	Miscellaneous fixes.  These were posted to LKML at
> 	https://lkml.org/lkml/2014/10/28/1161.
> 
> 4.	Signal-handling RCU updates.  These were posted to LKML at
> 	https://lkml.org/lkml/2014/10/28/1172.
> 
> 5.	Real-time updates.  These were posted to LKML at
> 	ttps://lkml.org/lkml/2014/10/28/1181.
> 
> 6.	Torture-test updates.  These were posted to LKML at
> 	https://lkml.org/lkml/2014/10/28/1204.
> 
> Note that a few commits posted to LKML have been deferred, in particular,
> there is some possibility that the DEC Alpha guys will make the compiler
> changes needed to allow pre-EV56 CPUs to safely access chars and shorts.
> 
> All of these have been exposed to -next testing.
> These changes are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next
> 
> for you to fetch changes up to 9ea6c5885681e3d9ce9844ba9dc57371a5cfc6d2:
> 
>   Merge branches 'torture.2014.11.03a', 'cpu.2014.11.03a', 'doc.2014.11.13a', 'fixes.2014.11.13a', 'signal.2014.10.29a' and 'rt.2014.10.29a' into HEAD (2014-11-13 10:39:04 -0800)
> 
> ----------------------------------------------------------------
> 
> Christoph Lameter (1):
>       rcu: Remove rcu_dynticks * parameters when they are always this_cpu_ptr(&rcu_dynticks)
> 
> Clark Williams (1):
>       rcu: Unify boost and kthread priorities
> 
> Oleg Nesterov (2):
>       signal: Document the RCU protection of ->sighand
>       rcu: More info about potential deadlocks with rcu_read_unlock()
> 
> Paul E. McKenney (22):
>       rcu: Remove CONFIG_RCU_CPU_STALL_VERBOSE
>       rcu: Move RCU_BOOST variable declarations, eliminating #ifdef
>       rcu: Avoid IPIing idle CPUs from synchronize_sched_expedited()
>       signal: Exit RCU read-side critical section on each pass through loop
>       rcu: Kick rcuo kthreads after their CPU goes offline
>       rcu: Fix for rcuo online-time-creation reorganization bug
>       rcu: Use DEFINE_PER_CPU_SHARED_ALIGNED for rcu_data
>       rcu: Remove "cpu" argument to rcu_check_callbacks()
>       rcu: Remove "cpu" argument to rcu_pending()
>       rcu: Remove "cpu" argument to rcu_preempt_check_callbacks()
>       rcu: Remove "cpu" argument to rcu_note_context_switch()
>       rcu: Remove "cpu" argument to rcu_needs_cpu()
>       rcu: Remove "cpu" argument to rcu_prepare_for_idle()
>       rcu: Remove "cpu" argument to rcu_cleanup_after_idle()
>       cpu: Avoid puts_pending overflow
>       torture: Run Linux-kernel binary out of results directory
>       rcutorture: Fix rcu_torture_cbflood() memory leak
>       documentation: Additional restriction for control dependencies
>       documentation: Add atomic_long_t to atomic_ops.txt
>       rcu: Optimize cond_resched_rcu_qs()
>       rcu: Fix FIXME in rcu_tasks_kthread()
>       Merge branches 'torture.2014.11.03a', 'cpu.2014.11.03a', 'doc.2014.11.13a', 'fixes.2014.11.13a', 'signal.2014.10.29a' and 'rt.2014.10.29a' into HEAD
> 
> Pranith Kumar (8):
>       rcu: Remove redundant TREE_PREEMPT_RCU config option
>       rcutorture: Add early boot self tests
>       rcutorture: Enable RCU self test in configs
>       rcutorture: Remove stale test configurations
>       rcutorture: Remove obsolete kversion param in kvm.sh
>       documentation: Document RCU self test boot params
>       documentation: memory-barriers.txt: Correct example for reorderings
>       rcu: Add sparse check for RCU_INIT_POINTER()
> 
> Stefan Hengelein (1):
>       init/Kconfig: move RCU_NOCB_CPU dependencies to choice
> 
>  Documentation/RCU/rcu.txt                          |   4 +-
>  Documentation/RCU/stallwarn.txt                    |  14 +--
>  Documentation/RCU/trace.txt                        |   4 +-
>  Documentation/RCU/whatisRCU.txt                    |   2 +-
>  Documentation/atomic_ops.txt                       |  12 ++-
>  Documentation/kernel-parameters.txt                |  16 +++
>  Documentation/memory-barriers.txt                  |  40 ++++++--
>  include/linux/init_task.h                          |   2 +-
>  include/linux/rcupdate.h                           |  19 ++--
>  include/linux/rcutiny.h                            |   2 +-
>  include/linux/rcutree.h                            |   6 +-
>  include/linux/sched.h                              |   4 +-
>  include/trace/events/rcu.h                         |   4 +-
>  init/Kconfig                                       |  49 ++++-----
>  kernel/cpu.c                                       |  19 ++--
>  kernel/fork.c                                      |   5 +-
>  kernel/rcu/Makefile                                |   2 +-
>  kernel/rcu/rcu.h                                   |   2 +
>  kernel/rcu/rcutorture.c                            |   1 +
>  kernel/rcu/tiny.c                                  |   6 +-
>  kernel/rcu/tree.c                                  |  97 ++++++++++--------
>  kernel/rcu/tree.h                                  |  22 ++--
>  kernel/rcu/tree_plugin.h                           | 111 +++++++++++----------
>  kernel/rcu/update.c                                |  89 ++++++++++++++++-
>  kernel/sched/core.c                                |   2 +-
>  kernel/signal.c                                    |  42 ++++----
>  kernel/softirq.c                                   |   2 +-
>  kernel/time/tick-sched.c                           |   2 +-
>  kernel/time/timer.c                                |   3 +-
>  lib/Kconfig.debug                                  |  14 +--
>  .../selftests/rcutorture/bin/kvm-test-1-run.sh     |   6 +-
>  tools/testing/selftests/rcutorture/bin/kvm.sh      |  19 +---
>  .../selftests/rcutorture/configs/rcu/TINY02        |   2 +
>  .../selftests/rcutorture/configs/rcu/TINY02.boot   |   2 +
>  .../selftests/rcutorture/configs/rcu/TREE01        |   3 +-
>  .../selftests/rcutorture/configs/rcu/TREE02        |   3 +-
>  .../selftests/rcutorture/configs/rcu/TREE02-T      |   3 +-
>  .../selftests/rcutorture/configs/rcu/TREE03        |   5 +-
>  .../selftests/rcutorture/configs/rcu/TREE04        |   1 -
>  .../selftests/rcutorture/configs/rcu/TREE05        |   1 -
>  .../selftests/rcutorture/configs/rcu/TREE05.boot   |   1 +
>  .../selftests/rcutorture/configs/rcu/TREE06        |   1 -
>  .../selftests/rcutorture/configs/rcu/TREE06.boot   |   3 +
>  .../selftests/rcutorture/configs/rcu/TREE07        |   1 -
>  .../selftests/rcutorture/configs/rcu/TREE08        |   5 +-
>  .../selftests/rcutorture/configs/rcu/TREE08-T      |   3 +-
>  .../selftests/rcutorture/configs/rcu/TREE08.boot   |   2 +
>  .../selftests/rcutorture/configs/rcu/TREE09        |   3 +-
>  .../selftests/rcutorture/configs/rcu/v0.0/CFLIST   |  14 ---
>  .../configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP           |  18 ----
>  .../configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp           |  20 ----
>  .../configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp           |  22 ----
>  .../configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP           |  18 ----
>  .../configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp           |  22 ----
>  .../selftests/rcutorture/configs/rcu/v0.0/NT1-nh   |  23 -----
>  .../selftests/rcutorture/configs/rcu/v0.0/NT3-NH   |  20 ----
>  .../configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP           |  19 ----
>  .../configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp           |  20 ----
>  .../configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp           |  20 ----
>  .../configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP           |  22 ----
>  .../configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp           |  27 -----
>  .../selftests/rcutorture/configs/rcu/v0.0/PT1-nh   |  23 -----
>  .../selftests/rcutorture/configs/rcu/v0.0/PT2-NH   |  22 ----
>  .../rcutorture/configs/rcu/v0.0/ver_functions.sh   |  33 ------
>  .../selftests/rcutorture/configs/rcu/v3.12/CFLIST  |  17 ----
>  .../configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP          |  19 ----
>  .../configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp          |  20 ----
>  .../configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp          |  22 ----
>  .../configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP          |  18 ----
>  .../configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp          |  22 ----
>  .../configs/rcu/v3.12/N6---t-nh-SD-smp-hp          |  19 ----
>  .../configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP          |  26 -----
>  .../configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP          |  22 ----
>  .../selftests/rcutorture/configs/rcu/v3.12/NT1-nh  |  23 -----
>  .../selftests/rcutorture/configs/rcu/v3.12/NT3-NH  |  20 ----
>  .../configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP          |  20 ----
>  .../configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp          |  20 ----
>  .../configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp          |  20 ----
>  .../configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP          |  22 ----
>  .../configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp          |  27 -----
>  .../configs/rcu/v3.12/P6---t-nh-SD-smp-hp          |  18 ----
>  .../configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP          |  30 ------
>  .../configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all      |  30 ------
>  .../configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none     |  30 ------
>  .../configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp          |  30 ------
>  .../selftests/rcutorture/configs/rcu/v3.12/PT1-nh  |  23 -----
>  .../selftests/rcutorture/configs/rcu/v3.12/PT2-NH  |  22 ----
>  .../selftests/rcutorture/configs/rcu/v3.3/CFLIST   |  14 ---
>  .../configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP           |  19 ----
>  .../configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp           |  20 ----
>  .../configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp           |  22 ----
>  .../configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP           |  18 ----
>  .../configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp           |  22 ----
>  .../selftests/rcutorture/configs/rcu/v3.3/NT1-nh   |  23 -----
>  .../selftests/rcutorture/configs/rcu/v3.3/NT3-NH   |  20 ----
>  .../configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP           |  20 ----
>  .../configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp           |  20 ----
>  .../configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp           |  20 ----
>  .../configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP           |  22 ----
>  .../configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp           |  27 -----
>  .../selftests/rcutorture/configs/rcu/v3.3/PT1-nh   |  23 -----
>  .../selftests/rcutorture/configs/rcu/v3.3/PT2-NH   |  22 ----
>  .../rcutorture/configs/rcu/v3.3/ver_functions.sh   |  44 --------
>  .../selftests/rcutorture/configs/rcu/v3.5/CFLIST   |  14 ---
>  .../configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP           |  19 ----
>  .../configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp           |  20 ----
>  .../configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp           |  22 ----
>  .../configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP           |  18 ----
>  .../configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp           |  22 ----
>  .../selftests/rcutorture/configs/rcu/v3.5/NT1-nh   |  23 -----
>  .../selftests/rcutorture/configs/rcu/v3.5/NT3-NH   |  20 ----
>  .../configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP           |  20 ----
>  .../configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp           |  20 ----
>  .../configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp           |  20 ----
>  .../configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP           |  22 ----
>  .../configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp           |  27 -----
>  .../selftests/rcutorture/configs/rcu/v3.5/PT1-nh   |  23 -----
>  .../selftests/rcutorture/configs/rcu/v3.5/PT2-NH   |  22 ----
>  .../rcutorture/configs/rcu/v3.5/ver_functions.sh   |  57 -----------
>  .../testing/selftests/rcutorture/doc/TINY_RCU.txt  |   2 +-
>  .../selftests/rcutorture/doc/TREE_RCU-kconfig.txt  |  15 ++-
>  121 files changed, 408 insertions(+), 1858 deletions(-)
>  create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TINY02.boot
>  create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TREE06.boot
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/CFLIST
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT1-nh
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT3-NH
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT1-nh
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT2-NH
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/ver_functions.sh
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/CFLIST
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N6---t-nh-SD-smp-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT1-nh
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT3-NH
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT1-nh
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT2-NH
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/CFLIST
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT1-nh
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT3-NH
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT1-nh
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT2-NH
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/ver_functions.sh
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/CFLIST
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT1-nh
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT3-NH
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT1-nh
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT2-NH
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/ver_functions.sh

Pulled into tip:core/rcu, thanks a lot Paul!

	Ingo
