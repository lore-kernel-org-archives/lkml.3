Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935117Ab3DOVKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 17:10:54 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52426 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933505Ab3DOVKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 17:10:35 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4/5] nohz: Improve a bit the full dynticks Kconfig documentation
Date: Mon, 15 Apr 2013 23:10:19 +0200
Message-Id: <1366060220-20271-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366060220-20271-1-git-send-email-fweisbec@gmail.com>
References: <1366060220-20271-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the "single task" statement from CONFIG_NO_HZ_FULL
title. The constraint can be invalidated when tasks from
other sched classes than SCHED_FAIR are running. Moreover
it's possible that hrtick join the party in the future.

Also add a line about the dependency on SMP.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/Kconfig |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 3b68322..358d601 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -97,11 +97,13 @@ config NO_HZ_IDLE
 	  Most of the time you want to say Y here.
 
 config NO_HZ_FULL
-	bool "Full dynticks system (tickless single task)"
+	bool "Full dynticks system (tickless)"
 	# NO_HZ_COMMON dependency
 	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
-	# RCU_USER_QS
-	depends on HAVE_CONTEXT_TRACKING && SMP
+	# We need at least one periodic CPU for timekeeping
+	depends on SMP
+	# RCU_USER_QS dependency
+	depends on HAVE_CONTEXT_TRACKING
 	# RCU_NOCB_CPU dependency
 	depends on TREE_RCU || TREE_PREEMPT_RCU
 	depends on VIRT_CPU_ACCOUNTING_GEN
-- 
1.7.5.4

