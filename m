Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937766Ab3DKAL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:11:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49558 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937385Ab3DKAGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:06:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 02/30] ARM: exynos: prepare for sparse IRQ
Date: Thu, 11 Apr 2013 02:04:44 +0200
Message-Id: <1365638712-1028578-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:y05spy58EtlzhT0eS62Lg77uyowHrW/kpDFvSixX8iv
 dqqxiFZ78I6Wis7Wc/uVWwqpgjKVnR5pW4o9OLzsLYOqhVdFkT
 vTetyXDw4PD/hHiZG+fdpp+VyTb4zVvUsCRXQJPF1z4eIxgYzI
 J7uORgs9/ut0mM25WUUUPqI0lFq029YvA6WqRc+Omiv38JJl1V
 M2WRtGqxtivgSkuk8vUrEqZh19IzwCfQfcL9tU3mPyt7yr/SMg
 DTX3t4NFtim5GVpvNVfAQ9CbU/dr8ijVsM3Hd4yYnstoACwJpH
 1QCOXMbKwB2nbZO8HklwT0UjxNsWnskpWqNu7mqEkUOIiE2VQy
 juiaXZnx9YEafxGHSq/nlK4H18d7pRIlkMk2Ol4RYm6T48hm5T
 qLOB/nDdydUgg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we enable CONFIG_SPARSE_IRQ, we have to set the value of NR_IRQS in
the machine_desc for legacy IRQ domains, and any file referring to the
number of interrupts or a specific number must include the mach/irqs.h
header file explicitly.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-exynos/dev-uart.c          | 1 +
 arch/arm/mach-exynos/include/mach/irqs.h | 5 ++++-
 arch/arm/mach-exynos/mach-armlex4210.c   | 2 ++
 arch/arm/mach-exynos/mach-exynos4-dt.c   | 3 +++
 arch/arm/mach-exynos/mach-exynos5-dt.c   | 2 ++
 arch/arm/mach-exynos/mach-nuri.c         | 2 ++
 arch/arm/mach-exynos/mach-origen.c       | 2 ++
 arch/arm/mach-exynos/mach-smdk4x12.c     | 2 ++
 arch/arm/mach-exynos/mach-smdkv310.c     | 3 +++
 arch/arm/plat-samsung/irq-vic-timer.c    | 1 +
 arch/arm/plat-samsung/pm.c               | 1 +
 arch/arm/plat-samsung/s5p-irq.c          | 1 +
 12 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/dev-uart.c b/arch/arm/mach-exynos/dev-uart.c
index 7c42f4b..c48aff0 100644
--- a/arch/arm/mach-exynos/dev-uart.c
+++ b/arch/arm/mach-exynos/dev-uart.c
@@ -20,6 +20,7 @@
 #include <asm/mach/irq.h>
 #include <mach/hardware.h>
 #include <mach/map.h>
+#include <mach/irqs.h>
 
 #include <plat/devs.h>
 
diff --git a/arch/arm/mach-exynos/include/mach/irqs.h b/arch/arm/mach-exynos/include/mach/irqs.h
index 35fe6d5..c72f59d 100644
--- a/arch/arm/mach-exynos/include/mach/irqs.h
+++ b/arch/arm/mach-exynos/include/mach/irqs.h
@@ -467,7 +467,10 @@
 #define IRQ_TIMER_BASE			(IRQ_GPIO_END + 64)
 
 /* Set the default NR_IRQS */
+#define EXYNOS_NR_IRQS			(IRQ_TIMER_BASE + IRQ_TIMER_COUNT)
 
-#define NR_IRQS				(IRQ_TIMER_BASE + IRQ_TIMER_COUNT)
+#ifndef CONFIG_SPARSE_IRQ
+#define NR_IRQS				EXYNOS_NR_IRQS
+#endif
 
 #endif /* __ASM_ARCH_IRQS_H */
diff --git a/arch/arm/mach-exynos/mach-armlex4210.c b/arch/arm/mach-exynos/mach-armlex4210.c
index 2c23b65..a503e02 100644
--- a/arch/arm/mach-exynos/mach-armlex4210.c
+++ b/arch/arm/mach-exynos/mach-armlex4210.c
@@ -25,6 +25,7 @@
 #include <plat/regs-srom.h>
 #include <plat/sdhci.h>
 
+#include <mach/irqs.h>
 #include <mach/map.h>
 
 #include "common.h"
