Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbaFCMIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:08:00 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:59791 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbaFCMH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 08:07:57 -0400
Date: Tue, 3 Jun 2014 14:07:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler tree changes for v3.16
Message-ID: <20140603120752.GA26873@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-core-for-linus

   # HEAD: 096aa33863a5e48de52d2ff30e0801b7487944f4 sched/numa: Decay ->wakee_flips instead of zeroing

The main scheduling related changes in this cycle were:

 - various sched/numa updates, for better performance

 - tree wide cleanup of open coded nice levels

 - nohz fix related to rq->nr_running use

 - cpuidle changes and continued consolidation to improve the 
   kernel/sched/idle.c high level idle scheduling logic. As part of 
   this effort I pulled cpuidle driver changes from Rafael as well.

 - standardized idle polling amongst architectures

 - continued work on preparing better power/energy aware scheduling

 - sched/rt updates

 - misc fixlets and cleanups

 Thanks,

	Ingo

--------------[ shortlog and diffstat created manually ]---------------->

Ben Segall (1):
      sched: Fix exec_start/task_hot on migrated tasks

Chander Kashyap (1):
      cpuidle / menu: move repeated correction factor check to init

Corey Minyard (1):
      sched: Initialize rq->age_stamp on processor start

Dietmar Eggemann (1):
      sched: Do not zero sg->cpumask and sg->sgp->power in build_sched_groups()

Dongsheng Yang (3):
      sched, treewide: Replace hardcoded nice values with MIN_NICE/MAX_NICE
      sched: Use clamp() and clamp_val() to make sys_nice() more readable
      sched: Consolidate open coded implementations of nice level frobbing into nice_to_rlimit() and rlimit_to_nice()

Ingo Molnar (4):
      Merge branch 'sched/urgent' into sched/core, to avoid conflicts
      Merge tag 'v3.15-rc6' into sched/core, to pick up the latest fixes
      Merge branch 'pm-cpuidle' of git://git.kernel.org/.../rafael/linux-pm into sched/core
      Merge branch 'sched/urgent' into sched/core to avoid conflicts with upcoming changes

James Hogan (1):
      metag: Remove TIF_POLLING_NRFLAG

Jason Low (2):
      sched/fair: Stop searching for tasks in newidle balance if there are runnable tasks
      sched: Fix the rq->next_balance logic in rebalance_domains() and idle_balance()

Kirill Tkhai (5):
      sched/rt: Sum number of all children tasks in hierarhy at ->rt_nr_running
      sched/rt: Add accessors rq_of_rt_se()
      sched/rt: Substract number of tasks of throttled queues from rq->nr_running
      sched: Revert commit 4c6c4e38c4e9 ("sched/core: Fix endless loop in pick_next_task()")
      sched, nohz: Change rq->nr_running to always use wrappers

Kirill V Tkhai (1):
      sched/rt: Do not try to push tasks if pinned task switches to RT

Michael Kerrisk (2):
      sched: Simplify return logic in sched_copy_attr()
      sched: Simplify return logic in sched_read_attr()

Peter Zijlstra (12):
      sched: Make scale_rt_power() deal with backward clocks
      sched/wait: Explain the shadowing and type inconsistencies
      sched: Remove set_need_resched()
      sched/idle, alpha: Switch from TS_POLLING to TIF_POLLING_NRFLAG
      sched/idle, tile: Switch from TS_POLLING to TIF_POLLING_NRFLAG
      sched/idle, ia64: Switch from TS_POLLING to TIF_POLLING_NRFLAG
      sched/idle, x86: Switch from TS_POLLING to TIF_POLLING_NRFLAG
      sched/idle: Remove TS_POLLING support
      sched/idle: Avoid spurious wakeup IPIs
      sched/idle: Delay clearing the polling bit
      sched/idle: Reflow cpuidle_idle_call()
      arm64: Remove TIF_POLLING_NRFLAG

Rafael J. Wysocki (4):
      cpuidle: Combine cpuidle_enabled() with cpuidle_select()
      cpuidle / menu: Return (-1) if there are no suitable states
      PM / suspend: Always use deepest C-state in the "freeze" sleep state
      sched/idle: Make cpuidle_idle_call() void

