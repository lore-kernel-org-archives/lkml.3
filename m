Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab3KFO3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:29:35 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:52768 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab3KFO3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:29:34 -0500
Date: Wed, 6 Nov 2013 06:29:21 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, oleg@redhat.com,
        dhowells@redhat.com, willy@linux.intel.com, tglx@linutronix.de,
        rostedt@goodmis.org, airlied@gmail.com,
        maarten.lankhorst@canonical.com, walken@google.com,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC 0/8] Move locking primitives into kernel/locking/
Message-ID: <20131106142921.GJ18245@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131105105244.666320103@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105105244.666320103@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110614-8236-0000-0000-0000037BCADE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 01:10:44PM +0100, Peter Zijlstra wrote:
> Hi all,
> 
> During Kernel Summit Dave mentioned that there wasn't a clear maintainer for
> locking bits.
> 
> To remedy this Ingo suggested gathering all the various locking primitives and
> lockdep into a single place: kernel/locking/.
> 
> I would further like to propose a MAINTAINERS entry like:
> 
> LOCKING
> M:      Ingo Molnar <mingo@redhat.com>
> M:      Peter Zijlstra <peterz@infradead.org>
> M:	Oleg Nesterov <oleg@redhat.com>
> M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> M:	Linus Torvalds <torvalds@linux-foundation.org>
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git locking/core
> S:      Maintained
> F:      kernel/locking/
> 
> Because for most 'fun' locking discussions we usually end up with at least
> those people anyway :-)
> 
> Comments?

OK, I am in.

How are we organizing this?  I could imagine divvying up the various
types of locks, having a minimum number of reviews or acks coupled
with a maximum review time, or just requiring the full set of reviews
and acks given the criticality of locking code.  Other approaches?

						Thanx, Paul

> ---
>  kernel/lglock.c                    |   89 
>  kernel/lockdep.c                   | 4257 -----------------------------------
>  kernel/lockdep_internals.h         |  170 -
>  kernel/lockdep_proc.c              |  683 -----
>  kernel/lockdep_states.h            |    9 
>  kernel/mutex-debug.c               |  110 
>  kernel/mutex-debug.h               |   55 
>  kernel/mutex.c                     |  960 -------
>  kernel/mutex.h                     |   48 
>  kernel/rtmutex-debug.c             |  187 -
>  kernel/rtmutex-debug.h             |   33 
>  kernel/rtmutex-tester.c            |  420 ---
>  kernel/rtmutex.c                   | 1060 --------
>  kernel/rtmutex.h                   |   26 
>  kernel/rtmutex_common.h            |  126 -
>  kernel/rwsem.c                     |  157 -
>  kernel/semaphore.c                 |  263 --
>  kernel/spinlock.c                  |  399 ---
>  lib/percpu-rwsem.c                 |  165 -
>  lib/rwsem-spinlock.c               |  296 --
>  lib/rwsem.c                        |  293 --
>  lib/spinlock_debug.c               |  302 --
>  kernel/locking/Makefile            |   25 
>  kernel/locking/lglock.c            |   89 
>  kernel/locking/lockdep.c           | 4257 +++++++++++++++++++++++++++++++++++
>  kernel/locking/lockdep_internals.h |  170 +
>  kernel/locking/lockdep_proc.c      |  683 +++++
>  kernel/locking/lockdep_states.h    |    9 
>  kernel/locking/mutex-debug.c       |  110 
>  kernel/locking/mutex-debug.h       |   55 
>  kernel/locking/mutex.c             |  960 +++++++
>  kernel/locking/mutex.h             |   48 
>  kernel/locking/percpu-rwsem.c      |  165 +
>  kernel/locking/rtmutex-debug.c     |  187 +
>  kernel/locking/rtmutex-debug.h     |   33 
>  kernel/locking/rtmutex-tester.c    |  420 +++
>  kernel/locking/rtmutex.c           | 1060 ++++++++
>  kernel/locking/rtmutex.h           |   26 
>  kernel/locking/rtmutex_common.h    |  126 +
>  kernel/locking/rwsem-spinlock.c    |  296 ++
>  kernel/locking/rwsem-xadd.c        |  293 ++
>  kernel/locking/rwsem.c             |  157 +
>  kernel/locking/semaphore.c         |  263 ++
>  kernel/locking/spinlock.c          |  399 +++
>  kernel/locking/spinlock_debug.c    |  302 ++
>  kernel/Makefile                    |   22 
>  kernel/futex.c                     |    2 
>  lib/Makefile                       |    4 
>  48 files changed, 10138 insertions(+), 10131 deletions(-)
> 
> 
> 

