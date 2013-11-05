Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab3KEMXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 07:23:41 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55909 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab3KEMXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 07:23:40 -0500
Message-Id: <20131105105244.666320103@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 05 Nov 2013 13:10:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, oleg@redhat.com, dhowells@redhat.com,
        willy@linux.intel.com, tglx@linutronix.de, rostedt@goodmis.org,
        airlied@gmail.com, maarten.lankhorst@canonical.com, walken@google.com,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC 0/8] Move locking primitives into kernel/locking/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

During Kernel Summit Dave mentioned that there wasn't a clear maintainer for
locking bits.

To remedy this Ingo suggested gathering all the various locking primitives and
lockdep into a single place: kernel/locking/.

I would further like to propose a MAINTAINERS entry like:

LOCKING
M:      Ingo Molnar <mingo@redhat.com>
M:      Peter Zijlstra <peterz@infradead.org>
M:	Oleg Nesterov <oleg@redhat.com>
M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
M:	Linus Torvalds <torvalds@linux-foundation.org>
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git locking/core
S:      Maintained
F:      kernel/locking/

Because for most 'fun' locking discussions we usually end up with at least
those people anyway :-)

Comments?

---
 kernel/lglock.c                    |   89 
 kernel/lockdep.c                   | 4257 -----------------------------------
 kernel/lockdep_internals.h         |  170 -
 kernel/lockdep_proc.c              |  683 -----
 kernel/lockdep_states.h            |    9 
 kernel/mutex-debug.c               |  110 
 kernel/mutex-debug.h               |   55 
 kernel/mutex.c                     |  960 -------
 kernel/mutex.h                     |   48 
 kernel/rtmutex-debug.c             |  187 -
 kernel/rtmutex-debug.h             |   33 
 kernel/rtmutex-tester.c            |  420 ---
 kernel/rtmutex.c                   | 1060 --------
 kernel/rtmutex.h                   |   26 
 kernel/rtmutex_common.h            |  126 -
 kernel/rwsem.c                     |  157 -
 kernel/semaphore.c                 |  263 --
 kernel/spinlock.c                  |  399 ---
 lib/percpu-rwsem.c                 |  165 -
 lib/rwsem-spinlock.c               |  296 --
 lib/rwsem.c                        |  293 --
 lib/spinlock_debug.c               |  302 --
 kernel/locking/Makefile            |   25 
 kernel/locking/lglock.c            |   89 
 kernel/locking/lockdep.c           | 4257 +++++++++++++++++++++++++++++++++++
 kernel/locking/lockdep_internals.h |  170 +
 kernel/locking/lockdep_proc.c      |  683 +++++
 kernel/locking/lockdep_states.h    |    9 
 kernel/locking/mutex-debug.c       |  110 
 kernel/locking/mutex-debug.h       |   55 
 kernel/locking/mutex.c             |  960 +++++++
 kernel/locking/mutex.h             |   48 
 kernel/locking/percpu-rwsem.c      |  165 +
 kernel/locking/rtmutex-debug.c     |  187 +
 kernel/locking/rtmutex-debug.h     |   33 
 kernel/locking/rtmutex-tester.c    |  420 +++
 kernel/locking/rtmutex.c           | 1060 ++++++++
 kernel/locking/rtmutex.h           |   26 
 kernel/locking/rtmutex_common.h    |  126 +
 kernel/locking/rwsem-spinlock.c    |  296 ++
 kernel/locking/rwsem-xadd.c        |  293 ++
 kernel/locking/rwsem.c             |  157 +
 kernel/locking/semaphore.c         |  263 ++
 kernel/locking/spinlock.c          |  399 +++
 kernel/locking/spinlock_debug.c    |  302 ++
 kernel/Makefile                    |   22 
 kernel/futex.c                     |    2 
 lib/Makefile                       |    4 
 48 files changed, 10138 insertions(+), 10131 deletions(-)



