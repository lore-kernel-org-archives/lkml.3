Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaANEO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 23:14:59 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:37837 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbaANEO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 23:14:56 -0500
Date: Mon, 13 Jan 2014 20:14:50 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/3] Crude timer-wheel latency hacks
Message-ID: <20140114041449.GA13934@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011404-0928-0000-0000-000005603982
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

The following three patches provide some crude timer-wheel latency
patches.  I understand that a more comprehensive solution is in progress,
but in the meantime, these patches work well in cases where a given
CPU has either zero or one timers pending, which is a common case for
NO_HZ_FULL kernels.  So, on the off-chance that this is helpful to
someone, the individual patches are as follows:

1.	Avoid jiffy-at-a-time stepping when the timer wheel is empty.

2.	Avoid jiffy-at-a-time stepping when the timer wheel transitions
	to empty.

3.	Avoid jiffy-at-a-time stepping after a timer is added to an
	initially empty timer wheel.

							Thanx, Paul

------------------------------------------------------------------------

 b/kernel/timer.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

