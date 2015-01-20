Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbbATApN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 19:45:13 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:41424 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbbATApL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 19:45:11 -0500
Date: Mon, 19 Jan 2015 16:45:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@kernel.org
Cc: xiexiuqi@huawei.com, dave@stgolabs.net, agordeev@redhat.com,
        bobby.prani@gmail.com, linux-kernel@vger.kernel.org,
        laijs@cn.fujitsu.com, ying.xue@windriver.com, dahi@linux.vnet.ibm.com,
        calvinowens@fb.com, mbenes@suse.cz
Subject: [GIT PULL rcu/next] RCU commits for 3.20
Message-ID: <20150120004502.GA14517@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012000-0021-0000-0000-000007E79836
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

The changes in this series include:

1.	Documentation updates.  These were posted to LKML at
	https://lkml.org/lkml/2015/1/7/496.

2.	Miscellaneous fixes.  These were posted to LKML at
	https://lkml.org/lkml/2015/1/7/507.

3.	Preemptible-RCU fixes, including fixing an old bug in the
	interaction of RCU priority boosting and CPU hotplug.  These were
	posted to LKML at https://lkml.org/lkml/2015/1/7/535.

4.	SRCU updates.  These were posted to LKML at
	https://lkml.org/lkml/2015/1/7/555.

5.	RCU CPU stall-warning updates.  These were posted to LKML at
	https://lkml.org/lkml/2015/1/7/565.

6.	RCU torture-test updates.  These were posted to LKML at
	https://lkml.org/lkml/2015/1/7/591.

These changes are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git for-mingo

for you to fetch changes up to 78e691f4ae2d5edea0199ca802bb505b9cdced88:

  Merge branches 'doc.2015.01.07a', 'fixes.2015.01.15a', 'preempt.2015.01.06a', 'srcu.2015.01.06a', 'stall.2015.01.16a' and 'torture.2015.01.11a' into HEAD (2015-01-15 23:34:34 -0800)

----------------------------------------------------------------

Alexander Gordeev (1):
      rcu: Remove redundant rcu_is_cpu_rrupt_from_idle() from tiny RCU

Calvin Owens (1):
      ksoftirqd: Enable IRQs and call cond_resched() before poking RCU

David Hildenbrand (1):
      hotplugcpu: Avoid deadlocks by waking active_writer

Davidlohr Bueso (1):
      documentation: Fix smp typo in memory-barriers.txt

Lai Jiangshan (3):
      tiny_rcu: Directly force QS when call_rcu_[bh|sched]() on idle_task
      rcu: Remove "select IRQ_WORK" from config TREE_RCU
      rcu: Revert "Allow post-unlock reference for rt_mutex" to avoid priority-inversion

Miroslav Benes (1):
      rcu: Fix RCU CPU stall detection in tiny implementation

Paul E. McKenney (43):
      rcu: Make rcu_nmi_enter() handle nesting
      rcu: Fix invoke_rcu_callbacks() comment
      compiler: Allow 1- and 2-byte smp_load_acquire() and smp_store_release()
      rcu: Fix rcu_barrier() race that could result in too-short wait
      rcu: Protect rcu_boost() lockless accesses with ACCESS_ONCE()
      rcu: Rename "empty" to "empty_norm" in preparation for boost rework
      rcu: Abstract rcu_cleanup_dead_rnp() from rcu_cleanup_dead_cpu()
      rcu: Make rcu_read_unlock_special() propagate ->qsmaskinit bit clearing
      rcu: Don't migrate blocked tasks even if all corresponding CPUs offline
      rcu: Shorten irq-disable region in rcu_cleanup_dead_cpu()
      rcu: Make use of rcu_preempt_has_tasks()
      rcu: Don't spawn rcub kthreads on root rcu_node structure
      rcu: Don't initiate RCU priority boosting on root rcu_node
      rcu: Don't bother affinitying rcub kthreads away from offline CPUs
      rcu: Note quiescent state when CPU goes offline
      rcu: Don't scan root rcu_node structure for stalled tasks
      rcu: Remove redundant callback-list initialization
      rcu: Expand SRCU ->completed to 64 bits
      rcu: Combine DEFINE_SRCU() and DEFINE_STATIC_SRCU()
      rcu: Set default to RCU_CPU_STALL_INFO=y
      rcutorture: Add checks for stall ending before dump start
      rcu: Make RCU_CPU_STALL_INFO include number of fqs attempts
      rcu: Improve diagnostics for spurious RCU CPU stall warnings
      rcu: Handle gpnum/completed wrap while dyntick idle
      documentation: Record limitations of bitfields and small variables
      rcutorture: Issue warnings on close calls due to Reader Batch blows
      rcu: Make _batches_completed() functions return unsigned long
      rcutorture: Make build-output parsing correctly flag RCU's warnings
      rcutorture: Use unsigned for Reader Batch computations
      rcu: Provide rcu_batches_completed_sched() for TINY_RCU
      rcutorture: Drop rcu_torture_completed() and friends
      rcu: Remove redundant rcu_batches_completed() declaration
      rcutorture: Check from beginning to end of grace period
      rcutorture: Handle different mpstat versions
      torture: Add "-enable-kvm -soundhw pcspk" to qemu command line
      torture: Flag console.log file to prevent holdovers from earlier runs
      rcutorture: Add more diagnostics in rcu_barrier() test failure case
      ksoftirqd: Use new cond_resched_rcu_qs() function
      rcu: Optionally run grace-period kthreads at real-time priority
      rcu: Make cond_resched_rcu_qs() apply to normal RCU flavors
      rcu: Add GP-kthread-starvation checks to CPU stall warnings
      rcu: Initialize tiny RCU stall-warning timeouts at boot
      Merge branches 'doc.2015.01.07a', 'fixes.2015.01.15a', 'preempt.2015.01.06a', 'srcu.2015.01.06a', 'stall.2015.01.16a' and 'torture.2015.01.11a' into HEAD

