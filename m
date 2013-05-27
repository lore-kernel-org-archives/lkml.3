Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab3E0OhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 10:37:04 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38393 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629Ab3E0Og5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 10:36:57 -0400
From: Afzal Mohammed <afzal@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: [PATCH v2 07/14] ARM: OMAP2+: AM43x: early init
Date: Mon, 27 May 2013 20:06:23 +0530
Message-ID: <82f3b2b672a45b971fd0bb34366a6af368015db0.1369658705.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1369658705.git.afzal@ti.com>
References: <cover.1369658705.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minimal early init - PRCM initialization not yet taken care.

Control module is similar (base address, feature register etc.) as
that of AM335x, while PRCM base address is different. Instead of
adding a new header file for AM43x, PRCM base address is added in
AM335x header file as it is similar to it to a large extent.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 arch/arm/mach-omap2/am33xx.h |  1 +
 arch/arm/mach-omap2/common.h |  1 +
 arch/arm/mach-omap2/io.c     | 14 ++++++++++++++
 3 files changed, 16 insertions(+)

diff --git a/arch/arm/mach-omap2/am33xx.h b/arch/arm/mach-omap2/am33xx.h
index 43296c1..5eef093 100644
--- a/arch/arm/mach-omap2/am33xx.h
+++ b/arch/arm/mach-omap2/am33xx.h
@@ -21,6 +21,7 @@
 #define AM33XX_SCM_BASE		0x44E10000
 #define AM33XX_CTRL_BASE	AM33XX_SCM_BASE
 #define AM33XX_PRCM_BASE	0x44E00000
+#define AM43XX_PRCM_BASE	0x44DF0000
 #define AM33XX_TAP_BASE		(AM33XX_CTRL_BASE + 0x3FC)
 
 #endif /* __ASM_ARCH_AM33XX_H */
diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index d555cf2..00f890e 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -96,6 +96,7 @@ void am33xx_init_early(void);
 void am35xx_init_early(void);
 void ti81xx_init_early(void);
 void am33xx_init_early(void);
+void am43xx_init_early(void);
 void omap4430_init_early(void);
 void omap5_init_early(void);
 void omap3_init_late(void);	/* Do not use this one */
diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index 3a81221..f933f7f 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -586,6 +586,20 @@ void __init am33xx_init_early(void)
 }
 #endif
 
+#ifdef CONFIG_SOC_AM43XX
+void __init am43xx_init_early(void)
+{
+	omap2_set_globals_tap(AM335X_CLASS,
+			      AM33XX_L4_WK_IO_ADDRESS(AM33XX_TAP_BASE));
+	omap2_set_globals_control(AM33XX_L4_WK_IO_ADDRESS(AM33XX_CTRL_BASE),
+				  NULL);
+	omap2_set_globals_prm(AM33XX_L4_WK_IO_ADDRESS(AM43XX_PRCM_BASE));
+	omap2_set_globals_cm(AM33XX_L4_WK_IO_ADDRESS(AM43XX_PRCM_BASE), NULL);
+	omap3xxx_check_revision();
+	am33xx_check_features();
+}
+#endif
+
 #ifdef CONFIG_ARCH_OMAP4
 void __init omap4430_init_early(void)
 {
-- 
1.7.12

