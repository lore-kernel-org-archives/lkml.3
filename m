Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab3DXAdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 20:33:22 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:47409 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab3DXAdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 20:33:21 -0400
Date: Tue, 23 Apr 2013 17:33:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/4] RCU debug-objects improvements
Message-ID: <20130424003312.GA15819@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042400-7408-0000-0000-00000F59D3A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

RCU's current debug-objects fixups are complex and heavyweight, plus the
fixups are not complete, because even with the fixups, RCU's callback
lists can still be corrupted.  This series reworks RCU's use of the
debug-objects facility and the facility itself to allow improved handling
of things like duplicate invocations of call_rcu().  This series includes:

1.	Simplify RCU's debug-objects fixups.

2.	Make debug_object_activate() return status.

3.	Make __call_rcu() leak callbacks when debug_object_activate()
	notes suspicious activity.  Leaking has its problems, but it
	is far better than silent corruption of RCU's data structures.

4.	Add a new object_debug option to rcutorture to allow
	deterministic testing of #3 above.

							Thanx, Paul


 b/include/linux/debugobjects.h |    6 +-
 b/kernel/rcu.h                 |   10 ++--
 b/kernel/rcupdate.c            |  100 -----------------------------------------
 b/kernel/rcutorture.c          |   37 +++++++++++++++
 b/kernel/rcutree.c             |   14 +++++
 b/lib/debugobjects.c           |   20 +++++---
 6 files changed, 74 insertions(+), 113 deletions(-)

