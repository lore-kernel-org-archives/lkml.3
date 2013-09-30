Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab3I3OBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:01:07 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46859 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322Ab3I3OAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:00:47 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>
CC: <tglx@linutronix.de>, <linus.walleij@linaro.org>,
        <santosh.shilimkar@ti.com>, <linux@arm.linux.org.uk>,
        <tony@atomide.com>, <rnayak@ti.com>, <marc.zyngier@arm.com>,
        <r.sricharan@ti.com>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <mark.rutland@arm.com>
Subject: [RFC PATCH 6/6] ARM: DRA: Enable Crossbar IP support for DRA7XX
Date: Mon, 30 Sep 2013 19:29:24 +0530
Message-ID: <1380549564-31045-7-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380549564-31045-1-git-send-email-r.sricharan@ti.com>
References: <1380549564-31045-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the crossbar IP support for DRA7xx soc.

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sricharan R <r.sricharan@ti.com>
---
 arch/arm/mach-omap2/Kconfig        |    1 +
 arch/arm/mach-omap2/omap4-common.c |    4 ++++
 2 files changed, 5 insertions(+)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 8413252..10ec40c 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -120,6 +120,7 @@ config SOC_DRA7XX
 	select ARM_GIC
 	select HAVE_SMP
 	select COMMON_CLK
+	select IRQ_CROSSBAR
 
 comment "OMAP Core Type"
 	depends on ARCH_OMAP2
diff --git a/arch/arm/mach-omap2/omap4-common.c b/arch/arm/mach-omap2/omap4-common.c
index adbe86b..4692f1c 100644
--- a/arch/arm/mach-omap2/omap4-common.c
+++ b/arch/arm/mach-omap2/omap4-common.c
@@ -22,6 +22,7 @@
 #include <linux/of_platform.h>
 #include <linux/export.h>
 #include <linux/irqchip/arm-gic.h>
+#include <linux/irqchip/irq-crossbar.h>
 #include <linux/of_address.h>
 
 #include <asm/hardware/cache-l2x0.h>
@@ -287,9 +288,12 @@ void __init omap_gic_of_init(void)
 
 skip_errata_init:
 	omap_wakeupgen_init();
+	if (soc_is_dra7xx())
+		crossbar_init();
 	irqchip_init();
 }
 
+
 #if defined(CONFIG_MMC_OMAP_HS) || defined(CONFIG_MMC_OMAP_HS_MODULE)
 static int omap4_twl6030_hsmmc_late_init(struct device *dev)
 {
-- 
1.7.9.5

