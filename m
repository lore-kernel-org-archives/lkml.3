Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964984AbaLKIQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 03:16:54 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:25516 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964919AbaLKIQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 03:16:52 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-5b-548952f07cfc
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, kgene.kim@samsung.com, heiko@sntech.de,
        arnd@arndb.de, thomas.ab@samsung.com, tomasz.figa@gmail.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v5 2/2] ARM: EXYNOS: refactoring of mach-exynos to enable
 chipid driver
Date: Thu, 11 Dec 2014 13:37:44 +0530
Message-id: <1418285264-21763-3-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 2.2.0
In-reply-to: <1418285264-21763-1-git-send-email-pankaj.dubey@samsung.com>
References: <1418285264-21763-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWyRsSkWvdDUGeIwZ39ChZ/Jx1jt/j/6DWr
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLG5f5rVYtPULu0XHMkaLVbv+MDpwebQ097B5/P41idFj
	56y77B6bl9R79G1Zxeix/do8Zo/Pm+QC2KO4bFJSczLLUov07RK4MtY/lCpYFlextek2SwPj
	soAuRk4OCQETidvTd7JD2GISF+6tZ+ti5OIQEljKKLFnUTMLTNHEyxdYQWwhgemMEufv50MU
	TWCSaLh/lgkkwSagK/Hk/VxmEFtEIFui//ZqsGZmgTWMEjd3qoHYwgKREvPubwaKc3CwCKhK
	THshABLmFfCQODDrJTPELjmJLbcegR3EKeApcWr/KyaIvR4SmxbOZALZKyGwi13iw6QlYA0s
	AgIS3yYfApspISArsekA1BxJiYMrbrBMYBRewMiwilE0tSC5oDgpvchErzgxt7g0L10vOT93
	EyMwHk7/ezZhB+O9A9aHGAU4GJV4eFdcbQ8RYk0sK67MPcRoCrRhIrOUaHI+MOrySuINjc2M
	LExNTI2NzC3NlMR5X0v9DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA6FX2vHLP+91JHV8c
	4k7++dLoE9jScVDwwi6lmSoXzVx2eK9aHRU9/95tlftdi9qPuAdGP1nKzqQ05di/BeLW6032
	mbQmt1s/Sbsce7Gwed4p7+DzE45NfPPeTlz154Zbogd7L33wr986QW7uKcNlbT6H9tpo3mRu
	+FzWn+/y/cORVV7OJ11LtiuxFGckGmoxFxUnAgBCuyozggIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQd0PQZ0hBosWiVv8nXSM3eL/o9es
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9mddi0dYv7BYdyxgtVu36w+jA5dHS3MPm8fvXJEaP
	nbPusntsXlLv0bdlFaPH9mvzmD0+b5ILYI9qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUz
	MNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpOSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBc
	j5EBGkhYw5ix/qFUwbK4iq1Nt1kaGJcFdDFyckgImEhMvHyBFcIWk7hwbz0biC0kMJ1R4vz9
	/C5GLiB7ApNEw/2zTCAJNgFdiSfv5zKD2CIC2RL9t1ezgNjMAmsYJW7uVAOxhQUiJebd3wwU
	5+BgEVCVmPZCACTMK+AhcWDWS2aIXXISW249YgexOQU8JU7tf8UEsddDYtPCmUwTGHkXMDKs
	YhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOtmdSOxhXNlgcYhTgYFTi4Q243B4ixJpYVlyZ
	e4hRgoNZSYT3sUNniBBvSmJlVWpRfnxRaU5q8SFGU6CjJjJLiSbnAxNBXkm8obGJuamxqaWJ
	hYmZpZI4r5J9W4iQQHpiSWp2ampBahFMHxMHp1QDY3qRZW9qlOrPFeUXs0N2nqwys1O/7lzz
	5ZWR+IakStkDS21u2HParJq/+0RXwY0XYXt9Hlx5uCVdzriRW6lEmk1AqOb58QhzQ7GfvIuV
	5EN7r1jNTWBeX/tlk499XaFbpsAkxXvnwi/JRnwzWl4reTP0+vQzJp6df5pnhuZ67dsgtTzm
	XFaPEktxRqKhFnNRcSIAQSbL1MwCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables chipid driver for ARCH_EXYNOS and refactors
