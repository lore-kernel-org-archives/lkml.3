Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbaJ1WN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:13:59 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:54086 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797AbaJ1WN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:13:57 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 8/9] rcu: Fix FIXME in rcu_tasks_kthread()
Date: Tue, 28 Oct 2014 15:10:01 -0700
Message-Id: <1414534202-27312-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414534202-27312-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028220944.GA26114@linux.vnet.ibm.com>
 <1414534202-27312-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0033-0000-0000-0000028046BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit affines rcu_tasks_kthread() to the housekeeping CPUs
in CONFIG_NO_HZ_FULL builds.  This is just a default, so systems
administrators are free to put this kthread somewhere else if they wish.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/update.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 3ef8ba58694e..8a39e68ff8e0 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -531,7 +531,8 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 	struct rcu_head *next;
 	LIST_HEAD(rcu_tasks_holdouts);
 
-	/* FIXME: Add housekeeping affinity. */
+	/* Run on housekeeping CPUs by default.  Sysadm can move if desired. */
+	housekeeping_affine(current);
 
 	/*
 	 * Each pass through the following loop makes one check for
-- 
1.8.1.5

