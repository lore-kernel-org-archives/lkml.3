Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab3IYB3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:29:36 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46456 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755901Ab3IYB3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:29:30 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/11] rcu: Use proper cpp macro for ->gp_flags
Date: Tue, 24 Sep 2013 18:29:12 -0700
Message-Id: <1380072561-31134-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380072561-31134-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925012750.GA30601@linux.vnet.ibm.com>
 <1380072561-31134-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-0320-0000-0000-0000011DA440
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

One of the ->gp_flags assignments used a raw number rather than the
cpp macro that was intended for this purpose, which this commit fixes.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 32618b3..e0fa192 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1452,7 +1452,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	rdp = this_cpu_ptr(rsp->rda);
 	rcu_advance_cbs(rsp, rnp, rdp);  /* Reduce false positives below. */
 	if (cpu_needs_another_gp(rsp, rdp))
-		rsp->gp_flags = 1;
+		rsp->gp_flags = RCU_GP_FLAG_INIT;
 	raw_spin_unlock_irq(&rnp->lock);
 }
 
-- 
1.8.1.5

