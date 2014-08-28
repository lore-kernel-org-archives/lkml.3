Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaH1S0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:26:24 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:52655 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaH1S0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:26:23 -0400
Date: Thu, 28 Aug 2014 11:26:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: [PATCH tip/core/rcu 0/15] Miscellaneous fixes for 3.18
Message-ID: <20140828182614.GA23877@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-3532-0000-0000-00000437050C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains miscellaneous fixes for RCU:

1.	Remove more read-modify-write ACCESS_ONCE() calls, courtesy of
	Pranith Kumar.

2.	Fix sparse warning for rcu_batches_completed_preempt(), courtesy
	of Pranith Kumar.

3.	Use bool type for variable holding rcu_is_watching() return
	value, courtesy of Pranith Kumar.

4.	Use bool constant for bool return in rcu_try_advance_all_cbs(),
	courtesy of Pranith Kumar.

5.	Use bool constant for bool return in rcu_lockdep_current_cpu_online(),
	courtesy of Pranith Kumar.

6.	Use bool constant for assignments to bool variable isidle,
	courtesy of Pranith Kumar.

7.	Shrink the kernel a bit by uninlining rcu_read_lock_held(),
	courtesy of Oleg Nesterov.

8.	Shrink the kernel a bit more by defining tracepoint strings only
	if CONFIG_TRACING is set, courtesy of Ard Biesheuvel.

9.	Fix outdated pathnames in comments, courtesy of Pranith Kumar.

10.	Remove stale comment, courtesy of Pranith Kumar.

11.	Break additional call_rcu() deadlock involving scheduler and perf.

12.	Shrink the TINY_RCU side of the kernel by putting error checks
	under #ifdef.

13.	Eliminate unnecessary self-wakeups, courtesy of Pranith Kumar.

14.	Replace flush_signals() with WARN_ON(signal_pending()).

15.	Add ACCESS_ONCE() for RCU_INIT_POINTER().

							Thanx, Paul

------------------------------------------------------------------------

 b/include/linux/rcupdate.h   |   40 ++-------------------------------------
 b/include/trace/events/rcu.h |    3 ++
 b/kernel/rcu/tiny.c          |    8 +++----
 b/kernel/rcu/tree.c          |   39 +++++++++++++++++++++++---------------
 b/kernel/rcu/tree.h          |    9 ++++++--
 b/kernel/rcu/tree_plugin.h   |   44 +++++++++++++++++++++++++++----------------
 b/kernel/rcu/update.c        |   32 +++++++++++++++++++++++++++++++
 7 files changed, 101 insertions(+), 74 deletions(-)

