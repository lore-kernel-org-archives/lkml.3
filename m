Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbaJ1WeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:34:08 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37413 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755860AbaJ1WeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:34:02 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 6/6] rcutorture: Fix rcu_torture_cbflood() memory leak
Date: Tue, 28 Oct 2014 15:30:05 -0700
Message-Id: <1414535405-30228-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414535405-30228-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028222929.GA29476@linux.vnet.ibm.com>
 <1414535405-30228-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0025-0000-0000-000000F0724A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Commit 38706bc5a29a (rcutorture: Add callback-flood test) vmalloc()ed
a bunch of RCU callbacks, but failed to free them.  This commit fixes
that oversight.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/rcutorture.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 240fa9094f83..4d559baf06e0 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -812,6 +812,7 @@ rcu_torture_cbflood(void *arg)
 		cur_ops->cb_barrier();
 		stutter_wait("rcu_torture_cbflood");
 	} while (!torture_must_stop());
+	vfree(rhp);
 	torture_kthread_stopping("rcu_torture_cbflood");
 	return 0;
 }
-- 
1.8.1.5

