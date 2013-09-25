Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab3IYBvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:51:43 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:40186 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab3IYBu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:50:27 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 5/6] rcu: Change EXPORT_SYMBOL() to EXPORT_SYMBOL_GPL()
Date: Tue, 24 Sep 2013 18:50:15 -0700
Message-Id: <1380073816-32381-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380073816-32381-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925014954.GA32109@linux.vnet.ibm.com>
 <1380073816-32381-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-1542-0000-0000-000001B8A40F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Commit e6b80a3b (rcu: Detect illegal rcu dereference in extended
quiescent state) exported the pre-existing rcu_is_cpu_idle() function
using EXPORT_SYMBOL().  However, this is inconsistent with the remaining
exports from RCU, which are all EXPORT_SYMBOL_GPL().  The current state
of affairs means that a non-GPL module could use rcu_is_cpu_idle(),
but in a CONFIG_TREE_PREEMPT_RCU=y kernel would be unable to invoke
rcu_read_lock() and rcu_read_unlock().

This commit therefore makes rcu_is_cpu_idle()'s export be consistent
with the rest of RCU, namely EXPORT_SYMBOL_GPL().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/rcutree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 910d868..1b123e1 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -669,7 +669,7 @@ int rcu_is_cpu_idle(void)
 	preempt_enable();
 	return ret;
 }
-EXPORT_SYMBOL(rcu_is_cpu_idle);
+EXPORT_SYMBOL_GPL(rcu_is_cpu_idle);
 
 /**
  * __rcu_is_watching - are RCU read-side critical sections safe?
-- 
1.8.1.5

