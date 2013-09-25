Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629Ab3IYB3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:29:34 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53554 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121Ab3IYB3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:29:30 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 04/11] rcu: Fix dubious "if" condition in __call_rcu_nocb_enqueue()
Date: Tue, 24 Sep 2013 18:29:14 -0700
Message-Id: <1380072561-31134-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380072561-31134-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925012750.GA30601@linux.vnet.ibm.com>
 <1380072561-31134-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-7182-0000-0000-000008839848
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit replaces an incorrect (but fortunately functional)
bitwise OR ("|") operator with the correct logical OR ("||").

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 130c97b..6f9aece 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2108,7 +2108,7 @@ static void __call_rcu_nocb_enqueue(struct rcu_data *rdp,
 
 	/* If we are not being polled and there is a kthread, awaken it ... */
 	t = ACCESS_ONCE(rdp->nocb_kthread);
-	if (rcu_nocb_poll | !t)
+	if (rcu_nocb_poll || !t)
 		return;
 	len = atomic_long_read(&rdp->nocb_q_count);
 	if (old_rhpp == &rdp->nocb_head) {
-- 
1.8.1.5

