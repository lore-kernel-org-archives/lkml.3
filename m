Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbaEVJhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:37:24 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:48447 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbaEVJhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:37:22 -0400
Date: Thu, 22 May 2014 11:37:16 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, kernelfans@gmail.com,
        iulia.manda21@gmail.com, himangi774@gmail.com, bernat.ada@gmail.com,
        pranith@gatech.edu, cl@linux.com, edumazet@google.com,
        rashika.kheria@gmail.com, tglx@linutronix.de, bobby.prani@gmail.com,
        uma.sharma523@gmail.com, riel@redhat.com
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.16
Message-ID: <20140522093715.GA31816@gmail.com>
References: <20140521223231.GA26741@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521223231.GA26741@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> The changes in this series include:
> 
> 1.	Update RCU documentation.  These were posted to LKML at
> 	https://lkml.org/lkml/2014/4/28/634.
> 
> 2.	Miscellaneous fixes.  These were posted to LKML at
> 	https://lkml.org/lkml/2014/4/28/645.
> 
> 3.	Torture-test changes.  These were posted to LKML at
> 	https://lkml.org/lkml/2014/4/28/667.
> 
> 4.	Variable-name renaming cleanup, sent separately due to conflicts.
> 	This was posted to LKML at https://lkml.org/lkml/2014/5/13/854.
> 
> 5.	Patch to suppress RCU stall warnings while sysrq requests are
> 	being processed.  This patch is the RCU portions of the patch
> 	that Rik posted to LKML at https://lkml.org/lkml/2014/4/29/457.
> 	The reason for pushing this patch ahead instead of waiting until
> 	3.17 is that the NMI-based stack traces are messing up sysrq
> 	output, and in some cases also messing up the system as well.
> 
> All of these have been exposed to -next testing.
> These changes are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next
> 
> for you to fetch changes up to 61f38db3e3c0e4c3be0858750e2cabeadaecac0c:
> 
>   rcu: Provide API to suppress stall warnings while sysrc runs (2014-05-19 10:52:04 -0700)
> 
> 							Thanx, Paul
> 
> ----------------------------------------------------------------
> Andreea-Cristina Bernat (3):
>       rcu: Add event tracing to dyntick_save_progress_counter().
>       rcu: Consolidate kfree_call_rcu() to use rcu_state pointer
>       rcu: Merge rcu_sched_force_quiescent_state() with rcu_force_quiescent_state()
> 
> Christoph Lameter (1):
>       rcu: Replace __this_cpu_ptr() uses with raw_cpu_ptr()
> 
> Eric Dumazet (1):
>       softirq: A single rcu_bh_qs() call per softirq set is enough
> 
> Himangi Saraogi (2):
>       rcu: Protect uses of ->jiffies_stall with ACCESS_ONCE()
>       rcu: Replace NR_CPUS with nr_cpu_ids
> 
> Iulia Manda (4):
>       rcu: Remove unused rcu_data structure field
>       rcu: Protect uses of jiffies_stall field with ACCESS_ONCE()
>       rcu: Remove "extern" from function declaration in include/linux/rcupdate.h
>       torture: Notice if an all-zero cpumask is passed inside a critical section
> 
> Liu Ping Fan (1):
>       rcu: Fix incorrect notes for code
> 
> Paul E. McKenney (50):
>       documentation: Update sysfs path for rcu_cpu_stall_suppress
>       documentation: Record rcu_dereference() value mishandling
>       documentation: Update API documentation
>       rcu: Protect ->gp_flags accesses with ACCESS_ONCE()
>       rcu: Print negatives for stall-warning counter wraparound
>       rcu: Update cpu_needs_another_gp() for futures from non-NOCB CPUs
>       rcu: Make callers awaken grace-period kthread
>       rcu: Document RCU_INIT_POINTER()'s lack of ordering guarantees
>       rcu: Bind RCU grace-period kthreads if NO_HZ_FULL
>       rcu: Make large and small sysidle systems use same state machine
>       rcutorture: Add forward-progress checking for writer
>       torture: Remove obsolete builddir options
>       torture: Add batch headers "--dryrun sched"
>       torture: Make parse-rcutorture.sh less RCU-specific
>       torture: Rename RCU_INITRD to TORTURE_INITRD
>       torture: Intensify locking test
>       torture: Allow variations of "defconfig" to be specified
>       torture: Rename RCU_KMAKE_ARG to TORTURE_KMAKE_ARG
>       torture: Rename RCU_BOOTARGS to TORTURE_BOOTARGS
>       torture: Rename RCU_BUILDONLY to TORTURE_BUILDONLY
>       torture: Rename RCU_QEMU_INTERACTIVE to TORTURE_QEMU_INTERACTIVE
>       torture: Rename RCU_QEMU_MAC to TORTURE_QEMU_MAC
>       torture: Rename RCU_QEMU_ARG to TORTURE_QEMU_ARG
>       torture: Rename RCU_QEMU_CMD to TORTURE_QEMU_CMD
>       torture: Make config-fragment filtering RCU-independent
>       torture: Make "--dryrun script" output self-sufficient
>       torture: Make "--dryrun script" use same environment as normal run
>       rcutorture: Print negatives for SRCU counter wraparound
>       torture: Include "Stopping" string to torture_kthread_stopping()
>       torture: Report diagnostics from qemu
>       torture: Increase stutter-end intensity
>       torture: Permit multi-word qemu and boot arguments
>       torture: Choose bzImage location based on architecture
>       torture: Add tracing-enabled variant of TREE02
>       torture: Dump ftrace buffer when the RCU grace period stalls
>       rcutorture: Export RCU grace-period kthread wait state to rcutorture
>       percpu: Fix raw_cpu_inc_return()
>       sched,rcu: Make cond_resched() report RCU quiescent states
>       rcutorture: Make rcu_torture_reader() use cond_resched()
>       torture: Better summary diagnostics for build failures
>       rcutorture: Check for rcu_torture_fqs creation errors
>       torture: Use elapsed time to detect hangs
>       rcutorture: Test RCU-sched primitives in TREE_PREEMPT_RCU kernels
>       rcutorture:  Add tests for get_state_synchronize_rcu()
>       rcutorture: Explicitly test synchronous grace-period primitives
>       rcutorture: Note diffs from git commits
>       rcutorture: Run rcu_torture_writer at normal priority
>       locktorture: Remove reference to nonexistent Kconfig parameter
>       torture: Check for multiple concurrent torture tests
>       Merge branches 'doc.2014.04.29a', 'fixes.2014.04.29a' and 'torture.2014.05.14a' into HEAD
> 
> Pranith Kumar (3):
>       rcu: Remove duplicate resched_cpu() declaration
>       torture: Remove __init from torture_init_begin/end
>       torture: Remove unused definition
> 
> Rashika Kheria (1):
>       rcutorture: Mark function as static in kernel/rcu/torture.c
> 
> Rik van Riel (1):
>       rcu: Provide API to suppress stall warnings while sysrc runs
> 
> Thomas Gleixner (1):
>       rcutorture: Add missing destroy_timer_on_stack()
> 
> Uma Sharma (1):
>       rcu: Variable name changed in tree_plugin.h and used in tree.c
> 
>  Documentation/RCU/00-INDEX                         |   2 +
>  Documentation/RCU/checklist.txt                    |  12 +-
>  Documentation/RCU/rcu_dereference.txt              | 371 +++++++++++++++++++++
>  Documentation/RCU/stallwarn.txt                    |   2 +-
>  Documentation/RCU/whatisRCU.txt                    |  55 ++-
>  include/linux/percpu.h                             |   2 +-
>  include/linux/rcupdate.h                           |  72 +++-
>  include/linux/rcutiny.h                            |   4 +
>  include/linux/rcutree.h                            |   1 +
>  include/linux/torture.h                            |   8 +-
>  kernel/locking/locktorture.c                       |  10 +-
>  kernel/rcu/rcutorture.c                            | 217 +++++++++---
>  kernel/rcu/tiny_plugin.h                           |   8 +-
>  kernel/rcu/tree.c                                  | 309 ++++++++++++-----
>  kernel/rcu/tree.h                                  |  11 +-
>  kernel/rcu/tree_plugin.h                           | 136 ++------
>  kernel/rcu/update.c                                |  30 ++
>  kernel/sched/core.c                                |   7 +-
>  kernel/softirq.c                                   |   4 +-
>  kernel/torture.c                                   |  40 ++-
>  .../testing/selftests/rcutorture/bin/configinit.sh |   2 +-
>  .../testing/selftests/rcutorture/bin/functions.sh  |  48 ++-
>  .../testing/selftests/rcutorture/bin/kvm-build.sh  |   6 +-
>  .../selftests/rcutorture/bin/kvm-recheck-lock.sh   |   2 +-
>  .../selftests/rcutorture/bin/kvm-recheck-rcu.sh    |   2 +-
>  .../selftests/rcutorture/bin/kvm-recheck.sh        |  24 +-
>  .../selftests/rcutorture/bin/kvm-test-1-run.sh     |  47 ++-
>  tools/testing/selftests/rcutorture/bin/kvm.sh      | 142 ++++----
>  .../bin/{parse-rcutorture.sh => parse-torture.sh}  |  22 +-
>  .../selftests/rcutorture/configs/rcu/TREE02-T      |  25 ++
>  .../selftests/rcutorture/configs/rcu/TREE08.boot   |   1 +
>  31 files changed, 1210 insertions(+), 412 deletions(-)
>  create mode 100644 Documentation/RCU/rcu_dereference.txt
>  rename tools/testing/selftests/rcutorture/bin/{parse-rcutorture.sh => parse-torture.sh} (79%)
>  create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TREE02-T
>  create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TREE08.boot

Pulled into tip:core/rcu, thanks a lot Paul!

	Ingo
