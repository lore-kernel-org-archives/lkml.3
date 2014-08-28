Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbaH1Sip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:38:45 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:44626 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbaH1Sif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:38:35 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/14] rcu: Use true/false for return in __call_rcu_nocb()
Date: Thu, 28 Aug 2014 11:38:06 -0700
Message-Id: <1409251097-26734-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409251097-26734-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828183754.GA25488@linux.vnet.ibm.com>
 <1409251097-26734-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-0928-0000-0000-0000047A4F0C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>

Return true/false instead of 0/1 in __call_rcu_nocb() as this returns a
bool type.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree_plugin.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 6c097d630b06..c4ff10e0aa90 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2123,7 +2123,7 @@ static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 {
 
 	if (!rcu_is_nocb_cpu(rdp->cpu))
-		return 0;
+		return false;
 	__call_rcu_nocb_enqueue(rdp, rhp, &rhp->next, 1, lazy, flags);
 	if (__is_kfree_rcu_offset((unsigned long)rhp->func))
 		trace_rcu_kfree_callback(rdp->rsp->name, rhp,
@@ -2134,7 +2134,7 @@ static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 		trace_rcu_callback(rdp->rsp->name, rhp,
 				   -atomic_long_read(&rdp->nocb_q_count_lazy),
 				   -atomic_long_read(&rdp->nocb_q_count));
-	return 1;
+	return true;
 }
 
 /*
-- 
1.8.1.5

