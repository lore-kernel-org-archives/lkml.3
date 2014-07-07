Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbaGGWst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:48:49 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59768 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaGGWss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:48:48 -0400
Date: Mon, 7 Jul 2014 15:48:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/2] Callback-offloading changes for 3.17
Message-ID: <20140707224841.GA10101@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-8236-0000-0000-000003A7248A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series provides a couple of callback-offloading changes:

1.	Parallelize and economize NOCB kthread wakeups to better handle
	cases where callback offloading is used on workloads that have
	many context switches and thus many grace periods.

2.	Don't offload callbacks for a given CPU unless it has been
	explicitly requested for that CPU, either directly at build
	time or boot time, or indirectly at boot time due to that
	CPU being a nohz_full CPU.

							Thanx, Paul

------------------------------------------------------------------------

 b/Documentation/kernel-parameters.txt |    7 
 b/init/Kconfig                        |    4 
 b/kernel/rcu/tree.h                   |   28 +++
 b/kernel/rcu/tree_plugin.h            |  255 ++++++++++++++++++++++++++++------
 4 files changed, 249 insertions(+), 45 deletions(-)

