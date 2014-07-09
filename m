Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbaGIEIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 00:08:09 -0400
Received: from mail-yk0-f169.google.com ([209.85.160.169]:45492 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaGIEIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 00:08:05 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 1/1] rcu: use true/false instead of 1/0 for a bool type
Date: Wed,  9 Jul 2014 00:08:17 -0400
Message-Id: <1404878897-3680-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more bool type change which I found while reading the code.

Use true/false instead of 0/1 for a bool type

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 1b70cb6..bc7b6f1 100644
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
@@ -2449,7 +2449,7 @@ static void force_qs_rnp(struct rcu_state *rsp,
 		for (; cpu <= rnp->grphi; cpu++, bit <<= 1) {
 			if ((rnp->qsmask & bit) != 0) {
 				if ((rnp->qsmaskinit & bit) != 0)
-					*isidle = 0;
+					*isidle = false;
 				if (f(per_cpu_ptr(rsp->rda, cpu), isidle, maxj))
 					mask |= bit;
 			}
-- 
1.9.1