Rik van Riel (8):
      sched/numa: Count pages on active node as local
      sched/numa: Retry placement more frequently when misplaced
      sched/numa: Do not set preferred_node on migration to a second choice node
      mm/numa: Remove BUG_ON() in __handle_mm_fault()
      sched: Call select_idle_sibling() when not affine_sd
      sched/numa: Allow task switch if load imbalance improves
      sched/numa: Update migrate_improves/degrades_locality()
      sched/numa: Decay ->wakee_flips instead of zeroing

Vincent Guittot (6):
      sched: Rework sched_domain topology definition
      sched, s390: Create a dedicated topology table
      sched, powerpc: Create a dedicated topology table
      sched: Add a new SD_SHARE_POWERDOMAIN for sched_domain
      sched, ARM: Create a dedicated scheduler topology table
      sched/numa: Fix initialization of sched_domain_topology for NUMA

xiaofeng.yan (1):
      sched/rt: Fix 'struct sched_dl_entity' and dl_task_time() comments, to match the current upstream code



 arch/alpha/include/asm/thread_info.h        |   4 +-
 arch/arm/kernel/topology.c                  |  26 ++++++++++
 arch/arm64/include/asm/thread_info.h        |   2 -
 arch/ia64/include/asm/thread_info.h         |   3 +-
 arch/ia64/include/asm/topology.h            |  24 ---------
 arch/metag/include/asm/thread_info.h        |   6 +--
 arch/powerpc/kernel/smp.c                   |  31 +++++++++---
 arch/s390/include/asm/topology.h            |  13 +----
 arch/s390/kernel/topology.c                 |  20 ++++++++
 arch/tile/include/asm/thread_info.h         |   3 +-
 arch/tile/include/asm/topology.h            |  33 ------------
 arch/x86/include/asm/thread_info.h          |   4 +-
 arch/x86/kernel/apm_32.c                    |  11 ----
 drivers/block/loop.c                        |   2 +-
 drivers/block/nbd.c                         |   2 +-
 drivers/block/pktcdvd.c                     |   2 +-
 drivers/char/ipmi/ipmi_si_intf.c            |   2 +-
 drivers/cpuidle/cpuidle.c                   |  55 +++++++++++++++-----
 drivers/cpuidle/governors/menu.c            |  17 ++++---
 drivers/s390/crypto/ap_bus.c                |   2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c           |   4 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c              |   2 +-
 drivers/scsi/fcoe/fcoe.c                    |   2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c              |   2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c            |   2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c            |   2 +-
 drivers/scsi/qla2xxx/qla_os.c               |   2 +-
 drivers/staging/android/binder.c            |   4 +-
 drivers/staging/lustre/lustre/llite/lloop.c |   2 +-
 fs/ocfs2/cluster/heartbeat.c                |   2 +-
 include/linux/cpuidle.h                     |   7 +--
 include/linux/sched.h                       | 104 +++++++++++++++++++++-----------------
 include/linux/sched/prio.h                  |  16 ++++++
 include/linux/thread_info.h                 |  14 ------
 include/linux/topology.h                    | 128 +++++------------------------------------------
 kernel/locking/locktorture.c                |   2 +-
 kernel/power/suspend.c                      |   2 +
 kernel/sched/core.c                         | 324 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------
 kernel/sched/deadline.c                     |   6 +--
 kernel/sched/fair.c                         | 226 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------
 kernel/sched/idle.c                         | 140 ++++++++++++++++++++++-----------------------------
 kernel/sched/rt.c                           | 119 ++++++++++++++++++++++++++++++++++++-------
 kernel/sched/sched.h                        |  26 ++++------
 kernel/sched/stop_task.c                    |   4 +-
 kernel/sys.c                                |   6 +--
 kernel/workqueue.c                          |   6 +--
 mm/huge_memory.c                            |   2 +-
 mm/memory.c                                 |   3 --
 48 files changed, 759 insertions(+), 662 deletions(-)
