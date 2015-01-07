Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbbAGSU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:20:56 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:53789 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbbAGSTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:19:52 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 12/12] rcutorture: Add more diagnostics in rcu_barrier() test failure case
Date: Wed,  7 Jan 2015 10:19:38 -0800
Message-Id: <1420654779-11213-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420654779-11213-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107181915.GA7803@linux.vnet.ibm.com>
 <1420654779-11213-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010718-0025-0000-0000-0000079243B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/rcutorture.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 24142c200901..30d42aa55d83 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1427,6 +1427,9 @@ static int rcu_torture_barrier(void *arg)
 		cur_ops->cb_barrier(); /* Implies smp_mb() for wait_event(). */
 		if (atomic_read(&barrier_cbs_invoked) != n_barrier_cbs) {
 			n_rcu_torture_barrier_error++;
+			pr_err("barrier_cbs_invoked = %d, n_barrier_cbs = %d\n",
+			       atomic_read(&barrier_cbs_invoked),
+			       n_barrier_cbs);
 			WARN_ON_ONCE(1);
 		}
 		n_barrier_successes++;
-- 
1.8.1.5

