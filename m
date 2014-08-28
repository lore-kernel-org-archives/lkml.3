Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbaH1S1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:27:36 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:52840 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbaH1S0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:26:46 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 06/15] rcu: Use true/false instead of 1/0 for a bool type
Date: Thu, 28 Aug 2014 11:26:25 -0700
Message-Id: <1409250394-25159-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409250394-25159-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828182614.GA23877@linux.vnet.ibm.com>
 <1409250394-25159-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-3532-0000-0000-0000043705F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>

This commit uses true/false instead of 1/0 for bool types in rcu_gp_fqs()
and force_qs_rnp().

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 253ea55dc508..2719978ea018 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1668,7 +1668,7 @@ static int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
 	if (fqs_state == RCU_SAVE_DYNTICK) {
 		/* Collect dyntick-idle snapshots. */
 		if (is_sysidle_rcu_state(rsp)) {
-			isidle = 1;
+			isidle = true;
 			maxj = jiffies - ULONG_MAX / 4;
 		}
 		force_qs_rnp(rsp, dyntick_save_progress_counter,
@@ -1677,7 +1677,7 @@ static int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
 		fqs_state = RCU_FORCE_QS;
 	} else {
 		/* Handle dyntick-idle and offline CPUs. */
-		isidle = 0;
+		isidle = false;
 		force_qs_rnp(rsp, rcu_implicit_dynticks_qs, &isidle, &maxj);
 	}
 	/* Clear flag to prevent immediate re-entry. */
@@ -2450,7 +2450,7 @@ static void force_qs_rnp(struct rcu_state *rsp,
 		for (; cpu <= rnp->grphi; cpu++, bit <<= 1) {
 			if ((rnp->qsmask & bit) != 0) {
 				if ((rnp->qsmaskinit & bit) != 0)
-					*isidle = 0;
+					*isidle = false;
 				if (f(per_cpu_ptr(rsp->rda, cpu), isidle, maxj))
 					mask |= bit;
 			}
-- 
1.8.1.5

