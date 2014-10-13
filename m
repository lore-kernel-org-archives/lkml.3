Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbaJMHNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 03:13:34 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:47722 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbaJMHNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 03:13:21 -0400
Date: Mon, 13 Oct 2014 09:13:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler tree changes for v3.18
Message-ID: <20141013071315.GA13316@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-core-for-linus

   # HEAD: f10e00f4bf360c36edbe6bf18a6c75b171cbe012 sched/dl: Use dl_bw_of() under rcu_read_lock_sched()

The main changes in this cycle were:

 - Optimized support for Intel "Cluster-on-Die" (CoD) topologies
   (Dave Hansen)

 - Various sched/idle refinements for better idle handling
   (Nicolas Pitre, Daniel Lezcano, Chuansheng Liu, Vincent Guittot)

 - sched/numa updates and optimizations (Rik van Riel)

 - sysbench speedup (Vincent Guittot)

 - capacity calculation cleanups/refactoring (Vincent Guittot)

 - Various cleanups to thread group iteration (Oleg Nesterov)

 - Double-rq-lock removal optimization and various refactorings
   (Kirill Tkhai)

 - various sched/deadline fixes

... and lots of other changes.

 Thanks,

	Ingo

------------------>
Aaron Tomlin (3):
      init/main.c: Give init_task a canary
      sched: Add helper for task stack page overrun checking
      sched: Add default-disabled option to BUG() when stack end location is overwritten

Andreea-Cristina Bernat (1):
      sched/fair: Replace rcu_assign_pointer() with RCU_INIT_POINTER()

Chuansheng Liu (3):
      sched: Add new API wake_up_if_idle() to wake up the idle cpu
      smp: Add new wake_up_all_idle_cpus() function
      cpuidle: Use wake_up_all_idle_cpus() to wake up all idle cpus

Daniel Lezcano (1):
      sched: Let the scheduler see CPU idle states

Dave Hansen (2):
      x86, sched: Add new topology for multi-NUMA-node CPUs
      sched/x86: Fix up typo in topology detection

Jason Low (1):
      sched: Reduce contention in update_cfs_rq_blocked_load()

Juri Lelli (5):
      Documentation/scheduler/sched-deadline.txt: Rewrite section 4 intro
      Documentation/scheduler/sched-deadline.txt: Add tests suite appendix
      Documentation/scheduler/sched-deadline.txt: Add minimal main() appendix
      sched/deadline: Clear dl_entity params when setscheduling to different class
      sched/deadline: Fix inter- exclusive cpusets migrations

Kirill Tkhai (19):
      sched/fair: Fix reschedule which is generated on throttled cfs_rq
      sched: Add wrapper for checking task_struct::on_rq
      sched: Teach scheduler to understand TASK_ON_RQ_MIGRATING state
      sched: Remove double_rq_lock() from __migrate_task()
      sched/fair: Remove double_lock_balance() from active_load_balance_cpu_stop()
      sched/fair: Remove double_lock_balance() from load_balance()
      sched, cleanup, treewide: Remove set_current_state(TASK_RUNNING) after schedule()
      sched/fair: cleanup: Remove useless assignment in select_task_rq_fair()
      sched/core: Use put_prev_task() accessor where possible
      sched/rt: Remove useless if from cleanup pick_next_task_rt()
      sched/dl: Simplify pick_dl_task()
      sched: Do not stop cpu in set_cpus_allowed_ptr() if task is not running
      sched/fair: Remove duplicate code from can_migrate_task()
      sched: Use dl_bw_of() under RCU read lock
      sched: cleanup: Rename 'out_unlock' to 'out_free_new_mask'
      sched: Use rq->rd in sched_setaffinity() under RCU read lock
      sched/rt: Use resched_curr() in task_tick_rt()
      sched/fair: Delete resched_cpu() from idle_balance()
      sched/dl: Use dl_bw_of() under rcu_read_lock_sched()

Lai Jiangshan (1):
      sched: Migrate waking tasks

Luca Abeni (2):
      Documentation/scheduler/sched-deadline.txt: Fix terminology and improve clarity
      Documentation/scheduler/sched-deadline.txt: Improve and clarify AC bits

Nicolas Pitre (1):
      sched/fair: Leverage the idle state info when choosing the "idlest" cpu

Oleg Nesterov (8):
      sched: s/do_each_thread/for_each_process_thread/ in core.c
      sched: s/do_each_thread/for_each_process_thread/ in debug.c
      sched: Change thread_group_cputime() to use for_each_thread()
      sched: Change autogroup_move_group() to use for_each_thread()
      sched/numa: Kill the wrong/dead TASK_DEAD check in task_numa_fault()
      sched: Fix the task-group check in tg_has_rt_tasks()
      sched: normalize_rt_tasks(): Don't use _irqsave for tasklist_lock, use task_rq_lock()
      sched: print_rq(): Don't use tasklist_lock

Peter Zijlstra (3):
      sched/fair: Make calculate_imbalance() independent
      sched/fair: Allow calculate_imbalance() to move idle cpus
      sched, mips, ia64: Remove __ARCH_WANT_UNLOCKED_CTXSW

Pranith Kumar (1):
      sched: Match declaration with definition

Rik van Riel (10):
      sched/fair: Make update_sd_pick_busiest() return 'true' on a busier sd
      sched/numa: Fix off-by-one in capacity check
      sched/numa: Fix numa capacity computation
      exit: Always reap resource stats in __exit_signal()
      time, signal: Protect resource use statistics with seqlock
      sched, time: Atomically increment stime & utime
      sched/numa: Use select_idle_sibling() to select a destination for task_numa_move()
      seqlock: Add irqsave variant of read_seqbegin_or_lock()
      sched, time: Fix lock inversion in thread_group_cputime()
      sched, time: Fix build error with 64 bit cputime_t on 32 bit systems

Scot Doyle (1):
      sched/wait: Document timeout corner case

Vincent Guittot (7):
      sched: Fix imbalance flag reset
      sched: Remove a wake_affine() condition
      sched: Fix avg_load computation
      sched: Allow all architectures to set 'capacity_orig'
      ARM: topology: Use the new cpu_capacity interface
      sched: Test the CPU's capacity in wake_affine()
      sched: Improve sysbench performance by fixing spurious active migration

Zhihui Zhang (2):
      sched: Rename a misleading variable in build_overlap_sched_groups()
      sched: Clean up some typos and grammatical errors in code/comments

xiaofeng.yan (1):
      sched/deadline: Fix a precision problem in the microseconds range


 Documentation/scheduler/sched-deadline.txt         | 340 ++++++++++++---
 arch/arm/kernel/topology.c                         |   4 +-
 arch/cris/arch-v10/drivers/sync_serial.c           |   1 -
 arch/cris/arch-v32/drivers/sync_serial.c           |   1 -
 arch/ia64/include/asm/processor.h                  |   1 -
 arch/mips/include/asm/processor.h                  |   6 -
 arch/powerpc/include/asm/cputime.h                 |   2 +
 arch/powerpc/mm/fault.c                            |   5 +-
 arch/s390/include/asm/cputime.h                    |   2 +
 arch/um/drivers/random.c                           |   1 -
 arch/x86/kernel/smpboot.c                          |  55 ++-
 arch/x86/mm/fault.c                                |   5 +-
 drivers/cpuidle/cpuidle.c                          |  15 +-
 drivers/gpu/vga/vgaarb.c                           |   1 -
 drivers/md/dm-bufio.c                              |   1 -
 drivers/parisc/power.c                             |   1 -
 drivers/s390/net/claw.c                            |   2 -
 drivers/scsi/fcoe/fcoe.c                           |   1 -
 drivers/scsi/qla2xxx/qla_os.c                      |   1 -
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |   3 -
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c |   1 -
 drivers/staging/lustre/lustre/libcfs/fail.c        |   1 -
 drivers/tty/bfin_jtag_comm.c                       |   1 -
 fs/afs/vlocation.c                                 |   1 -
 fs/jfs/jfs_logmgr.c                                |   2 -
 fs/jfs/jfs_txnmgr.c                                |   3 -
 fs/nfs/blocklayout/blocklayoutdev.c                |   1 -
 fs/nfs/blocklayout/blocklayoutdm.c                 |   1 -
 fs/nfsd/nfs4recover.c                              |   1 -
 include/asm-generic/cputime_jiffies.h              |   2 +
 include/asm-generic/cputime_nsecs.h                |   2 +
 include/linux/sched.h                              |   6 +
 include/linux/seqlock.h                            |  19 +
 include/linux/smp.h                                |   2 +
 include/linux/wait.h                               |  16 +-
 init/main.c                                        |   1 +
 kernel/exit.c                                      |  47 +-
 kernel/fork.c                                      |  13 +-
 kernel/sched/auto_group.c                          |   5 +-
 kernel/sched/core.c                                | 295 ++++++++-----
 kernel/sched/cpudeadline.c                         |   4 +-
 kernel/sched/cputime.c                             |  64 +--
 kernel/sched/deadline.c                            |  33 +-
 kernel/sched/debug.c                               |  13 +-
 kernel/sched/fair.c                                | 479 +++++++++++++--------
 kernel/sched/idle.c                                |   6 +
 kernel/sched/rt.c                                  |  21 +-
 kernel/sched/sched.h                               |  80 ++--
 kernel/sched/stop_task.c                           |   2 +-
 kernel/smp.c                                       |  22 +
 kernel/sys.c                                       |   2 -
 kernel/time/hrtimer.c                              |   1 -
 kernel/time/posix-cpu-timers.c                     |  14 -
 kernel/trace/ring_buffer_benchmark.c               |   3 -
 kernel/trace/trace_stack.c                         |   4 +-
 lib/Kconfig.debug                                  |  12 +
 56 files changed, 1075 insertions(+), 553 deletions(-)

diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentation/scheduler/sched-deadline.txt
index 18adc92a6b3b..21461a0441c1 100644
--- a/Documentation/scheduler/sched-deadline.txt
+++ b/Documentation/scheduler/sched-deadline.txt
@@ -15,6 +15,8 @@ CONTENTS
  5. Tasks CPU affinity
    5.1 SCHED_DEADLINE and cpusets HOWTO
  6. Future plans
+ A. Test suite
+ B. Minimal main()
 
 
 0. WARNING
@@ -38,24 +40,25 @@ CONTENTS
 ==================
 
  SCHED_DEADLINE uses three parameters, named "runtime", "period", and
- "deadline" to schedule tasks. A SCHED_DEADLINE task is guaranteed to receive
+ "deadline", to schedule tasks. A SCHED_DEADLINE task should receive
  "runtime" microseconds of execution time every "period" microseconds, and
  these "runtime" microseconds are available within "deadline" microseconds
  from the beginning of the period.  In order to implement this behaviour,
  every time the task wakes up, the scheduler computes a "scheduling deadline"
  consistent with the guarantee (using the CBS[2,3] algorithm). Tasks are then
  scheduled using EDF[1] on these scheduling deadlines (the task with the
- smallest scheduling deadline is selected for execution). Notice that this
- guaranteed is respected if a proper "admission control" strategy (see Section
- "4. Bandwidth management") is used.
+ earliest scheduling deadline is selected for execution). Notice that the
+ task actually receives "runtime" time units within "deadline" if a proper
+ "admission control" strategy (see Section "4. Bandwidth management") is used
+ (clearly, if the system is overloaded this guarantee cannot be respected).
 
  Summing up, the CBS[2,3] algorithms assigns scheduling deadlines to tasks so
  that each task runs for at most its runtime every period, avoiding any
  interference between different tasks (bandwidth isolation), while the EDF[1]
- algorithm selects the task with the smallest scheduling deadline as the one
- to be executed first.  Thanks to this feature, also tasks that do not
- strictly comply with the "traditional" real-time task model (see Section 3)
- can effectively use the new policy.
+ algorithm selects the task with the earliest scheduling deadline as the one
+ to be executed next. Thanks to this feature, tasks that do not strictly comply
+ with the "traditional" real-time task model (see Section 3) can effectively
+ use the new policy.
 
  In more details, the CBS algorithm assigns scheduling deadlines to
  tasks in the following way:
@@ -64,45 +67,45 @@ CONTENTS
     "deadline", and "period" parameters;
 
   - The state of the task is described by a "scheduling deadline", and
-    a "current runtime". These two parameters are initially set to 0;
+    a "remaining runtime". These two parameters are initially set to 0;
 
   - When a SCHED_DEADLINE task wakes up (becomes ready for execution),
     the scheduler checks if
 
-                    current runtime                runtime
-         ---------------------------------- > ----------------
-         scheduling deadline - current time         period
+                 remaining runtime                  runtime
+        ----------------------------------    >    ---------
+        scheduling deadline - current time           period
 
     then, if the scheduling deadline is smaller than the current time, or
     this condition is verified, the scheduling deadline and the
-    current budget are re-initialised as
+    remaining runtime are re-initialised as
 
          scheduling deadline = current time + deadline
-         current runtime = runtime
+         remaining runtime = runtime
 
-    otherwise, the scheduling deadline and the current runtime are
+    otherwise, the scheduling deadline and the remaining runtime are
     left unchanged;
 
   - When a SCHED_DEADLINE task executes for an amount of time t, its
-    current runtime is decreased as
+    remaining runtime is decreased as
 
-         current runtime = current runtime - t
+         remaining runtime = remaining runtime - t
 
     (technically, the runtime is decreased at every tick, or when the
     task is descheduled / preempted);
 
-  - When the current runtime becomes less or equal than 0, the task is
+  - When the remaining runtime becomes less or equal than 0, the task is
     said to be "throttled" (also known as "depleted" in real-time literature)
     and cannot be scheduled until its scheduling deadline. The "replenishment
     time" for this task (see next item) is set to be equal to the current
     value of the scheduling deadline;
 
   - When the current time is equal to the replenishment time of a
-    throttled task, the scheduling deadline and the current runtime are
+    throttled task, the scheduling deadline and the remaining runtime are
     updated as
 
          scheduling deadline = scheduling deadline + period
-         current runtime = current runtime + runtime
+         remaining runtime = remaining runtime + runtime
 
 
 3. Scheduling Real-Time Tasks
@@ -134,6 +137,50 @@ CONTENTS
  A real-time task can be periodic with period P if r_{j+1} = r_j + P, or
  sporadic with minimum inter-arrival time P is r_{j+1} >= r_j + P. Finally,
  d_j = r_j + D, where D is the task's relative deadline.
+ The utilisation of a real-time task is defined as the ratio between its
+ WCET and its period (or minimum inter-arrival time), and represents
+ the fraction of CPU time needed to execute the task.
+
+ If the total utilisation sum_i(WCET_i/P_i) is larger than M (with M equal
+ to the number of CPUs), then the scheduler is unable to respect all the
+ deadlines.
+ Note that total utilisation is defined as the sum of the utilisations
+ WCET_i/P_i over all the real-time tasks in the system. When considering
+ multiple real-time tasks, the parameters of the i-th task are indicated
+ with the "_i" suffix.
+ Moreover, if the total utilisation is larger than M, then we risk starving
+ non- real-time tasks by real-time tasks.
+ If, instead, the total utilisation is smaller than M, then non real-time
+ tasks will not be starved and the system might be able to respect all the
+ deadlines.
+ As a matter of fact, in this case it is possible to provide an upper bound
+ for tardiness (defined as the maximum between 0 and the difference
+ between the finishing time of a job and its absolute deadline).
+ More precisely, it can be proven that using a global EDF scheduler the
+ maximum tardiness of each task is smaller or equal than
+	((M − 1) · WCET_max − WCET_min)/(M − (M − 2) · U_max) + WCET_max
+ where WCET_max = max_i{WCET_i} is the maximum WCET, WCET_min=min_i{WCET_i}
+ is the minimum WCET, and U_max = max_i{WCET_i/P_i} is the maximum utilisation.
+
+ If M=1 (uniprocessor system), or in case of partitioned scheduling (each
+ real-time task is statically assigned to one and only one CPU), it is
+ possible to formally check if all the deadlines are respected.
+ If D_i = P_i for all tasks, then EDF is able to respect all the deadlines
+ of all the tasks executing on a CPU if and only if the total utilisation
+ of the tasks running on such a CPU is smaller or equal than 1.
+ If D_i != P_i for some task, then it is possible to define the density of
+ a task as C_i/min{D_i,T_i}, and EDF is able to respect all the deadlines
+ of all the tasks running on a CPU if the sum sum_i C_i/min{D_i,T_i} of the
+ densities of the tasks running on such a CPU is smaller or equal than 1
+ (notice that this condition is only sufficient, and not necessary).
+
+ On multiprocessor systems with global EDF scheduling (non partitioned
+ systems), a sufficient test for schedulability can not be based on the
+ utilisations (it can be shown that task sets with utilisations slightly
+ larger than 1 can miss deadlines regardless of the number of CPUs M).
+ However, as previously stated, enforcing that the total utilisation is smaller
+ than M is enough to guarantee that non real-time tasks are not starved and
+ that the tardiness of real-time tasks has an upper bound.
 
  SCHED_DEADLINE can be used to schedule real-time tasks guaranteeing that
  the jobs' deadlines of a task are respected. In order to do this, a task
@@ -147,6 +194,8 @@ CONTENTS
  and the absolute deadlines (d_j) coincide, so a proper admission control
  allows to respect the jobs' absolute deadlines for this task (this is what is
  called "hard schedulability property" and is an extension of Lemma 1 of [2]).
+ Notice that if runtime > deadline the admission control will surely reject
+ this task, as it is not possible to respect its temporal constraints.
 
  References:
   1 - C. L. Liu and J. W. Layland. Scheduling algorithms for multiprogram-
@@ -156,46 +205,57 @@ CONTENTS
       Real-Time Systems. Proceedings of the 19th IEEE Real-time Systems
       Symposium, 1998. http://retis.sssup.it/~giorgio/paps/1998/rtss98-cbs.pdf
   3 - L. Abeni. Server Mechanisms for Multimedia Applications. ReTiS Lab
-      Technical Report. http://xoomer.virgilio.it/lucabe72/pubs/tr-98-01.ps
+      Technical Report. http://disi.unitn.it/~abeni/tr-98-01.pdf
 
 4. Bandwidth management
 =======================
 
- In order for the -deadline scheduling to be effective and useful, it is
- important to have some method to keep the allocation of the available CPU
- bandwidth to the tasks under control.
- This is usually called "admission control" and if it is not performed at all,
+ As previously mentioned, in order for -deadline scheduling to be
+ effective and useful (that is, to be able to provide "runtime" time units
+ within "deadline"), it is important to have some method to keep the allocation
+ of the available fractions of CPU time to the various tasks under control.
+ This is usually called "admission control" and if it is not performed, then
  no guarantee can be given on the actual scheduling of the -deadline tasks.
 
