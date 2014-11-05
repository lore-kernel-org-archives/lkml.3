Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbaKERmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:42:52 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:58686 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbaKERlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:41:45 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 01/10] rcu: Fix invoke_rcu_callbacks() comment
Date: Wed,  5 Nov 2014 09:41:25 -0800
Message-Id: <1415209294-2534-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20141105174109.GA1306@linux.vnet.ibm.com>
References: <20141105174109.GA1306@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110517-0033-0000-0000-00000294FBEE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Despite what the comment says, it is only softirqs that are disabled,
not interrupts.  This commit therefore fixes the comment.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 7680fc275036..1b8dc3f8d80c 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2569,7 +2569,7 @@ static void rcu_process_callbacks(struct softirq_action *unused)
  * Schedule RCU callback invocation.  If the specified type of RCU
  * does not support RCU priority boosting, just do a direct call,
  * otherwise wake up the per-CPU kernel kthread.  Note that because we
- * are running on the current CPU with interrupts disabled, the
+ * are running on the current CPU with softirqs disabled, the
  * rcu_cpu_kthread_task cannot disappear out from under us.
  */
 static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
-- 
1.8.1.5

