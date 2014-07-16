Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbaGPVE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:04:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:59805 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbaGPVEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:52 -0400
Message-Id: <20140716205055.767965781@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [patch V2 42/64] arm: bL_switcher:k Use ktime_get_real_ns()
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=arm-bL_switcher-use-ktime_get_ns.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the nanoseconds based interface instead of converting from a
timespec.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/common/bL_switcher.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

Index: tip/arch/arm/common/bL_switcher.c
===================================================================
--- tip.orig/arch/arm/common/bL_switcher.c
+++ tip/arch/arm/common/bL_switcher.c
@@ -58,16 +58,6 @@ static int read_mpidr(void)
 }
 
 /*
- * Get a global nanosecond time stamp for tracing.
- */
-static s64 get_ns(void)
-{
-	struct timespec ts;
-	getnstimeofday(&ts);
-	return timespec_to_ns(&ts);
-}
-
-/*
  * bL switcher core code.
  */
 
@@ -224,7 +214,7 @@ static int bL_switch_to(unsigned int new
 	 */
 	local_irq_disable();
 	local_fiq_disable();
-	trace_cpu_migrate_begin(get_ns(), ob_mpidr);
+	trace_cpu_migrate_begin(ktime_get_real_ns(), ob_mpidr);
 
 	/* redirect GIC's SGIs to our counterpart */
 	gic_migrate_target(bL_gic_id[ib_cpu][ib_cluster]);
@@ -267,7 +257,7 @@ static int bL_switch_to(unsigned int new
 					  tdev->evtdev->next_event, 1);
 	}
 
-	trace_cpu_migrate_finish(get_ns(), ib_mpidr);
+	trace_cpu_migrate_finish(ktime_get_real_ns(), ib_mpidr);
 	local_fiq_enable();
 	local_irq_enable();
 
@@ -558,7 +548,7 @@ int bL_switcher_get_logical_index(u32 mp
 
 static void bL_switcher_trace_trigger_cpu(void *__always_unused info)
 {
-	trace_cpu_migrate_current(get_ns(), read_mpidr());
+	trace_cpu_migrate_current(ktime_get_real_ns(), read_mpidr());
 }
 
 int bL_switcher_trace_trigger(void)


