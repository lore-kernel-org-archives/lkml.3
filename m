Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbaBQW2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:28:38 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:35095 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbaBQWNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:14 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 21/55] rcutorture: Export torture_type and verbose module parameters
Date: Mon, 17 Feb 2014 14:12:25 -0800
Message-Id: <1392675179-11560-21-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-8236-0000-0000-0000074F37D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The torture_type and verbose module parameters are needed for log messages,
so this commit exports them to include/linux/torture.h.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/torture.h | 4 ++++
 kernel/rcu/rcutorture.c | 8 ++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/torture.h b/include/linux/torture.h
index c61b4ce18a13..9b6a4834de8f 100644
--- a/include/linux/torture.h
+++ b/include/linux/torture.h
@@ -49,6 +49,10 @@ extern int fullstop;
 /* Protect fullstop transitions and spawning of kthreads.  */
 extern struct mutex fullstop_mutex;
 
+/* Common module parameters. */
+extern char *torture_type;
+extern bool verbose;
+
 #define TORTURE_FLAG "-torture:"
 #define TOROUT_STRING(s) \
 	pr_alert("%s" TORTURE_FLAG s "\n", torture_type)
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 3687619b243a..49cdeeaaa54b 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -90,11 +90,15 @@ torture_parm(int, test_boost_interval, 7,
 	     "Interval between boost tests, seconds.");
 torture_parm(bool, test_no_idle_hz, true,
 	     "Test support for tickless idle CPUs");
-torture_parm(bool, verbose, false, "Enable verbose debugging printk()s");
 
-static char *torture_type = "rcu";
+char *torture_type = "rcu";
+EXPORT_SYMBOL_GPL(torture_type);
 module_param(torture_type, charp, 0444);
 MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, ...)");
+bool verbose;
+EXPORT_SYMBOL_GPL(verbose);
+module_param(verbose, bool, 0444);
+MODULE_PARM_DESC(verbose, "Enable verbose debugging printk()s");
 
 static int nrealreaders;
 static struct task_struct *writer_task;
-- 
1.8.1.5

