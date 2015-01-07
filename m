Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbbAGSXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:23:09 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:53599 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbbAGSTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:19:49 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 05/12] rcu: provide rcu_batches_completed_sched() for TINY_RCU
Date: Wed,  7 Jan 2015 10:19:31 -0800
Message-Id: <1420654779-11213-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420654779-11213-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107181915.GA7803@linux.vnet.ibm.com>
 <1420654779-11213-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010718-8236-0000-0000-0000086A771C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

A bug in rcutorture has caused it to ignore completed batches.
In preparation for fixing that bug, this commit provides TINY_RCU with
the required rcu_batches_completed_sched().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcutiny.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 91f7e4c37800..1ce2d6b8f0c3 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -107,6 +107,14 @@ static inline unsigned long rcu_batches_completed_bh(void)
 	return 0;
 }
 
+/*
+ * Return the number of sched grace periods.
+ */
+static inline unsigned long rcu_batches_completed_sched(void)
+{
+	return 0;
+}
+
 static inline void rcu_force_quiescent_state(void)
 {
 }
-- 
1.8.1.5