@@ -196,6 +197,7 @@ static void __init armlex4210_machine_init(void)
 MACHINE_START(ARMLEX4210, "ARMLEX4210")
 	/* Maintainer: Alim Akhtar <alim.akhtar@samsung.com> */
 	.atag_offset	= 0x100,
+	.nr_irqs	= EXYNOS_NR_IRQS,
 	.smp		= smp_ops(exynos_smp_ops),
 	.init_irq	= exynos4_init_irq,
 	.map_io		= armlex4210_map_io,
diff --git a/arch/arm/mach-exynos/mach-exynos4-dt.c b/arch/arm/mach-exynos/mach-exynos4-dt.c
index b9ed834..5f23682 100644
--- a/arch/arm/mach-exynos/mach-exynos4-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos4-dt.c
@@ -20,6 +20,8 @@
 
 #include <asm/mach/arch.h>
 #include <plat/mfc.h>
+#include <mach/irqs.h>
+
 
 #include "common.h"
 
@@ -54,6 +56,7 @@ static void __init exynos4_reserve(void)
 }
 DT_MACHINE_START(EXYNOS4210_DT, "Samsung Exynos4 (Flattened Device Tree)")
 	/* Maintainer: Thomas Abraham <thomas.abraham@linaro.org> */
+	.nr_irqs	= EXYNOS_NR_IRQS,
 	.smp		= smp_ops(exynos_smp_ops),
 	.init_irq	= exynos4_init_irq,
 	.map_io		= exynos4_dt_map_io,
diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
index 753b94f..8b7456a 100644
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@ -16,6 +16,7 @@
 #include <linux/clocksource.h>
 
 #include <asm/mach/arch.h>
+#include <mach/irqs.h>
 #include <mach/regs-pmu.h>
 
 #include <plat/cpu.h>
@@ -76,6 +77,7 @@ static void __init exynos5_reserve(void)
 
 DT_MACHINE_START(EXYNOS5_DT, "SAMSUNG EXYNOS5 (Flattened Device Tree)")
 	/* Maintainer: Kukjin Kim <kgene.kim@samsung.com> */
+	.nr_irqs	= EXYNOS_NR_IRQS,
 	.init_irq	= exynos5_init_irq,
 	.smp		= smp_ops(exynos_smp_ops),
 	.map_io		= exynos5_dt_map_io,
diff --git a/arch/arm/mach-exynos/mach-nuri.c b/arch/arm/mach-exynos/mach-nuri.c
index 0c10852..fbae331 100644
--- a/arch/arm/mach-exynos/mach-nuri.c
+++ b/arch/arm/mach-exynos/mach-nuri.c
@@ -53,6 +53,7 @@
 #include <plat/fimc-core.h>
 #include <plat/camport.h>
 
+#include <mach/irqs.h>
 #include <mach/map.h>
 
 #include "common.h"
@@ -1376,6 +1377,7 @@ static void __init nuri_machine_init(void)
 MACHINE_START(NURI, "NURI")
 	/* Maintainer: Kyungmin Park <kyungmin.park@samsung.com> */
 	.atag_offset	= 0x100,
+	.nr_irqs	= EXYNOS_NR_IRQS,
 	.smp		= smp_ops(exynos_smp_ops),
 	.init_irq	= exynos4_init_irq,
 	.map_io		= nuri_map_io,
diff --git a/arch/arm/mach-exynos/mach-origen.c b/arch/arm/mach-exynos/mach-origen.c
index f662345..a3ee06a 100644
--- a/arch/arm/mach-exynos/mach-origen.c
+++ b/arch/arm/mach-exynos/mach-origen.c
@@ -46,6 +46,7 @@
 #include <plat/hdmi.h>
 
 #include <mach/map.h>
+#include <mach/irqs.h>
 
 #include <drm/exynos_drm.h>
 #include "common.h"
@@ -811,6 +812,7 @@ static void __init origen_machine_init(void)
 MACHINE_START(ORIGEN, "ORIGEN")
 	/* Maintainer: JeongHyeon Kim <jhkim@insignal.co.kr> */
 	.atag_offset	= 0x100,
+	.nr_irqs	= EXYNOS_NR_IRQS,
 	.smp		= smp_ops(exynos_smp_ops),
 	.init_irq	= exynos4_init_irq,
 	.map_io		= origen_map_io,
