Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbaJ1WR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:17:26 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49325 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbaJ1WRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:17:24 -0400
Date: Tue, 28 Oct 2014 15:13:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: [PATCH tip/core/rcu 0/2] Signal-related changes for 3.19
Message-ID: <20141028221330.GA27479@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0033-0000-0000-000000E3F9DC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series updates RCU handling in signals:

1.	Prevents a possible very long RCU read-side critical section
	in kill_pid_info().

2.	Explain why the "obviously buggy" freeing of sighand by
	__cleanup_sighand() without an RCU grace period really isn't
	buggy, courtesy of Oleg Nesterov.

							Thanx, Paul

------------------------------------------------------------------------

 b/kernel/fork.c   |    5 ++++-
 b/kernel/signal.c |   42 +++++++++++++++++++++++++-----------------
 2 files changed, 29 insertions(+), 18 deletions(-)