machine code for using chipid driver for identification of
SoC ID and SoC rev.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/Kconfig                 |  2 +
 arch/arm/mach-exynos/common.h                | 54 ++++++++-----------
 arch/arm/mach-exynos/exynos.c                | 77 +++++++++++-----------------
 arch/arm/mach-exynos/include/mach/map.h      |  2 -
 arch/arm/mach-exynos/platsmp.c               |  2 +-
 arch/arm/mach-exynos/pm.c                    |  8 +--
 arch/arm/plat-samsung/cpu.c                  | 14 -----
 arch/arm/plat-samsung/include/plat/cpu.h     |  2 -
 arch/arm/plat-samsung/include/plat/map-s5p.h |  1 -
 9 files changed, 60 insertions(+), 102 deletions(-)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index b9e3f1c..dd656a4 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -25,6 +25,8 @@ menuconfig ARCH_EXYNOS
 	select S5P_DEV_MFC
 	select SRAM
 	select MFD_SYSCON
+	select SOC_SAMSUNG
+	select EXYNOS_CHIPID
 	help
 	  Support for SAMSUNG EXYNOS SoCs (EXYNOS4/5)
 
diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 865f878..107b2c8 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -13,39 +13,26 @@
 #define __ARCH_ARM_MACH_EXYNOS_COMMON_H
 
 #include <linux/of.h>
+#include <linux/soc/samsung/exynos-soc.h>
 
-#define EXYNOS3250_SOC_ID	0xE3472000
-#define EXYNOS3_SOC_MASK	0xFFFFF000
-
-#define EXYNOS4210_CPU_ID	0x43210000
-#define EXYNOS4212_CPU_ID	0x43220000
-#define EXYNOS4412_CPU_ID	0xE4412200
-#define EXYNOS4_CPU_MASK	0xFFFE0000
-
-#define EXYNOS5250_SOC_ID	0x43520000
-#define EXYNOS5410_SOC_ID	0xE5410000
-#define EXYNOS5420_SOC_ID	0xE5420000
-#define EXYNOS5440_SOC_ID	0xE5440000
-#define EXYNOS5800_SOC_ID	0xE5422000
-#define EXYNOS5_SOC_MASK	0xFFFFF000
-
-extern unsigned long samsung_cpu_id;
+static inline u32 exynos_product_id(void);
 
 #define IS_SAMSUNG_CPU(name, id, mask)		\
 static inline int is_samsung_##name(void)	\
 {						\
-	return ((samsung_cpu_id & mask) == (id & mask));	\
+	u32 product_id = exynos_product_id();	\
+	return ((product_id & mask) == (id));	\
 }
 
-IS_SAMSUNG_CPU(exynos3250, EXYNOS3250_SOC_ID, EXYNOS3_SOC_MASK)
-IS_SAMSUNG_CPU(exynos4210, EXYNOS4210_CPU_ID, EXYNOS4_CPU_MASK)
-IS_SAMSUNG_CPU(exynos4212, EXYNOS4212_CPU_ID, EXYNOS4_CPU_MASK)
-IS_SAMSUNG_CPU(exynos4412, EXYNOS4412_CPU_ID, EXYNOS4_CPU_MASK)
-IS_SAMSUNG_CPU(exynos5250, EXYNOS5250_SOC_ID, EXYNOS5_SOC_MASK)
-IS_SAMSUNG_CPU(exynos5410, EXYNOS5410_SOC_ID, EXYNOS5_SOC_MASK)
-IS_SAMSUNG_CPU(exynos5420, EXYNOS5420_SOC_ID, EXYNOS5_SOC_MASK)
-IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS5_SOC_MASK)
-IS_SAMSUNG_CPU(exynos5800, EXYNOS5800_SOC_ID, EXYNOS5_SOC_MASK)
+IS_SAMSUNG_CPU(exynos3250, EXYNOS3250_SOC_ID, EXYNOS_SOC_MASK)
+IS_SAMSUNG_CPU(exynos4210, EXYNOS4210_SOC_ID, EXYNOS_SOC_MASK)
+IS_SAMSUNG_CPU(exynos4212, EXYNOS4212_SOC_ID, EXYNOS_SOC_MASK)
+IS_SAMSUNG_CPU(exynos4412, EXYNOS4412_SOC_ID, EXYNOS_SOC_MASK)
+IS_SAMSUNG_CPU(exynos5250, EXYNOS5250_SOC_ID, EXYNOS_SOC_MASK)
+IS_SAMSUNG_CPU(exynos5410, EXYNOS5410_SOC_ID, EXYNOS_SOC_MASK)
+IS_SAMSUNG_CPU(exynos5420, EXYNOS5420_SOC_ID, EXYNOS_SOC_MASK)
+IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS_SOC_MASK)
+IS_SAMSUNG_CPU(exynos5800, EXYNOS5800_SOC_ID, EXYNOS_SOC_MASK)
 
 #if defined(CONFIG_SOC_EXYNOS3250)
 # define soc_is_exynos3250()	is_samsung_exynos3250()
