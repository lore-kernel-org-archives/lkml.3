Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbaIBVTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:19:49 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:49518 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173AbaIBVTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:19:45 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v2 9/9] ARM: zynq: Rename 'zynq_platform_cpu_die'
Date: Tue,  2 Sep 2014 14:19:14 -0700
Message-Id: <1409692754-13437-10-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.0.1.g27b9230
In-Reply-To: <1409692754-13437-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1409692754-13437-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Match the naming pattern of all other SMP ops and rename
zynq_platform_cpu_die --> zynq_cpu_die.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
v2:
 - make comments comply to kernel-doc format
---
 arch/arm/mach-zynq/platsmp.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
index f722b5a83a45..52d768ff7857 100644
--- a/arch/arm/mach-zynq/platsmp.c
+++ b/arch/arm/mach-zynq/platsmp.c
@@ -137,12 +137,14 @@ static int zynq_cpu_kill(unsigned cpu)
 	return 1;
 }
 
-/*
- * platform-specific code to shutdown a CPU
+/**
+ * zynq_cpu_die - Let a CPU core die
+ * @cpu:	Dying CPU
  *
- * Called with IRQs disabled
+ * Platform-specific code to shutdown a CPU.
+ * Called with IRQs disabled on the dying CPU.
  */
-static void zynq_platform_cpu_die(unsigned int cpu)
+static void zynq_cpu_die(unsigned int cpu)
 {
 	zynq_slcr_cpu_state_write(cpu, true);
 
@@ -162,7 +164,7 @@ struct smp_operations zynq_smp_ops __initdata = {
 	.smp_boot_secondary	= zynq_boot_secondary,
 	.smp_secondary_init	= zynq_secondary_init,
 #ifdef CONFIG_HOTPLUG_CPU
-	.cpu_die		= zynq_platform_cpu_die,
+	.cpu_die		= zynq_cpu_die,
 	.cpu_kill		= zynq_cpu_kill,
 #endif
 };
-- 
2.1.0.1.g27b9230

