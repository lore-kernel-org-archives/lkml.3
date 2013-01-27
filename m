Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab3A0AEv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 19:04:51 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41987 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530Ab3A0AEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 19:04:48 -0500
Date: Sat, 26 Jan 2013 16:04:35 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/4] v2 Documentation and rcutorture changes for
 3.9
Message-ID: <20130127000435.GA1521@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012700-5806-0000-0000-00001ECE0D57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

The following are changes to documentation and rcutorture:

1.	Export trace_clock_local() in order to allow rcutorture event
	tracing to emit the time of the beginning of the RCU read-side
	critical section at the point where a failure is detected.
2.	Reduce rcutorture's read-side tracing to include only failures,
	thus cutting the number of events down to something reasonable
	(normally zero, in fact!).
3.	Add atomic_xchg() to the list of atomic operations and memory
	barriers, courtesy of Richard Braun.
4.	Make rcutorture's shuffler task also shuffle recently added
	rcutorture kthreads.

Changes since v1:

o	Fixed build problem in #2 located by Randy Dunlap based on
	diagnosis from Steven Rostedt.

o	Added patch #4.

							Thanx, Paul


 b/Documentation/atomic_ops.txt      |    2 +
 b/Documentation/memory-barriers.txt |    1 
 b/include/linux/rcupdate.h          |   13 ++++++--
 b/include/trace/events/rcu.h        |   19 +++++++++---
 b/kernel/rcupdate.c                 |    9 +++--
 b/kernel/rcutorture.c               |   55 ++++++++++++++++++++++++++++--------
 b/kernel/trace/trace_clock.c        |    1 
 b/lib/Kconfig.debug                 |    1 
 8 files changed, 79 insertions(+), 22 deletions(-)

