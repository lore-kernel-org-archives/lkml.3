Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab3BGLWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 06:22:39 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:56066 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758124Ab3BGLWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 06:22:36 -0500
Message-ID: <51138E4C.2080005@gmail.com>
Date: Thu, 07 Feb 2013 19:21:48 +0800
From: Lai Jiangshan <eag0628@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        rostedt@goodmis.org, rbraun@sceen.net, zhong@linux.vnet.ibm.com,
        markus@trippelsdorf.de, sasha.levin@oracle.com,
        cody@linux.vnet.ibm.com, dave@linux.vnet.ibm.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.9
References: <20130204171817.GA18332@linux.vnet.ibm.com>
In-Reply-To: <20130204171817.GA18332@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Paul

These (https://lkml.org/lkml/2012/11/29/123) are still not merged.

Thanks,
lai

On 05/02/13 01:18, Paul E. McKenney wrote:
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
>    git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next
>
> --------------------->
>
> Cody P Schafer (1):
>        rcu: Correct 'optimized' to 'optimize' in header comment
>
> Dave Hansen (1):
>        rcu: Consolidate debugging Kconfig options
>
> Frederic Weisbecker (1):
>        context_tracking: Add comments on interface and internals
>
> Josh Triplett (1):
>        rcu: Make rcu_is_cpu_rrupt_from_idle helper functions static
>
> Li Zhong (2):
>        rcu: Use new nesting value for rcu_dyntick trace in rcu_eqs_enter_common
>        rcu: Remove unused code originally used for context tracking
>
> Paul E. McKenney (11):
>        tracing: Export trace_clock_local()
>        rcu: Reduce rcutorture tracing
>        rcu: Fix blimit type for trace_rcu_batch_start()
>        rcu: Silence compiler array out-of-bounds false positive
>        rcu: Tag callback lists with corresponding grace-period number
>        rcu: Trace callback acceleration
>        rcu: Remove obsolete Kconfig option from comment
>        rcu: Provide RCU CPU stall warnings for tiny RCU
>        rcu: Allow TREE_PREEMPT_RCU on UP systems
>        rcu: Make rcutorture's shuffler task shuffle recently added tasks
>        Merge branches 'doctorture.2013.01.29a', 'fixes.2013.01.26a', 'tagcb.2013.01.24a' and 'tiny.2013.01.29b' into HEAD
>
> Richard Braun (1):
>        Documentation: Memory barrier semantics of atomic_xchg()
>
> Sasha Levin (1):
>        rcutorture: Don't compare ptr with 0
>
>   Documentation/atomic_ops.txt      |    2 +
>   Documentation/memory-barriers.txt |    1 +
>   include/linux/rcupdate.h          |   15 ++-
>   include/trace/events/rcu.h        |   31 +++--
>   init/Kconfig                      |   12 ++-
>   kernel/context_tracking.c         |   75 +++++++++--
>   kernel/rcu.h                      |    7 +
>   kernel/rcupdate.c                 |   60 ++++++++-
>   kernel/rcutiny.c                  |    8 +-
>   kernel/rcutiny_plugin.h           |   56 ++++++++
>   kernel/rcutorture.c               |   57 +++++++--
>   kernel/rcutree.c                  |  260 ++++++++++++++++++++++++++-----------
>   kernel/rcutree.h                  |   11 +--
>   kernel/trace/trace_clock.c        |    1 +
>   lib/Kconfig.debug                 |  117 +++++++++--------
>   15 files changed, 528 insertions(+), 185 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

