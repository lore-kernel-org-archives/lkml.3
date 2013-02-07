Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161025Ab3BGSD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 13:03:27 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:52541 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030213Ab3BGSDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:03:25 -0500
Date: Thu, 7 Feb 2013 08:15:32 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        rostedt@goodmis.org, rbraun@sceen.net, zhong@linux.vnet.ibm.com,
        markus@trippelsdorf.de, sasha.levin@oracle.com,
        cody@linux.vnet.ibm.com, dave@linux.vnet.ibm.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.9
Message-ID: <20130207161532.GR2632@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130204171817.GA18332@linux.vnet.ibm.com>
 <51138E4C.2080005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51138E4C.2080005@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020718-7408-0000-0000-00000C9B987F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 07:21:48PM +0800, Lai Jiangshan wrote:
> Hi, Paul
> 
> These (https://lkml.org/lkml/2012/11/29/123) are still not merged.

Ah, good point...

My intent was to merge as soon as https://lkml.org/lkml/2012/12/5/201
was responded to.  The question should not have blocked merging, so I
should have followed up, but the again, so should have you.  ;-)

I queued the patches, and if testing goes well, will push them to -tip
in a few days.

The remaining issue for invoking srcu_read_lock() from offline CPUs is
that lockdep does tracing that uses RCU.  So your patch 4/8 is incomplete,
though a good step towards allowing SRCU to be invoked from offline CPUs.
Thoughts on getting the rest of the way there?

							Thanx, Paul

> Thanks,
> lai
> 
> On 05/02/13 01:18, Paul E. McKenney wrote:
> >Hello, Ingo,
> >
> >The major features of this series are:
> >
> >1.	Changes to rcutorture and to RCU documentation.  Posted to LKML at
> >	https://lkml.org/lkml/2013/1/26/188.
> >
> >2.	Enhancements to uniprocessor handling in tiny RCU. Posted to LKML
> >	at https://lkml.org/lkml/2013/1/27/2.
> >
> >3.	Tag RCU callbacks with grace-period number to simplify callback
> >	advancement.  Posted to LKML at https://lkml.org/lkml/2013/1/26/203.
> >
> >4.	Miscellaneous fixes.  Posted to LKML at
> >	https://lkml.org/lkml/2013/1/26/204.
> >
> >All of these commits have been subject to -next testing.
> >
> >These changes are available in the git repository at:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next
> >
> >--------------------->
> >
> >Cody P Schafer (1):
> >       rcu: Correct 'optimized' to 'optimize' in header comment
> >
> >Dave Hansen (1):
> >       rcu: Consolidate debugging Kconfig options
> >
> >Frederic Weisbecker (1):
> >       context_tracking: Add comments on interface and internals
> >
> >Josh Triplett (1):
> >       rcu: Make rcu_is_cpu_rrupt_from_idle helper functions static
> >
> >Li Zhong (2):
> >       rcu: Use new nesting value for rcu_dyntick trace in rcu_eqs_enter_common
> >       rcu: Remove unused code originally used for context tracking
> >
> >Paul E. McKenney (11):
> >       tracing: Export trace_clock_local()
> >       rcu: Reduce rcutorture tracing
> >       rcu: Fix blimit type for trace_rcu_batch_start()
> >       rcu: Silence compiler array out-of-bounds false positive
> >       rcu: Tag callback lists with corresponding grace-period number
> >       rcu: Trace callback acceleration
> >       rcu: Remove obsolete Kconfig option from comment
> >       rcu: Provide RCU CPU stall warnings for tiny RCU
> >       rcu: Allow TREE_PREEMPT_RCU on UP systems
> >       rcu: Make rcutorture's shuffler task shuffle recently added tasks
> >       Merge branches 'doctorture.2013.01.29a', 'fixes.2013.01.26a', 'tagcb.2013.01.24a' and 'tiny.2013.01.29b' into HEAD
> >
> >Richard Braun (1):
> >       Documentation: Memory barrier semantics of atomic_xchg()
> >
> >Sasha Levin (1):
> >       rcutorture: Don't compare ptr with 0
> >
> >  Documentation/atomic_ops.txt      |    2 +
> >  Documentation/memory-barriers.txt |    1 +
> >  include/linux/rcupdate.h          |   15 ++-
> >  include/trace/events/rcu.h        |   31 +++--
> >  init/Kconfig                      |   12 ++-
> >  kernel/context_tracking.c         |   75 +++++++++--
> >  kernel/rcu.h                      |    7 +
> >  kernel/rcupdate.c                 |   60 ++++++++-
> >  kernel/rcutiny.c                  |    8 +-
> >  kernel/rcutiny_plugin.h           |   56 ++++++++
> >  kernel/rcutorture.c               |   57 +++++++--
> >  kernel/rcutree.c                  |  260 ++++++++++++++++++++++++++-----------
> >  kernel/rcutree.h                  |   11 +--
> >  kernel/trace/trace_clock.c        |    1 +
> >  lib/Kconfig.debug                 |  117 +++++++++--------
> >  15 files changed, 528 insertions(+), 185 deletions(-)
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >Please read the FAQ at  http://www.tux.org/lkml/
> >
> 

