Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab3KNMUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 07:20:03 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42863 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753560Ab3KNMT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 07:19:56 -0500
From: Sricharan R <r.sricharan@ti.com>
To: <r.sricharan@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linus.walleij@linaro.org>, <linux@arm.linux.org.uk>,
        <tony@atomide.com>, <rnayak@ti.com>, <marc.zyngier@arm.com>,
        <grant.likely@linaro.org>, <mark.rutland@arm.com>,
        <robherring2@gmail.com>, <tglx@linutronix.de>, <galak@codeaurora.org>,
        <rob.herring@calxeda.com>, <nm@ti.com>, <bcousson@baylibre.com>
Subject: [PATCH V4 4/4] ARM: DRA: Enable Crossbar IP support for DRA7XX
Date: Thu, 14 Nov 2013 17:48:50 +0530
Message-ID: <1384431530-2166-5-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384431530-2166-1-git-send-email-r.sricharan@ti.com>
References: <1384431530-2166-1-git-send-email-r.sricharan@ti.com>
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
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
[V4] Removed the unnecessary soc check as per
     Nishanth Menon <nm@ti.com> comments

 arch/arm/mach-omap2/Kconfig        |    1 +
 arch/arm/mach-omap2/omap4-common.c |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index dc21df1..d538df6 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -135,6 +135,7 @@ config SOC_DRA7XX
 	select ARM_GIC
 	select HAVE_SMP
 	select COMMON_CLK
+	select IRQ_CROSSBAR
 
 comment "OMAP Core Type"
 	depends on ARCH_OMAP2
diff --git a/arch/arm/mach-omap2/omap4-common.c b/arch/arm/mach-omap2/omap4-common.c
index 5791143..5430c31 100644
--- a/arch/arm/mach-omap2/omap4-common.c
+++ b/arch/arm/mach-omap2/omap4-common.c
@@ -22,6 +22,7 @@
 #include <linux/of_platform.h>
 #include <linux/export.h>
 #include <linux/irqchip/arm-gic.h>
+#include <linux/irqchip/irq-crossbar.h>
 #include <linux/of_address.h>
 #include <linux/reboot.h>
 
@@ -282,6 +283,7 @@ void __init omap_gic_of_init(void)
 
 skip_errata_init:
 	omap_wakeupgen_init();
+	irqcrossbar_init();
 	irqchip_init();
 }
 
-- 
1.7.9.5

