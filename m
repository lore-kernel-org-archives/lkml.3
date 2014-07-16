Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbaGPLu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 07:50:59 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:40011 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759589AbaGPLu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 07:50:57 -0400
Date: Wed, 16 Jul 2014 13:50:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, fabf@skynet.be, bobby.prani@gmail.com,
        davidshan@tencent.com, joe@perches.com, keescook@chromium.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.17
Message-ID: <20140716115046.GC28434@gmail.com>
References: <20140713184237.GA30855@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140713184237.GA30855@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> The changes in this series include:
> 
> 1.	Update RCU documentation.  These were posted to LKML at
> 	https://lkml.org/lkml/2014/7/7/650.
> 
> 2.	Miscellaneous fixes.  These were posted to LKML at
> 	https://lkml.org/lkml/2014/7/7/678.
> 
> 3.	Maintainership changes.  These were posted to LKML at
> 	https://lkml.org/lkml/2014/7/7/713, with a couple of
> 	additional at https://lkml.org/lkml/2014/7/3/812 and
> 	https://lkml.org/lkml/2014/6/2/585.
> 
> 4.	Torture-test updates.  These were posted to LKML at
> 	https://lkml.org/lkml/2014/7/7/816.
> 
> 5.	Callback-offloading changes.  These were posted to LKML at
> 	https://lkml.org/lkml/2014/7/7/1007.
> 
> All of these have been exposed to -next testing.
> These changes are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next
> 
> for you to fetch changes up to 1823172ab582eb54456fd1354869bb850a1196ba:
> 
>   Merge branches 'doc.2014.07.08a', 'fixes.2014.07.09a', 'maintainers.2014.07.08b', 'nocbs.2014.07.07a' and 'torture.2014.07.07a' into HEAD (2014-07-09 09:16:54 -0700)
> 
> ----------------------------------------------------------------
> 
> Fabian Frederick (1):
>       rcu: Make rcu node arrays static const char * const
> 
> Joe Perches (2):
>       rcu: Update rcu torture maintainership filename patterns
>       scripts: Teach get_maintainer.pl about the new "R:" tag
> 
> Kees Cook (1):
>       torture: Avoid format string leak to thead name
> 
> Paul E. McKenney (23):
>       torture: Enable versions without CFcommon to function correctly
>       torture: Clean up diagnostics from --buildonly runs
>       MAINTAINERS: Add "R:" designated-reviewers tag
>       rcu: Add designated reviewers for RCU
>       rcu: Parallelize and economize NOCB kthread wakeups
>       rcu: Don't offload callbacks unless specifically requested
>       documentation: Clarify wake-up/memory-barrier relationship
>       documentation: Add acquire/release barriers to pairing rules
>       documentation: Add pointer to percpu-ref for RCU and refcount
>       rcu: Update RCU maintainership
>       rcu: Document deadlock-avoidance information for rcu_read_unlock()
>       rcu: Handle obsolete references to TINY_PREEMPT_RCU
>       signal: Explain local_irq_save() call
>       rcu: Remove redundant ACCESS_ONCE() from tick_do_timer_cpu
>       rcu: Eliminate read-modify-write ACCESS_ONCE() calls
>       rcu: Loosen __call_rcu()'s rcu_head alignment constraint
>       rcu: Allow post-unlock reference for rt_mutex
>       rcu: Simplify priority boosting by putting rt_mutex in rcu_node
>       rcu: Bind grace-period kthreads to non-NO_HZ_FULL CPUs
>       rcu: Don't use NMIs to dump other CPUs' stacks
>       rcu: Remove CONFIG_PROVE_RCU_DELAY
>       rcu: Fix __rcu_reclaim() to use true/false for bool
>       Merge branches 'doc.2014.07.08a', 'fixes.2014.07.09a', 'maintainers.2014.07.08b', 'nocbs.2014.07.07a' and 'torture.2014.07.07a' into HEAD
> 
> Pranith Kumar (4):
>       documentation: Update reference, kerneltrap.org no longer works
>       rcu: Check both root and current rcu_node when setting up future grace period
>       rcu: Fix a sparse warning in rcu_initiate_boost()
>       rcu: Fix a sparse warning in rcu_report_unblock_qs_rnp()
> 
> Shan Wei (1):
>       rcu: Use __this_cpu_read() instead of per_cpu_ptr()
> 
>  Documentation/RCU/RTFP.txt                         |   4 +-
>  Documentation/RCU/rcuref.txt                       |   9 +
>  Documentation/kernel-parameters.txt                |   7 +
>  Documentation/memory-barriers.txt                  |  27 +-
>  MAINTAINERS                                        |  18 +-
>  include/linux/init_task.h                          |   9 +-
>  include/linux/rcupdate.h                           |  45 ++-
>  include/linux/sched.h                              |   6 -
>  include/linux/tick.h                               |  20 ++
>  init/Kconfig                                       |   6 +-
>  kernel/rcu/rcu.h                                   |   8 +-
>  kernel/rcu/srcu.c                                  |   4 +-
>  kernel/rcu/tree.c                                  |  59 ++--
>  kernel/rcu/tree.h                                  |  36 ++-
>  kernel/rcu/tree_plugin.h                           | 301 +++++++++++++++++----
>  kernel/rcu/update.c                                |   3 -
>  kernel/signal.c                                    |   4 +
>  kernel/time/tick-sched.c                           |  10 +
>  kernel/torture.c                                   |   2 +-
>  lib/Kconfig.debug                                  |  14 -
>  scripts/get_maintainer.pl                          |  22 +-
>  .../selftests/rcutorture/bin/kvm-recheck.sh        |   8 +-
>  .../selftests/rcutorture/bin/kvm-test-1-run.sh     |   9 +-
>  tools/testing/selftests/rcutorture/bin/kvm.sh      |  21 +-
>  .../selftests/rcutorture/configs/rcu/TREE01        |   1 -
>  .../selftests/rcutorture/configs/rcu/TREE02        |   1 -
>  .../selftests/rcutorture/configs/rcu/TREE02-T      |   1 -
>  .../selftests/rcutorture/configs/rcu/TREE03        |   1 -
>  .../selftests/rcutorture/configs/rcu/TREE04        |   1 -
>  .../selftests/rcutorture/configs/rcu/TREE05        |   1 -
>  .../selftests/rcutorture/configs/rcu/TREE06        |   1 -
>  .../selftests/rcutorture/configs/rcu/TREE07        |   1 -
>  .../selftests/rcutorture/configs/rcu/TREE08        |   1 -
>  .../selftests/rcutorture/configs/rcu/TREE08-T      |   1 -
>  .../selftests/rcutorture/configs/rcu/TREE09        |   1 -
>  .../configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp           |   1 -
>  .../configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp          |   1 -
>  .../configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp           |   1 -
>  .../configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp           |   1 -
>  .../selftests/rcutorture/doc/TREE_RCU-kconfig.txt  |   1 -
>  40 files changed, 491 insertions(+), 177 deletions(-)
> 

Pulled, thanks a lot Paul!

	Ingo