- Since when RT-throttling has been introduced each task group has a bandwidth
- associated, calculated as a certain amount of runtime over a period.
- Moreover, to make it possible to manipulate such bandwidth, readable/writable
- controls have been added to both procfs (for system wide settings) and cgroupfs
- (for per-group settings).
- Therefore, the same interface is being used for controlling the bandwidth
- distrubution to -deadline tasks.
-
- However, more discussion is needed in order to figure out how we want to manage
- SCHED_DEADLINE bandwidth at the task group level. Therefore, SCHED_DEADLINE
- uses (for now) a less sophisticated, but actually very sensible, mechanism to
- ensure that a certain utilization cap is not overcome per each root_domain.
-
- Another main difference between deadline bandwidth management and RT-throttling
+ As already stated in Section 3, a necessary condition to be respected to
+ correctly schedule a set of real-time tasks is that the total utilisation
+ is smaller than M. When talking about -deadline tasks, this requires that
+ the sum of the ratio between runtime and period for all tasks is smaller
+ than M. Notice that the ratio runtime/period is equivalent to the utilisation
+ of a "traditional" real-time task, and is also often referred to as
+ "bandwidth".
+ The interface used to control the CPU bandwidth that can be allocated
+ to -deadline tasks is similar to the one already used for -rt
+ tasks with real-time group scheduling (a.k.a. RT-throttling - see
+ Documentation/scheduler/sched-rt-group.txt), and is based on readable/
+ writable control files located in procfs (for system wide settings).
+ Notice that per-group settings (controlled through cgroupfs) are still not
+ defined for -deadline tasks, because more discussion is needed in order to
+ figure out how we want to manage SCHED_DEADLINE bandwidth at the task group
+ level.
+
+ A main difference between deadline bandwidth management and RT-throttling
  is that -deadline tasks have bandwidth on their own (while -rt ones don't!),
- and thus we don't need an higher level throttling mechanism to enforce the
- desired bandwidth.
+ and thus we don't need a higher level throttling mechanism to enforce the
+ desired bandwidth. In other words, this means that interface parameters are
+ only used at admission control time (i.e., when the user calls
+ sched_setattr()). Scheduling is then performed considering actual tasks'
+ parameters, so that CPU bandwidth is allocated to SCHED_DEADLINE tasks
+ respecting their needs in terms of granularity. Therefore, using this simple
+ interface we can put a cap on total utilization of -deadline tasks (i.e.,
+ \Sum (runtime_i / period_i) < global_dl_utilization_cap).
 
 4.1 System wide settings
 ------------------------
 
  The system wide settings are configured under the /proc virtual file system.
 
- For now the -rt knobs are used for dl admission control and the -deadline
- runtime is accounted against the -rt runtime. We realise that this isn't
- entirely desirable; however, it is better to have a small interface for now,
- and be able to change it easily later. The ideal situation (see 5.) is to run
- -rt tasks from a -deadline server; in which case the -rt bandwidth is a direct
- subset of dl_bw.
+ For now the -rt knobs are used for -deadline admission control and the
+ -deadline runtime is accounted against the -rt runtime. We realise that this
+ isn't entirely desirable; however, it is better to have a small interface for
+ now, and be able to change it easily later. The ideal situation (see 5.) is to
+ run -rt tasks from a -deadline server; in which case the -rt bandwidth is a
+ direct subset of dl_bw.
 
  This means that, for a root_domain comprising M CPUs, -deadline tasks
  can be created while the sum of their bandwidths stays below:
@@ -231,8 +291,16 @@ CONTENTS
  950000. With rt_period equal to 1000000, by default, it means that -deadline
  tasks can use at most 95%, multiplied by the number of CPUs that compose the
  root_domain, for each root_domain.
+ This means that non -deadline tasks will receive at least 5% of the CPU time,
+ and that -deadline tasks will receive their runtime with a guaranteed
+ worst-case delay respect to the "deadline" parameter. If "deadline" = "period"
+ and the cpuset mechanism is used to implement partitioned scheduling (see
+ Section 5), then this simple setting of the bandwidth management is able to
+ deterministically guarantee that -deadline tasks will receive their runtime
+ in a period.
 
- A -deadline task cannot fork.
+ Finally, notice that in order not to jeopardize the admission control a
+ -deadline task cannot fork.
 
 5. Tasks CPU affinity
 =====================
@@ -279,3 +347,179 @@ CONTENTS
  throttling patches [https://lkml.org/lkml/2010/2/23/239] but we still are in
  the preliminary phases of the merge and we really seek feedback that would
  help us decide on the direction it should take.
+
+Appendix A. Test suite
+======================
+
+ The SCHED_DEADLINE policy can be easily tested using two applications that
+ are part of a wider Linux Scheduler validation suite. The suite is
+ available as a GitHub repository: https://github.com/scheduler-tools.
+
+ The first testing application is called rt-app and can be used to
+ start multiple threads with specific parameters. rt-app supports
+ SCHED_{OTHER,FIFO,RR,DEADLINE} scheduling policies and their related
+ parameters (e.g., niceness, priority, runtime/deadline/period). rt-app
+ is a valuable tool, as it can be used to synthetically recreate certain
+ workloads (maybe mimicking real use-cases) and evaluate how the scheduler
+ behaves under such workloads. In this way, results are easily reproducible.
+ rt-app is available at: https://github.com/scheduler-tools/rt-app.
+
+ Thread parameters can be specified from the command line, with something like
+ this:
+
+  # rt-app -t 100000:10000:d -t 150000:20000:f:10 -D5
+
+ The above creates 2 threads. The first one, scheduled by SCHED_DEADLINE,
+ executes for 10ms every 100ms. The second one, scheduled at SCHED_FIFO
+ priority 10, executes for 20ms every 150ms. The test will run for a total
+ of 5 seconds.
+
+ More interestingly, configurations can be described with a json file that
+ can be passed as input to rt-app with something like this:
+
+  # rt-app my_config.json
+
+ The parameters that can be specified with the second method are a superset
+ of the command line options. Please refer to rt-app documentation for more
+ details (<rt-app-sources>/doc/*.json).
+
+ The second testing application is a modification of schedtool, called
+ schedtool-dl, which can be used to setup SCHED_DEADLINE parameters for a
+ certain pid/application. schedtool-dl is available at:
+ https://github.com/scheduler-tools/schedtool-dl.git.
+
+ The usage is straightforward:
+
+  # schedtool -E -t 10000000:100000000 -e ./my_cpuhog_app
+
+ With this, my_cpuhog_app is put to run inside a SCHED_DEADLINE reservation
+ of 10ms every 100ms (note that parameters are expressed in microseconds).
+ You can also use schedtool to create a reservation for an already running
+ application, given that you know its pid:
+
+  # schedtool -E -t 10000000:100000000 my_app_pid
+
+Appendix B. Minimal main()
+==========================
+
+ We provide in what follows a simple (ugly) self-contained code snippet
+ showing how SCHED_DEADLINE reservations can be created by a real-time
+ application developer.
+
+ #define _GNU_SOURCE
+ #include <unistd.h>
+ #include <stdio.h>
+ #include <stdlib.h>
+ #include <string.h>
+ #include <time.h>
+ #include <linux/unistd.h>
+ #include <linux/kernel.h>
+ #include <linux/types.h>
+ #include <sys/syscall.h>
+ #include <pthread.h>
+
+ #define gettid() syscall(__NR_gettid)
+
+ #define SCHED_DEADLINE	6
+
+ /* XXX use the proper syscall numbers */
+ #ifdef __x86_64__
+ #define __NR_sched_setattr		314
+ #define __NR_sched_getattr		315
+ #endif
+
+ #ifdef __i386__
+ #define __NR_sched_setattr		351
+ #define __NR_sched_getattr		352
+ #endif
+
+ #ifdef __arm__
+ #define __NR_sched_setattr		380
+ #define __NR_sched_getattr		381
+ #endif
+
+ static volatile int done;
+
+ struct sched_attr {
+	__u32 size;
+
+	__u32 sched_policy;
+	__u64 sched_flags;
+
+	/* SCHED_NORMAL, SCHED_BATCH */
+	__s32 sched_nice;
+
+	/* SCHED_FIFO, SCHED_RR */
+	__u32 sched_priority;
+
+	/* SCHED_DEADLINE (nsec) */
+	__u64 sched_runtime;
+	__u64 sched_deadline;
+	__u64 sched_period;
+ };
+
+ int sched_setattr(pid_t pid,
+		  const struct sched_attr *attr,
+		  unsigned int flags)
+ {
+	return syscall(__NR_sched_setattr, pid, attr, flags);
+ }
+
+ int sched_getattr(pid_t pid,
+		  struct sched_attr *attr,
+		  unsigned int size,
+		  unsigned int flags)
+ {
+	return syscall(__NR_sched_getattr, pid, attr, size, flags);
+ }
+
+ void *run_deadline(void *data)
+ {
+	struct sched_attr attr;
+	int x = 0;
+	int ret;
+	unsigned int flags = 0;
+
+	printf("deadline thread started [%ld]\n", gettid());
+
+	attr.size = sizeof(attr);
+	attr.sched_flags = 0;
+	attr.sched_nice = 0;
+	attr.sched_priority = 0;
+
+	/* This creates a 10ms/30ms reservation */
+	attr.sched_policy = SCHED_DEADLINE;
+	attr.sched_runtime = 10 * 1000 * 1000;
+	attr.sched_period = attr.sched_deadline = 30 * 1000 * 1000;
+
+	ret = sched_setattr(0, &attr, flags);
+	if (ret < 0) {
+		done = 0;
+		perror("sched_setattr");
+		exit(-1);
+	}
+
+	while (!done) {
+		x++;
+	}
+
+	printf("deadline thread dies [%ld]\n", gettid());
+	return NULL;
+ }
+
+ int main (int argc, char **argv)
+ {
+	pthread_t thread;
+
+	printf("main thread [%ld]\n", gettid());
+
+	pthread_create(&thread, NULL, run_deadline, NULL);
+
+	sleep(10);
+
+	done = 1;
+	pthread_join(thread, NULL);
+
+	printf("main dies [%ld]\n", gettid());
+	return 0;
+ }
diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index e35d880f9773..89cfdd6e50cb 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -42,7 +42,7 @@
  */
 static DEFINE_PER_CPU(unsigned long, cpu_scale);
 
-unsigned long arch_scale_freq_capacity(struct sched_domain *sd, int cpu)
+unsigned long arch_scale_cpu_capacity(struct sched_domain *sd, int cpu)
 {
 	return per_cpu(cpu_scale, cpu);
 }
@@ -166,7 +166,7 @@ static void update_cpu_capacity(unsigned int cpu)
 	set_capacity_scale(cpu, cpu_capacity(cpu) / middle_capacity);
 
 	printk(KERN_INFO "CPU%u: update cpu_capacity %lu\n",
-		cpu, arch_scale_freq_capacity(NULL, cpu));
+		cpu, arch_scale_cpu_capacity(NULL, cpu));
 }
 
 #else
diff --git a/arch/cris/arch-v10/drivers/sync_serial.c b/arch/cris/arch-v10/drivers/sync_serial.c
index 29eb02ab3f25..0f3983241e60 100644
--- a/arch/cris/arch-v10/drivers/sync_serial.c
+++ b/arch/cris/arch-v10/drivers/sync_serial.c
@@ -1086,7 +1086,6 @@ static ssize_t sync_serial_write(struct file *file, const char *buf,
 	}
 	local_irq_restore(flags);
 	schedule();
-	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&port->out_wait_q, &wait);
 	if (signal_pending(current))
 		return -EINTR;
diff --git a/arch/cris/arch-v32/drivers/sync_serial.c b/arch/cris/arch-v32/drivers/sync_serial.c
index bbb806b68838..5a149134cfb5 100644
--- a/arch/cris/arch-v32/drivers/sync_serial.c
+++ b/arch/cris/arch-v32/drivers/sync_serial.c
@@ -1089,7 +1089,6 @@ static ssize_t sync_serial_write(struct file *file, const char *buf,
 	}
 
 	schedule();
-	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&port->out_wait_q, &wait);
 
 	if (signal_pending(current))
diff --git a/arch/ia64/include/asm/processor.h b/arch/ia64/include/asm/processor.h
index c7367130ab14..ce53c50d0ba4 100644
--- a/arch/ia64/include/asm/processor.h
+++ b/arch/ia64/include/asm/processor.h
@@ -19,7 +19,6 @@
 #include <asm/ptrace.h>
 #include <asm/ustack.h>
 
-#define __ARCH_WANT_UNLOCKED_CTXSW
 #define ARCH_HAS_PREFETCH_SWITCH_STACK
 
 #define IA64_NUM_PHYS_STACK_REG	96
diff --git a/arch/mips/include/asm/processor.h b/arch/mips/include/asm/processor.h
index 05f08438a7c4..f1df4cb4a286 100644
--- a/arch/mips/include/asm/processor.h
+++ b/arch/mips/include/asm/processor.h
@@ -397,12 +397,6 @@ unsigned long get_wchan(struct task_struct *p);
 #define ARCH_HAS_PREFETCHW
 #define prefetchw(x) __builtin_prefetch((x), 1, 1)
 
-/*
- * See Documentation/scheduler/sched-arch.txt; prevents deadlock on SMP
- * systems.
- */
-#define __ARCH_WANT_UNLOCKED_CTXSW
-
 #endif
 
 #endif /* _ASM_PROCESSOR_H */
diff --git a/arch/powerpc/include/asm/cputime.h b/arch/powerpc/include/asm/cputime.h
index 607559ab271f..6c840ceab820 100644
--- a/arch/powerpc/include/asm/cputime.h
+++ b/arch/powerpc/include/asm/cputime.h
@@ -32,6 +32,8 @@ static inline void setup_cputime_one_jiffy(void) { }
 typedef u64 __nocast cputime_t;
 typedef u64 __nocast cputime64_t;
 
