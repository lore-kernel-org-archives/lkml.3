Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbbAEMTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 07:19:25 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51806 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbbAEMTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:19:20 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-86-54aa8146f17f
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linus.walleij@linaro.org, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com, Mark Rutland <mark.rutland@arm.com>, nm@ti.com,
        khilman@linaro.org
Subject: [PATCH v11 1/9] ARM: OMAP2+: use common l2cache initialization code
Date: Mon, 05 Jan 2015 13:19:00 +0100
Message-id: <1420460348-20302-2-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1420460348-20302-1-git-send-email-m.szyprowski@samsung.com>
References: <1420460348-20302-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xK7pujatCDOavErH4O+kYu8Wj+Y+Z
	LXoXXGWz+Hp4BaPF2aY37BbbO2ewW0z5s5zJYtPja6wWl3fNYbOYvaSfxWLG+X1MFrcv81qc
	276FxWLtkbvsFkuvX2SyePPjLJPFqeuf2SxW7frDaLH/ipeDsMeaeWsYPVqae9g8fv+axOjx
	7eskFo/Lfb1MHou+Z3nsnHWX3ePOtT1sHpuX1HtcOdHE6tG3ZRWjx/Eb25k8Pm+SC+CN4rJJ
	Sc3JLEst0rdL4Mo4sXgJa8Fb6Yqu3Y/ZGhhPiXcxcnJICJhIfNrwgQ3CFpO4cG89kM3FISSw
	lFFiwp/PTBBOH5PEpKsrmUCq2AQMJbredoF1iAi4Sfxbdwisg1lgGovEpiPnmUESwgI+EvP3
	nWYFsVkEVCWaln4Ai/MKeEicuLOVFWKdnMT/lyvAhnIKeEos3buPHcQWAqo5c2st+wRG3gWM
	DKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQiLj6w7GpcesDjEKcDAq8fB6nFgZIsSaWFZc
	mXuIUYKDWUmE91X6qhAh3pTEyqrUovz4otKc1OJDjEwcnFINjDyT9XeopotzZqmH631brSLw
	5Zb5bIkPYUbVFge5j7AfKJ0Ref2rlbp//om4RZHN644svnXDUmnSZf/VjjO09wk2ZfK/1uts
	PfSg8PwX27Un7iZs+XFA3v72z/OLs1f+mnRs31s94z3sf6NnH6z54Fb788JOh5i/VqoPe6V6
	jy/jOt4iKMSaVqLEUpyRaKjFXFScCABFoIoxagIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements generic DT L2C initialisation (the one from
init_IRQ in arch/arm/kernel/irq.c) for Omap4 and AM43 platforms and
kills the SoC specific stuff in arch/arm/mach-omap2/omap4-common.c.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/mach-omap2/board-generic.c |  6 ++++++
 arch/arm/mach-omap2/common.h        |  7 +++++++
 arch/arm/mach-omap2/omap4-common.c  | 16 +---------------
 3 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index 608079a1aba6..c5c480b76da5 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -171,6 +171,9 @@ static const char *const omap4_boards_compat[] __initconst = {
 };
 
 DT_MACHINE_START(OMAP4_DT, "Generic OMAP4 (Flattened Device Tree)")
+	.l2c_aux_val	= OMAP_L2C_AUX_CTRL,
+	.l2c_aux_mask	= 0xcf9fffff,
+	.l2c_write_sec	= omap4_l2c310_write_sec,
 	.reserve	= omap_reserve,
 	.smp		= smp_ops(omap4_smp_ops),
 	.map_io		= omap4_map_io,
@@ -214,6 +217,9 @@ static const char *const am43_boards_compat[] __initconst = {
 };
 
 DT_MACHINE_START(AM43_DT, "Generic AM43 (Flattened Device Tree)")
+	.l2c_aux_val	= OMAP_L2C_AUX_CTRL,
+	.l2c_aux_mask	= 0xcf9fffff,
+	.l2c_write_sec	= omap4_l2c310_write_sec,
 	.map_io		= am33xx_map_io,
 	.init_early	= am43xx_init_early,
 	.init_late	= am43xx_init_late,
diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index 377eea849e7b..19c9144d8b38 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -35,6 +35,7 @@
 #include <linux/irqchip/irq-omap-intc.h>
 
 #include <asm/proc-fns.h>
+#include <asm/hardware/cache-l2x0.h>
 
 #include "i2c.h"
 #include "serial.h"
@@ -94,11 +95,17 @@ extern void omap3_gptimer_timer_init(void);
 extern void omap4_local_timer_init(void);
 #ifdef CONFIG_CACHE_L2X0
 int omap_l2_cache_init(void);
+#define OMAP_L2C_AUX_CTRL	(L2C_AUX_CTRL_SHARED_OVERRIDE | \
+				 L310_AUX_CTRL_DATA_PREFETCH | \
+				 L310_AUX_CTRL_INSTR_PREFETCH)
+void omap4_l2c310_write_sec(unsigned long val, unsigned reg);
 #else
 static inline int omap_l2_cache_init(void)
 {
 	return 0;
 }
+#define OMAP_L2C_AUX_CTRL	0
+#define omap4_l2c310_write_sec	NULL
 #endif
 extern void omap5_realtime_timer_init(void);
 
diff --git a/arch/arm/mach-omap2/omap4-common.c b/arch/arm/mach-omap2/omap4-common.c
index b7cb44abe49b..fe99ceff2e2d 100644
--- a/arch/arm/mach-omap2/omap4-common.c
+++ b/arch/arm/mach-omap2/omap4-common.c
@@ -166,7 +166,7 @@ void __iomem *omap4_get_l2cache_base(void)
 	return l2cache_base;
 }
 
-static void omap4_l2c310_write_sec(unsigned long val, unsigned reg)
+void omap4_l2c310_write_sec(unsigned long val, unsigned reg)
 {
 	unsigned smc_op;
 
@@ -201,24 +201,10 @@ static void omap4_l2c310_write_sec(unsigned long val, unsigned reg)
 
 int __init omap_l2_cache_init(void)
 {
-	u32 aux_ctrl;
-
 	/* Static mapping, never released */
 	l2cache_base = ioremap(OMAP44XX_L2CACHE_BASE, SZ_4K);
 	if (WARN_ON(!l2cache_base))
 		return -ENOMEM;
-
-	/* 16-way associativity, parity disabled, way size - 64KB (es2.0 +) */
-	aux_ctrl = L2C_AUX_CTRL_SHARED_OVERRIDE |
-		   L310_AUX_CTRL_DATA_PREFETCH |
-		   L310_AUX_CTRL_INSTR_PREFETCH;
-
-	outer_cache.write_sec = omap4_l2c310_write_sec;
-	if (of_have_populated_dt())
-		l2x0_of_init(aux_ctrl, 0xcf9fffff);
-	else
-		l2x0_init(l2cache_base, aux_ctrl, 0xcf9fffff);
-
 	return 0;
 }
 #endif
-- 
1.9.2

