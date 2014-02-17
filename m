Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbaBQVfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:35:40 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:60661 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbaBQVfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:35:38 -0500
Date: Mon, 17 Feb 2014 13:35:33 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/12] Miscellaneous fixes for 3.15
Message-ID: <20140217213533.GA5387@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021721-0928-0000-0000-000006C30E58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series provides miscellaneous fixes;

1.	Add ACCESS_ONCE() to uses of ->n_force_qs_lh.

2.	Stop tracking FSF's postal address.

3.	Remove ACCESS_ONCE() from the volatile-declared jiffies.

4.	Glue ASCII strings together, courtesy of Joe Perches.

5.	Indentation and spacing fixes, courtesy of Joe Perches.

6.	Define rcu_assign_pointer() in terms of Peter Zijlstra's shiny
	new smp_store_release().

7.	Disambiguate CONFIG_RCU_NOCB_CPUs, courtesy of Paul Bolle.

8.	Move SRCU work to power-efficient workqueue, courtesy of
	Shaibal Dutta.

9-12.	Downgrade rcu_dereference_raw() to rcu_access_pointer() in
	cases where there is no subsequent dereferencing.

							Thanx, Paul

------------------------------------------------------------------------

 b/block/blk-cgroup.c       |    2 -
 b/block/blk-ioc.c          |    2 -
 b/fs/file.c                |    2 -
 b/include/linux/rculist.h  |   17 ++++-----
 b/include/linux/rcupdate.h |    4 +-
 b/include/linux/rcutiny.h  |    4 +-
 b/include/linux/rcutree.h  |    4 +-
 b/include/linux/srcu.h     |    4 +-
 b/kernel/ksysfs.c          |    2 +
 b/kernel/notifier.c        |    2 -
 b/kernel/rcu/rcu.h         |    4 +-
 b/kernel/rcu/srcu.c        |    4 +-
 b/kernel/rcu/tiny.c        |    4 +-
 b/kernel/rcu/tiny_plugin.h |    4 +-
 b/kernel/rcu/torture.c     |    4 +-
 b/kernel/rcu/tree.c        |    4 +-
 b/kernel/rcu/tree.h        |    4 +-
 b/kernel/rcu/tree_plugin.h |    4 +-
 b/kernel/rcu/tree_trace.c  |    2 -
 b/kernel/rcu/update.c      |    4 +-
 include/linux/rcupdate.h   |   82 ++++++++++++++++++++-------------------------
 kernel/rcu/rcu.h           |    2 -
 kernel/rcu/srcu.c          |    5 +-
 kernel/rcu/torture.c       |    4 +-
 kernel/rcu/tree.c          |   10 ++---
 kernel/rcu/tree_plugin.h   |    2 -
 kernel/rcu/tree_trace.c    |    4 +-
 27 files changed, 92 insertions(+), 98 deletions(-)

