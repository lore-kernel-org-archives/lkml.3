Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbaJ1Vzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:55:35 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50296 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142AbaJ1Vzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:55:33 -0400
Date: Tue, 28 Oct 2014 14:51:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: [PATCH tip/core/rcu 0/9] Per-CPU-variable updates
Message-ID: <20141028215140.GA23970@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102821-0029-0000-0000-000000F4EB88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series updates RCU's handling of per-CPU variables, mostly
moving from "cpu" function arguments to various "this_"-style accessors
for per-CPU variables:

1.	Drop the rdtp argument from RCU's dyntick-idle and sysidle
	functions, substituting this_cpu_ptr(), courtesy of Christoph
	Lameter.

2.	Use DEFINE_PER_CPU_SHARED_ALIGNED for rcu_data structures in
	order to avoid false sharing with other per-CPU variables.

3-9.	Remove "cpu" arguments from a number of RCU functions that are
	only ever invoked on that CPU, and use appropriate "this_"-style
	accesssors for the per-CPU variables.

							Thanx, Paul

------------------------------------------------------------------------

 b/include/linux/rcupdate.h |    2 +-
 b/include/linux/rcutiny.h  |    2 +-
 b/include/linux/rcutree.h  |    4 ++--
 b/kernel/cpu.c             |   19 +++++++++++++------
 b/kernel/rcu/tiny.c        |    2 +-
 b/kernel/rcu/tree.c        |   25 +++++++++++++------------
 b/kernel/rcu/tree.h        |    4 ++--
 b/kernel/rcu/tree_plugin.h |   11 +++++++----
 b/kernel/sched/core.c      |    2 +-
 b/kernel/softirq.c         |    2 +-
 b/kernel/time/tick-sched.c |    2 +-
 b/kernel/time/timer.c      |    3 +--
 include/linux/rcupdate.h   |    2 +-
 include/linux/rcutree.h    |    2 +-
 kernel/rcu/tree.c          |   30 +++++++++++++++---------------
 kernel/rcu/tree.h          |    8 ++++----
 kernel/rcu/tree_plugin.h   |   42 +++++++++++++++++++++---------------------
 17 files changed, 86 insertions(+), 76 deletions(-)

