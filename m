Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab3J3O6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:58:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49657 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369Ab3J3O6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:58:39 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <tony@atomide.com>, <rnayak@ti.com>,
        <marc.zyngier@arm.com>, <grant.likely@linaro.org>,
        <mark.rutland@arm.com>, <robherring2@gmail.com>, <tglx@linutronix.de>,
        <santosh.shilimkar@ti.com>, <r.sricharan@ti.com>
Subject: [PATCH V2 7/7] ARM: DRA: Enable Crossbar IP support for DRA7XX
Date: Wed, 30 Oct 2013 20:27:20 +0530
Message-ID: <1383145040-15852-8-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383145040-15852-1-git-send-email-r.sricharan@ti.com>
References: <1383145040-15852-1-git-send-email-r.sricharan@ti.com>
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
 arch/arm/mach-omap2/Kconfig        |    2 +-
 arch/arm/mach-omap2/omap4-common.c |    4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index d2d0227..73c4889 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -123,9 +123,9 @@ config SOC_DRA7XX
 	select ARM_GIC
 	select HAVE_SMP
 	select COMMON_CLK
-	select CROSSBAR
 	select ARCH_HAS_RESET_CONTROLLER
 	select RESET_TI
+	select IRQ_CROSSBAR
 
 comment "OMAP Core Type"
 	depends on ARCH_OMAP2
diff --git a/arch/arm/mach-omap2/omap4-common.c b/arch/arm/mach-omap2/omap4-common.c
index 40c265e..f64826f 100644
--- a/arch/arm/mach-omap2/omap4-common.c
+++ b/arch/arm/mach-omap2/omap4-common.c
@@ -22,6 +22,7 @@
 #include <linux/of_platform.h>
 #include <linux/export.h>
 #include <linux/irqchip/arm-gic.h>
+#include <linux/irqchip/irq-crossbar.h>
 #include <linux/of_address.h>
 #include <linux/reboot.h>
 
@@ -291,9 +292,12 @@ void __init omap_gic_of_init(void)
 
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

