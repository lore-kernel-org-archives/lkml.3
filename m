Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab3BDSHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 13:07:40 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:44404 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab3BDSHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 13:07:39 -0500
Date: Mon, 4 Feb 2013 19:07:34 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        rostedt@goodmis.org, rbraun@sceen.net, zhong@linux.vnet.ibm.com,
        markus@trippelsdorf.de, sasha.levin@oracle.com,
        cody@linux.vnet.ibm.com, dave@linux.vnet.ibm.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.9
Message-ID: <20130204180734.GA10022@gmail.com>
References: <20130204171817.GA18332@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204171817.GA18332@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> The major features of this series are:
> 
> 1.	Changes to rcutorture and to RCU documentation.  Posted to LKML at
> 	https://lkml.org/lkml/2013/1/26/188.
> 
> 2.	Enhancements to uniprocessor handling in tiny RCU. Posted to LKML
> 	at https://lkml.org/lkml/2013/1/27/2.
> 
> 3.	Tag RCU callbacks with grace-period number to simplify callback
> 	advancement.  Posted to LKML at https://lkml.org/lkml/2013/1/26/203.
> 
> 4.	Miscellaneous fixes.  Posted to LKML at
> 	https://lkml.org/lkml/2013/1/26/204.
> 
> All of these commits have been subject to -next testing.
> 
> These changes are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next
> 
> --------------------->
> 
> Cody P Schafer (1):
>       rcu: Correct 'optimized' to 'optimize' in header comment
> 
> Dave Hansen (1):
>       rcu: Consolidate debugging Kconfig options
> 
> Frederic Weisbecker (1):
>       context_tracking: Add comments on interface and internals
> 
> Josh Triplett (1):
>       rcu: Make rcu_is_cpu_rrupt_from_idle helper functions static
> 
> Li Zhong (2):
>       rcu: Use new nesting value for rcu_dyntick trace in rcu_eqs_enter_common
>       rcu: Remove unused code originally used for context tracking
> 
> Paul E. McKenney (11):
>       tracing: Export trace_clock_local()
>       rcu: Reduce rcutorture tracing
>       rcu: Fix blimit type for trace_rcu_batch_start()
>       rcu: Silence compiler array out-of-bounds false positive
>       rcu: Tag callback lists with corresponding grace-period number
>       rcu: Trace callback acceleration
>       rcu: Remove obsolete Kconfig option from comment
>       rcu: Provide RCU CPU stall warnings for tiny RCU
>       rcu: Allow TREE_PREEMPT_RCU on UP systems
>       rcu: Make rcutorture's shuffler task shuffle recently added tasks
>       Merge branches 'doctorture.2013.01.29a', 'fixes.2013.01.26a', 'tagcb.2013.01.24a' and 'tiny.2013.01.29b' into HEAD
> 
> Richard Braun (1):
>       Documentation: Memory barrier semantics of atomic_xchg()
> 
> Sasha Levin (1):
>       rcutorture: Don't compare ptr with 0
> 
>  Documentation/atomic_ops.txt      |    2 +
>  Documentation/memory-barriers.txt |    1 +
>  include/linux/rcupdate.h          |   15 ++-
>  include/trace/events/rcu.h        |   31 +++--
>  init/Kconfig                      |   12 ++-
>  kernel/context_tracking.c         |   75 +++++++++--
>  kernel/rcu.h                      |    7 +
>  kernel/rcupdate.c                 |   60 ++++++++-
>  kernel/rcutiny.c                  |    8 +-
>  kernel/rcutiny_plugin.h           |   56 ++++++++
>  kernel/rcutorture.c               |   57 +++++++--
>  kernel/rcutree.c                  |  260 ++++++++++++++++++++++++++-----------
>  kernel/rcutree.h                  |   11 +--
>  kernel/trace/trace_clock.c        |    1 +
>  lib/Kconfig.debug                 |  117 +++++++++--------
>  15 files changed, 528 insertions(+), 185 deletions(-)

Pulled, thanks a lot Paul!

	Ingo
