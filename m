Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaGGWkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:40:25 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:38215 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbaGGWia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:38:30 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Fabian Frederick <fabf@skynet.be>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 04/17] rcu: Make rcu node arrays static const char * const
Date: Mon,  7 Jul 2014 15:38:08 -0700
Message-Id: <1404772701-8804-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140707223756.GA7187@linux.vnet.ibm.com>
 <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-3532-0000-0000-000002FA8B8A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

Those two arrays are being passed to lockdep_init_map(), which expects
const char *, and are stored in lockdep_map the same way.

Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 625d0b0cd75a..ebd99af2214e 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3564,14 +3564,16 @@ static void __init rcu_init_levelspread(struct rcu_state *rsp)
 static void __init rcu_init_one(struct rcu_state *rsp,
 		struct rcu_data __percpu *rda)
 {
-	static char *buf[] = { "rcu_node_0",
-			       "rcu_node_1",
-			       "rcu_node_2",
-			       "rcu_node_3" };  /* Match MAX_RCU_LVLS */
-	static char *fqs[] = { "rcu_node_fqs_0",
-			       "rcu_node_fqs_1",
-			       "rcu_node_fqs_2",
-			       "rcu_node_fqs_3" };  /* Match MAX_RCU_LVLS */
+	static const char * const buf[] = {
+		"rcu_node_0",
+		"rcu_node_1",
+		"rcu_node_2",
+		"rcu_node_3" };  /* Match MAX_RCU_LVLS */
+	static const char * const fqs[] = {
+		"rcu_node_fqs_0",
+		"rcu_node_fqs_1",
+		"rcu_node_fqs_2",
+		"rcu_node_fqs_3" };  /* Match MAX_RCU_LVLS */
 	static u8 fl_mask = 0x1;
 	int cpustride = 1;
 	int i;
-- 
1.8.1.5

