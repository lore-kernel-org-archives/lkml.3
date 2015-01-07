Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbbAGRUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:20:40 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:40872 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbbAGRUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:20:38 -0500
Date: Wed, 7 Jan 2015 09:20:30 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: [PATCH tip/core/rcu 0/10] Miscellaneous fixes for 3.20
Message-ID: <20150107172030.GA31571@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0017-0000-0000-000007BD521F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains miscellaneous fixes for 3.20:

1.	Make rcu_nmi_enter() handle nesting, as there are now some
	architectures that use RCU read-side critical sections in
	NMI-like constructs that can nest in one another.  Algorithm
	courtesy of Andy Lutomirski.

2.	Remove redundant rcu_is_cpu_rrupt_from_idle() from tiny RCU,
	courtesy of Alexander Gordeev.

3.	Fix invoke_rcu_callbacks() comment to correctly reflect
	required calling environment.

4.	Allow 1- and 2-byte smp_load_acquire() and smp_store_release(),
	given that the C11 standard requires that compilers support this.

5.	Replace smp_read_barrier_depends() with lockless_dereference(),
	courtesy of Pranith Kumar.

6.	Directly force QS when call_rcu_[bh|sched]() on idle_task for
	tiny RCU, courtesy of Lai Jiangshan.  Saves more than 1KB.

7.	Fix sparse warning from hlist_for_each_entry_continue_rcu_bh(),
	courtesy of Ying Xue.

8.	Fix hang in CPU hotplug code, courtesy of David Hildenbrand.

9.	Fix rcu_barrier() race that could result in too-short wait.

10.	Remove obsolete "select IRQ_WORK" from config TREE_RCU, courtesy
	of Lai Jiangshan.

							Thanx, Paul

------------------------------------------------------------------------

 b/include/linux/compiler.h |    2 
 b/include/linux/rculist.h  |   16 +++---
 b/include/linux/rcupdate.h |   10 ++--
 b/init/Kconfig             |    2 
 b/kernel/cpu.c             |   56 +++++++++-------------
 b/kernel/rcu/rcu.h         |    6 ++
 b/kernel/rcu/tiny.c        |  111 +++------------------------------------------
 b/kernel/rcu/tiny_plugin.h |    2 
 b/kernel/rcu/tree.c        |   75 ++++++++++++++++++++----------
 b/kernel/rcu/tree.h        |   30 ++----------
 b/kernel/rcu/tree_plugin.h |   45 +++++++++++-------
 11 files changed, 138 insertions(+), 217 deletions(-)

