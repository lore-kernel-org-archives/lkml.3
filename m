Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaHTUnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:43:00 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:44142 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbaHTUm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:42:58 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pm@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 9/9] ARM: zynq: Rename 'zynq_platform_cpu_die'
Date: Wed, 20 Aug 2014 13:41:55 -0700
Message-Id: <1408567315-28479-10-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.0.1.1.gfbfc394
In-Reply-To: <1408567315-28479-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1408567315-28479-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Match the naming pattern of all other SMP ops and rename
zynq_platform_cpu_die --> zynq_cpu_die.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/mach-zynq/platsmp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
index 04e578718aa2..95933c5e70e1 100644
--- a/arch/arm/mach-zynq/platsmp.c
+++ b/arch/arm/mach-zynq/platsmp.c
@@ -138,7 +138,7 @@ static int zynq_cpu_kill(unsigned cpu)
  *
  * Called with IRQs disabled
  */
-static void zynq_platform_cpu_die(unsigned int cpu)
+static void zynq_cpu_die(unsigned int cpu)
 {
 	zynq_slcr_cpu_state_write(cpu, true);
 
@@ -158,7 +158,7 @@ struct smp_operations zynq_smp_ops __initdata = {
 	.smp_boot_secondary	= zynq_boot_secondary,
 	.smp_secondary_init	= zynq_secondary_init,
 #ifdef CONFIG_HOTPLUG_CPU
-	.cpu_die		= zynq_platform_cpu_die,
+	.cpu_die		= zynq_cpu_die,
 	.cpu_kill		= zynq_cpu_kill,
 #endif
 };
-- 
2.0.1.1.gfbfc394