@@ -71,10 +58,6 @@ IS_SAMSUNG_CPU(exynos5800, EXYNOS5800_SOC_ID, EXYNOS5_SOC_MASK)
 # define soc_is_exynos4412()	0
 #endif
 
-#define EXYNOS4210_REV_0	(0x0)
-#define EXYNOS4210_REV_1_0	(0x10)
-#define EXYNOS4210_REV_1_1	(0x11)
-
 #if defined(CONFIG_SOC_EXYNOS5250)
 # define soc_is_exynos5250()	is_samsung_exynos5250()
 #else
@@ -150,8 +133,15 @@ extern void exynos_pm_central_suspend(void);
 extern int exynos_pm_central_resume(void);
 extern void exynos_enter_aftr(void);
 
-extern void s5p_init_cpu(void __iomem *cpuid_addr);
-extern unsigned int samsung_rev(void);
+static inline u32 exynos_product_id(void)
+{
+	return exynos_soc_info.product_id;
+}
+
+static inline u32 exynos_revision(void)
+{
+	return exynos_soc_info.revision;
+}
 
 static inline void pmu_raw_writel(u32 val, u32 offset)
 {
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index c13d083..e2a640b 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -126,53 +126,16 @@ static void __init exynos_init_late(void)
 	exynos_pm_init();
 }
 
-static int __init exynos_fdt_map_chipid(unsigned long node, const char *uname,
-					int depth, void *data)
+static void __init exynos4_init_io(void)
 {
-	struct map_desc iodesc;
-	const __be32 *reg;
-	int len;
-
-	if (!of_flat_dt_is_compatible(node, "samsung,exynos4210-chipid") &&
-		!of_flat_dt_is_compatible(node, "samsung,exynos5440-clock"))
-		return 0;
-
-	reg = of_get_flat_dt_prop(node, "reg", &len);
-	if (reg == NULL || len != (sizeof(unsigned long) * 2))
-		return 0;
-
-	iodesc.pfn = __phys_to_pfn(be32_to_cpu(reg[0]));
-	iodesc.length = be32_to_cpu(reg[1]) - 1;
-	iodesc.virtual = (unsigned long)S5P_VA_CHIPID;
-	iodesc.type = MT_DEVICE;
-	iotable_init(&iodesc, 1);
-	return 1;
-}
-
-/*
- * exynos_map_io
- *
- * register the standard cpu IO areas
- */
-static void __init exynos_map_io(void)
-{
-	if (soc_is_exynos4())
-		iotable_init(exynos4_iodesc, ARRAY_SIZE(exynos4_iodesc));
-
-	if (soc_is_exynos5())
-		iotable_init(exynos5_iodesc, ARRAY_SIZE(exynos5_iodesc));
+	debug_ll_io_init();
+	iotable_init(exynos4_iodesc, ARRAY_SIZE(exynos4_iodesc));
 }
 
