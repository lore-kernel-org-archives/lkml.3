Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaBQVkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:40:15 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:59295 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaBQVkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:40:13 -0500
Date: Mon, 17 Feb 2014 13:40:07 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/3] Response-time changes for 3.15
Message-ID: <20140217214007.GA6609@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021721-7164-0000-0000-000006267BEE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains minor response-time improvements.

1.	Create trivial always-true version of rcu_is_nocb_cpu() for
	CONFIG_RCU_NOCB_CPU_ALL=y kernels.

2.	Create trivial always-false version of rcu_needs_cpu() for
	CONFIG_RCU_NOCB_CPU_ALL=y kernels.

3.	Don't bother doing CONFIG_RCU_FAST_NO_HZ work at idle entry
	and exit time for CONFIG_RCU_NOCB_CPU_ALL=y kernels.

							Thanx, Paul

------------------------------------------------------------------------

 b/include/linux/rcupdate.h |    4 ++++
 b/include/linux/rcutiny.h  |    6 ------
 b/include/linux/rcutree.h  |    2 ++
 b/kernel/rcu/tree.c        |    2 +-
 b/kernel/rcu/tree_plugin.h |    2 ++
 include/linux/rcupdate.h   |    9 +++++++++
 kernel/rcu/tree_plugin.h   |   11 +++++++++--
 7 files changed, 27 insertions(+), 9 deletions(-)

