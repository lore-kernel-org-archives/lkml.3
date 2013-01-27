Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab3A0APm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 19:15:42 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:52090 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab3A0APj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 19:15:39 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, Dave Hansen <dave@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 07/10] rcu: Consolidate debugging Kconfig options
Date: Sat, 26 Jan 2013 16:15:09 -0800
Message-Id: <1359245712-3843-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1359245712-3843-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130127001454.GA2682@linux.vnet.ibm.com>
 <1359245712-3843-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012700-5518-0000-0000-00000B0B382C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Hansen <dave@linux.vnet.ibm.com>

The RCU-related debugging Kconfig options are in two different places,
and consume too much screen real estate.  This commit therefore
consolidates them into their own menu.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 lib/Kconfig.debug |  114 +++++++++++++++++++++++++++-------------------------
 1 files changed, 59 insertions(+), 55 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 3a35309..122db3d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -605,61 +605,6 @@ config PROVE_LOCKING
 
 	 For more details, see Documentation/lockdep-design.txt.
 
-config PROVE_RCU
-	bool "RCU debugging: prove RCU correctness"
-	depends on PROVE_LOCKING
-	default n
-	help
-	 This feature enables lockdep extensions that check for correct
-	 use of RCU APIs.  This is currently under development.  Say Y
-	 if you want to debug RCU usage or help work on the PROVE_RCU
-	 feature.
-
-	 Say N if you are unsure.
-
-config PROVE_RCU_REPEATEDLY
-	bool "RCU debugging: don't disable PROVE_RCU on first splat"
-	depends on PROVE_RCU
-	default n
-	help
-	 By itself, PROVE_RCU will disable checking upon issuing the
-	 first warning (or "splat").  This feature prevents such
-	 disabling, allowing multiple RCU-lockdep warnings to be printed
-	 on a single reboot.
-
-	 Say Y to allow multiple RCU-lockdep warnings per boot.
-
-	 Say N if you are unsure.
-
-config PROVE_RCU_DELAY
-	bool "RCU debugging: preemptible RCU race provocation"
-	depends on DEBUG_KERNEL && PREEMPT_RCU
-	default n
-	help
-	 There is a class of races that involve an unlikely preemption
-	 of __rcu_read_unlock() just after ->rcu_read_lock_nesting has
-	 been set to INT_MIN.  This feature inserts a delay at that
-	 point to increase the probability of these races.
-
-	 Say Y to increase probability of preemption of __rcu_read_unlock().
-
-	 Say N if you are unsure.
-
-config SPARSE_RCU_POINTER
-	bool "RCU debugging: sparse-based checks for pointer usage"
-	default n
-	help
-	 This feature enables the __rcu sparse annotation for
-	 RCU-protected pointers.  This annotation will cause sparse
-	 to flag any non-RCU used of annotated pointers.  This can be
-	 helpful when debugging RCU usage.  Please note that this feature
-	 is not intended to enforce code cleanliness; it is instead merely
-	 a debugging aid.
-
-	 Say Y to make sparse flag questionable use of RCU-protected pointers
-
-	 Say N if you are unsure.
-
 config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
@@ -937,6 +882,63 @@ config BOOT_PRINTK_DELAY
 	  BOOT_PRINTK_DELAY also may cause LOCKUP_DETECTOR to detect
 	  what it believes to be lockup conditions.
 
+menu "RCU Debugging"
+
+config PROVE_RCU
+	bool "RCU debugging: prove RCU correctness"
+	depends on PROVE_LOCKING
+	default n
+	help
+	 This feature enables lockdep extensions that check for correct
+	 use of RCU APIs.  This is currently under development.  Say Y
+	 if you want to debug RCU usage or help work on the PROVE_RCU
+	 feature.
+
+	 Say N if you are unsure.
+
+config PROVE_RCU_REPEATEDLY
+	bool "RCU debugging: don't disable PROVE_RCU on first splat"
+	depends on PROVE_RCU
+	default n
+	help
+	 By itself, PROVE_RCU will disable checking upon issuing the
+	 first warning (or "splat").  This feature prevents such
+	 disabling, allowing multiple RCU-lockdep warnings to be printed
+	 on a single reboot.
+
+	 Say Y to allow multiple RCU-lockdep warnings per boot.
+
+	 Say N if you are unsure.
+
+config PROVE_RCU_DELAY
+	bool "RCU debugging: preemptible RCU race provocation"
+	depends on DEBUG_KERNEL && PREEMPT_RCU
+	default n
+	help
+	 There is a class of races that involve an unlikely preemption
+	 of __rcu_read_unlock() just after ->rcu_read_lock_nesting has
+	 been set to INT_MIN.  This feature inserts a delay at that
+	 point to increase the probability of these races.
+
+	 Say Y to increase probability of preemption of __rcu_read_unlock().
+
+	 Say N if you are unsure.
+
+config SPARSE_RCU_POINTER
+	bool "RCU debugging: sparse-based checks for pointer usage"
+	default n
+	help
+	 This feature enables the __rcu sparse annotation for
+	 RCU-protected pointers.  This annotation will cause sparse
+	 to flag any non-RCU used of annotated pointers.  This can be
+	 helpful when debugging RCU usage.  Please note that this feature
+	 is not intended to enforce code cleanliness; it is instead merely
+	 a debugging aid.
+
+	 Say Y to make sparse flag questionable use of RCU-protected pointers
+
+	 Say N if you are unsure.
+
 config RCU_TORTURE_TEST
 	tristate "torture tests for RCU"
 	depends on DEBUG_KERNEL
@@ -1015,6 +1017,8 @@ config RCU_TRACE
 	  Say Y here if you want to enable RCU tracing
 	  Say N if you are unsure.
 
+endmenu # "RCU Debugging"
+
 config KPROBES_SANITY_TEST
 	bool "Kprobes sanity tests"
 	depends on DEBUG_KERNEL
-- 
1.7.8

