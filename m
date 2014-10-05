Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaJERZL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 13:25:11 -0400
Received: from p01c12o143.mxlogic.net ([208.65.145.66]:47618 "EHLO
	p01c12o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaJERZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 13:25:08 -0400
X-MXL-Hash: 54317ef3574b265c-5ee411e6751ab876cbd679b61e946ebdd2d8d34e
X-MXL-Hash: 54317ee32f0e9f23-af5c2a2ed8506f995c6403b40ff2e57fceed5b70
From: Joe Lawrence <joe.lawrence@stratus.com>
To: <linux-kernel@vger.kernel.org>
CC: <tj@kernel.org>, <paulmck@linux.vnet.ibm.com>, <jiri@resnulli.us>,
        Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH v2 2/2] workqueue: use cond_resched_rcu_qs macro
Date: Sun, 5 Oct 2014 13:24:22 -0400
Message-ID: <1412529862-17954-3-git-send-email-joe.lawrence@stratus.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1412529862-17954-1-git-send-email-joe.lawrence@stratus.com>
References: <1412529862-17954-1-git-send-email-joe.lawrence@stratus.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [134.111.199.152]
X-AnalysisOut: [v=2.1 cv=cfrGrxzM c=1 sm=1 tr=0 a=VNTQBUOG7PJoPU2GWtE7Ww==]
X-AnalysisOut: [:117 a=VNTQBUOG7PJoPU2GWtE7Ww==:17 a=_KQqW7t0BisA:10 a=Cdz]
X-AnalysisOut: [KgOd8jloA:10 a=BLceEmwcHowA:10 a=uelBKuKpAAAA:8 a=YlVTAMxI]
X-AnalysisOut: [AAAA:8 a=_ij20-WnZM7GQZtJwRsA:9 a=kSViFEBMy1sA:10]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014100508); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tidy up and use cond_resched_rcu_qs when calling cond_resched and
reporting potential quiescent state to RCU.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 kernel/workqueue.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 345bec9..09b685d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2046,8 +2046,7 @@ __acquires(&pool->lock)
 	 * stop_machine. At the same time, report a quiescent RCU state so
 	 * the same condition doesn't freeze RCU.
 	 */
-	rcu_note_voluntary_context_switch(current);
-	cond_resched();
+	cond_resched_rcu_qs();
 
 	spin_lock_irq(&pool->lock);
 
-- 
1.7.10.4