-static void __init exynos_init_io(void)
+static void __init exynos5_init_io(void)
 {
 	debug_ll_io_init();
-
-	of_scan_flat_dt(exynos_fdt_map_chipid, NULL);
-
-	/* detect cpu id and rev. */
-	s5p_init_cpu(S5P_VA_CHIPID);
-
-	exynos_map_io();
+	iotable_init(exynos5_iodesc, ARRAY_SIZE(exynos5_iodesc));
 }
 
 static const struct of_device_id exynos_dt_pmu_match[] = {
@@ -209,6 +172,8 @@ static void __init exynos_init_irq(void)
 	 * init_irq
 	 */
 	exynos_map_pmu();
+
+	exynos_chipid_early_init(NULL);
 }
 
 static void __init exynos_dt_machine_init(void)
@@ -258,7 +223,7 @@ static void __init exynos_dt_machine_init(void)
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
-static char const *exynos_dt_compat[] __initconst = {
+static char const *exynos4_dt_compat[] __initconst = {
 	"samsung,exynos3",
 	"samsung,exynos3250",
 	"samsung,exynos4",
@@ -266,6 +231,10 @@ static char const *exynos_dt_compat[] __initconst = {
 	"samsung,exynos4212",
 	"samsung,exynos4412",
 	"samsung,exynos4415",
+	NULL
+};
+
+static char const *exynos5_dt_compat[] __initconst = {
 	"samsung,exynos5",
 	"samsung,exynos5250",
 	"samsung,exynos5260",
@@ -299,18 +268,34 @@ static void __init exynos_dt_fixup(void)
 	of_fdt_limit_memory(8);
 }
 
-DT_MACHINE_START(EXYNOS_DT, "SAMSUNG EXYNOS (Flattened Device Tree)")
+DT_MACHINE_START(EXYNOS4_DT, "SAMSUNG EXYNOS4 (Flattened Device Tree)")
+	/* Maintainer: Thomas Abraham <thomas.abraham@linaro.org> */
+	/* Maintainer: Kukjin Kim <kgene.kim@samsung.com> */
+	.l2c_aux_val	= 0x3c400001,
+	.l2c_aux_mask	= 0xc20fffff,
+	.smp		= smp_ops(exynos_smp_ops),
+	.map_io		= exynos4_init_io,
+	.init_early	= exynos_firmware_init,
+	.init_irq	= exynos_init_irq,
+	.init_machine	= exynos_dt_machine_init,
+	.init_late	= exynos_init_late,
+	.dt_compat	= exynos4_dt_compat,
+	.reserve	= exynos_reserve,
+	.dt_fixup	= exynos_dt_fixup,
+MACHINE_END
+
+DT_MACHINE_START(EXYNOS5_DT, "SAMSUNG EXYNOS5 (Flattened Device Tree)")
 	/* Maintainer: Thomas Abraham <thomas.abraham@linaro.org> */
 	/* Maintainer: Kukjin Kim <kgene.kim@samsung.com> */
 	.l2c_aux_val	= 0x3c400001,
 	.l2c_aux_mask	= 0xc20fffff,
 	.smp		= smp_ops(exynos_smp_ops),
-	.map_io		= exynos_init_io,
+	.map_io		= exynos5_init_io,
 	.init_early	= exynos_firmware_init,
 	.init_irq	= exynos_init_irq,
 	.init_machine	= exynos_dt_machine_init,
 	.init_late	= exynos_init_late,
-	.dt_compat	= exynos_dt_compat,
+	.dt_compat	= exynos5_dt_compat,
 	.reserve	= exynos_reserve,
 	.dt_fixup	= exynos_dt_fixup,
 MACHINE_END
diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
index 1ad3f49..2e1c115 100644
--- a/arch/arm/mach-exynos/include/mach/map.h
+++ b/arch/arm/mach-exynos/include/mach/map.h
@@ -22,8 +22,6 @@
 
 #include <plat/map-s5p.h>
 
-#define EXYNOS_PA_CHIPID		0x10000000
-
 #define EXYNOS4_PA_SYSCON		0x10010000
 #define EXYNOS5_PA_SYSCON		0x10050100
 
diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 7a1ebfe..5c318c3 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -196,7 +196,7 @@ int exynos_cluster_power_state(int cluster)
 
 static inline void __iomem *cpu_boot_reg_base(void)
 {
-	if (soc_is_exynos4210() && samsung_rev() == EXYNOS4210_REV_1_1)
+	if (soc_is_exynos4210() && exynos_revision() == EXYNOS4210_REV_1_1)
 		return pmu_base_addr + S5P_INFORM5;
 	return sysram_base_addr;
 }
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 86f3ecd..d694190 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -32,18 +32,18 @@
 
 static inline void __iomem *exynos_boot_vector_addr(void)
 {
-	if (samsung_rev() == EXYNOS4210_REV_1_1)
+	if (exynos_revision() == EXYNOS4210_REV_1_1)
 		return pmu_base_addr + S5P_INFORM7;
-	else if (samsung_rev() == EXYNOS4210_REV_1_0)
+	else if (exynos_revision() == EXYNOS4210_REV_1_0)
 		return sysram_base_addr + 0x24;
 	return pmu_base_addr + S5P_INFORM0;
 }
 
 static inline void __iomem *exynos_boot_vector_flag(void)
 {
-	if (samsung_rev() == EXYNOS4210_REV_1_1)
+	if (exynos_revision() == EXYNOS4210_REV_1_1)
 		return pmu_base_addr + S5P_INFORM6;
-	else if (samsung_rev() == EXYNOS4210_REV_1_0)
+	else if (exynos_revision() == EXYNOS4210_REV_1_0)
 		return sysram_base_addr + 0x20;
 	return pmu_base_addr + S5P_INFORM1;
 }
diff --git a/arch/arm/plat-samsung/cpu.c b/arch/arm/plat-samsung/cpu.c
index 71333bb..02d95fd 100644
--- a/arch/arm/plat-samsung/cpu.c
+++ b/arch/arm/plat-samsung/cpu.c
@@ -21,12 +21,6 @@
 unsigned long samsung_cpu_id;
 static unsigned int samsung_cpu_rev;
 
-unsigned int samsung_rev(void)
-{
-	return samsung_cpu_rev;
-}
-EXPORT_SYMBOL(samsung_rev);
-
 void __init s3c64xx_init_cpu(void)
 {
 	samsung_cpu_id = __raw_readl(S3C_VA_SYS + 0x118);
@@ -43,11 +37,3 @@ void __init s3c64xx_init_cpu(void)
 
 	pr_info("Samsung CPU ID: 0x%08lx\n", samsung_cpu_id);
 }
-
-void __init s5p_init_cpu(void __iomem *cpuid_addr)
-{
-	samsung_cpu_id = __raw_readl(cpuid_addr);
-	samsung_cpu_rev = samsung_cpu_id & 0xFF;
-
-	pr_info("Samsung CPU ID: 0x%08lx\n", samsung_cpu_id);
-}
diff --git a/arch/arm/plat-samsung/include/plat/cpu.h b/arch/arm/plat-samsung/include/plat/cpu.h
index 61d14f3..fa7d0d6 100644
--- a/arch/arm/plat-samsung/include/plat/cpu.h
+++ b/arch/arm/plat-samsung/include/plat/cpu.h
@@ -114,8 +114,6 @@ extern void s3c24xx_init_io(struct map_desc *mach_desc, int size);
 
 extern void s3c64xx_init_cpu(void);
 
-extern unsigned int samsung_rev(void);
-
 extern void s3c24xx_init_uarts(struct s3c2410_uartcfg *cfg, int no);
 
 extern void s3c24xx_init_clocks(int xtal);
diff --git a/arch/arm/plat-samsung/include/plat/map-s5p.h b/arch/arm/plat-samsung/include/plat/map-s5p.h
index f5cf2bd..3df015c 100644
--- a/arch/arm/plat-samsung/include/plat/map-s5p.h
+++ b/arch/arm/plat-samsung/include/plat/map-s5p.h
@@ -13,7 +13,6 @@
 #ifndef __ASM_PLAT_MAP_S5P_H
 #define __ASM_PLAT_MAP_S5P_H __FILE__
 
-#define S5P_VA_CHIPID		S3C_ADDR(0x02000000)
 #define S5P_VA_CMU		S3C_ADDR(0x02100000)
 
 #define S5P_VA_DMC0		S3C_ADDR(0x02440000)
-- 
2.2.0