+#define cmpxchg_cputime(ptr, old, new) cmpxchg(ptr, old, new)
+
 #ifdef __KERNEL__
 
 /*
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 51ab9e7e6c39..99b2f2775658 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -30,7 +30,6 @@
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
 #include <linux/perf_event.h>
-#include <linux/magic.h>
 #include <linux/ratelimit.h>
 #include <linux/context_tracking.h>
 
@@ -508,7 +507,6 @@ int __kprobes do_page_fault(struct pt_regs *regs, unsigned long address,
 void bad_page_fault(struct pt_regs *regs, unsigned long address, int sig)
 {
 	const struct exception_table_entry *entry;
-	unsigned long *stackend;
 
 	/* Are we prepared to handle this fault?  */
 	if ((entry = search_exception_tables(regs->nip)) != NULL) {
@@ -537,8 +535,7 @@ void bad_page_fault(struct pt_regs *regs, unsigned long address, int sig)
 	printk(KERN_ALERT "Faulting instruction address: 0x%08lx\n",
 		regs->nip);
 
-	stackend = end_of_stack(current);
-	if (current != &init_task && *stackend != STACK_END_MAGIC)
+	if (task_stack_end_corrupted(current))
 		printk(KERN_ALERT "Thread overran stack, or stack corrupted\n");
 
 	die("Kernel access of bad area", regs, sig);
diff --git a/arch/s390/include/asm/cputime.h b/arch/s390/include/asm/cputime.h
index f65bd3634519..3001887f94b7 100644
--- a/arch/s390/include/asm/cputime.h
+++ b/arch/s390/include/asm/cputime.h
@@ -18,6 +18,8 @@
 typedef unsigned long long __nocast cputime_t;
 typedef unsigned long long __nocast cputime64_t;
 
+#define cmpxchg_cputime(ptr, old, new) cmpxchg64(ptr, old, new)
+
 static inline unsigned long __div(unsigned long long n, unsigned long base)
 {
 #ifndef CONFIG_64BIT
diff --git a/arch/um/drivers/random.c b/arch/um/drivers/random.c
index 9e3a72205827..dd16c902ff70 100644
--- a/arch/um/drivers/random.c
+++ b/arch/um/drivers/random.c
@@ -79,7 +79,6 @@ static ssize_t rng_dev_read (struct file *filp, char __user *buf, size_t size,
 			set_task_state(current, TASK_INTERRUPTIBLE);
 
 			schedule();
-			set_task_state(current, TASK_RUNNING);
 			remove_wait_queue(&host_read_wait, &wait);
 
 			if (atomic_dec_and_test(&host_sleep_count)) {
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 2d872e08fab9..bae9e09291ec 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -296,11 +296,19 @@ void smp_store_cpu_info(int id)
 }
 
 static bool
+topology_same_node(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
+{
+	int cpu1 = c->cpu_index, cpu2 = o->cpu_index;
+
+	return (cpu_to_node(cpu1) == cpu_to_node(cpu2));
+}
+
+static bool
 topology_sane(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o, const char *name)
 {
 	int cpu1 = c->cpu_index, cpu2 = o->cpu_index;
 
-	return !WARN_ONCE(cpu_to_node(cpu1) != cpu_to_node(cpu2),
+	return !WARN_ONCE(!topology_same_node(c, o),
 		"sched: CPU #%d's %s-sibling CPU #%d is not on the same node! "
 		"[node: %d != %d]. Ignoring dependency.\n",
 		cpu1, name, cpu2, cpu_to_node(cpu1), cpu_to_node(cpu2));
@@ -341,17 +349,44 @@ static bool match_llc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 	return false;
 }
 
-static bool match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
+/*
+ * Unlike the other levels, we do not enforce keeping a
+ * multicore group inside a NUMA node.  If this happens, we will
+ * discard the MC level of the topology later.
+ */
+static bool match_die(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 {
-	if (c->phys_proc_id == o->phys_proc_id) {
-		if (cpu_has(c, X86_FEATURE_AMD_DCM))
-			return true;
-
-		return topology_sane(c, o, "mc");
-	}
+	if (c->phys_proc_id == o->phys_proc_id)
+		return true;
 	return false;
 }
 
+static struct sched_domain_topology_level numa_inside_package_topology[] = {
+#ifdef CONFIG_SCHED_SMT
+	{ cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
+#endif
+#ifdef CONFIG_SCHED_MC
+	{ cpu_coregroup_mask, cpu_core_flags, SD_INIT_NAME(MC) },
+#endif
+	{ NULL, },
+};
+/*
+ * set_sched_topology() sets the topology internal to a CPU.  The
+ * NUMA topologies are layered on top of it to build the full
+ * system topology.
+ *
+ * If NUMA nodes are observed to occur within a CPU package, this
+ * function should be called.  It forces the sched domain code to
+ * only use the SMT level for the CPU portion of the topology.
+ * This essentially falls back to relying on NUMA information
+ * from the SRAT table to describe the entire system topology
+ * (except for hyperthreads).
+ */
+static void primarily_use_numa_for_topology(void)
+{
+	set_sched_topology(numa_inside_package_topology);
+}
+
 void set_cpu_sibling_map(int cpu)
 {
 	bool has_smt = smp_num_siblings > 1;
@@ -388,7 +423,7 @@ void set_cpu_sibling_map(int cpu)
 	for_each_cpu(i, cpu_sibling_setup_mask) {
 		o = &cpu_data(i);
 
-		if ((i == cpu) || (has_mp && match_mc(c, o))) {
+		if ((i == cpu) || (has_mp && match_die(c, o))) {
 			link_mask(core, cpu, i);
 
 			/*
@@ -410,6 +445,8 @@ void set_cpu_sibling_map(int cpu)
 			} else if (i != cpu && !c->booted_cores)
 				c->booted_cores = cpu_data(i).booted_cores;
 		}
+		if (match_die(c, o) && !topology_same_node(c, o))
+			primarily_use_numa_for_topology();
 	}
 }
 
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index a24194681513..6240bc7ae741 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -3,7 +3,6 @@
  *  Copyright (C) 2001, 2002 Andi Kleen, SuSE Labs.
  *  Copyright (C) 2008-2009, Red Hat Inc., Ingo Molnar
  */
-#include <linux/magic.h>		/* STACK_END_MAGIC		*/
 #include <linux/sched.h>		/* test_thread_flag(), ...	*/
 #include <linux/kdebug.h>		/* oops_begin/end, ...		*/
 #include <linux/module.h>		/* search_exception_table	*/
@@ -649,7 +648,6 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 	   unsigned long address, int signal, int si_code)
 {
 	struct task_struct *tsk = current;
-	unsigned long *stackend;
 	unsigned long flags;
 	int sig;
 
@@ -709,8 +707,7 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 
 	show_fault_oops(regs, error_code, address);
 
-	stackend = end_of_stack(tsk);
-	if (tsk != &init_task && *stackend != STACK_END_MAGIC)
+	if (task_stack_end_corrupted(tsk))
 		printk(KERN_EMERG "Thread overran stack, or stack corrupted\n");
 
 	tsk->thread.cr2		= address;
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index ee9df5e3f5eb..125150dc6e81 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -223,8 +223,14 @@ void cpuidle_uninstall_idle_handler(void)
 {
 	if (enabled_devices) {
 		initialized = 0;
-		kick_all_cpus_sync();
+		wake_up_all_idle_cpus();
 	}
+
+	/*
+	 * Make sure external observers (such as the scheduler)
+	 * are done looking at pointed idle states.
+	 */
+	synchronize_rcu();
 }
 
 /**
@@ -530,11 +536,6 @@ EXPORT_SYMBOL_GPL(cpuidle_register);
 
 #ifdef CONFIG_SMP
 
-static void smp_callback(void *v)
-{
-	/* we already woke the CPU up, nothing more to do */
-}
-
 /*
  * This function gets called when a part of the kernel has a new latency
  * requirement.  This means we need to get all processors out of their C-state,
@@ -544,7 +545,7 @@ static void smp_callback(void *v)
 static int cpuidle_latency_notify(struct notifier_block *b,
 		unsigned long l, void *v)
 {
-	smp_call_function(smp_callback, NULL, 1);
+	wake_up_all_idle_cpus();
 	return NOTIFY_OK;
 }
 
diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index d2077f040f3e..d07f810c7087 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -403,7 +403,6 @@ int vga_get(struct pci_dev *pdev, unsigned int rsrc, int interruptible)
 		}
 		schedule();
 		remove_wait_queue(&vga_wait_queue, &wait);
-		set_current_state(TASK_RUNNING);
 	}
 	return rc;
 }
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index ab472c557d18..0505559f0965 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -720,7 +720,6 @@ static void __wait_for_free_buffer(struct dm_bufio_client *c)
 
 	io_schedule();
 
-	set_task_state(current, TASK_RUNNING);
 	remove_wait_queue(&c->free_buffer_wait, &wait);
 
 	dm_bufio_lock(c);
diff --git a/drivers/parisc/power.c b/drivers/parisc/power.c
index 90cca5e3805f..ef31b77404ef 100644
--- a/drivers/parisc/power.c
+++ b/drivers/parisc/power.c
@@ -121,7 +121,6 @@ static int kpowerswd(void *param)
 		unsigned long soft_power_reg = (unsigned long) param;
 
 		schedule_timeout_interruptible(pwrsw_enabled ? HZ : HZ/POWERSWITCH_POLL_PER_SEC);
-		__set_current_state(TASK_RUNNING);
 
 		if (unlikely(!pwrsw_enabled))
 			continue;
diff --git a/drivers/s390/net/claw.c b/drivers/s390/net/claw.c
index fbc6701bef30..213e54ee8a66 100644
--- a/drivers/s390/net/claw.c
+++ b/drivers/s390/net/claw.c
@@ -481,7 +481,6 @@ claw_open(struct net_device *dev)
                 spin_unlock_irqrestore(
 			get_ccwdev_lock(privptr->channel[i].cdev), saveflags);
                 schedule();
-		set_current_state(TASK_RUNNING);
                 remove_wait_queue(&privptr->channel[i].wait, &wait);
                 if(rc != 0)
                         ccw_check_return_code(privptr->channel[i].cdev, rc);
@@ -828,7 +827,6 @@ claw_release(struct net_device *dev)
 	        spin_unlock_irqrestore(
 			get_ccwdev_lock(privptr->channel[i].cdev), saveflags);
 	        schedule();
-		set_current_state(TASK_RUNNING);
 	        remove_wait_queue(&privptr->channel[i].wait, &wait);
 	        if (rc != 0) {
                         ccw_check_return_code(privptr->channel[i].cdev, rc);
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 00ee0ed642aa..4a8ac7d8c76b 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1884,7 +1884,6 @@ static int fcoe_percpu_receive_thread(void *arg)
 			set_current_state(TASK_INTERRUPTIBLE);
 			spin_unlock_bh(&p->fcoe_rx_list.lock);
 			schedule();
-			set_current_state(TASK_RUNNING);
 			goto retry;
 		}
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index be9698d920c2..8b5a5dc129b4 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4853,7 +4853,6 @@ qla2x00_do_dpc(void *data)
 		    "DPC handler sleeping.\n");
 
 		schedule();
-		__set_current_state(TASK_RUNNING);
 
 		if (!base_vha->flags.init_done || ha->flags.mbox_busy)
 			goto end_loop;
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
index 306d72876432..b94f7436ec19 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
@@ -3215,7 +3215,6 @@ kiblnd_connd (void *arg)
 
 		schedule_timeout(timeout);
 
-		set_current_state(TASK_RUNNING);
 		remove_wait_queue(&kiblnd_data.kib_connd_waitq, &wait);
 		spin_lock_irqsave(&kiblnd_data.kib_connd_lock, flags);
 	}
@@ -3432,7 +3431,6 @@ kiblnd_scheduler(void *arg)
 		busy_loops = 0;
 
 		remove_wait_queue(&sched->ibs_waitq, &wait);
-		set_current_state(TASK_RUNNING);
 		spin_lock_irqsave(&sched->ibs_lock, flags);
 	}
 
@@ -3507,7 +3505,6 @@ kiblnd_failover_thread(void *arg)
 
 		rc = schedule_timeout(long_sleep ? cfs_time_seconds(10) :
 						   cfs_time_seconds(1));
-		set_current_state(TASK_RUNNING);
 		remove_wait_queue(&kiblnd_data.kib_failover_waitq, &wait);
 		write_lock_irqsave(glock, flags);
 
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
index 521439954fcb..9994fc66111b 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
@@ -2233,7 +2233,6 @@ ksocknal_connd (void *arg)
 		nloops = 0;
 		schedule_timeout(timeout);
 
-		set_current_state(TASK_RUNNING);
 		remove_wait_queue(&ksocknal_data.ksnd_connd_waitq, &wait);
 		spin_lock_bh(connd_lock);
 	}
diff --git a/drivers/staging/lustre/lustre/libcfs/fail.c b/drivers/staging/lustre/lustre/libcfs/fail.c
index 1bf9c90b4789..e73ca3df9734 100644
--- a/drivers/staging/lustre/lustre/libcfs/fail.c
+++ b/drivers/staging/lustre/lustre/libcfs/fail.c
@@ -131,7 +131,6 @@ int __cfs_fail_timeout_set(__u32 id, __u32 value, int ms, int set)
 		       id, ms);
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule_timeout(cfs_time_seconds(ms) / 1000);
-		set_current_state(TASK_RUNNING);
 		CERROR("cfs_fail_timeout id %x awake\n", id);
 	}
 	return ret;
diff --git a/drivers/tty/bfin_jtag_comm.c b/drivers/tty/bfin_jtag_comm.c
index 8096fcbe2dc1..d7b198c400c7 100644
--- a/drivers/tty/bfin_jtag_comm.c
+++ b/drivers/tty/bfin_jtag_comm.c
@@ -77,7 +77,6 @@ bfin_jc_emudat_manager(void *arg)
 			pr_debug("waiting for readers\n");
 			__set_current_state(TASK_UNINTERRUPTIBLE);
 			schedule();
-			__set_current_state(TASK_RUNNING);
 			continue;
 		}
 
diff --git a/fs/afs/vlocation.c b/fs/afs/vlocation.c
index b6df2e83809f..52976785a32c 100644
--- a/fs/afs/vlocation.c
+++ b/fs/afs/vlocation.c
@@ -130,7 +130,6 @@ static int afs_vlocation_access_vl_by_id(struct afs_vlocation *vl,
 					/* second+ BUSY - sleep a little bit */
 					set_current_state(TASK_UNINTERRUPTIBLE);
 					schedule_timeout(1);
-					__set_current_state(TASK_RUNNING);
 				}
 				continue;
 			}
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 0acddf60af55..bc462dcd7a40 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -1585,7 +1585,6 @@ void jfs_flush_journal(struct jfs_log *log, int wait)
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		LOGGC_UNLOCK(log);
 		schedule();
-		__set_current_state(TASK_RUNNING);
 		LOGGC_LOCK(log);
 		remove_wait_queue(&target->gcwait, &__wait);
 	}
@@ -2359,7 +2358,6 @@ int jfsIOWait(void *arg)
 			set_current_state(TASK_INTERRUPTIBLE);
 			spin_unlock_irq(&log_redrive_lock);
 			schedule();
-			__set_current_state(TASK_RUNNING);
 		}
 	} while (!kthread_should_stop());
 
diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
index 564c4f279ac6..d595856453b2 100644
--- a/fs/jfs/jfs_txnmgr.c
+++ b/fs/jfs/jfs_txnmgr.c
@@ -136,7 +136,6 @@ static inline void TXN_SLEEP_DROP_LOCK(wait_queue_head_t * event)
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	TXN_UNLOCK();
 	io_schedule();
-	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(event, &wait);
 }
 
@@ -2808,7 +2807,6 @@ int jfs_lazycommit(void *arg)
 			set_current_state(TASK_INTERRUPTIBLE);
 			LAZY_UNLOCK(flags);
 			schedule();
-			__set_current_state(TASK_RUNNING);
 			remove_wait_queue(&jfs_commit_thread_wait, &wq);
 		}
 	} while (!kthread_should_stop());
@@ -2996,7 +2994,6 @@ int jfs_sync(void *arg)
 			set_current_state(TASK_INTERRUPTIBLE);
 			TXN_UNLOCK();
 			schedule();
-			__set_current_state(TASK_RUNNING);
 		}
 	} while (!kthread_should_stop());
 
diff --git a/fs/nfs/blocklayout/blocklayoutdev.c b/fs/nfs/blocklayout/blocklayoutdev.c
index 04303b5c9361..9fde840c42d3 100644
--- a/fs/nfs/blocklayout/blocklayoutdev.c
+++ b/fs/nfs/blocklayout/blocklayoutdev.c
@@ -146,7 +146,6 @@ nfs4_blk_decode_device(struct nfs_server *server,
 
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	schedule();
-	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&nn->bl_wq, &wq);
 
 	if (reply->status != BL_DEVICE_REQUEST_PROC) {
diff --git a/fs/nfs/blocklayout/blocklayoutdm.c b/fs/nfs/blocklayout/blocklayoutdm.c
index 8999cfddd866..b18680eb6b39 100644
--- a/fs/nfs/blocklayout/blocklayoutdm.c
+++ b/fs/nfs/blocklayout/blocklayoutdm.c
@@ -76,7 +76,6 @@ static void dev_remove(struct net *net, dev_t dev)
 
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	schedule();
-	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&nn->bl_wq, &wq);
 
 out:
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 9c271f42604a..8f1af78ebb67 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -670,7 +670,6 @@ __cld_pipe_upcall(struct rpc_pipe *pipe, struct cld_msg *cmsg)
 	}
 
 	schedule();
-	set_current_state(TASK_RUNNING);
 
 	if (msg.errno < 0)
 		ret = msg.errno;
diff --git a/include/asm-generic/cputime_jiffies.h b/include/asm-generic/cputime_jiffies.h
index d5cb78f53986..fe386fc6e85e 100644
--- a/include/asm-generic/cputime_jiffies.h
+++ b/include/asm-generic/cputime_jiffies.h
@@ -3,6 +3,8 @@
 
 typedef unsigned long __nocast cputime_t;
 
+#define cmpxchg_cputime(ptr, old, new) cmpxchg(ptr, old, new)
+
 #define cputime_one_jiffy		jiffies_to_cputime(1)
 #define cputime_to_jiffies(__ct)	(__force unsigned long)(__ct)
 #define cputime_to_scaled(__ct)		(__ct)
diff --git a/include/asm-generic/cputime_nsecs.h b/include/asm-generic/cputime_nsecs.h
index 4e817606c549..0419485891f2 100644
--- a/include/asm-generic/cputime_nsecs.h
+++ b/include/asm-generic/cputime_nsecs.h
@@ -21,6 +21,8 @@
 typedef u64 __nocast cputime_t;
 typedef u64 __nocast cputime64_t;
 
+#define cmpxchg_cputime(ptr, old, new) cmpxchg64(ptr, old, new)
+
 #define cputime_one_jiffy		jiffies_to_cputime(1)
 
 #define cputime_div(__ct, divisor)  div_u64((__force u64)__ct, divisor)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5c2c885ee52b..18f52624eaa6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -57,6 +57,7 @@ struct sched_param {
 #include <linux/llist.h>
 #include <linux/uidgid.h>
 #include <linux/gfp.h>
+#include <linux/magic.h>
 
 #include <asm/processor.h>
 
@@ -645,6 +646,7 @@ struct signal_struct {
 	 * Live threads maintain their own counters and add to these
 	 * in __exit_signal, except for the group leader.
 	 */
+	seqlock_t stats_lock;
 	cputime_t utime, stime, cutime, cstime;
 	cputime_t gtime;
 	cputime_t cgtime;
@@ -1023,6 +1025,7 @@ struct sched_domain_topology_level {
 extern struct sched_domain_topology_level *sched_domain_topology;
 
 extern void set_sched_topology(struct sched_domain_topology_level *tl);
+extern void wake_up_if_idle(int cpu);
 
 #ifdef CONFIG_SCHED_DEBUG
 # define SD_INIT_NAME(type)		.name = #type
@@ -2614,6 +2617,8 @@ static inline unsigned long *end_of_stack(struct task_struct *p)
 }
 
 #endif
+#define task_stack_end_corrupted(task) \
+		(*(end_of_stack(task)) != STACK_END_MAGIC)
 
 static inline int object_is_on_stack(void *obj)
 {
@@ -2636,6 +2641,7 @@ static inline unsigned long stack_not_used(struct task_struct *p)
 	return (unsigned long)n - (unsigned long)end_of_stack(p);
 }
 #endif
+extern void set_task_stack_end_magic(struct task_struct *tsk);
 
 /* set thread flags in other task's structures
  * - see asm/thread_info.h for TIF_xxxx flags available
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index cc359636cfa3..f5df8f687b4d 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -456,4 +456,23 @@ read_sequnlock_excl_irqrestore(seqlock_t *sl, unsigned long flags)
 	spin_unlock_irqrestore(&sl->lock, flags);
 }
 
+static inline unsigned long
+read_seqbegin_or_lock_irqsave(seqlock_t *lock, int *seq)
+{
+	unsigned long flags = 0;
+
+	if (!(*seq & 1))	/* Even */
+		*seq = read_seqbegin(lock);
+	else			/* Odd */
+		read_seqlock_excl_irqsave(lock, flags);
+
+	return flags;
+}
+
+static inline void
+done_seqretry_irqrestore(seqlock_t *lock, int seq, unsigned long flags)
+{
+	if (seq & 1)
+		read_sequnlock_excl_irqrestore(lock, flags);
+}
 #endif /* __LINUX_SEQLOCK_H */
diff --git a/include/linux/smp.h b/include/linux/smp.h
index 34347f26be9b..93dff5fff524 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -100,6 +100,7 @@ int smp_call_function_any(const struct cpumask *mask,
 			  smp_call_func_t func, void *info, int wait);
 
 void kick_all_cpus_sync(void);