Pranith Kumar (2):
      rcupdate: Replace smp_read_barrier_depends() with lockless_dereference()
      rcu: Make SRCU optional by using CONFIG_SRCU

Xie XiuQi (1):
      documentation: Update sysfs path for rcu_cpu_stall_timeout

Ying Xue (1):
      rculist: Fix sparse warning

 Documentation/RCU/stallwarn.txt                    |  16 +-
 Documentation/RCU/trace.txt                        |  32 +-
 Documentation/memory-barriers.txt                  |  46 ++-
 arch/arm/kvm/Kconfig                               |   1 +
 arch/arm64/kvm/Kconfig                             |   1 +
 arch/mips/kvm/Kconfig                              |   1 +
 arch/powerpc/kvm/Kconfig                           |   1 +
 arch/s390/kvm/Kconfig                              |   1 +
 arch/tile/kvm/Kconfig                              |   1 +
 arch/x86/Kconfig                                   |   1 +
 arch/x86/kvm/Kconfig                               |   1 +
 drivers/clk/Kconfig                                |   1 +
 drivers/cpufreq/Kconfig                            |   1 +
 drivers/devfreq/Kconfig                            |   1 +
 drivers/md/Kconfig                                 |   1 +
 drivers/net/Kconfig                                |   1 +
 fs/btrfs/Kconfig                                   |   1 +
 fs/notify/Kconfig                                  |   1 +
 fs/quota/Kconfig                                   |   1 +
 include/linux/compiler.h                           |   2 +-
 include/linux/rculist.h                            |  16 +-
 include/linux/rcupdate.h                           |  13 +-
 include/linux/rcutiny.h                            |  45 ++-
 include/linux/rcutree.h                            |  11 +-
 include/linux/srcu.h                               |  14 +-
 init/Kconfig                                       |  18 +-
 kernel/cpu.c                                       |  56 ++--
 kernel/notifier.c                                  |   3 +
 kernel/power/Kconfig                               |   1 +
 kernel/rcu/Makefile                                |   3 +-
 kernel/rcu/rcu.h                                   |   6 +
 kernel/rcu/rcutorture.c                            |  66 ++--
 kernel/rcu/srcu.c                                  |   2 +-
 kernel/rcu/tiny.c                                  | 113 +------
 kernel/rcu/tiny_plugin.h                           |   9 +-
 kernel/rcu/tree.c                                  | 355 +++++++++++++++------
 kernel/rcu/tree.h                                  |  62 +---
 kernel/rcu/tree_plugin.h                           | 271 +++++-----------
 kernel/rcu/tree_trace.c                            |   8 +-
 kernel/softirq.c                                   |   3 +-
 lib/Kconfig.debug                                  |   3 +-
 mm/Kconfig                                         |   1 +
 security/tomoyo/Kconfig                            |   1 +
 tools/testing/selftests/rcutorture/bin/cpus2use.sh |   2 +-
 .../selftests/rcutorture/bin/kvm-recheck-rcu.sh    |  18 ++
 .../selftests/rcutorture/bin/kvm-test-1-run.sh     |   9 +-
 .../selftests/rcutorture/bin/parse-build.sh        |  20 +-
 .../selftests/rcutorture/bin/parse-console.sh      |   2 +-
 48 files changed, 657 insertions(+), 586 deletions(-)

