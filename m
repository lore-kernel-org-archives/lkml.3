Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbaBQQAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 11:00:21 -0500
Received: from relais.videotron.ca ([24.201.245.36]:50032 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbaBQQAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 11:00:17 -0500
Content-transfer-encoding: 7BIT
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Burton <paul.burton@imgtec.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH 2/2] cpuidle/arm64: remove redundant cpuidle_idle_call()
Date: Mon, 17 Feb 2014 10:59:30 -0500
Message-id: <1392652770-19397-3-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: git-send-email 1.8.4.108.g55ea5f6
In-reply-to: <1392652770-19397-1-git-send-email-nicolas.pitre@linaro.org>
References: <1392652770-19397-1-git-send-email-nicolas.pitre@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core idle loop now takes care of it.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm64/kernel/process.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 1c0a9be2ff..9cce0098f4 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -33,7 +33,6 @@
 #include <linux/kallsyms.h>
 #include <linux/init.h>
 #include <linux/cpu.h>
-#include <linux/cpuidle.h>
 #include <linux/elfcore.h>
 #include <linux/pm.h>
 #include <linux/tick.h>
@@ -94,10 +93,8 @@ void arch_cpu_idle(void)
 	 * This should do all the clock switching and wait for interrupt
 	 * tricks
 	 */
-	if (cpuidle_idle_call()) {
-		cpu_do_idle();
-		local_irq_enable();
-	}
+	cpu_do_idle();
+	local_irq_enable();
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-- 
1.8.4.108.g55ea5f6

