Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465Ab3ICFnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 01:43:39 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:40506 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab3ICFnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 01:43:37 -0400
Date: Tue, 3 Sep 2013 07:43:33 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: arnd@arndb.de, bjorn@mork.no, bob@cozybit.com, bp@suse.de,
        davem@davemloft.net, davidlohr.bueso@hp.com, dipankar@in.ibm.com,
        eric.dumazet@gmail.com, fengguang.wu@intel.com, fweisbec@gmail.com,
        james.hogan@imgtec.com, johannes@sipsolutions.net,
        john.stultz@linaro.org, josh@joshtriplett.org, kaber@trash.net,
        kevin@guarana.org, laijs@cn.fujitsu.com, lizefan@huawei.com,
        mathieu.desnoyers@efficios.com, riel@surriel.com, rostedt@goodmis.org,
        sedat.dilek@gmail.com, symingz@gmail.com, tglx@linutronix.de,
        tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.12
Message-ID: <20130903054333.GA16261@gmail.com>
References: <20130902182959.GA32334@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130902182959.GA32334@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> The major changes for this series are:
> 
> 1.	Update RCU documentation.  These were posted to LKML at
> 	https://lkml.org/lkml/2013/8/19/611.
> 
> 2.	Miscellaneous fixes.  These were posted to LKML at
> 	https://lkml.org/lkml/2013/8/19/619.
> 
> 3.	Full-system idle detection.  This is for use by Frederic
> 	Weisbecker's adaptive-ticks mechanism.	Its purpose is
> 	to allow the timekeeping CPU to shut off its tick when
> 	all other CPUs are idle.  These were posted to LKML at
> 	https://lkml.org/lkml/2013/8/19/648.
> 
> 4.	Improve rcutorture test coverage.  These were posted to LKML at
> 	https://lkml.org/lkml/2013/8/19/675.
> 
> All of these commits have been subjected to -next testing and are
> available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next
> 
> for you to fetch changes up to 25f27ce4a6a4995c8bdd69b4b2180465ed5ad2b8:
> 
>   Merge branches 'doc.2013.08.19a', 'fixes.2013.08.20a', 'sysidle.2013.08.31a' and 'torture.2013.08.20a' into HEAD (2013-08-31 14:44:45 -0700)
> 
> ----------------------------------------------------------------
> 
> Borislav Petkov (1):
>       rcu: Expedite grace periods during suspend/resume
> 
> James Hogan (1):
>       rcu: Select IRQ_WORK from TREE_PREEMPT_RCU
> 
> Paul E. McKenney (24):
>       rcu: Fix rcu_barrier() documentation
>       rcu: Simplify debug-objects fixups
>       debugobjects: Make debug_object_activate() return status
>       rcu: Make call_rcu() leak callbacks for debug-object errors
>       rcu: Avoid redundant grace-period kthread wakeups
>       rcu: Eliminate unused APIs intended for adaptive ticks
>       nohz_full: Add testing information to documentation
>       nohz_full: Add Kconfig parameter for scalable detection of all-idle state
>       nohz_full: Add rcu_dyntick data for scalable detection of all-idle state
>       nohz_full: Add per-CPU idle-state tracking
>       nohz_full: Add full-system idle states and variables
>       nohz_full: Add full-system-idle arguments to API
>       rcu: Update RTFP documentation
>       doc: Fix memory-barrier control-dependency example
>       rcu: Add duplicate-callback tests to rcutorture
>       rcu: Increase rcutorture test coverage
>       rcu: Sort rcutorture module parameters
>       rcu: Remove unused variable from rcu_torture_writer()
>       rcu: Make rcutorture emit online failures if verbose
>       rcu: Simplify _rcu_barrier() processing
>       jiffies: Avoid undefined behavior from signed overflow
>       nohz_full: Add full-system-idle state machine
>       nohz_full: Force RCU's grace-period kthreads onto timekeeping CPU
>       Merge branches 'doc.2013.08.19a', 'fixes.2013.08.20a', 'sysidle.2013.08.31a' and 'torture.2013.08.20a' into HEAD
> 
> Tejun Heo (1):
>       rculist: list_first_or_null_rcu() should use list_entry_rcu()
> 
>  Documentation/RCU/RTFP.txt        | 858 ++++++++++++++++++++++++--------------
>  Documentation/RCU/rcubarrier.txt  |  12 +-
>  Documentation/RCU/torture.txt     |  10 +
>  Documentation/memory-barriers.txt |  10 +-
>  Documentation/timers/NO_HZ.txt    |  44 +-
>  include/linux/debugobjects.h      |   6 +-
>  include/linux/jiffies.h           |   8 +-
>  include/linux/rculist.h           |   5 +-
>  include/linux/rcupdate.h          |  22 +-
>  init/Kconfig                      |   1 +
>  kernel/rcu.h                      |  10 +-
>  kernel/rcupdate.c                 | 100 -----
>  kernel/rcutorture.c               | 388 ++++++++---------
>  kernel/rcutree.c                  | 150 ++++---
>  kernel/rcutree.h                  |  17 +
>  kernel/rcutree_plugin.h           | 424 ++++++++++++++++++-
>  kernel/time/Kconfig               |  50 +++
>  lib/debugobjects.c                |  20 +-
>  18 files changed, 1418 insertions(+), 717 deletions(-)

Pulled, thanks a lot Paul!

	Ingo
