Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbaBQW06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:26:58 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:51020 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbaBQWNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:16 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 19/55] rcutorture: Abstract TOROUT_STRING() and friends
Date: Mon, 17 Feb 2014 14:12:23 -0800
Message-Id: <1392675179-11560-19-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-1344-0000-0000-000005D5BDDE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

These diagnostic macros are not confined to torturing RCU, so this commit
makes them available to other torture tests.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/torture.h | 8 ++++++++
 kernel/rcu/rcutorture.c | 8 --------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/torture.h b/include/linux/torture.h
index 368e15bb1a39..8a4088f2f87b 100644
--- a/include/linux/torture.h
+++ b/include/linux/torture.h
@@ -41,6 +41,14 @@
 	module_param(name, type, 0444); \
 	MODULE_PARM_DESC(name, msg);
 
+#define TORTURE_FLAG "-torture:"
+#define TOROUT_STRING(s) \
+	pr_alert("%s" TORTURE_FLAG s "\n", torture_type)
+#define VERBOSE_TOROUT_STRING(s) \
+	do { if (verbose) pr_alert("%s" TORTURE_FLAG s "\n", torture_type); } while (0)
+#define VERBOSE_TOROUT_ERRSTRING(s) \
+	do { if (verbose) pr_alert("%s" TORTURE_FLAG "!!! " s "\n", torture_type); } while (0)
+
 /* Low-rider random number generator. */
 struct torture_random_state {
 	unsigned long trs_state;
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 04813bdf5e53..2bb3dcb67221 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -96,14 +96,6 @@ static char *torture_type = "rcu";
 module_param(torture_type, charp, 0444);
 MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, ...)");
 
-#define TORTURE_FLAG "-torture:"
-#define TOROUT_STRING(s) \
-	do { pr_alert("%s" TORTURE_FLAG s "\n", torture_type); } while (0)
-#define VERBOSE_TOROUT_STRING(s) \
-	do { if (verbose) pr_alert("%s" TORTURE_FLAG s "\n", torture_type); } while (0)
-#define VERBOSE_TOROUT_ERRSTRING(s) \
-	do { if (verbose) pr_alert("%s" TORTURE_FLAG "!!! " s "\n", torture_type); } while (0)
-
 static int nrealreaders;
 static struct task_struct *writer_task;
 static struct task_struct **fakewriter_tasks;
-- 
1.8.1.5

