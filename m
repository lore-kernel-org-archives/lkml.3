Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbaHVODw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:03:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34012 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451AbaHVODD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:03:03 -0400
From: Nishanth Menon <nm@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 09/10] ARM: OMAP5: Add hook in SoC initcalls to enable pm initialization
Date: Fri, 22 Aug 2014 09:02:33 -0500
Message-ID: <1408716154-26101-10-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408716154-26101-1-git-send-email-nm@ti.com>
References: <1408716154-26101-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Shilimkar <santosh.shilimkar@ti.com>

With consolidated code, now we can add the required hooks for
OMAP5 to enable power management.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
[nm@ti.com: minor rebase updates]
Signed-off-by: Nishanth Menon <nm@ti.com>
---
/home/nmenon/tmp/upstream/v3.17/cpuidle-suspend-support/0009-ARM-OMAP5-Add-hook-in-SoC-initcalls-to-enable-pm-ini.patch
 arch/arm/mach-omap2/common.h |    2 +-
 arch/arm/mach-omap2/io.c     |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index dc571f1..5bb1592 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -60,7 +60,7 @@ static inline int omap3_pm_init(void)
 }
 #endif
 
-#if defined(CONFIG_PM) && defined(CONFIG_ARCH_OMAP4)
+#if defined(CONFIG_PM) && (defined(CONFIG_ARCH_OMAP4) || defined(CONFIG_SOC_OMAP5))
 int omap4_pm_init(void);
 int omap4_pm_init_early(void);
 #else
diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index 5d0667c..2890c2d 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -667,6 +667,7 @@ void __init omap5_init_early(void)
 	omap2_set_globals_cm(OMAP2_L4_IO_ADDRESS(OMAP54XX_CM_CORE_AON_BASE),
 			     OMAP2_L4_IO_ADDRESS(OMAP54XX_CM_CORE_BASE));
 	omap2_set_globals_prcm_mpu(OMAP2_L4_IO_ADDRESS(OMAP54XX_PRCM_MPU_BASE));
+	omap4_pm_init_early();
 	omap_prm_base_init();
 	omap_cm_base_init();
 	omap44xx_prm_init();
@@ -682,6 +683,8 @@ void __init omap5_init_early(void)
 void __init omap5_init_late(void)
 {
 	omap_common_late_init();
+	omap4_pm_init();
+	omap2_clk_enable_autoidle_all();
 }
 #endif
 
-- 
1.7.9.5

