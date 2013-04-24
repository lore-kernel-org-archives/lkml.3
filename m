Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab3DXCs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 22:48:58 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:47559 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab3DXCs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 22:48:56 -0400
Date: Tue, 23 Apr 2013 19:48:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rik van Riel <riel@surriel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH tip/core/rcu 0/4] RCU debug-objects improvements
Message-ID: <20130424024849.GE3427@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+icZUVyAvSuts0hCUFvnQkGUFztjmuz0v4MpwHCahyHf7XZOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUVyAvSuts0hCUFvnQkGUFztjmuz0v4MpwHCahyHf7XZOw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042402-5518-0000-0000-00000DDE5B37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 03:45:20AM +0200, Sedat Dilek wrote:
> [ QUOTE ]
> 
> Hello!
> 
> RCU's current debug-objects fixups are complex and heavyweight, plus the
> fixups are not complete, because even with the fixups, RCU's callback
> lists can still be corrupted.  This series reworks RCU's use of the
> debug-objects facility and the facility itself to allow improved handling
> of things like duplicate invocations of call_rcu().  This series includes:
> 
> 1.	Simplify RCU's debug-objects fixups.
> 
> 2.	Make debug_object_activate() return status.
> 
> 3.	Make __call_rcu() leak callbacks when debug_object_activate()
> 	notes suspicious activity.  Leaking has its problems, but it
> 	is far better than silent corruption of RCU's data structures.
> 
> 4.	Add a new object_debug option to rcutorture to allow
> 	deterministic testing of #3 above.
> 
> 							Thanx, Paul
> 
> 
>  b/include/linux/debugobjects.h |    6 +-
>  b/kernel/rcu.h                 |   10 ++--
>  b/kernel/rcupdate.c            |  100 -----------------------------------------
>  b/kernel/rcutorture.c          |   37 +++++++++++++++
>  b/kernel/rcutree.c             |   14 +++++
>  b/lib/debugobjects.c           |   20 +++++---
>  6 files changed, 74 insertions(+), 113 deletions(-)
> 
> [ /QUOTE ]
> 
> I applied your patchset against the "buggy" Linux-Next (next-20130423)
> with none of the ipc-sem-next patches (even w/o the suggested Linus
> patch) to see if I see more debug-outputs,
> 
> I have attached my syslog while building my kernel.
> Please, have a look!

The warnings and the leaking of the offending callback are all present,
thank you for testing this!

> Thanks for the patches.
> 
> Feel free to add to all of the 4 patches my Tested-by.

Will do!

						Thanx, Paul

> - Sedat -
> 
> [1] http://marc.info/?l=linux-kernel&m=136676361101735&w=2