diff --git a/arch/arm/mach-exynos/mach-smdk4x12.c b/arch/arm/mach-exynos/mach-smdk4x12.c
index 184faa3..3ebd5e4 100644
--- a/arch/arm/mach-exynos/mach-smdk4x12.c
+++ b/arch/arm/mach-exynos/mach-smdk4x12.c
@@ -39,6 +39,7 @@
 #include <plat/regs-serial.h>
 #include <plat/sdhci.h>
 
+#include <mach/irqs.h>
 #include <mach/map.h>
 
 #include <drm/exynos_drm.h>
@@ -384,6 +385,7 @@ MACHINE_START(SMDK4412, "SMDK4412")
 	/* Maintainer: Kukjin Kim <kgene.kim@samsung.com> */
 	/* Maintainer: Changhwan Youn <chaos.youn@samsung.com> */
 	.atag_offset	= 0x100,
+	.nr_irqs	= EXYNOS_NR_IRQS,
 	.smp		= smp_ops(exynos_smp_ops),
 	.init_irq	= exynos4_init_irq,
 	.map_io		= smdk4x12_map_io,
diff --git a/arch/arm/mach-exynos/mach-smdkv310.c b/arch/arm/mach-exynos/mach-smdkv310.c
index ee815a7..5527a28 100644
--- a/arch/arm/mach-exynos/mach-smdkv310.c
+++ b/arch/arm/mach-exynos/mach-smdkv310.c
@@ -43,6 +43,7 @@
 #include <plat/clock.h>
 #include <plat/hdmi.h>
 
+#include <mach/irqs.h>
 #include <mach/map.h>
 
 #include <drm/exynos_drm.h>
@@ -420,6 +421,7 @@ MACHINE_START(SMDKV310, "SMDKV310")
 	/* Maintainer: Kukjin Kim <kgene.kim@samsung.com> */
 	/* Maintainer: Changhwan Youn <chaos.youn@samsung.com> */
 	.atag_offset	= 0x100,
+	.nr_irqs	= EXYNOS_NR_IRQS,
 	.smp		= smp_ops(exynos_smp_ops),
 	.init_irq	= exynos4_init_irq,
 	.map_io		= smdkv310_map_io,
@@ -432,6 +434,7 @@ MACHINE_END
 MACHINE_START(SMDKC210, "SMDKC210")
 	/* Maintainer: Kukjin Kim <kgene.kim@samsung.com> */
 	.atag_offset	= 0x100,
+	.nr_irqs	= EXYNOS_NR_IRQS,
 	.smp		= smp_ops(exynos_smp_ops),
 	.init_irq	= exynos4_init_irq,
 	.map_io		= smdkv310_map_io,
diff --git a/arch/arm/plat-samsung/irq-vic-timer.c b/arch/arm/plat-samsung/irq-vic-timer.c
index 5d205e7..0fceb42 100644
--- a/arch/arm/plat-samsung/irq-vic-timer.c
+++ b/arch/arm/plat-samsung/irq-vic-timer.c
@@ -20,6 +20,7 @@
 #include <linux/io.h>
 
 #include <mach/map.h>
+#include <mach/irqs.h>
 #include <plat/cpu.h>
 #include <plat/irq-vic-timer.h>
 #include <plat/regs-timer.h>
diff --git a/arch/arm/plat-samsung/pm.c b/arch/arm/plat-samsung/pm.c
index 002b147..53210ec 100644
--- a/arch/arm/plat-samsung/pm.c
+++ b/arch/arm/plat-samsung/pm.c
@@ -27,6 +27,7 @@
 #include <plat/regs-serial.h>
 #include <mach/regs-clock.h>
 #include <mach/regs-irq.h>
+#include <mach/irqs.h>
 #include <asm/irq.h>
 
 #include <plat/pm.h>
diff --git a/arch/arm/plat-samsung/s5p-irq.c b/arch/arm/plat-samsung/s5p-irq.c
index 103e371..ff1a760 100644
--- a/arch/arm/plat-samsung/s5p-irq.c
+++ b/arch/arm/plat-samsung/s5p-irq.c
@@ -15,6 +15,7 @@
 #include <linux/io.h>
 #include <linux/irqchip/arm-vic.h>
 
+#include <mach/irqs.h>
 #include <mach/map.h>
 #include <plat/regs-timer.h>
 #include <plat/cpu.h>
-- 
1.8.1.2