+void wake_up_all_idle_cpus(void);
 
 /*
  * Generic and arch helpers
@@ -148,6 +149,7 @@ smp_call_function_any(const struct cpumask *mask, smp_call_func_t func,
 }
 
 static inline void kick_all_cpus_sync(void) {  }
+static inline void wake_up_all_idle_cpus(void) {  }
 
 #endif /* !SMP */
 
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 6fb1ba5f9b2f..034f6fc7c65f 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -280,9 +280,11 @@ do {									\
  * wake_up() has to be called after changing any variable that could
  * change the result of the wait condition.
  *
- * The function returns 0 if the @timeout elapsed, or the remaining
- * jiffies (at least 1) if the @condition evaluated to %true before
- * the @timeout elapsed.
+ * Returns:
+ * 0 if the @condition evaluated to %false after the @timeout elapsed,
+ * 1 if the @condition evaluated to %true after the @timeout elapsed,
+ * or the remaining jiffies (at least 1) if the @condition evaluated
+ * to %true before the @timeout elapsed.
  */
 #define wait_event_timeout(wq, condition, timeout)			\
 ({									\
@@ -363,9 +365,11 @@ do {									\
  * change the result of the wait condition.
  *
  * Returns:
- * 0 if the @timeout elapsed, -%ERESTARTSYS if it was interrupted by
- * a signal, or the remaining jiffies (at least 1) if the @condition
- * evaluated to %true before the @timeout elapsed.
+ * 0 if the @condition evaluated to %false after the @timeout elapsed,
+ * 1 if the @condition evaluated to %true after the @timeout elapsed,
+ * the remaining jiffies (at least 1) if the @condition evaluated
+ * to %true before the @timeout elapsed, or -%ERESTARTSYS if it was
+ * interrupted by a signal.
  */
 #define wait_event_interruptible_timeout(wq, condition, timeout)	\
 ({									\
diff --git a/init/main.c b/init/main.c
index bb1aed928f21..5fc3fc7bd475 100644
--- a/init/main.c
+++ b/init/main.c
@@ -508,6 +508,7 @@ asmlinkage __visible void __init start_kernel(void)
 	 * lockdep hash:
 	 */
 	lockdep_init();
+	set_task_stack_end_magic(&init_task);
 	smp_setup_processor_id();
 	debug_objects_early_init();
 
diff --git a/kernel/exit.c b/kernel/exit.c
index 32c58f7433a3..fa09b86609db 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -115,32 +115,33 @@ static void __exit_signal(struct task_struct *tsk)
 
 		if (tsk == sig->curr_target)
 			sig->curr_target = next_thread(tsk);
-		/*
-		 * Accumulate here the counters for all threads but the
-		 * group leader as they die, so they can be added into
-		 * the process-wide totals when those are taken.
-		 * The group leader stays around as a zombie as long
-		 * as there are other threads.  When it gets reaped,
-		 * the exit.c code will add its counts into these totals.
-		 * We won't ever get here for the group leader, since it
-		 * will have been the last reference on the signal_struct.
-		 */
-		task_cputime(tsk, &utime, &stime);
-		sig->utime += utime;
-		sig->stime += stime;
-		sig->gtime += task_gtime(tsk);
-		sig->min_flt += tsk->min_flt;
-		sig->maj_flt += tsk->maj_flt;
-		sig->nvcsw += tsk->nvcsw;
-		sig->nivcsw += tsk->nivcsw;
-		sig->inblock += task_io_get_inblock(tsk);
-		sig->oublock += task_io_get_oublock(tsk);
-		task_io_accounting_add(&sig->ioac, &tsk->ioac);
-		sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
 	}
 
+	/*
+	 * Accumulate here the counters for all threads but the group leader
+	 * as they die, so they can be added into the process-wide totals
+	 * when those are taken.  The group leader stays around as a zombie as
+	 * long as there are other threads.  When it gets reaped, the exit.c
+	 * code will add its counts into these totals.  We won't ever get here
+	 * for the group leader, since it will have been the last reference on
+	 * the signal_struct.
+	 */
+	task_cputime(tsk, &utime, &stime);
+	write_seqlock(&sig->stats_lock);
+	sig->utime += utime;
+	sig->stime += stime;
+	sig->gtime += task_gtime(tsk);
+	sig->min_flt += tsk->min_flt;
+	sig->maj_flt += tsk->maj_flt;
+	sig->nvcsw += tsk->nvcsw;
+	sig->nivcsw += tsk->nivcsw;
+	sig->inblock += task_io_get_inblock(tsk);
+	sig->oublock += task_io_get_oublock(tsk);
+	task_io_accounting_add(&sig->ioac, &tsk->ioac);
+	sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
 	sig->nr_threads--;
 	__unhash_process(tsk, group_dead);
+	write_sequnlock(&sig->stats_lock);
 
 	/*
 	 * Do this under ->siglock, we can race with another thread
@@ -1043,6 +1044,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		spin_lock_irq(&p->real_parent->sighand->siglock);
 		psig = p->real_parent->signal;
 		sig = p->signal;
+		write_seqlock(&psig->stats_lock);
 		psig->cutime += tgutime + sig->cutime;
 		psig->cstime += tgstime + sig->cstime;
 		psig->cgtime += task_gtime(p) + sig->gtime + sig->cgtime;
@@ -1065,6 +1067,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 			psig->cmaxrss = maxrss;
 		task_io_accounting_add(&psig->ioac, &p->ioac);
 		task_io_accounting_add(&psig->ioac, &sig->ioac);
+		write_sequnlock(&psig->stats_lock);
 		spin_unlock_irq(&p->real_parent->sighand->siglock);
 	}
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 0cf9cdb6e491..ad64248c4b18 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -294,11 +294,18 @@ int __weak arch_dup_task_struct(struct task_struct *dst,
 	return 0;
 }
 
+void set_task_stack_end_magic(struct task_struct *tsk)
+{
+	unsigned long *stackend;
+
+	stackend = end_of_stack(tsk);
+	*stackend = STACK_END_MAGIC;	/* for overflow detection */
+}
+
 static struct task_struct *dup_task_struct(struct task_struct *orig)
 {
 	struct task_struct *tsk;
 	struct thread_info *ti;
-	unsigned long *stackend;
 	int node = tsk_fork_get_node(orig);
 	int err;
 
@@ -328,8 +335,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 	setup_thread_stack(tsk, orig);
 	clear_user_return_notifier(tsk);
 	clear_tsk_need_resched(tsk);
-	stackend = end_of_stack(tsk);
-	*stackend = STACK_END_MAGIC;	/* for overflow detection */
+	set_task_stack_end_magic(tsk);
 
 #ifdef CONFIG_CC_STACKPROTECTOR
 	tsk->stack_canary = get_random_int();
@@ -1068,6 +1074,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->curr_target = tsk;
 	init_sigpending(&sig->shared_pending);
 	INIT_LIST_HEAD(&sig->posix_timers);
+	seqlock_init(&sig->stats_lock);
 
 	hrtimer_init(&sig->real_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	sig->real_timer.function = it_real_fn;
diff --git a/kernel/sched/auto_group.c b/kernel/sched/auto_group.c
index e73efba98301..8a2e230fb86a 100644
--- a/kernel/sched/auto_group.c
+++ b/kernel/sched/auto_group.c
@@ -148,11 +148,8 @@ autogroup_move_group(struct task_struct *p, struct autogroup *ag)
 	if (!ACCESS_ONCE(sysctl_sched_autogroup_enabled))
 		goto out;
 
-	t = p;
-	do {
+	for_each_thread(p, t)
 		sched_move_task(t);
-	} while_each_thread(p, t);
-
 out:
 	unlock_task_sighand(p, &flags);
 	autogroup_kref_put(prev);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ec1a286684a5..c84bdc098656 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -333,9 +333,12 @@ static inline struct rq *__task_rq_lock(struct task_struct *p)
 	for (;;) {
 		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
-		if (likely(rq == task_rq(p)))
+		if (likely(rq == task_rq(p) && !task_on_rq_migrating(p)))
 			return rq;
 		raw_spin_unlock(&rq->lock);
+
+		while (unlikely(task_on_rq_migrating(p)))
+			cpu_relax();
 	}
 }
 
@@ -352,10 +355,13 @@ static struct rq *task_rq_lock(struct task_struct *p, unsigned long *flags)
 		raw_spin_lock_irqsave(&p->pi_lock, *flags);
 		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
-		if (likely(rq == task_rq(p)))
+		if (likely(rq == task_rq(p) && !task_on_rq_migrating(p)))
 			return rq;
 		raw_spin_unlock(&rq->lock);
 		raw_spin_unlock_irqrestore(&p->pi_lock, *flags);
+
+		while (unlikely(task_on_rq_migrating(p)))
+			cpu_relax();
 	}
 }
 
@@ -449,7 +455,15 @@ static void __hrtick_start(void *arg)
 void hrtick_start(struct rq *rq, u64 delay)
 {
 	struct hrtimer *timer = &rq->hrtick_timer;
-	ktime_t time = ktime_add_ns(timer->base->get_time(), delay);
+	ktime_t time;
+	s64 delta;
+
+	/*
+	 * Don't schedule slices shorter than 10000ns, that just
+	 * doesn't make sense and can cause timer DoS.
+	 */
+	delta = max_t(s64, delay, 10000LL);
+	time = ktime_add_ns(timer->base->get_time(), delta);
 
 	hrtimer_set_expires(timer, time);
 
@@ -1043,7 +1057,7 @@ void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
 	 * A queue event has occurred, and we're going to schedule.  In
 	 * this case, we can save a useless back to back clock update.
 	 */
-	if (rq->curr->on_rq && test_tsk_need_resched(rq->curr))
+	if (task_on_rq_queued(rq->curr) && test_tsk_need_resched(rq->curr))
 		rq->skip_clock_update = 1;
 }
 
@@ -1088,7 +1102,7 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 
 static void __migrate_swap_task(struct task_struct *p, int cpu)
 {
-	if (p->on_rq) {
+	if (task_on_rq_queued(p)) {
 		struct rq *src_rq, *dst_rq;
 
 		src_rq = task_rq(p);
@@ -1214,7 +1228,7 @@ static int migration_cpu_stop(void *data);
 unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 {
 	unsigned long flags;
-	int running, on_rq;
+	int running, queued;
 	unsigned long ncsw;
 	struct rq *rq;
 
@@ -1252,7 +1266,7 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		rq = task_rq_lock(p, &flags);
 		trace_sched_wait_task(p);
 		running = task_running(rq, p);
-		on_rq = p->on_rq;
+		queued = task_on_rq_queued(p);
 		ncsw = 0;
 		if (!match_state || p->state == match_state)
 			ncsw = p->nvcsw | LONG_MIN; /* sets MSB */
@@ -1284,7 +1298,7 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		 * running right now), it's preempted, and we should
 		 * yield - it could be a while.
 		 */
-		if (unlikely(on_rq)) {
+		if (unlikely(queued)) {
 			ktime_t to = ktime_set(0, NSEC_PER_SEC/HZ);
 
 			set_current_state(TASK_UNINTERRUPTIBLE);
@@ -1478,7 +1492,7 @@ ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
 static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
 {
 	activate_task(rq, p, en_flags);
-	p->on_rq = 1;
+	p->on_rq = TASK_ON_RQ_QUEUED;
 
 	/* if a worker is waking up, notify workqueue */
 	if (p->flags & PF_WQ_WORKER)
@@ -1537,7 +1551,7 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
 	int ret = 0;
 
 	rq = __task_rq_lock(p);
-	if (p->on_rq) {
+	if (task_on_rq_queued(p)) {
 		/* check_preempt_curr() may use rq clock */
 		update_rq_clock(rq);
 		ttwu_do_wakeup(rq, p, wake_flags);
@@ -1620,6 +1634,25 @@ static void ttwu_queue_remote(struct task_struct *p, int cpu)
 	}
 }
 
+void wake_up_if_idle(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long flags;
+
+	if (!is_idle_task(rq->curr))
+		return;
+
+	if (set_nr_if_polling(rq->idle)) {
+		trace_sched_wake_idle_without_ipi(cpu);
+	} else {
+		raw_spin_lock_irqsave(&rq->lock, flags);
+		if (is_idle_task(rq->curr))
+			smp_send_reschedule(cpu);
+		/* Else cpu is not in idle, do nothing here */
+		raw_spin_unlock_irqrestore(&rq->lock, flags);
+	}
+}
+
 bool cpus_share_cache(int this_cpu, int that_cpu)
 {
 	return per_cpu(sd_llc_id, this_cpu) == per_cpu(sd_llc_id, that_cpu);
@@ -1742,7 +1775,7 @@ static void try_to_wake_up_local(struct task_struct *p)
 	if (!(p->state & TASK_NORMAL))
 		goto out;
 
-	if (!p->on_rq)
+	if (!task_on_rq_queued(p))
 		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
 
 	ttwu_do_wakeup(rq, p, 0);
@@ -1776,6 +1809,20 @@ int wake_up_state(struct task_struct *p, unsigned int state)
 }
 
 /*
+ * This function clears the sched_dl_entity static params.
+ */
+void __dl_clear_params(struct task_struct *p)
+{
+	struct sched_dl_entity *dl_se = &p->dl;
+
+	dl_se->dl_runtime = 0;
+	dl_se->dl_deadline = 0;
+	dl_se->dl_period = 0;
+	dl_se->flags = 0;
+	dl_se->dl_bw = 0;
+}
+
+/*
  * Perform scheduler related setup for a newly forked process p.
  * p is forked by current.
  *
@@ -1799,10 +1846,7 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 
 	RB_CLEAR_NODE(&p->dl.rb_node);
 	hrtimer_init(&p->dl.dl_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	p->dl.dl_runtime = p->dl.runtime = 0;
-	p->dl.dl_deadline = p->dl.deadline = 0;
-	p->dl.dl_period = 0;
-	p->dl.flags = 0;
+	__dl_clear_params(p);
 
 	INIT_LIST_HEAD(&p->rt.run_list);
 
@@ -1977,6 +2021,8 @@ unsigned long to_ratio(u64 period, u64 runtime)
 #ifdef CONFIG_SMP
 inline struct dl_bw *dl_bw_of(int i)
 {
+	rcu_lockdep_assert(rcu_read_lock_sched_held(),
+			   "sched RCU must be held");
 	return &cpu_rq(i)->rd->dl_bw;
 }
 
@@ -1985,6 +2031,8 @@ static inline int dl_bw_cpus(int i)
 	struct root_domain *rd = cpu_rq(i)->rd;
 	int cpus = 0;
 
+	rcu_lockdep_assert(rcu_read_lock_sched_held(),
+			   "sched RCU must be held");
 	for_each_cpu_and(i, rd->span, cpu_active_mask)
 		cpus++;
 
@@ -2095,7 +2143,7 @@ void wake_up_new_task(struct task_struct *p)
 	init_task_runnable_average(p);
 	rq = __task_rq_lock(p);
 	activate_task(rq, p, 0);
-	p->on_rq = 1;
+	p->on_rq = TASK_ON_RQ_QUEUED;
 	trace_sched_wakeup_new(p, true);
 	check_preempt_curr(rq, p, WF_FORK);
 #ifdef CONFIG_SMP
@@ -2287,10 +2335,6 @@ asmlinkage __visible void schedule_tail(struct task_struct *prev)
 	 */
 	post_schedule(rq);
 
-#ifdef __ARCH_WANT_UNLOCKED_CTXSW
-	/* In this case, finish_task_switch does not reenable preemption */
-	preempt_enable();
-#endif
 	if (current->set_child_tid)
 		put_user(task_pid_vnr(current), current->set_child_tid);
 }
@@ -2333,9 +2377,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	 * of the scheduler it's an obvious special-case), so we
 	 * do an early lockdep release here:
 	 */
-#ifndef __ARCH_WANT_UNLOCKED_CTXSW
 	spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
-#endif
 
 	context_tracking_task_switch(prev, next);
 	/* Here we just switch the register state and the stack. */
@@ -2451,7 +2493,7 @@ static u64 do_task_delta_exec(struct task_struct *p, struct rq *rq)
 	 * project cycles that may never be accounted to this
 	 * thread, breaking clock_gettime().
 	 */
-	if (task_current(rq, p) && p->on_rq) {
+	if (task_current(rq, p) && task_on_rq_queued(p)) {
 		update_rq_clock(rq);
 		ns = rq_clock_task(rq) - p->se.exec_start;
 		if ((s64)ns < 0)
@@ -2497,7 +2539,7 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 	 * If we see ->on_cpu without ->on_rq, the task is leaving, and has
 	 * been accounted, so we're correct here as well.
 	 */
-	if (!p->on_cpu || !p->on_rq)
+	if (!p->on_cpu || !task_on_rq_queued(p))
 		return p->se.sum_exec_runtime;
 #endif
 
@@ -2660,6 +2702,9 @@ static noinline void __schedule_bug(struct task_struct *prev)
  */
 static inline void schedule_debug(struct task_struct *prev)
 {
+#ifdef CONFIG_SCHED_STACK_END_CHECK
+	BUG_ON(unlikely(task_stack_end_corrupted(prev)));
+#endif
 	/*
 	 * Test if we are atomic. Since do_exit() needs to call into
 	 * schedule() atomically, we ignore that path. Otherwise whine
@@ -2801,7 +2846,7 @@ static void __sched __schedule(void)
 		switch_count = &prev->nvcsw;
 	}
 
-	if (prev->on_rq || rq->skip_clock_update < 0)
+	if (task_on_rq_queued(prev) || rq->skip_clock_update < 0)
 		update_rq_clock(rq);
 
 	next = pick_next_task(rq, prev);
@@ -2966,7 +3011,7 @@ EXPORT_SYMBOL(default_wake_function);
  */
 void rt_mutex_setprio(struct task_struct *p, int prio)
 {
-	int oldprio, on_rq, running, enqueue_flag = 0;
+	int oldprio, queued, running, enqueue_flag = 0;
 	struct rq *rq;
 	const struct sched_class *prev_class;
 
@@ -2995,12 +3040,12 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	trace_sched_pi_setprio(p, prio);
 	oldprio = p->prio;
 	prev_class = p->sched_class;
-	on_rq = p->on_rq;
+	queued = task_on_rq_queued(p);
 	running = task_current(rq, p);
-	if (on_rq)
+	if (queued)
 		dequeue_task(rq, p, 0);
 	if (running)
-		p->sched_class->put_prev_task(rq, p);
+		put_prev_task(rq, p);
 
 	/*
 	 * Boosting condition are:
@@ -3037,7 +3082,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
-	if (on_rq)
+	if (queued)
 		enqueue_task(rq, p, enqueue_flag);
 
 	check_class_changed(rq, p, prev_class, oldprio);
@@ -3048,7 +3093,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 
 void set_user_nice(struct task_struct *p, long nice)
 {
-	int old_prio, delta, on_rq;
+	int old_prio, delta, queued;
 	unsigned long flags;
 	struct rq *rq;
 
@@ -3069,8 +3114,8 @@ void set_user_nice(struct task_struct *p, long nice)
 		p->static_prio = NICE_TO_PRIO(nice);
 		goto out_unlock;
 	}
-	on_rq = p->on_rq;
-	if (on_rq)
+	queued = task_on_rq_queued(p);
+	if (queued)
 		dequeue_task(rq, p, 0);
 
 	p->static_prio = NICE_TO_PRIO(nice);
@@ -3079,7 +3124,7 @@ void set_user_nice(struct task_struct *p, long nice)
 	p->prio = effective_prio(p);
 	delta = p->prio - old_prio;
 
-	if (on_rq) {
+	if (queued) {
 		enqueue_task(rq, p, 0);
 		/*
 		 * If the task increased its priority or is running and
@@ -3351,7 +3396,7 @@ static int __sched_setscheduler(struct task_struct *p,
 {
 	int newprio = dl_policy(attr->sched_policy) ? MAX_DL_PRIO - 1 :
 		      MAX_RT_PRIO - 1 - attr->sched_priority;
-	int retval, oldprio, oldpolicy = -1, on_rq, running;
+	int retval, oldprio, oldpolicy = -1, queued, running;
 	int policy = attr->sched_policy;
 	unsigned long flags;
 	const struct sched_class *prev_class;
@@ -3548,19 +3593,19 @@ static int __sched_setscheduler(struct task_struct *p,
 		return 0;
 	}
 
-	on_rq = p->on_rq;
+	queued = task_on_rq_queued(p);
 	running = task_current(rq, p);
-	if (on_rq)
+	if (queued)
 		dequeue_task(rq, p, 0);
 	if (running)
-		p->sched_class->put_prev_task(rq, p);
+		put_prev_task(rq, p);
 
 	prev_class = p->sched_class;
 	__setscheduler(rq, p, attr);
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
-	if (on_rq) {
+	if (queued) {
 		/*
 		 * We enqueue to tail when the priority of a task is
 		 * increased (user space view).
@@ -3984,14 +4029,14 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 		rcu_read_lock();
 		if (!ns_capable(__task_cred(p)->user_ns, CAP_SYS_NICE)) {
 			rcu_read_unlock();
-			goto out_unlock;
+			goto out_free_new_mask;
 		}
 		rcu_read_unlock();
 	}
 
 	retval = security_task_setscheduler(p);
 	if (retval)
-		goto out_unlock;
+		goto out_free_new_mask;
 
 
 	cpuset_cpus_allowed(p, cpus_allowed);
@@ -4004,13 +4049,14 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 	 * root_domain.
 	 */
 #ifdef CONFIG_SMP
-	if (task_has_dl_policy(p)) {
-		const struct cpumask *span = task_rq(p)->rd->span;
-
-		if (dl_bandwidth_enabled() && !cpumask_subset(span, new_mask)) {
+	if (task_has_dl_policy(p) && dl_bandwidth_enabled()) {
+		rcu_read_lock();
+		if (!cpumask_subset(task_rq(p)->rd->span, new_mask)) {
 			retval = -EBUSY;
-			goto out_unlock;
+			rcu_read_unlock();
+			goto out_free_new_mask;
 		}
+		rcu_read_unlock();
 	}
 #endif
 again:
@@ -4028,7 +4074,7 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 			goto again;
 		}
 	}
-out_unlock:
+out_free_new_mask:
 	free_cpumask_var(new_mask);
 out_free_cpus_allowed:
 	free_cpumask_var(cpus_allowed);
@@ -4512,7 +4558,7 @@ void show_state_filter(unsigned long state_filter)
 		"  task                        PC stack   pid father\n");
 #endif
 	rcu_read_lock();
-	do_each_thread(g, p) {
+	for_each_process_thread(g, p) {
 		/*
 		 * reset the NMI-timeout, listing all files on a slow
 		 * console might take a lot of time:
@@ -4520,7 +4566,7 @@ void show_state_filter(unsigned long state_filter)
 		touch_nmi_watchdog();
 		if (!state_filter || (p->state & state_filter))
 			sched_show_task(p);
-	} while_each_thread(g, p);
+	}
 
 	touch_all_softlockup_watchdogs();
 
@@ -4575,7 +4621,7 @@ void init_idle(struct task_struct *idle, int cpu)
 	rcu_read_unlock();
 
 	rq->curr = rq->idle = idle;
-	idle->on_rq = 1;
+	idle->on_rq = TASK_ON_RQ_QUEUED;
 #if defined(CONFIG_SMP)
 	idle->on_cpu = 1;
 #endif
@@ -4596,6 +4642,33 @@ void init_idle(struct task_struct *idle, int cpu)
 }
 
 #ifdef CONFIG_SMP
+/*
+ * move_queued_task - move a queued task to new rq.
+ *
+ * Returns (locked) new rq. Old rq's lock is released.
+ */
+static struct rq *move_queued_task(struct task_struct *p, int new_cpu)
+{
+	struct rq *rq = task_rq(p);
+
+	lockdep_assert_held(&rq->lock);
+
+	dequeue_task(rq, p, 0);
+	p->on_rq = TASK_ON_RQ_MIGRATING;
+	set_task_cpu(p, new_cpu);
+	raw_spin_unlock(&rq->lock);
+
+	rq = cpu_rq(new_cpu);
+
+	raw_spin_lock(&rq->lock);
+	BUG_ON(task_cpu(p) != new_cpu);
+	p->on_rq = TASK_ON_RQ_QUEUED;
+	enqueue_task(rq, p, 0);
+	check_preempt_curr(rq, p, 0);
+
+	return rq;
+}
+
 void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
 {
 	if (p->sched_class && p->sched_class->set_cpus_allowed)
@@ -4652,14 +4725,15 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 		goto out;
 
 	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
-	if (p->on_rq) {
+	if (task_running(rq, p) || p->state == TASK_WAKING) {
 		struct migration_arg arg = { p, dest_cpu };
 		/* Need help from migration thread: drop lock and wait. */
 		task_rq_unlock(rq, p, &flags);
 		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
 		tlb_migrate_finish(p->mm);
 		return 0;
-	}
+	} else if (task_on_rq_queued(p))
+		rq = move_queued_task(p, dest_cpu);
 out:
 	task_rq_unlock(rq, p, &flags);
 
@@ -4680,20 +4754,20 @@ EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
  */
 static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 {
-	struct rq *rq_dest, *rq_src;
+	struct rq *rq;
 	int ret = 0;
 
 	if (unlikely(!cpu_active(dest_cpu)))
 		return ret;
 
-	rq_src = cpu_rq(src_cpu);
-	rq_dest = cpu_rq(dest_cpu);
+	rq = cpu_rq(src_cpu);
 
 	raw_spin_lock(&p->pi_lock);
-	double_rq_lock(rq_src, rq_dest);
+	raw_spin_lock(&rq->lock);
 	/* Already moved. */
 	if (task_cpu(p) != src_cpu)
 		goto done;
+
 	/* Affinity changed (again). */
 	if (!cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
 		goto fail;
@@ -4702,16 +4776,12 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 	 * If we're not on a rq, the next wake-up will ensure we're
 	 * placed properly.
 	 */
-	if (p->on_rq) {
-		dequeue_task(rq_src, p, 0);
-		set_task_cpu(p, dest_cpu);
-		enqueue_task(rq_dest, p, 0);
-		check_preempt_curr(rq_dest, p, 0);
-	}
+	if (task_on_rq_queued(p))
+		rq = move_queued_task(p, dest_cpu);
 done:
 	ret = 1;
 fail:
-	double_rq_unlock(rq_src, rq_dest);
+	raw_spin_unlock(&rq->lock);
 	raw_spin_unlock(&p->pi_lock);
 	return ret;
 }
@@ -4743,22 +4813,22 @@ void sched_setnuma(struct task_struct *p, int nid)
 {
 	struct rq *rq;
 	unsigned long flags;
-	bool on_rq, running;
+	bool queued, running;
 
 	rq = task_rq_lock(p, &flags);
-	on_rq = p->on_rq;
+	queued = task_on_rq_queued(p);
 	running = task_current(rq, p);
 
-	if (on_rq)
+	if (queued)
 		dequeue_task(rq, p, 0);
 	if (running)
-		p->sched_class->put_prev_task(rq, p);
+		put_prev_task(rq, p);
 
 	p->numa_preferred_nid = nid;
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
-	if (on_rq)
+	if (queued)
 		enqueue_task(rq, p, 0);
 	task_rq_unlock(rq, p, &flags);
 }
@@ -4778,6 +4848,12 @@ static int migration_cpu_stop(void *data)
 	 * be on another cpu but it doesn't matter.
 	 */
 	local_irq_disable();
+	/*
+	 * We need to explicitly wake pending tasks before running
+	 * __migrate_task() such that we will not miss enforcing cpus_allowed
+	 * during wakeups, see set_cpus_allowed_ptr()'s TASK_WAKING test.
+	 */
+	sched_ttwu_pending();
 	__migrate_task(arg->task, raw_smp_processor_id(), arg->dest_cpu);
 	local_irq_enable();
 	return 0;
@@ -5188,6 +5264,7 @@ static int sched_cpu_inactive(struct notifier_block *nfb,
 {
 	unsigned long flags;
 	long cpu = (long)hcpu;
+	struct dl_bw *dl_b;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DOWN_PREPARE:
@@ -5195,15 +5272,19 @@ static int sched_cpu_inactive(struct notifier_block *nfb,
 
 		/* explicitly allow suspend */
 		if (!(action & CPU_TASKS_FROZEN)) {
-			struct dl_bw *dl_b = dl_bw_of(cpu);
 			bool overflow;
 			int cpus;
 
+			rcu_read_lock_sched();
+			dl_b = dl_bw_of(cpu);
+
 			raw_spin_lock_irqsave(&dl_b->lock, flags);
 			cpus = dl_bw_cpus(cpu);
 			overflow = __dl_overflow(dl_b, cpus, 0, 0);
 			raw_spin_unlock_irqrestore(&dl_b->lock, flags);
 
+			rcu_read_unlock_sched();
+
 			if (overflow)
 				return notifier_from_errno(-EBUSY);
 		}
@@ -5746,7 +5827,7 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 	const struct cpumask *span = sched_domain_span(sd);
 	struct cpumask *covered = sched_domains_tmpmask;
 	struct sd_data *sdd = sd->private;
-	struct sched_domain *child;
+	struct sched_domain *sibling;
 	int i;
 
 	cpumask_clear(covered);
@@ -5757,10 +5838,10 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 		if (cpumask_test_cpu(i, covered))
 			continue;
 
-		child = *per_cpu_ptr(sdd->sd, i);
+		sibling = *per_cpu_ptr(sdd->sd, i);
 
 		/* See the comment near build_group_mask(). */
-		if (!cpumask_test_cpu(i, sched_domain_span(child)))
+		if (!cpumask_test_cpu(i, sched_domain_span(sibling)))
 			continue;
 
 		sg = kzalloc_node(sizeof(struct sched_group) + cpumask_size(),
@@ -5770,10 +5851,9 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 			goto fail;
 
 		sg_span = sched_group_cpus(sg);
-		if (child->child) {
-			child = child->child;
-			cpumask_copy(sg_span, sched_domain_span(child));
-		} else
+		if (sibling->child)
+			cpumask_copy(sg_span, sched_domain_span(sibling->child));
+		else
 			cpumask_set_cpu(i, sg_span);
 
 		cpumask_or(covered, covered, sg_span);
@@ -7124,13 +7204,13 @@ static void normalize_task(struct rq *rq, struct task_struct *p)
 		.sched_policy = SCHED_NORMAL,
 	};
 	int old_prio = p->prio;
-	int on_rq;
+	int queued;
 
-	on_rq = p->on_rq;
-	if (on_rq)
+	queued = task_on_rq_queued(p);
+	if (queued)
 		dequeue_task(rq, p, 0);
 	__setscheduler(rq, p, &attr);
-	if (on_rq) {
+	if (queued) {
 		enqueue_task(rq, p, 0);
 		resched_curr(rq);
 	}
@@ -7144,12 +7224,12 @@ void normalize_rt_tasks(void)
 	unsigned long flags;
 	struct rq *rq;
 
-	read_lock_irqsave(&tasklist_lock, flags);
-	do_each_thread(g, p) {
+	read_lock(&tasklist_lock);
+	for_each_process_thread(g, p) {
 		/*
 		 * Only normalize user tasks:
 		 */
-		if (!p->mm)
+		if (p->flags & PF_KTHREAD)
 			continue;
 
 		p->se.exec_start		= 0;
@@ -7164,21 +7244,16 @@ void normalize_rt_tasks(void)
 			 * Renice negative nice level userspace
 			 * tasks back to 0:
 			 */
-			if (task_nice(p) < 0 && p->mm)
+			if (task_nice(p) < 0)
 				set_user_nice(p, 0);
 			continue;
 		}
 
-		raw_spin_lock(&p->pi_lock);
-		rq = __task_rq_lock(p);
-
+		rq = task_rq_lock(p, &flags);
 		normalize_task(rq, p);
-
-		__task_rq_unlock(rq);
-		raw_spin_unlock(&p->pi_lock);
-	} while_each_thread(g, p);
-
-	read_unlock_irqrestore(&tasklist_lock, flags);
+		task_rq_unlock(rq, p, &flags);
+	}
+	read_unlock(&tasklist_lock);
 }
 
 #endif /* CONFIG_MAGIC_SYSRQ */
@@ -7318,19 +7393,19 @@ void sched_offline_group(struct task_group *tg)
 void sched_move_task(struct task_struct *tsk)
 {
 	struct task_group *tg;
-	int on_rq, running;
+	int queued, running;
 	unsigned long flags;
 	struct rq *rq;
 
 	rq = task_rq_lock(tsk, &flags);
 
 	running = task_current(rq, tsk);
-	on_rq = tsk->on_rq;
+	queued = task_on_rq_queued(tsk);
 
-	if (on_rq)
+	if (queued)
 		dequeue_task(rq, tsk, 0);
 	if (unlikely(running))
-		tsk->sched_class->put_prev_task(rq, tsk);
+		put_prev_task(rq, tsk);
 
 	tg = container_of(task_css_check(tsk, cpu_cgrp_id,
 				lockdep_is_held(&tsk->sighand->siglock)),
@@ -7340,14 +7415,14 @@ void sched_move_task(struct task_struct *tsk)
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	if (tsk->sched_class->task_move_group)
-		tsk->sched_class->task_move_group(tsk, on_rq);
+		tsk->sched_class->task_move_group(tsk, queued);
 	else
 #endif
 		set_task_rq(tsk, task_cpu(tsk));
 
 	if (unlikely(running))
 		tsk->sched_class->set_curr_task(rq);
-	if (on_rq)
+	if (queued)
 		enqueue_task(rq, tsk, 0);
 
 	task_rq_unlock(rq, tsk, &flags);
@@ -7365,10 +7440,10 @@ static inline int tg_has_rt_tasks(struct task_group *tg)
 {
 	struct task_struct *g, *p;
 
-	do_each_thread(g, p) {
-		if (rt_task(p) && task_rq(p)->rt.tg == tg)
+	for_each_process_thread(g, p) {
+		if (rt_task(p) && task_group(p) == tg)
 			return 1;
-	} while_each_thread(g, p);
+	}
 
 	return 0;
 }
@@ -7577,6 +7652,7 @@ static int sched_dl_global_constraints(void)
 	u64 runtime = global_rt_runtime();
 	u64 period = global_rt_period();
 	u64 new_bw = to_ratio(period, runtime);
+	struct dl_bw *dl_b;
 	int cpu, ret = 0;
 	unsigned long flags;
 
@@ -7590,13 +7666,16 @@ static int sched_dl_global_constraints(void)
 	 * solutions is welcome!
 	 */
 	for_each_possible_cpu(cpu) {
-		struct dl_bw *dl_b = dl_bw_of(cpu);
+		rcu_read_lock_sched();
+		dl_b = dl_bw_of(cpu);
 
 		raw_spin_lock_irqsave(&dl_b->lock, flags);
 		if (new_bw < dl_b->total_bw)
 			ret = -EBUSY;
 		raw_spin_unlock_irqrestore(&dl_b->lock, flags);
 
+		rcu_read_unlock_sched();
+
 		if (ret)
 			break;
 	}
@@ -7607,6 +7686,7 @@ static int sched_dl_global_constraints(void)
 static void sched_dl_do_global(void)
 {
 	u64 new_bw = -1;
+	struct dl_bw *dl_b;
 	int cpu;
 	unsigned long flags;
 
@@ -7620,11 +7700,14 @@ static void sched_dl_do_global(void)
 	 * FIXME: As above...
 	 */
 	for_each_possible_cpu(cpu) {
-		struct dl_bw *dl_b = dl_bw_of(cpu);
+		rcu_read_lock_sched();
+		dl_b = dl_bw_of(cpu);
 
 		raw_spin_lock_irqsave(&dl_b->lock, flags);
 		dl_b->bw = new_bw;
 		raw_spin_unlock_irqrestore(&dl_b->lock, flags);
+
+		rcu_read_unlock_sched();
 	}
 }
 
@@ -8005,7 +8088,7 @@ static int tg_cfs_schedulable_down(struct task_group *tg, void *data)
 		struct cfs_bandwidth *parent_b = &tg->parent->cfs_bandwidth;
 
 		quota = normalize_cfs_quota(tg, d);
-		parent_quota = parent_b->hierarchal_quota;
+		parent_quota = parent_b->hierarchical_quota;
 
 		/*
 		 * ensure max(child_quota) <= parent_quota, inherit when no
@@ -8016,7 +8099,7 @@ static int tg_cfs_schedulable_down(struct task_group *tg, void *data)
 		else if (parent_quota != RUNTIME_INF && quota > parent_quota)
 			return -EINVAL;
 	}
-	cfs_b->hierarchal_quota = quota;
+	cfs_b->hierarchical_quota = quota;
 
 	return 0;
 }
diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index bd95963dae80..539ca3ce071b 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -107,9 +107,7 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
 	int best_cpu = -1;
 	const struct sched_dl_entity *dl_se = &p->dl;
 
-	if (later_mask && cpumask_and(later_mask, cp->free_cpus,
-			&p->cpus_allowed) && cpumask_and(later_mask,
-			later_mask, cpu_active_mask)) {
+	if (later_mask && cpumask_and(later_mask, later_mask, cp->free_cpus)) {
 		best_cpu = cpumask_any(later_mask);
 		goto out;
 	} else if (cpumask_test_cpu(cpudl_maximum(cp), &p->cpus_allowed) &&
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 72fdf06ef865..8394b1ee600c 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -288,24 +288,29 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 	struct signal_struct *sig = tsk->signal;
 	cputime_t utime, stime;
 	struct task_struct *t;
-
-	times->utime = sig->utime;
-	times->stime = sig->stime;
-	times->sum_exec_runtime = sig->sum_sched_runtime;
+	unsigned int seq, nextseq;
+	unsigned long flags;
 
 	rcu_read_lock();
-	/* make sure we can trust tsk->thread_group list */
-	if (!likely(pid_alive(tsk)))
-		goto out;
-
-	t = tsk;
+	/* Attempt a lockless read on the first round. */
+	nextseq = 0;
 	do {
-		task_cputime(t, &utime, &stime);
-		times->utime += utime;
-		times->stime += stime;
-		times->sum_exec_runtime += task_sched_runtime(t);
-	} while_each_thread(tsk, t);
-out:
+		seq = nextseq;
+		flags = read_seqbegin_or_lock_irqsave(&sig->stats_lock, &seq);
+		times->utime = sig->utime;
+		times->stime = sig->stime;
+		times->sum_exec_runtime = sig->sum_sched_runtime;
+
+		for_each_thread(tsk, t) {
+			task_cputime(t, &utime, &stime);
+			times->utime += utime;
+			times->stime += stime;
+			times->sum_exec_runtime += task_sched_runtime(t);
+		}
+		/* If lockless access failed, take the lock. */
+		nextseq = 1;
+	} while (need_seqretry(&sig->stats_lock, seq));
+	done_seqretry_irqrestore(&sig->stats_lock, seq, flags);
 	rcu_read_unlock();
 }
 
@@ -550,6 +555,23 @@ static cputime_t scale_stime(u64 stime, u64 rtime, u64 total)
 }
 
 /*
+ * Atomically advance counter to the new value. Interrupts, vcpu
+ * scheduling, and scaling inaccuracies can cause cputime_advance
+ * to be occasionally called with a new value smaller than counter.
+ * Let's enforce atomicity.
+ *
+ * Normally a caller will only go through this loop once, or not
+ * at all in case a previous caller updated counter the same jiffy.
+ */
+static void cputime_advance(cputime_t *counter, cputime_t new)
+{
+	cputime_t old;
+
+	while (new > (old = ACCESS_ONCE(*counter)))
+		cmpxchg_cputime(counter, old, new);
+}
+
+/*
  * Adjust tick based cputime random precision against scheduler
  * runtime accounting.
  */
@@ -594,13 +616,8 @@ static void cputime_adjust(struct task_cputime *curr,
 		utime = rtime - stime;
 	}
 
-	/*
-	 * If the tick based count grows faster than the scheduler one,
-	 * the result of the scaling may go backward.
-	 * Let's enforce monotonicity.
-	 */
-	prev->stime = max(prev->stime, stime);
-	prev->utime = max(prev->utime, utime);
+	cputime_advance(&prev->stime, stime);
+	cputime_advance(&prev->utime, utime);
 
 out:
 	*ut = prev->utime;
@@ -617,9 +634,6 @@ void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	cputime_adjust(&cputime, &p->prev_cputime, ut, st);
 }
 
-/*
- * Must be called with siglock held.
- */
 void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
 	struct task_cputime cputime;
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 255ce138b652..abfaf3d9a29f 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -530,7 +530,7 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 	update_rq_clock(rq);
 	dl_se->dl_throttled = 0;
 	dl_se->dl_yielded = 0;
-	if (p->on_rq) {
+	if (task_on_rq_queued(p)) {
 		enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
 		if (task_has_dl_policy(rq->curr))
 			check_preempt_curr_dl(rq, p, 0);
@@ -997,10 +997,7 @@ static void check_preempt_curr_dl(struct rq *rq, struct task_struct *p,
 #ifdef CONFIG_SCHED_HRTICK
 static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
 {
-	s64 delta = p->dl.dl_runtime - p->dl.runtime;
-
-	if (delta > 10000)
-		hrtick_start(rq, p->dl.runtime);
+	hrtick_start(rq, p->dl.runtime);
 }
 #endif
 
@@ -1030,7 +1027,7 @@ struct task_struct *pick_next_task_dl(struct rq *rq, struct task_struct *prev)
 		 * means a stop task can slip in, in which case we need to
 		 * re-start task selection.
 		 */
-		if (rq->stop && rq->stop->on_rq)
+		if (rq->stop && task_on_rq_queued(rq->stop))
 			return RETRY_TASK;
 	}
 
@@ -1124,10 +1121,8 @@ static void set_curr_task_dl(struct rq *rq)
 static int pick_dl_task(struct rq *rq, struct task_struct *p, int cpu)
 {
 	if (!task_running(rq, p) &&
-	    (cpu < 0 || cpumask_test_cpu(cpu, &p->cpus_allowed)) &&
-	    (p->nr_cpus_allowed > 1))
+	    cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
 		return 1;
-
 	return 0;
 }
 
@@ -1169,6 +1164,13 @@ static int find_later_rq(struct task_struct *task)
 	if (task->nr_cpus_allowed == 1)
 		return -1;
 
+	/*
+	 * We have to consider system topology and task affinity
+	 * first, then we can look for a suitable cpu.
+	 */
+	cpumask_copy(later_mask, task_rq(task)->rd->span);
+	cpumask_and(later_mask, later_mask, cpu_active_mask);
+	cpumask_and(later_mask, later_mask, &task->cpus_allowed);
 	best_cpu = cpudl_find(&task_rq(task)->rd->cpudl,
 			task, later_mask);
 	if (best_cpu == -1)
@@ -1257,7 +1259,8 @@ static struct rq *find_lock_later_rq(struct task_struct *task, struct rq *rq)
 			if (unlikely(task_rq(task) != rq ||
 				     !cpumask_test_cpu(later_rq->cpu,
 				                       &task->cpus_allowed) ||
-				     task_running(rq, task) || !task->on_rq)) {
+				     task_running(rq, task) ||
+				     !task_on_rq_queued(task))) {
 				double_unlock_balance(rq, later_rq);
 				later_rq = NULL;
 				break;
@@ -1296,7 +1299,7 @@ static struct task_struct *pick_next_pushable_dl_task(struct rq *rq)
 	BUG_ON(task_current(rq, p));
 	BUG_ON(p->nr_cpus_allowed <= 1);
 
-	BUG_ON(!p->on_rq);
+	BUG_ON(!task_on_rq_queued(p));
 	BUG_ON(!dl_task(p));
 
 	return p;
@@ -1443,7 +1446,7 @@ static int pull_dl_task(struct rq *this_rq)
 		     dl_time_before(p->dl.deadline,
 				    this_rq->dl.earliest_dl.curr))) {
 			WARN_ON(p == src_rq->curr);
-			WARN_ON(!p->on_rq);
+			WARN_ON(!task_on_rq_queued(p));
 
 			/*
 			 * Then we pull iff p has actually an earlier
@@ -1569,6 +1572,8 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 	if (hrtimer_active(&p->dl.dl_timer) && !dl_policy(p->policy))
 		hrtimer_try_to_cancel(&p->dl.dl_timer);
 
+	__dl_clear_params(p);
+
 #ifdef CONFIG_SMP
 	/*
 	 * Since this might be the only -deadline task on the rq,
@@ -1596,7 +1601,7 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 	if (unlikely(p->dl.dl_throttled))
 		return;
 
-	if (p->on_rq && rq->curr != p) {
+	if (task_on_rq_queued(p) && rq->curr != p) {
 #ifdef CONFIG_SMP
 		if (rq->dl.overloaded && push_dl_task(rq) && rq != task_rq(p))
 			/* Only reschedule if pushing failed */
@@ -1614,7 +1619,7 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 static void prio_changed_dl(struct rq *rq, struct task_struct *p,
 			    int oldprio)
 {
-	if (p->on_rq || rq->curr == p) {
+	if (task_on_rq_queued(p) || rq->curr == p) {
 #ifdef CONFIG_SMP
 		/*
 		 * This might be too much, but unfortunately
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 627b3c34b821..ce33780d8f20 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -150,7 +150,6 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
 {
 	struct task_struct *g, *p;
-	unsigned long flags;
 
 	SEQ_printf(m,
 	"\nrunnable tasks:\n"
@@ -159,16 +158,14 @@ static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
 	"------------------------------------------------------"
 	"----------------------------------------------------\n");
 
-	read_lock_irqsave(&tasklist_lock, flags);
-
-	do_each_thread(g, p) {
+	rcu_read_lock();
+	for_each_process_thread(g, p) {
 		if (task_cpu(p) != rq_cpu)
 			continue;
 
 		print_task(m, rq, p);
-	} while_each_thread(g, p);
-
-	read_unlock_irqrestore(&tasklist_lock, flags);
+	}
+	rcu_read_unlock();
 }
 
 void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
@@ -333,9 +330,7 @@ do {									\
 	print_cfs_stats(m, cpu);
 	print_rt_stats(m, cpu);
 
-	rcu_read_lock();
 	print_rq(m, rq, cpu);
-	rcu_read_unlock();
 	spin_unlock_irqrestore(&sched_debug_lock, flags);
 	SEQ_printf(m, "\n");
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bfa3c86d0d68..bd61cff8ee4f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -23,6 +23,7 @@
 #include <linux/latencytop.h>
 #include <linux/sched.h>
 #include <linux/cpumask.h>
+#include <linux/cpuidle.h>
 #include <linux/slab.h>
 #include <linux/profile.h>
 #include <linux/interrupt.h>
@@ -665,6 +666,7 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 }
 
 #ifdef CONFIG_SMP
+static int select_idle_sibling(struct task_struct *p, int cpu);
 static unsigned long task_h_load(struct task_struct *p);
 
 static inline void __update_task_entity_contrib(struct sched_entity *se);
@@ -1038,7 +1040,8 @@ struct numa_stats {
  */
 static void update_numa_stats(struct numa_stats *ns, int nid)
 {
-	int cpu, cpus = 0;
+	int smt, cpu, cpus = 0;
+	unsigned long capacity;
 
 	memset(ns, 0, sizeof(*ns));
 	for_each_cpu(cpu, cpumask_of_node(nid)) {
@@ -1062,8 +1065,12 @@ static void update_numa_stats(struct numa_stats *ns, int nid)
 	if (!cpus)
 		return;
 
-	ns->task_capacity =
-		DIV_ROUND_CLOSEST(ns->compute_capacity, SCHED_CAPACITY_SCALE);
+	/* smt := ceil(cpus / capacity), assumes: 1 < smt_power < 2 */
+	smt = DIV_ROUND_UP(SCHED_CAPACITY_SCALE * cpus, ns->compute_capacity);
+	capacity = cpus / smt; /* cores */
+
+	ns->task_capacity = min_t(unsigned, capacity,
+		DIV_ROUND_CLOSEST(ns->compute_capacity, SCHED_CAPACITY_SCALE));
 	ns->has_free_capacity = (ns->nr_running < ns->task_capacity);
 }
 
@@ -1206,7 +1213,7 @@ static void task_numa_compare(struct task_numa_env *env,
 
 	if (!cur) {
 		/* Is there capacity at our destination? */
-		if (env->src_stats.has_free_capacity &&
+		if (env->src_stats.nr_running <= env->src_stats.task_capacity &&
 		    !env->dst_stats.has_free_capacity)
 			goto unlock;
 
@@ -1252,6 +1259,13 @@ static void task_numa_compare(struct task_numa_env *env,
 	if (load_too_imbalanced(src_load, dst_load, env))
 		goto unlock;
 
+	/*
+	 * One idle CPU per node is evaluated for a task numa move.
+	 * Call select_idle_sibling to maybe find a better one.
+	 */
+	if (!cur)
+		env->dst_cpu = select_idle_sibling(env->p, env->dst_cpu);
+
 assign:
 	task_numa_assign(env, cur, imp);
 unlock:
@@ -1775,7 +1789,7 @@ void task_numa_free(struct task_struct *p)
 		list_del(&p->numa_entry);
 		grp->nr_tasks--;
 		spin_unlock_irqrestore(&grp->lock, flags);
-		rcu_assign_pointer(p->numa_group, NULL);
+		RCU_INIT_POINTER(p->numa_group, NULL);
 		put_numa_group(grp);
 	}
 
@@ -1804,10 +1818,6 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	if (!p->mm)
 		return;
 
-	/* Do not worry about placement if exiting */
-	if (p->state == TASK_DEAD)
-		return;
-
 	/* Allocate buffer to track faults on a per-node basis */
 	if (unlikely(!p->numa_faults_memory)) {
 		int size = sizeof(*p->numa_faults_memory) *
@@ -2211,8 +2221,8 @@ static __always_inline u64 decay_load(u64 val, u64 n)
 
 	/*
 	 * As y^PERIOD = 1/2, we can combine
-	 *    y^n = 1/2^(n/PERIOD) * k^(n%PERIOD)
-	 * With a look-up table which covers k^n (n<PERIOD)
+	 *    y^n = 1/2^(n/PERIOD) * y^(n%PERIOD)
+	 * With a look-up table which covers y^n (n<PERIOD)
 	 *
 	 * To achieve constant time decay_load.
 	 */
@@ -2377,6 +2387,9 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
 	tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
 	tg_contrib -= cfs_rq->tg_load_contrib;
 
+	if (!tg_contrib)
+		return;
+
 	if (force_update || abs(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
 		atomic_long_add(tg_contrib, &tg->load_avg);
 		cfs_rq->tg_load_contrib += tg_contrib;
@@ -3892,14 +3905,6 @@ static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
 				resched_curr(rq);
 			return;
 		}
-
-		/*
-		 * Don't schedule slices shorter than 10000ns, that just
-		 * doesn't make sense. Rely on vruntime for fairness.
-		 */
-		if (rq->curr != p)
-			delta = max_t(s64, 10000LL, delta);
-
 		hrtick_start(rq, delta);
 	}
 }
@@ -4087,7 +4092,7 @@ static unsigned long capacity_of(int cpu)
 static unsigned long cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
-	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
+	unsigned long nr_running = ACCESS_ONCE(rq->cfs.h_nr_running);
 	unsigned long load_avg = rq->cfs.runnable_load_avg;
 
 	if (nr_running)
@@ -4276,8 +4281,8 @@ static int wake_wide(struct task_struct *p)
 static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 {
 	s64 this_load, load;
+	s64 this_eff_load, prev_eff_load;
 	int idx, this_cpu, prev_cpu;
-	unsigned long tl_per_task;
 	struct task_group *tg;
 	unsigned long weight;
 	int balanced;
@@ -4320,47 +4325,30 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	 * Otherwise check if either cpus are near enough in load to allow this
 	 * task to be woken on this_cpu.
 	 */
-	if (this_load > 0) {
-		s64 this_eff_load, prev_eff_load;
+	this_eff_load = 100;
+	this_eff_load *= capacity_of(prev_cpu);
 
-		this_eff_load = 100;
-		this_eff_load *= capacity_of(prev_cpu);
+	prev_eff_load = 100 + (sd->imbalance_pct - 100) / 2;
+	prev_eff_load *= capacity_of(this_cpu);
+
+	if (this_load > 0) {
 		this_eff_load *= this_load +
 			effective_load(tg, this_cpu, weight, weight);
 
-		prev_eff_load = 100 + (sd->imbalance_pct - 100) / 2;
-		prev_eff_load *= capacity_of(this_cpu);
 		prev_eff_load *= load + effective_load(tg, prev_cpu, 0, weight);
+	}
 
-		balanced = this_eff_load <= prev_eff_load;
-	} else
-		balanced = true;
-
-	/*
-	 * If the currently running task will sleep within
-	 * a reasonable amount of time then attract this newly
-	 * woken task:
-	 */
-	if (sync && balanced)
-		return 1;
+	balanced = this_eff_load <= prev_eff_load;
 
 	schedstat_inc(p, se.statistics.nr_wakeups_affine_attempts);
-	tl_per_task = cpu_avg_load_per_task(this_cpu);
 
-	if (balanced ||
-	    (this_load <= load &&
-	     this_load + target_load(prev_cpu, idx) <= tl_per_task)) {
-		/*
-		 * This domain has SD_WAKE_AFFINE and
-		 * p is cache cold in this domain, and
-		 * there is no bad imbalance.
-		 */
-		schedstat_inc(sd, ttwu_move_affine);
-		schedstat_inc(p, se.statistics.nr_wakeups_affine);
+	if (!balanced)
+		return 0;
 
-		return 1;
-	}
-	return 0;
+	schedstat_inc(sd, ttwu_move_affine);
+	schedstat_inc(p, se.statistics.nr_wakeups_affine);
+
+	return 1;
 }
 
 /*
@@ -4428,20 +4416,46 @@ static int
 find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 {
 	unsigned long load, min_load = ULONG_MAX;
-	int idlest = -1;
+	unsigned int min_exit_latency = UINT_MAX;
+	u64 latest_idle_timestamp = 0;
+	int least_loaded_cpu = this_cpu;
+	int shallowest_idle_cpu = -1;
 	int i;
 
 	/* Traverse only the allowed CPUs */
 	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpus_allowed(p)) {
-		load = weighted_cpuload(i);
-
-		if (load < min_load || (load == min_load && i == this_cpu)) {
-			min_load = load;
-			idlest = i;
+		if (idle_cpu(i)) {
+			struct rq *rq = cpu_rq(i);
+			struct cpuidle_state *idle = idle_get_state(rq);
+			if (idle && idle->exit_latency < min_exit_latency) {
+				/*
+				 * We give priority to a CPU whose idle state
+				 * has the smallest exit latency irrespective
+				 * of any idle timestamp.
+				 */
+				min_exit_latency = idle->exit_latency;
+				latest_idle_timestamp = rq->idle_stamp;
+				shallowest_idle_cpu = i;
+			} else if ((!idle || idle->exit_latency == min_exit_latency) &&
+				   rq->idle_stamp > latest_idle_timestamp) {
+				/*
+				 * If equal or no active idle state, then
+				 * the most recently idled CPU might have
+				 * a warmer cache.
+				 */
+				latest_idle_timestamp = rq->idle_stamp;
+				shallowest_idle_cpu = i;
+			}
+		} else {
+			load = weighted_cpuload(i);
+			if (load < min_load || (load == min_load && i == this_cpu)) {
+				min_load = load;
+				least_loaded_cpu = i;
+			}
 		}
 	}
 
-	return idlest;
+	return shallowest_idle_cpu != -1 ? shallowest_idle_cpu : least_loaded_cpu;
 }
 
 /*
@@ -4513,11 +4527,8 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 	if (p->nr_cpus_allowed == 1)
 		return prev_cpu;
 
-	if (sd_flag & SD_BALANCE_WAKE) {
-		if (cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
-			want_affine = 1;
-		new_cpu = prev_cpu;
-	}
+	if (sd_flag & SD_BALANCE_WAKE)
+		want_affine = cpumask_test_cpu(cpu, tsk_cpus_allowed(p));
 
 	rcu_read_lock();
 	for_each_domain(cpu, tmp) {
@@ -4704,7 +4715,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 		return;
 
 	/*
-	 * This is possible from callers such as move_task(), in which we
+	 * This is possible from callers such as attach_tasks(), in which we
 	 * unconditionally check_prempt_curr() after an enqueue (which may have
 	 * lead to a throttle).  This both saves work and prevents false
 	 * next-buddy nomination below.
@@ -5112,27 +5123,18 @@ struct lb_env {
 	unsigned int		loop_max;
 
 	enum fbq_type		fbq_type;
+	struct list_head	tasks;
 };
 
 /*
- * move_task - move a task from one runqueue to another runqueue.
- * Both runqueues must be locked.
- */
-static void move_task(struct task_struct *p, struct lb_env *env)
-{
-	deactivate_task(env->src_rq, p, 0);
-	set_task_cpu(p, env->dst_cpu);
-	activate_task(env->dst_rq, p, 0);
-	check_preempt_curr(env->dst_rq, p, 0);
-}
-
-/*
  * Is this task likely cache-hot:
  */
 static int task_hot(struct task_struct *p, struct lb_env *env)
 {
 	s64 delta;
 
+	lockdep_assert_held(&env->src_rq->lock);
+
 	if (p->sched_class != &fair_sched_class)
 		return 0;
 
@@ -5252,6 +5254,9 @@ static
 int can_migrate_task(struct task_struct *p, struct lb_env *env)
 {
 	int tsk_cache_hot = 0;
+
+	lockdep_assert_held(&env->src_rq->lock);
+
 	/*
 	 * We do not migrate tasks that are:
 	 * 1) throttled_lb_pair, or
@@ -5310,24 +5315,12 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	if (!tsk_cache_hot)
 		tsk_cache_hot = migrate_degrades_locality(p, env);
 
-	if (migrate_improves_locality(p, env)) {
-#ifdef CONFIG_SCHEDSTATS
+	if (migrate_improves_locality(p, env) || !tsk_cache_hot ||
+	    env->sd->nr_balance_failed > env->sd->cache_nice_tries) {
 		if (tsk_cache_hot) {
 			schedstat_inc(env->sd, lb_hot_gained[env->idle]);
 			schedstat_inc(p, se.statistics.nr_forced_migrations);
 		}
-#endif
-		return 1;
-	}
-
-	if (!tsk_cache_hot ||
-		env->sd->nr_balance_failed > env->sd->cache_nice_tries) {
-
-		if (tsk_cache_hot) {
-			schedstat_inc(env->sd, lb_hot_gained[env->idle]);
-			schedstat_inc(p, se.statistics.nr_forced_migrations);
-		}
-
 		return 1;
 	}
 
@@ -5336,47 +5329,63 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 }
 
 /*
- * move_one_task tries to move exactly one task from busiest to this_rq, as
+ * detach_task() -- detach the task for the migration specified in env
+ */
+static void detach_task(struct task_struct *p, struct lb_env *env)
+{
+	lockdep_assert_held(&env->src_rq->lock);
+
+	deactivate_task(env->src_rq, p, 0);
+	p->on_rq = TASK_ON_RQ_MIGRATING;
+	set_task_cpu(p, env->dst_cpu);
+}
+
+/*
+ * detach_one_task() -- tries to dequeue exactly one task from env->src_rq, as
  * part of active balancing operations within "domain".
- * Returns 1 if successful and 0 otherwise.
  *
- * Called with both runqueues locked.
+ * Returns a task if successful and NULL otherwise.
  */
-static int move_one_task(struct lb_env *env)
+static struct task_struct *detach_one_task(struct lb_env *env)
 {
 	struct task_struct *p, *n;
 
+	lockdep_assert_held(&env->src_rq->lock);
+
 	list_for_each_entry_safe(p, n, &env->src_rq->cfs_tasks, se.group_node) {
 		if (!can_migrate_task(p, env))
 			continue;
 
-		move_task(p, env);
+		detach_task(p, env);
+
 		/*
-		 * Right now, this is only the second place move_task()
-		 * is called, so we can safely collect move_task()
-		 * stats here rather than inside move_task().
+		 * Right now, this is only the second place where
+		 * lb_gained[env->idle] is updated (other is detach_tasks)
+		 * so we can safely collect stats here rather than
+		 * inside detach_tasks().
 		 */
 		schedstat_inc(env->sd, lb_gained[env->idle]);
-		return 1;
+		return p;
 	}
-	return 0;
+	return NULL;
 }
 
 static const unsigned int sched_nr_migrate_break = 32;
 
 /*
- * move_tasks tries to move up to imbalance weighted load from busiest to
- * this_rq, as part of a balancing operation within domain "sd".
- * Returns 1 if successful and 0 otherwise.
+ * detach_tasks() -- tries to detach up to imbalance weighted load from
+ * busiest_rq, as part of a balancing operation within domain "sd".
  *
- * Called with both runqueues locked.
+ * Returns number of detached tasks if successful and 0 otherwise.
  */
-static int move_tasks(struct lb_env *env)
+static int detach_tasks(struct lb_env *env)
 {
 	struct list_head *tasks = &env->src_rq->cfs_tasks;
 	struct task_struct *p;
 	unsigned long load;
-	int pulled = 0;
+	int detached = 0;
+
+	lockdep_assert_held(&env->src_rq->lock);
 
 	if (env->imbalance <= 0)
 		return 0;
@@ -5407,14 +5416,16 @@ static int move_tasks(struct lb_env *env)
 		if ((load / 2) > env->imbalance)
 			goto next;
 
-		move_task(p, env);
-		pulled++;
+		detach_task(p, env);
+		list_add(&p->se.group_node, &env->tasks);
+
+		detached++;
 		env->imbalance -= load;
 
 #ifdef CONFIG_PREEMPT
 		/*
 		 * NEWIDLE balancing is a source of latency, so preemptible
-		 * kernels will stop after the first task is pulled to minimize
+		 * kernels will stop after the first task is detached to minimize
 		 * the critical section.
 		 */
 		if (env->idle == CPU_NEWLY_IDLE)
@@ -5434,13 +5445,58 @@ static int move_tasks(struct lb_env *env)
 	}
 
 	/*
-	 * Right now, this is one of only two places move_task() is called,
-	 * so we can safely collect move_task() stats here rather than
-	 * inside move_task().
+	 * Right now, this is one of only two places we collect this stat
+	 * so we can safely collect detach_one_task() stats here rather
+	 * than inside detach_one_task().
 	 */
-	schedstat_add(env->sd, lb_gained[env->idle], pulled);
+	schedstat_add(env->sd, lb_gained[env->idle], detached);
+
+	return detached;
+}
+
+/*
+ * attach_task() -- attach the task detached by detach_task() to its new rq.
+ */
+static void attach_task(struct rq *rq, struct task_struct *p)
+{
+	lockdep_assert_held(&rq->lock);
+
+	BUG_ON(task_rq(p) != rq);
+	p->on_rq = TASK_ON_RQ_QUEUED;
+	activate_task(rq, p, 0);
+	check_preempt_curr(rq, p, 0);
+}
+
+/*
+ * attach_one_task() -- attaches the task returned from detach_one_task() to
+ * its new rq.
+ */
+static void attach_one_task(struct rq *rq, struct task_struct *p)
+{
+	raw_spin_lock(&rq->lock);
+	attach_task(rq, p);
+	raw_spin_unlock(&rq->lock);
+}
+
+/*
+ * attach_tasks() -- attaches all tasks detached by detach_tasks() to their
+ * new rq.
+ */
+static void attach_tasks(struct lb_env *env)
+{
+	struct list_head *tasks = &env->tasks;
+	struct task_struct *p;
+
+	raw_spin_lock(&env->dst_rq->lock);
+
+	while (!list_empty(tasks)) {
+		p = list_first_entry(tasks, struct task_struct, se.group_node);
+		list_del_init(&p->se.group_node);
 
-	return pulled;
+		attach_task(env->dst_rq, p);
+	}
+
+	raw_spin_unlock(&env->dst_rq->lock);
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -5559,6 +5615,13 @@ static unsigned long task_h_load(struct task_struct *p)
 #endif
 
 /********** Helpers for find_busiest_group ************************/
+
+enum group_type {
+	group_other = 0,
+	group_imbalanced,
+	group_overloaded,
+};
+
 /*
  * sg_lb_stats - stats of a sched_group required for load_balancing
  */
@@ -5572,7 +5635,7 @@ struct sg_lb_stats {
 	unsigned int group_capacity_factor;
 	unsigned int idle_cpus;
 	unsigned int group_weight;
-	int group_imb; /* Is there an imbalance in the group ? */
+	enum group_type group_type;
 	int group_has_free_capacity;
 #ifdef CONFIG_NUMA_BALANCING
 	unsigned int nr_numa_running;
@@ -5610,6 +5673,8 @@ static inline void init_sd_lb_stats(struct sd_lb_stats *sds)
 		.total_capacity = 0UL,
 		.busiest_stat = {
 			.avg_load = 0UL,
+			.sum_nr_running = 0,
+			.group_type = group_other,
 		},
 	};
 }
@@ -5652,19 +5717,17 @@ unsigned long __weak arch_scale_freq_capacity(struct sched_domain *sd, int cpu)
 	return default_scale_capacity(sd, cpu);
 }
 
-static unsigned long default_scale_smt_capacity(struct sched_domain *sd, int cpu)
+static unsigned long default_scale_cpu_capacity(struct sched_domain *sd, int cpu)
 {
-	unsigned long weight = sd->span_weight;
-	unsigned long smt_gain = sd->smt_gain;
+	if ((sd->flags & SD_SHARE_CPUCAPACITY) && (sd->span_weight > 1))
+		return sd->smt_gain / sd->span_weight;
 
-	smt_gain /= weight;
-
-	return smt_gain;
+	return SCHED_CAPACITY_SCALE;
 }
 
-unsigned long __weak arch_scale_smt_capacity(struct sched_domain *sd, int cpu)
+unsigned long __weak arch_scale_cpu_capacity(struct sched_domain *sd, int cpu)
 {
-	return default_scale_smt_capacity(sd, cpu);
+	return default_scale_cpu_capacity(sd, cpu);
 }
 
 static unsigned long scale_rt_capacity(int cpu)
@@ -5703,18 +5766,15 @@ static unsigned long scale_rt_capacity(int cpu)
 
 static void update_cpu_capacity(struct sched_domain *sd, int cpu)
 {
-	unsigned long weight = sd->span_weight;
 	unsigned long capacity = SCHED_CAPACITY_SCALE;
 	struct sched_group *sdg = sd->groups;
 
-	if ((sd->flags & SD_SHARE_CPUCAPACITY) && weight > 1) {
-		if (sched_feat(ARCH_CAPACITY))
-			capacity *= arch_scale_smt_capacity(sd, cpu);
-		else
-			capacity *= default_scale_smt_capacity(sd, cpu);
+	if (sched_feat(ARCH_CAPACITY))
+		capacity *= arch_scale_cpu_capacity(sd, cpu);
+	else
+		capacity *= default_scale_cpu_capacity(sd, cpu);
 
-		capacity >>= SCHED_CAPACITY_SHIFT;
-	}
+	capacity >>= SCHED_CAPACITY_SHIFT;
 
 	sdg->sgc->capacity_orig = capacity;
 
@@ -5891,6 +5951,18 @@ static inline int sg_capacity_factor(struct lb_env *env, struct sched_group *gro
 	return capacity_factor;
 }
 
+static enum group_type
+group_classify(struct sched_group *group, struct sg_lb_stats *sgs)
+{
+	if (sgs->sum_nr_running > sgs->group_capacity_factor)
+		return group_overloaded;
+
+	if (sg_imbalanced(group))
+		return group_imbalanced;
+
+	return group_other;
+}
+
 /**
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
  * @env: The load balancing environment.
@@ -5920,7 +5992,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			load = source_load(i, load_idx);
 
 		sgs->group_load += load;
-		sgs->sum_nr_running += rq->nr_running;
+		sgs->sum_nr_running += rq->cfs.h_nr_running;
 
 		if (rq->nr_running > 1)
 			*overload = true;
@@ -5942,9 +6014,8 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		sgs->load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
 
 	sgs->group_weight = group->group_weight;
-
-	sgs->group_imb = sg_imbalanced(group);
 	sgs->group_capacity_factor = sg_capacity_factor(env, group);
+	sgs->group_type = group_classify(group, sgs);
 
 	if (sgs->group_capacity_factor > sgs->sum_nr_running)
 		sgs->group_has_free_capacity = 1;
@@ -5968,13 +6039,19 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 				   struct sched_group *sg,
 				   struct sg_lb_stats *sgs)
 {
-	if (sgs->avg_load <= sds->busiest_stat.avg_load)
-		return false;
+	struct sg_lb_stats *busiest = &sds->busiest_stat;
 
-	if (sgs->sum_nr_running > sgs->group_capacity_factor)
+	if (sgs->group_type > busiest->group_type)
 		return true;
 
-	if (sgs->group_imb)
+	if (sgs->group_type < busiest->group_type)
+		return false;
+
+	if (sgs->avg_load <= busiest->avg_load)
+		return false;
+
+	/* This is the busiest node in its class. */
+	if (!(env->sd->flags & SD_ASYM_PACKING))
 		return true;
 
 	/*
@@ -5982,8 +6059,7 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 	 * numbered CPUs in the group, therefore mark all groups
 	 * higher than ourself as busy.
 	 */
-	if ((env->sd->flags & SD_ASYM_PACKING) && sgs->sum_nr_running &&
-	    env->dst_cpu < group_first_cpu(sg)) {
+	if (sgs->sum_nr_running && env->dst_cpu < group_first_cpu(sg)) {
 		if (!sds->busiest)
 			return true;
 
@@ -6228,7 +6304,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 	local = &sds->local_stat;
 	busiest = &sds->busiest_stat;
 
-	if (busiest->group_imb) {
+	if (busiest->group_type == group_imbalanced) {
 		/*
 		 * In the group_imb case we cannot rely on group-wide averages
 		 * to ensure cpu-load equilibrium, look at wider averages. XXX
@@ -6248,12 +6324,11 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 		return fix_small_imbalance(env, sds);
 	}
 
-	if (!busiest->group_imb) {
-		/*
-		 * Don't want to pull so many tasks that a group would go idle.
-		 * Except of course for the group_imb case, since then we might
-		 * have to drop below capacity to reach cpu-load equilibrium.
-		 */
+	/*
+	 * If there aren't any idle cpus, avoid creating some.
+	 */
+	if (busiest->group_type == group_overloaded &&
+	    local->group_type   == group_overloaded) {
 		load_above_capacity =
 			(busiest->sum_nr_running - busiest->group_capacity_factor);
 
@@ -6337,7 +6412,7 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
 	 * work because they assume all things are equal, which typically
 	 * isn't true due to cpus_allowed constraints and the like.
 	 */
-	if (busiest->group_imb)
+	if (busiest->group_type == group_imbalanced)
 		goto force_balance;
 
 	/* SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
@@ -6346,7 +6421,7 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
 		goto force_balance;
 
 	/*
-	 * If the local group is more busy than the selected busiest group
+	 * If the local group is busier than the selected busiest group
 	 * don't try and pull any tasks.
 	 */
 	if (local->avg_load >= busiest->avg_load)
@@ -6361,13 +6436,14 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
 
 	if (env->idle == CPU_IDLE) {
 		/*
-		 * This cpu is idle. If the busiest group load doesn't
-		 * have more tasks than the number of available cpu's and
-		 * there is no imbalance between this and busiest group
-		 * wrt to idle cpu's, it is balanced.
+		 * This cpu is idle. If the busiest group is not overloaded
+		 * and there is no imbalance between this and busiest group
+		 * wrt idle cpus, it is balanced. The imbalance becomes
+		 * significant if the diff is greater than 1 otherwise we
+		 * might end up to just move the imbalance on another group
 		 */
-		if ((local->idle_cpus < busiest->idle_cpus) &&
-		    busiest->sum_nr_running <= busiest->group_weight)
+		if ((busiest->group_type != group_overloaded) &&
+				(local->idle_cpus <= (busiest->idle_cpus + 1)))
 			goto out_balanced;
 	} else {
 		/*
@@ -6550,6 +6626,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.loop_break	= sched_nr_migrate_break,
 		.cpus		= cpus,
 		.fbq_type	= all,
+		.tasks		= LIST_HEAD_INIT(env.tasks),
 	};
 
 	/*
@@ -6599,23 +6676,30 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		env.loop_max  = min(sysctl_sched_nr_migrate, busiest->nr_running);
 
 more_balance:
-		local_irq_save(flags);
-		double_rq_lock(env.dst_rq, busiest);
+		raw_spin_lock_irqsave(&busiest->lock, flags);
 
 		/*
 		 * cur_ld_moved - load moved in current iteration
 		 * ld_moved     - cumulative load moved across iterations
 		 */
-		cur_ld_moved = move_tasks(&env);
-		ld_moved += cur_ld_moved;
-		double_rq_unlock(env.dst_rq, busiest);
-		local_irq_restore(flags);
+		cur_ld_moved = detach_tasks(&env);
 
 		/*
-		 * some other cpu did the load balance for us.
+		 * We've detached some tasks from busiest_rq. Every
+		 * task is masked "TASK_ON_RQ_MIGRATING", so we can safely
+		 * unlock busiest->lock, and we are able to be sure
+		 * that nobody can manipulate the tasks in parallel.
+		 * See task_rq_lock() family for the details.
 		 */
-		if (cur_ld_moved && env.dst_cpu != smp_processor_id())
-			resched_cpu(env.dst_cpu);
+
+		raw_spin_unlock(&busiest->lock);
+
+		if (cur_ld_moved) {
+			attach_tasks(&env);
+			ld_moved += cur_ld_moved;
+		}
+
+		local_irq_restore(flags);
 
 		if (env.flags & LBF_NEED_BREAK) {
 			env.flags &= ~LBF_NEED_BREAK;
@@ -6665,10 +6749,8 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		if (sd_parent) {
 			int *group_imbalance = &sd_parent->groups->sgc->imbalance;
 
-			if ((env.flags & LBF_SOME_PINNED) && env.imbalance > 0) {
+			if ((env.flags & LBF_SOME_PINNED) && env.imbalance > 0)
 				*group_imbalance = 1;
-			} else if (*group_imbalance)
-				*group_imbalance = 0;
 		}
 
 		/* All tasks on this runqueue were pinned by CPU affinity */
@@ -6679,7 +6761,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 				env.loop_break = sched_nr_migrate_break;
 				goto redo;
 			}
-			goto out_balanced;
+			goto out_all_pinned;
 		}
 	}
 
@@ -6744,7 +6826,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		 * If we've begun active balancing, start to back off. This
 		 * case may not be covered by the all_pinned logic if there
 		 * is only 1 task on the busy runqueue (because we don't call
-		 * move_tasks).
+		 * detach_tasks).
 		 */
 		if (sd->balance_interval < sd->max_interval)
 			sd->balance_interval *= 2;
@@ -6753,6 +6835,23 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	goto out;
 
 out_balanced:
+	/*
+	 * We reach balance although we may have faced some affinity
+	 * constraints. Clear the imbalance flag if it was set.
+	 */
+	if (sd_parent) {
+		int *group_imbalance = &sd_parent->groups->sgc->imbalance;
+
+		if (*group_imbalance)
+			*group_imbalance = 0;
+	}
+
+out_all_pinned:
+	/*
+	 * We reach balance because all tasks are pinned at this level so
+	 * we can't migrate them. Let the imbalance flag set so parent level
+	 * can try to migrate them.
+	 */
 	schedstat_inc(sd, lb_balanced[idle]);
 
 	sd->nr_balance_failed = 0;
@@ -6914,6 +7013,7 @@ static int active_load_balance_cpu_stop(void *data)
 	int target_cpu = busiest_rq->push_cpu;
 	struct rq *target_rq = cpu_rq(target_cpu);
 	struct sched_domain *sd;
+	struct task_struct *p = NULL;
 
 	raw_spin_lock_irq(&busiest_rq->lock);
 
@@ -6933,9 +7033,6 @@ static int active_load_balance_cpu_stop(void *data)
 	 */
 	BUG_ON(busiest_rq == target_rq);
 
-	/* move a task from busiest_rq to target_rq */
-	double_lock_balance(busiest_rq, target_rq);
-
 	/* Search for an sd spanning us and the target CPU. */
 	rcu_read_lock();
 	for_each_domain(target_cpu, sd) {
@@ -6956,16 +7053,22 @@ static int active_load_balance_cpu_stop(void *data)
 
 		schedstat_inc(sd, alb_count);
 
-		if (move_one_task(&env))
+		p = detach_one_task(&env);
+		if (p)
 			schedstat_inc(sd, alb_pushed);
 		else
 			schedstat_inc(sd, alb_failed);
 	}
 	rcu_read_unlock();
-	double_unlock_balance(busiest_rq, target_rq);
 out_unlock:
 	busiest_rq->active_balance = 0;
-	raw_spin_unlock_irq(&busiest_rq->lock);
+	raw_spin_unlock(&busiest_rq->lock);
+
+	if (p)
+		attach_one_task(target_rq, p);
+
+	local_irq_enable();
+
 	return 0;
 }
 
@@ -7465,7 +7568,7 @@ static void task_fork_fair(struct task_struct *p)
 static void
 prio_changed_fair(struct rq *rq, struct task_struct *p, int oldprio)
 {
-	if (!p->se.on_rq)
+	if (!task_on_rq_queued(p))
 		return;
 
 	/*
@@ -7490,11 +7593,11 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
 	 * switched back to the fair class the enqueue_entity(.flags=0) will
 	 * do the right thing.
 	 *
-	 * If it's on_rq, then the dequeue_entity(.flags=0) will already
-	 * have normalized the vruntime, if it's !on_rq, then only when
+	 * If it's queued, then the dequeue_entity(.flags=0) will already
+	 * have normalized the vruntime, if it's !queued, then only when
 	 * the task is sleeping will it still have non-normalized vruntime.
 	 */
-	if (!p->on_rq && p->state != TASK_RUNNING) {
+	if (!task_on_rq_queued(p) && p->state != TASK_RUNNING) {
 		/*
 		 * Fix up our vruntime so that the current sleep doesn't
 		 * cause 'unlimited' sleep bonus.
@@ -7521,15 +7624,15 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
  */
 static void switched_to_fair(struct rq *rq, struct task_struct *p)
 {
-	struct sched_entity *se = &p->se;
 #ifdef CONFIG_FAIR_GROUP_SCHED
+	struct sched_entity *se = &p->se;
 	/*
 	 * Since the real-depth could have been changed (only FAIR
 	 * class maintain depth value), reset depth properly.
 	 */
 	se->depth = se->parent ? se->parent->depth + 1 : 0;
 #endif
-	if (!se->on_rq)
+	if (!task_on_rq_queued(p))
 		return;
 
 	/*
@@ -7575,7 +7678,7 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static void task_move_group_fair(struct task_struct *p, int on_rq)
+static void task_move_group_fair(struct task_struct *p, int queued)
 {
 	struct sched_entity *se = &p->se;
 	struct cfs_rq *cfs_rq;
@@ -7594,7 +7697,7 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
 	 * fair sleeper stuff for the first placement, but who cares.
 	 */
 	/*
-	 * When !on_rq, vruntime of the task has usually NOT been normalized.
+	 * When !queued, vruntime of the task has usually NOT been normalized.
 	 * But there are some cases where it has already been normalized:
 	 *
 	 * - Moving a forked child which is waiting for being woken up by
@@ -7605,14 +7708,14 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
 	 * To prevent boost or penalty in the new cfs_rq caused by delta
 	 * min_vruntime between the two cfs_rqs, we skip vruntime adjustment.
 	 */
-	if (!on_rq && (!se->sum_exec_runtime || p->state == TASK_WAKING))
-		on_rq = 1;
+	if (!queued && (!se->sum_exec_runtime || p->state == TASK_WAKING))
+		queued = 1;
 
-	if (!on_rq)
+	if (!queued)
 		se->vruntime -= cfs_rq_of(se)->min_vruntime;
 	set_task_rq(p, task_cpu(p));
 	se->depth = se->parent ? se->parent->depth + 1 : 0;
-	if (!on_rq) {
+	if (!queued) {
 		cfs_rq = cfs_rq_of(se);
 		se->vruntime += cfs_rq->min_vruntime;
 #ifdef CONFIG_SMP
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 11e7bc434f43..c47fce75e666 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -147,6 +147,9 @@ static void cpuidle_idle_call(void)
 	    clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu))
 		goto use_default;
 
+	/* Take note of the planned idle state. */
+	idle_set_state(this_rq(), &drv->states[next_state]);
+
 	/*
 	 * Enter the idle state previously returned by the governor decision.
 	 * This function will block until an interrupt occurs and will take
@@ -154,6 +157,9 @@ static void cpuidle_idle_call(void)
 	 */
 	entered_state = cpuidle_enter(drv, dev, next_state);
 
+	/* The cpu is no longer idle or about to enter idle. */
+	idle_set_state(this_rq(), NULL);
+
 	if (broadcast)
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 5f6edca4fafd..87ea5bf1b87f 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1448,7 +1448,7 @@ pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 		 * means a dl or stop task can slip in, in which case we need
 		 * to re-start task selection.
 		 */
-		if (unlikely((rq->stop && rq->stop->on_rq) ||
+		if (unlikely((rq->stop && task_on_rq_queued(rq->stop)) ||
 			     rq->dl.dl_nr_running))
 			return RETRY_TASK;
 	}
@@ -1468,8 +1468,7 @@ pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 	p = _pick_next_task_rt(rq);
 
 	/* The running task is never eligible for pushing */
-	if (p)
-		dequeue_pushable_task(rq, p);
+	dequeue_pushable_task(rq, p);
 
 	set_post_schedule(rq);
 
@@ -1624,7 +1623,7 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
 				     !cpumask_test_cpu(lowest_rq->cpu,
 						       tsk_cpus_allowed(task)) ||
 				     task_running(rq, task) ||
-				     !task->on_rq)) {
+				     !task_on_rq_queued(task))) {
 
 				double_unlock_balance(rq, lowest_rq);
 				lowest_rq = NULL;
@@ -1658,7 +1657,7 @@ static struct task_struct *pick_next_pushable_task(struct rq *rq)
 	BUG_ON(task_current(rq, p));
 	BUG_ON(p->nr_cpus_allowed <= 1);
 
-	BUG_ON(!p->on_rq);
+	BUG_ON(!task_on_rq_queued(p));
 	BUG_ON(!rt_task(p));
 
 	return p;
@@ -1809,7 +1808,7 @@ static int pull_rt_task(struct rq *this_rq)
 		 */
 		if (p && (p->prio < this_rq->rt.highest_prio.curr)) {
 			WARN_ON(p == src_rq->curr);
-			WARN_ON(!p->on_rq);
+			WARN_ON(!task_on_rq_queued(p));
 
 			/*
 			 * There's a chance that p is higher in priority
@@ -1870,7 +1869,7 @@ static void set_cpus_allowed_rt(struct task_struct *p,
 
 	BUG_ON(!rt_task(p));
 
-	if (!p->on_rq)
+	if (!task_on_rq_queued(p))
 		return;
 
 	weight = cpumask_weight(new_mask);
@@ -1936,7 +1935,7 @@ static void switched_from_rt(struct rq *rq, struct task_struct *p)
 	 * we may need to handle the pulling of RT tasks
 	 * now.
 	 */
-	if (!p->on_rq || rq->rt.rt_nr_running)
+	if (!task_on_rq_queued(p) || rq->rt.rt_nr_running)
 		return;
 
 	if (pull_rt_task(rq))
@@ -1970,7 +1969,7 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p)
 	 * If that current running task is also an RT task
 	 * then see if we can move to another run queue.
 	 */
-	if (p->on_rq && rq->curr != p) {
+	if (task_on_rq_queued(p) && rq->curr != p) {
 #ifdef CONFIG_SMP
 		if (p->nr_cpus_allowed > 1 && rq->rt.overloaded &&
 		    /* Don't resched if we changed runqueues */
@@ -1989,7 +1988,7 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p)
 static void
 prio_changed_rt(struct rq *rq, struct task_struct *p, int oldprio)
 {
-	if (!p->on_rq)
+	if (!task_on_rq_queued(p))
 		return;
 
 	if (rq->curr == p) {
@@ -2073,7 +2072,7 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 	for_each_sched_rt_entity(rt_se) {
 		if (rt_se->run_list.prev != rt_se->run_list.next) {
 			requeue_task_rt(rq, p, 0);
-			set_tsk_need_resched(p);
+			resched_curr(rq);
 			return;
 		}
 	}
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 579712f4e9d5..6130251de280 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -14,6 +14,11 @@
 #include "cpuacct.h"
 
 struct rq;
+struct cpuidle_state;
+
+/* task_struct::on_rq states: */
+#define TASK_ON_RQ_QUEUED	1
+#define TASK_ON_RQ_MIGRATING	2
 
 extern __read_mostly int scheduler_running;
 
@@ -126,6 +131,9 @@ struct rt_bandwidth {
 	u64			rt_runtime;
 	struct hrtimer		rt_period_timer;
 };
+
+void __dl_clear_params(struct task_struct *p);
+
 /*
  * To keep the bandwidth of -deadline tasks and groups under control
  * we need some place where:
@@ -184,7 +192,7 @@ struct cfs_bandwidth {
 	raw_spinlock_t lock;
 	ktime_t period;
 	u64 quota, runtime;
-	s64 hierarchal_quota;
+	s64 hierarchical_quota;
 	u64 runtime_expires;
 
 	int idle, timer_active;
@@ -636,6 +644,11 @@ struct rq {
 #ifdef CONFIG_SMP
 	struct llist_head wake_list;
 #endif
+
+#ifdef CONFIG_CPU_IDLE
+	/* Must be inspected within a rcu lock section */
+	struct cpuidle_state *idle_state;
+#endif
 };
 
 static inline int cpu_of(struct rq *rq)
@@ -647,7 +660,7 @@ static inline int cpu_of(struct rq *rq)
 #endif
 }
 
-DECLARE_PER_CPU(struct rq, runqueues);
+DECLARE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 
 #define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
 #define this_rq()		(&__get_cpu_var(runqueues))
@@ -942,6 +955,15 @@ static inline int task_running(struct rq *rq, struct task_struct *p)
 #endif
 }
 
+static inline int task_on_rq_queued(struct task_struct *p)
+{
+	return p->on_rq == TASK_ON_RQ_QUEUED;
+}
+
+static inline int task_on_rq_migrating(struct task_struct *p)
+{
+	return p->on_rq == TASK_ON_RQ_MIGRATING;
+}
 
 #ifndef prepare_arch_switch
 # define prepare_arch_switch(next)	do { } while (0)
@@ -953,7 +975,6 @@ static inline int task_running(struct rq *rq, struct task_struct *p)
 # define finish_arch_post_lock_switch()	do { } while (0)
 #endif
 
-#ifndef __ARCH_WANT_UNLOCKED_CTXSW
 static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
 {
 #ifdef CONFIG_SMP
@@ -991,35 +1012,6 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 	raw_spin_unlock_irq(&rq->lock);
 }
 
-#else /* __ARCH_WANT_UNLOCKED_CTXSW */
-static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
-{
-#ifdef CONFIG_SMP
-	/*
-	 * We can optimise this out completely for !SMP, because the
-	 * SMP rebalancing from interrupt is the only thing that cares
-	 * here.
-	 */
-	next->on_cpu = 1;
-#endif
-	raw_spin_unlock(&rq->lock);
-}
-
-static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
-{
-#ifdef CONFIG_SMP
-	/*
-	 * After ->on_cpu is cleared, the task can be moved to a different CPU.
-	 * We must ensure this doesn't happen until the switch is completely
-	 * finished.
-	 */
-	smp_wmb();
-	prev->on_cpu = 0;
-#endif
-	local_irq_enable();
-}
-#endif /* __ARCH_WANT_UNLOCKED_CTXSW */
-
 /*
  * wake flags
  */
@@ -1180,6 +1172,30 @@ static inline void idle_exit_fair(struct rq *rq) { }
 
 #endif
 
+#ifdef CONFIG_CPU_IDLE
+static inline void idle_set_state(struct rq *rq,
+				  struct cpuidle_state *idle_state)
+{
+	rq->idle_state = idle_state;
+}
+
+static inline struct cpuidle_state *idle_get_state(struct rq *rq)
+{
+	WARN_ON(!rcu_read_lock_held());
+	return rq->idle_state;
+}
+#else
+static inline void idle_set_state(struct rq *rq,
+				  struct cpuidle_state *idle_state)
+{
+}
+
+static inline struct cpuidle_state *idle_get_state(struct rq *rq)
+{
+	return NULL;
+}
+#endif
+
 extern void sysrq_sched_debug_show(void);
 extern void sched_init_granularity(void);
 extern void update_max_interval(void);
diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index bfe0edadbfbb..67426e529f59 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -28,7 +28,7 @@ pick_next_task_stop(struct rq *rq, struct task_struct *prev)
 {
 	struct task_struct *stop = rq->stop;
 
-	if (!stop || !stop->on_rq)
+	if (!stop || !task_on_rq_queued(stop))
 		return NULL;
 
 	put_prev_task(rq, prev);
diff --git a/kernel/smp.c b/kernel/smp.c
index aff8aa14f547..9e0d0b289118 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -13,6 +13,7 @@
 #include <linux/gfp.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
+#include <linux/sched.h>
 
 #include "smpboot.h"
 
@@ -699,3 +700,24 @@ void kick_all_cpus_sync(void)
 	smp_call_function(do_nothing, NULL, 1);
 }
 EXPORT_SYMBOL_GPL(kick_all_cpus_sync);
+
+/**
+ * wake_up_all_idle_cpus - break all cpus out of idle
+ * wake_up_all_idle_cpus try to break all cpus which is in idle state even
+ * including idle polling cpus, for non-idle cpus, we will do nothing
+ * for them.
+ */
+void wake_up_all_idle_cpus(void)
+{
+	int cpu;
+
+	preempt_disable();
+	for_each_online_cpu(cpu) {
+		if (cpu == smp_processor_id())
+			continue;
+
+		wake_up_if_idle(cpu);
+	}
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(wake_up_all_idle_cpus);
diff --git a/kernel/sys.c b/kernel/sys.c
index ce8129192a26..b6636643cbd1 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -862,11 +862,9 @@ void do_sys_times(struct tms *tms)
 {
 	cputime_t tgutime, tgstime, cutime, cstime;
 
-	spin_lock_irq(&current->sighand->siglock);
 	thread_group_cputime_adjusted(current, &tgutime, &tgstime);
 	cutime = current->signal->cutime;
 	cstime = current->signal->cstime;
-	spin_unlock_irq(&current->sighand->siglock);
 	tms->tms_utime = cputime_to_clock_t(tgutime);
 	tms->tms_stime = cputime_to_clock_t(tgstime);
 	tms->tms_cutime = cputime_to_clock_t(cutime);
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 1c2fe7de2842..ab370ffffd53 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1776,7 +1776,6 @@ schedule_hrtimeout_range_clock(ktime_t *expires, unsigned long delta,
 	 */
 	if (!expires) {
 		schedule();
-		__set_current_state(TASK_RUNNING);
 		return -EINTR;
 	}
 
diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
index 3b8946416a5f..492b986195d5 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -272,22 +272,8 @@ static int posix_cpu_clock_get_task(struct task_struct *tsk,
 		if (same_thread_group(tsk, current))
 			err = cpu_clock_sample(which_clock, tsk, &rtn);
 	} else {
-		unsigned long flags;
-		struct sighand_struct *sighand;
-
-		/*
-		 * while_each_thread() is not yet entirely RCU safe,
-		 * keep locking the group while sampling process
-		 * clock for now.
-		 */
-		sighand = lock_task_sighand(tsk, &flags);
-		if (!sighand)
-			return err;
-
 		if (tsk == current || thread_group_leader(tsk))
 			err = cpu_clock_sample_group(which_clock, tsk, &rtn);
-
-		unlock_task_sighand(tsk, &flags);
 	}
 
 	if (!err)
diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index 0434ff1b808e..3f9e328c30b5 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -205,7 +205,6 @@ static void ring_buffer_consumer(void)
 			break;
 
 		schedule();
-		__set_current_state(TASK_RUNNING);
 	}
 	reader_finish = 0;
 	complete(&read_done);
@@ -379,7 +378,6 @@ static int ring_buffer_consumer_thread(void *arg)
 			break;
 
 		schedule();
-		__set_current_state(TASK_RUNNING);
 	}
 	__set_current_state(TASK_RUNNING);
 
@@ -407,7 +405,6 @@ static int ring_buffer_producer_thread(void *arg)
 		trace_printk("Sleeping for 10 secs\n");
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(HZ * SLEEP_TIME);
-		__set_current_state(TASK_RUNNING);
 	}
 
 	if (kill_test)
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 8a4e5cb66a4c..16eddb308c33 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -13,7 +13,6 @@
 #include <linux/sysctl.h>
 #include <linux/init.h>
 #include <linux/fs.h>
-#include <linux/magic.h>
 
 #include <asm/setup.h>
 
@@ -171,8 +170,7 @@ check_stack(unsigned long ip, unsigned long *stack)
 			i++;
 	}
 
-	if ((current != &init_task &&
-		*(end_of_stack(current)) != STACK_END_MAGIC)) {
+	if (task_stack_end_corrupted(current)) {
 		print_max_stack();
 		BUG();
 	}
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a28590083622..e58163d69db1 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -824,6 +824,18 @@ config SCHEDSTATS
 	  application, you can say N to avoid the very slight overhead
 	  this adds.
 
+config SCHED_STACK_END_CHECK
+	bool "Detect stack corruption on calls to schedule()"
+	depends on DEBUG_KERNEL
+	default n
+	help
+	  This option checks for a stack overrun on calls to schedule().
+	  If the stack end location is found to be over written always panic as
+	  the content of the corrupted region can no longer be trusted.
+	  This is to ensure no erroneous behaviour occurs which could result in
+	  data corruption or a sporadic crash at a later stage once the region
+	  is examined. The runtime overhead introduced is minimal.
+
 config TIMER_STATS
 	bool "Collect kernel timers statistics"
 	depends on DEBUG_KERNEL && PROC_FS
