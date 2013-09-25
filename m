Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab3IYBuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:50:06 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:57387 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab3IYBuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:50:03 -0400
Date: Tue, 24 Sep 2013 18:49:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/6] Idle entry/exit changes for 3.13
Message-ID: <20130925014954.GA32109@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-1344-0000-0000-000001EB0D38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series updates RCU's idle entry/exit processing:

1.	Remove redundant code from rcu_cleanup_after_idle().

2.	Throttle rcu_try_advance_all_cbs() execution to avoid kbuild
	slowdowns.

3.	Throttle non-lazy-callback-induced invoke_rcu_core() invocations.

4.	Add primitive to determine whether it is safe to enter an RCU
	read-side critical section.

5.	Upgrade EXPORT_SYMBOL() to EXPORT_SYMBOL_GPL().

6.	Change rcu_is_cpu_idle() function to __rcu_is_watching() for
	naming consistency.

							Thanx, Paul


 b/include/linux/rcupdate.h |   26 +++++++++++-----------
 b/include/linux/rcutiny.h  |   25 ++++++++++++++++++----
 b/include/linux/rcutree.h  |    4 ++-
 b/kernel/lockdep.c         |    4 +--
 b/kernel/rcupdate.c        |    2 -
 b/kernel/rcutiny.c         |   10 ++++----
 b/kernel/rcutree.c         |   51 ++++++++++++++++++++++++++++-----------------
 b/kernel/rcutree.h         |    2 +
 b/kernel/rcutree_plugin.h  |   24 +++++++++++----------
 9 files changed, 92 insertions(+), 56 deletions(-)

