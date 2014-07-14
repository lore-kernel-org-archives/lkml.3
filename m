Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbaGNKKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:10:04 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:41577 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbaGNKGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:06:12 -0400
Date: Mon, 14 Jul 2014 03:06:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, linux-rt-users@vger.kernel.org
Subject: [PATCH RFC tip/core/rcu 0/2] NOCB kthread economization patches
Message-ID: <20140714100604.GA9905@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071410-1344-0000-0000-000002D02C84
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series provides a couple of patches that reduce the number of rcuo
kthreads in cases where nr_cpu_ids is larger than the actual number of
online CPUs.

1.	Preparation patch that rationalizes RCU's creation of early-boot
	kthreads.

2.	Instead of creation rcuo kthreads for each possible CPU, create
	them only for those CPUs that have come online at least once
	since boot.

							Thanx, Paul

------------------------------------------------------------------------

 b/kernel/rcu/tree.c        |    8 ++-
 b/kernel/rcu/tree.h        |    5 +-
 b/kernel/rcu/tree_plugin.h |  105 ++++++++++++++++++++++++++++++++++++---------
 3 files changed, 95 insertions(+), 23 deletions(-)

