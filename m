Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaBFOQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:16:56 -0500
Received: from relais.videotron.ca ([24.201.245.36]:13196 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbaBFOQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:16:53 -0500
Content-transfer-encoding: 7BIT
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH 1/2] PPC: powernv: remove redundant cpuidle_idle_call()
Date: Thu, 06 Feb 2014 09:16:27 -0500
Message-id: <1391696188-14540-1-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: git-send-email 1.8.4.108.g55ea5f6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core idle loop now takes care of it.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
---
 arch/powerpc/platforms/powernv/setup.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index 21166f65c9..a932feb290 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -26,7 +26,6 @@
 #include <linux/of_fdt.h>
 #include <linux/interrupt.h>
 #include <linux/bug.h>
-#include <linux/cpuidle.h>
 
 #include <asm/machdep.h>
 #include <asm/firmware.h>
@@ -217,16 +216,6 @@ static int __init pnv_probe(void)
 	return 1;
 }
 
-void powernv_idle(void)
-{
-	/* Hook to cpuidle framework if available, else
-	 * call on default platform idle code
-	 */
-	if (cpuidle_idle_call()) {
-		power7_idle();
-	}
-}
-
 define_machine(powernv) {
 	.name			= "PowerNV",
 	.probe			= pnv_probe,
@@ -236,7 +225,7 @@ define_machine(powernv) {
 	.show_cpuinfo		= pnv_show_cpuinfo,
 	.progress		= pnv_progress,
 	.machine_shutdown	= pnv_shutdown,
-	.power_save             = powernv_idle,
+	.power_save             = power7_idle,
 	.calibrate_decr		= generic_calibrate_decr,
 #ifdef CONFIG_KEXEC
 	.kexec_cpu_down		= pnv_kexec_cpu_down,
-- 
1.8.4.108.g55ea5f6

