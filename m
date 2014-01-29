Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaA2Rp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 12:45:26 -0500
Received: from relais.videotron.ca ([24.201.245.36]:21485 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbaA2RpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 12:45:21 -0500
Content-transfer-encoding: 7BIT
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: [PATCH v2 2/6] ARM: remove redundant cpuidle_idle_call()
Date: Wed, 29 Jan 2014 12:45:09 -0500
Message-id: <1391017513-12995-3-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: git-send-email 1.8.4.108.g55ea5f6
In-reply-to: <1391017513-12995-1-git-send-email-nicolas.pitre@linaro.org>
References: <1391017513-12995-1-git-send-email-nicolas.pitre@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core idle loop now takes care of it.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/kernel/process.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 92f7b15dd2..adabeababe 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -30,7 +30,6 @@
 #include <linux/uaccess.h>
 #include <linux/random.h>
 #include <linux/hw_breakpoint.h>
-#include <linux/cpuidle.h>
 #include <linux/leds.h>
 #include <linux/reboot.h>
 
@@ -133,7 +132,11 @@ EXPORT_SYMBOL_GPL(arm_pm_restart);
 
 void (*arm_pm_idle)(void);
 
-static void default_idle(void)
+/*
+ * Called from the core idle loop.
+ */
+
+void arch_cpu_idle(void)
 {
 	if (arm_pm_idle)
 		arm_pm_idle();
@@ -168,15 +171,6 @@ void arch_cpu_idle_dead(void)
 #endif
 
 /*
- * Called from the core idle loop.
- */
-void arch_cpu_idle(void)
-{
-	if (cpuidle_idle_call())
-		default_idle();
-}
-
-/*
  * Called by kexec, immediately prior to machine_kexec().
  *
  * This must completely disable all secondary CPUs; simply causing those CPUs
-- 
1.8.4.108.g55ea5f6

