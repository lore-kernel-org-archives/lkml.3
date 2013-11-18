Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563Ab3KRWCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 17:02:30 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:47639 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab3KRWC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 17:02:26 -0500
Date: Mon, 18 Nov 2013 14:02:20 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: [PATCH RFC tip/core/rcu 0/3] RT latency optimizations
Message-ID: <20131118220220.GA23353@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111822-3532-0000-0000-0000032208E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series provides some minor latency optimizations for kernels that
build with CONFIG_RCU_NOCB_CPU_ALL=y:

1.	Create a static inline implementation of rcu_is_nocb_cpu() that
	unconditionally returns true when CONFIG_RCU_NOCB_CPU_ALL=y.

2.	Create a static inline implementation of rcu_needs_cpu() that
	unconditionally returns false when CONFIG_RCU_NOCB_CPU_ALL=y.

3.	Create static inline implementations of rcu_prepare_for_idle()
	and rcu_cleanup_after_idle() that are no-ops when
	CONFIG_RCU_NOCB_CPU_ALL=y.

							Thanx, Paul

------------------------------------------------------------------------

 b/include/linux/rcupdate.h |   13 +++++++++++++
 b/include/linux/rcutiny.h  |    6 ------
 b/include/linux/rcutree.h  |    2 ++
 b/kernel/rcu/tree.c        |    2 +-
 b/kernel/rcu/tree_plugin.h |   13 +++++++++++--
 5 files changed, 27 insertions(+), 9 deletions(-)

