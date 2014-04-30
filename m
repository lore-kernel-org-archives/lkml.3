Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbaD3FAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 01:00:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63379 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189AbaD3E7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 00:59:48 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-4f-53608340bf9b
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 09/12] ARM: EXYNOS: Refactored code for using PMU address
 via DT
Date: Wed, 30 Apr 2014 14:17:34 +0900
Message-id: <1398835057-3860-10-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
References: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsVy+t8zfV2H5oRgg42b9Cz+TjrGbjFp3QEm
	i2WT7rJZ9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaL25d5LRZt/cJusX7GaxaLm8+2M1ns
	aFnN4sDr0dLcw+bx+9ckRo+/q14we2xeUu/Rt2UVo8fnTXIBbFFcNimpOZllqUX6dglcGYue
	n2AquP+eqaJ90272BsY1e5i6GDk5JARMJBa1t7FA2GISF+6tZ+ti5OIQEljGKLHo82xGmKJn
	H9+zQiQWMUrcW3OcGSQhJNDGJLFtHRuIzSagK/Hk/VywuIhAtsSVxvvMIA3MAiuYJFqnzAJL
	CAuESiw5/A1sHYuAqsTzG+9YQWxeAQ+J6Wf3sncxcgBtU5CYM8kGJMwJFF54+zcrxC53iYaG
	HkaQmRIC19glpj/ezg4xR0Di2+RDLBC9shKbDjBDHC0pcXDFDZYJjMILGBlWMYqmFiQXFCel
	FxnqFSfmFpfmpesl5+duYoRES+8OxtsHrA8xJgONm8gsJZqcD4y2vJJ4Q2MzIwtTE1NjI3NL
	M9KElcR5kx4mBQkJpCeWpGanphakFsUXleakFh9iZOLglGpgvGk3s/KYfJQ8k/oanZx6me+r
	5hvPmee1bers9SelNwZebZS7ypTu0+D7O91v0aWb/dVvPErlV+zfKliY6rXNpYVz1eeGhGPS
	xld6BPnrPt74aabzd+Mv4TUTkxIre4NebQyvLzfcXaXNu94gRCg17suFmXzJ079+5w7TXToz
	+IOWfV7F/Tm3lFiKMxINtZiLihMBeOKWsawCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t9jAV2H5oRgg1sHlSz+TjrGbjFp3QEm
	i2WT7rJZ9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaL25d5LRZt/cJusX7GaxaLm8+2M1ns
	aFnN4sDr0dLcw+bx+9ckRo+/q14we2xeUu/Rt2UVo8fnTXIBbFENjDYZqYkpqUUKqXnJ+SmZ
	eem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QIcqKZQl5pQChQISi4uV9O0wTQgN
	cdO1gGmM0PUNCYLrMTJAAwnrGDMWPT/BVHD/PVNF+6bd7A2Ma/YwdTFyckgImEg8+/ieFcIW
	k7hwbz1bFyMXh5DAIkaJe2uOM4MkhATamCS2rWMDsdkEdCWevJ8LFhcRyJa40nifGaSBWWAF
	k0TrlFlgCWGBUIklh7+xgNgsAqoSz2+8A9vAK+AhMf3sXvYuRg6gbQoScybZgIQ5gcILb/9m
	hdjlLtHQ0MM4gZF3ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgWHwmvYNxVYPFIUYB
	DkYlHl6BrfHBQqyJZcWVuYcYJTiYlUR4z1cmBAvxpiRWVqUW5ccXleakFh9iTAY6aiKzlGhy
	PjBN5JXEGxqbmBlZGplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDI//fFrWn
	TW9cLzt077FkeTL1K1vXx/f8B1hrTG/ODXoZ69bIlNYqaj8j+VAow/Hj2de+l58Jdfza6PPu
	xYJPJ2sOLzz5+8GZV8H/nZevZ7z290q92Yo9VUq+fc9mxRctPySw65zMinfP/82uy1m8wCbq
	5jyVIyYBzBMvunME7DnOvJWXXd9VfqUSS3FGoqEWc1FxIgCtFsHjCQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under "arm/mach-exynos" many files are using PMU register offsets.
Since we have added support for accessing PMU base address via DT,
now we can remove PMU mapping from exynosX_iodesc. Let's convert
all these access using either of iomapped address or regmap handle.
This will help us in removing static mapping of PMU base address
as well as help in reducing dependency over machine header files.
Thus helping for migration of PMU implementation from machine to
driver folder which can be reused for ARM64 bsed SoC.

CC: Ben Dooks <ben-linux@fluff.org>
CC: Kyungmin Park <kyungmin.park@samsung.com>
CC: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/common.h                |    4 +-
 arch/arm/mach-exynos/exynos.c                |   19 +-
 arch/arm/mach-exynos/hotplug.c               |    4 +-
 arch/arm/mach-exynos/include/mach/map.h      |    3 -
 arch/arm/mach-exynos/platsmp.c               |   38 +-
 arch/arm/mach-exynos/pm.c                    |   77 ++--
 arch/arm/mach-exynos/pmu.c                   |   40 +-
 arch/arm/mach-exynos/regs-pmu.h              |  506 +++++++++++++-------------
 arch/arm/plat-samsung/include/plat/map-s5p.h |    1 -
 9 files changed, 362 insertions(+), 330 deletions(-)

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 33a2bee..2922f20 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -37,7 +37,7 @@ extern void exynos_cpu_die(unsigned int cpu);
 
 /* PMU(Power Management Unit) support */
 
-#define PMU_TABLE_END	NULL
+#define PMU_TABLE_END	(-1U)
 
 enum sys_powerdown {
 	SYS_AFTR,
@@ -48,7 +48,7 @@ enum sys_powerdown {
 
 extern unsigned long l2x0_regs_phys;
 struct exynos_pmu_conf {
-	void __iomem *reg;
+	unsigned int offset;
 	unsigned int val[NUM_SYS_POWERDOWN];
 };
 
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 9045fd6..a59b122 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_domain.h>
 #include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -66,11 +67,6 @@ static struct map_desc exynos4_iodesc[] __initdata = {
 		.length		= SZ_4K,
 		.type		= MT_DEVICE,
 	}, {
-		.virtual	= (unsigned long)S5P_VA_PMU,
-		.pfn		= __phys_to_pfn(EXYNOS4_PA_PMU),
-		.length		= SZ_64K,
-		.type		= MT_DEVICE,
-	}, {
 		.virtual	= (unsigned long)S5P_VA_COMBINER_BASE,
 		.pfn		= __phys_to_pfn(EXYNOS4_PA_COMBINER),
 		.length		= SZ_4K,
@@ -194,11 +190,6 @@ static struct map_desc exynos5_iodesc[] __initdata = {
 		.pfn		= __phys_to_pfn(EXYNOS5_PA_CMU),
 		.length		= 144 * SZ_1K,
 		.type		= MT_DEVICE,
-	}, {
-		.virtual	= (unsigned long)S5P_VA_PMU,
-		.pfn		= __phys_to_pfn(EXYNOS5_PA_PMU),
-		.length		= SZ_64K,
-		.type		= MT_DEVICE,
 	},
 };
 
@@ -206,7 +197,7 @@ static void exynos_restart(enum reboot_mode mode, const char *cmd)
 {
 	struct device_node *np;
 	u32 val = 0x1;
-	void __iomem *addr = EXYNOS_SWRESET;
+	void __iomem *addr = NULL;
 
 	if (of_machine_is_compatible("samsung,exynos5440")) {
 		u32 status;
@@ -219,9 +210,9 @@ static void exynos_restart(enum reboot_mode mode, const char *cmd)
 		val = __raw_readl(addr);
 
 		val = (val & 0xffff0000) | (status & 0xffff);
-	}
-
-	__raw_writel(val, addr);
+		__raw_writel(val, addr);
+	} else
+		regmap_write(exynos_pmu_regmap, EXYNOS_SWRESET, val);
 }
 
 static struct platform_device exynos_cpuidle = {
diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index 73b0b5c..0243ef3 100644
--- a/arch/arm/mach-exynos/hotplug.c
+++ b/arch/arm/mach-exynos/hotplug.c
@@ -13,6 +13,7 @@
 #include <linux/errno.h>
 #include <linux/smp.h>
 #include <linux/io.h>
+#include <linux/regmap.h>
 
 #include <asm/cacheflush.h>
 #include <asm/cp15.h>
@@ -91,11 +92,12 @@ static inline void cpu_leave_lowpower(void)
 
 static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
 {
+	struct regmap *pmu_regmap = get_exynos_pmuregmap();
 	for (;;) {
 
 		/* make cpu1 to be turned off at next WFI command */
 		if (cpu == 1)
-			__raw_writel(0, S5P_ARM_CORE1_CONFIGURATION);
+			regmap_write(pmu_regmap, S5P_ARM_CORE1_CONFIGURATION, 0);
 
 		/*
 		 * here's the WFI
diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
index 7b046b5..1ba7fb5 100644
--- a/arch/arm/mach-exynos/include/mach/map.h
+++ b/arch/arm/mach-exynos/include/mach/map.h
@@ -35,9 +35,6 @@
 #define EXYNOS4_PA_SYSCON		0x10010000
 #define EXYNOS5_PA_SYSCON		0x10050100
 
-#define EXYNOS4_PA_PMU			0x10020000
-#define EXYNOS5_PA_PMU			0x10040000
-
 #define EXYNOS4_PA_CMU			0x10030000
 #define EXYNOS5_PA_CMU			0x10010000
 
diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 29c2286..375ea4e 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -19,6 +19,7 @@
 #include <linux/jiffies.h>
 #include <linux/smp.h>
 #include <linux/io.h>
+#include <linux/of_address.h>
 
 #include <asm/cacheflush.h>
 #include <asm/smp_plat.h>
@@ -31,11 +32,12 @@
 #include "regs-pmu.h"
 
 extern void exynos4_secondary_startup(void);
+static void __iomem *pmu_base;
 
 static inline void __iomem *cpu_boot_reg_base(void)
 {
 	if (soc_is_exynos4210() && samsung_rev() == EXYNOS4210_REV_1_1)
-		return S5P_INFORM5;
+		return pmu_base + S5P_INFORM5;
 	return S5P_VA_SYSRAM;
 }
 
@@ -68,6 +70,30 @@ static void __iomem *scu_base_addr(void)
 	return (void __iomem *)(S5P_VA_SCU);
 }
 
+static const struct of_device_id exynos_dt_pmu_match[] = {
+	{ .compatible = "samsung,exynos4210-pmu" },
+	{ .compatible = "samsung,exynos4212-pmu" },
+	{ .compatible = "samsung,exynos4412-pmu" },
+	{ .compatible = "samsung,exynos5250-pmu" },
+	{},
+};
+
+static void __iomem *pmu_base_addr(void)
+{
+	struct device_node *np = NULL;
+	if (!pmu_base) {
+		np = of_find_matching_node(NULL, exynos_dt_pmu_match);
+
+		if (!np)
+			panic("%s, failed to find PMU node\n", __func__);
+		else
+			pmu_base = of_iomap(np, 0);
+
+		if (!pmu_base)
+			panic("%s: failed to map registers\n", __func__);
+	}
+	return pmu_base;
+}
 static DEFINE_SPINLOCK(boot_lock);
 
 static void exynos_secondary_init(unsigned int cpu)
@@ -106,14 +132,14 @@ static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
 	 */
 	write_pen_release(phys_cpu);
 
-	if (!(__raw_readl(S5P_ARM_CORE1_STATUS) & S5P_CORE_LOCAL_PWR_EN)) {
+	if (!(__raw_readl(pmu_base + S5P_ARM_CORE1_STATUS)
+				& S5P_CORE_LOCAL_PWR_EN)) {
 		__raw_writel(S5P_CORE_LOCAL_PWR_EN,
-			     S5P_ARM_CORE1_CONFIGURATION);
-
+			pmu_base + S5P_ARM_CORE1_CONFIGURATION);
 		timeout = 10;
 
 		/* wait max 10 ms until cpu1 is on */
-		while ((__raw_readl(S5P_ARM_CORE1_STATUS)
+		while ((__raw_readl(pmu_base + S5P_ARM_CORE1_STATUS)
 			& S5P_CORE_LOCAL_PWR_EN) != S5P_CORE_LOCAL_PWR_EN) {
 			if (timeout-- == 0)
 				break;
@@ -201,6 +227,8 @@ static void __init exynos_smp_prepare_cpus(unsigned int max_cpus)
 {
 	int i;
 
+	pmu_base = pmu_base_addr();
+
 	if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A9)
 		scu_enable(scu_base_addr());
 
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index f445c49..ee427d7 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -21,6 +21,7 @@
 #include <linux/irqchip/arm-gic.h>
 #include <linux/err.h>
 #include <linux/clk.h>
+#include <linux/regmap.h>
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -38,6 +39,8 @@
 #include "regs-pmu.h"
 #include "regs-sys.h"
 
+static struct regmap *pmu_regmap;
+
 /**
  * struct exynos_wkup_irq - Exynos GIC to PMU IRQ mapping
  * @hwirq: Hardware IRQ signal of the GIC
@@ -104,10 +107,10 @@ static int exynos_irq_set_wake(struct irq_data *data, unsigned int state)
 
 #define EXYNOS_BOOT_VECTOR_ADDR	(samsung_rev() == EXYNOS4210_REV_1_1 ? \
 			S5P_INFORM7 : (samsung_rev() == EXYNOS4210_REV_1_0 ? \
-			(S5P_VA_SYSRAM + 0x24) : S5P_INFORM0))
+			0x24 : S5P_INFORM0))
 #define EXYNOS_BOOT_VECTOR_FLAG	(samsung_rev() == EXYNOS4210_REV_1_1 ? \
 			S5P_INFORM6 : (samsung_rev() == EXYNOS4210_REV_1_0 ? \
-			(S5P_VA_SYSRAM + 0x20) : S5P_INFORM1))
+			0x20 : S5P_INFORM1))
 
 #define S5P_CHECK_AFTR  0xFCBA0D10
 #define S5P_CHECK_SLEEP 0x00000BAD
@@ -115,13 +118,20 @@ static int exynos_irq_set_wake(struct irq_data *data, unsigned int state)
 /* Ext-GIC nIRQ/nFIQ is the only wakeup source in AFTR */
 static void exynos_set_wakeupmask(long mask)
 {
-	__raw_writel(mask, S5P_WAKEUP_MASK);
+	regmap_write(pmu_regmap, S5P_WAKEUP_MASK, mask);
 }
 
 static void exynos_cpu_set_boot_vector(long flags)
 {
-	__raw_writel(virt_to_phys(exynos_cpu_resume), EXYNOS_BOOT_VECTOR_ADDR);
-	__raw_writel(flags, EXYNOS_BOOT_VECTOR_FLAG);
+	if (samsung_rev() == EXYNOS4210_REV_1_0) {
+		__raw_writel(virt_to_phys(exynos_cpu_resume),
+				S5P_VA_SYSRAM + EXYNOS_BOOT_VECTOR_ADDR);
+		__raw_writel(flags, S5P_VA_SYSRAM + EXYNOS_BOOT_VECTOR_FLAG);
+	} else {
+		regmap_write(pmu_regmap, EXYNOS_BOOT_VECTOR_ADDR,
+				virt_to_phys(exynos_cpu_resume));
+		regmap_write(pmu_regmap, EXYNOS_BOOT_VECTOR_FLAG, flags);
+	}
 }
 
 void exynos_enter_aftr(void)
@@ -192,49 +202,51 @@ static void exynos_pm_prepare(void)
 	unsigned int tmp;
 
 	/* Set wake-up mask registers */
-	__raw_writel(exynos_get_eint_wake_mask(), S5P_EINT_WAKEUP_MASK);
-	__raw_writel(exynos_irqwake_intmask & ~(1 << 31), S5P_WAKEUP_MASK);
+	regmap_write(pmu_regmap, S5P_EINT_WAKEUP_MASK,
+			exynos_get_eint_wake_mask());
+	regmap_write(pmu_regmap, S5P_WAKEUP_MASK,
+			exynos_irqwake_intmask & ~(1 << 31));
 
 	s3c_pm_do_save(exynos_core_save, ARRAY_SIZE(exynos_core_save));
 
 	if (soc_is_exynos5250()) {
 		s3c_pm_do_save(exynos5_sys_save, ARRAY_SIZE(exynos5_sys_save));
 		/* Disable USE_RETENTION of JPEG_MEM_OPTION */
-		tmp = __raw_readl(EXYNOS5_JPEG_MEM_OPTION);
+		regmap_read(pmu_regmap, EXYNOS5_JPEG_MEM_OPTION, &tmp);
 		tmp &= ~EXYNOS5_OPTION_USE_RETENTION;
-		__raw_writel(tmp, EXYNOS5_JPEG_MEM_OPTION);
+		regmap_write(pmu_regmap, EXYNOS5_JPEG_MEM_OPTION, tmp);
 	}
 
 	/* Set value of power down register for sleep mode */
 
 	exynos_sys_powerdown_conf(SYS_SLEEP);
-	__raw_writel(S5P_CHECK_SLEEP, S5P_INFORM1);
+	regmap_write(pmu_regmap, S5P_INFORM1, S5P_CHECK_SLEEP);
 
 	/* ensure at least INFORM0 has the resume address */
 
-	__raw_writel(virt_to_phys(exynos_cpu_resume), S5P_INFORM0);
+	regmap_write(pmu_regmap, S5P_INFORM0, virt_to_phys(exynos_cpu_resume));
 }
 
 static void exynos_pm_central_suspend(void)
 {
-	unsigned long tmp;
+	unsigned int tmp;
 
 	/* Setting Central Sequence Register for power down mode */
-	tmp = __raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
+	regmap_read(pmu_regmap, S5P_CENTRAL_SEQ_CONFIGURATION, &tmp);
 	tmp &= ~S5P_CENTRAL_LOWPWR_CFG;
-	__raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
+	regmap_write(pmu_regmap, S5P_CENTRAL_SEQ_CONFIGURATION, tmp);
 }
 
 static int exynos_pm_suspend(void)
 {
-	unsigned long tmp;
+	unsigned int tmp;
 
 	exynos_pm_central_suspend();
 
 	/* Setting SEQ_OPTION register */
 
 	tmp = (S5P_USE_STANDBY_WFI0 | S5P_USE_STANDBY_WFE0);
-	__raw_writel(tmp, S5P_CENTRAL_SEQ_OPTION);
+	regmap_write(pmu_regmap, S5P_CENTRAL_SEQ_OPTION, tmp);
 
 	if (!soc_is_exynos5250())
 		exynos_cpu_save_register();
@@ -244,7 +256,7 @@ static int exynos_pm_suspend(void)
 
 static int exynos_pm_central_resume(void)
 {
-	unsigned long tmp;
+	unsigned int tmp;
 
 	/*
 	 * If PMU failed while entering sleep mode, WFI will be
@@ -252,12 +264,12 @@ static int exynos_pm_central_resume(void)
 	 * S5P_CENTRAL_LOWPWR_CFG bit will not be set automatically
 	 * in this situation.
 	 */
-	tmp = __raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
+	regmap_read(pmu_regmap, S5P_CENTRAL_SEQ_CONFIGURATION, &tmp);
 	if (!(tmp & S5P_CENTRAL_LOWPWR_CFG)) {
 		tmp |= S5P_CENTRAL_LOWPWR_CFG;
-		__raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
+		regmap_write(pmu_regmap, S5P_CENTRAL_SEQ_CONFIGURATION, tmp);
 		/* clear the wakeup state register */
-		__raw_writel(0x0, S5P_WAKEUP_STAT);
+		regmap_write(pmu_regmap, S5P_WAKEUP_STAT, 0x0);
 		/* No need to perform below restore code */
 		return -1;
 	}
@@ -275,13 +287,13 @@ static void exynos_pm_resume(void)
 
 	/* For release retention */
 
-	__raw_writel((1 << 28), S5P_PAD_RET_MAUDIO_OPTION);
-	__raw_writel((1 << 28), S5P_PAD_RET_GPIO_OPTION);
-	__raw_writel((1 << 28), S5P_PAD_RET_UART_OPTION);
-	__raw_writel((1 << 28), S5P_PAD_RET_MMCA_OPTION);
-	__raw_writel((1 << 28), S5P_PAD_RET_MMCB_OPTION);
-	__raw_writel((1 << 28), S5P_PAD_RET_EBIA_OPTION);
-	__raw_writel((1 << 28), S5P_PAD_RET_EBIB_OPTION);
+	regmap_write(pmu_regmap, S5P_PAD_RET_MAUDIO_OPTION, (1 << 28));
+	regmap_write(pmu_regmap, S5P_PAD_RET_GPIO_OPTION, (1 << 28));
+	regmap_write(pmu_regmap, S5P_PAD_RET_UART_OPTION, (1 << 28));
+	regmap_write(pmu_regmap, S5P_PAD_RET_MMCA_OPTION, (1 << 28));
+	regmap_write(pmu_regmap, S5P_PAD_RET_MMCB_OPTION, (1 << 28));
+	regmap_write(pmu_regmap, S5P_PAD_RET_EBIA_OPTION, (1 << 28));
+	regmap_write(pmu_regmap, S5P_PAD_RET_EBIB_OPTION, (1 << 28));
 
 	if (soc_is_exynos5250())
 		s3c_pm_do_restore(exynos5_sys_save,
@@ -295,7 +307,7 @@ static void exynos_pm_resume(void)
 early_wakeup:
 
 	/* Clear SLEEP mode set in INFORM1 */
-	__raw_writel(0x0, S5P_INFORM1);
+	regmap_write(pmu_regmap, S5P_INFORM1, 0x0);
 
 	return;
 }
@@ -338,8 +350,8 @@ static int exynos_suspend_enter(suspend_state_t state)
 
 	s3c_pm_restore_uarts();
 
-	S3C_PMDBG("%s: wakeup stat: %08x\n", __func__,
-			__raw_readl(S5P_WAKEUP_STAT));
+	regmap_read(pmu_regmap, S5P_WAKEUP_STAT, &ret);
+	S3C_PMDBG("%s: wakeup stat: %08x\n", __func__, ret);
 
 	s3c_pm_check_restore();
 
@@ -401,15 +413,16 @@ void __init exynos_pm_init(void)
 {
 	u32 tmp;
 
+	pmu_regmap = get_exynos_pmuregmap();
 	cpu_pm_register_notifier(&exynos_cpu_pm_notifier_block);
 
 	/* Platform-specific GIC callback */
 	gic_arch_extn.irq_set_wake = exynos_irq_set_wake;
 
 	/* All wakeup disable */
-	tmp = __raw_readl(S5P_WAKEUP_MASK);
+	regmap_read(pmu_regmap, S5P_WAKEUP_MASK, &tmp);
 	tmp |= ((0xFF << 8) | (0x1F << 1));
-	__raw_writel(tmp, S5P_WAKEUP_MASK);
+	regmap_write(pmu_regmap, S5P_WAKEUP_MASK, tmp);
 
 	register_syscore_ops(&exynos_pm_syscore_ops);
 	suspend_set_ops(&exynos_suspend_ops);
diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index 4c3453a..67116a5 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -11,6 +11,7 @@
 
 #include <linux/io.h>
 #include <linux/kernel.h>
+#include <linux/regmap.h>
 
 #include <plat/cpu.h>
 
@@ -18,6 +19,7 @@
 #include "regs-pmu.h"
 
 static const struct exynos_pmu_conf *exynos_pmu_config;
+static struct regmap *pmu_regmap;
 
 static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
 	/* { .reg = address, .val = { AFTR, LPA, SLEEP } */
@@ -317,7 +319,7 @@ static const struct exynos_pmu_conf exynos5250_pmu_config[] = {
 	{ PMU_TABLE_END,},
 };
 
-static void __iomem * const exynos5_list_both_cnt_feed[] = {
+static unsigned int const exynos5_list_both_cnt_feed[] = {
 	EXYNOS5_ARM_CORE0_OPTION,
 	EXYNOS5_ARM_CORE1_OPTION,
 	EXYNOS5_ARM_COMMON_OPTION,
@@ -331,7 +333,7 @@ static void __iomem * const exynos5_list_both_cnt_feed[] = {
 	EXYNOS5_TOP_PWR_SYSMEM_OPTION,
 };
 
-static void __iomem * const exynos5_list_diable_wfi_wfe[] = {
+static unsigned int const exynos5_list_diable_wfi_wfe[] = {
 	EXYNOS5_ARM_CORE1_OPTION,
 	EXYNOS5_FSYS_ARM_OPTION,
 	EXYNOS5_ISP_ARM_OPTION,
@@ -346,27 +348,28 @@ static void exynos5_init_pmu(void)
 	 * Enable both SC_FEEDBACK and SC_COUNTER
 	 */
 	for (i = 0 ; i < ARRAY_SIZE(exynos5_list_both_cnt_feed) ; i++) {
-		tmp = __raw_readl(exynos5_list_both_cnt_feed[i]);
+		regmap_read(pmu_regmap, exynos5_list_both_cnt_feed[i], &tmp);
 		tmp |= (EXYNOS5_USE_SC_FEEDBACK |
 			EXYNOS5_USE_SC_COUNTER);
-		__raw_writel(tmp, exynos5_list_both_cnt_feed[i]);
+		regmap_write(pmu_regmap, exynos5_list_both_cnt_feed[i], tmp);
 	}
 
 	/*
 	 * SKIP_DEACTIVATE_ACEACP_IN_PWDN_BITFIELD Enable
 	 */
-	tmp = __raw_readl(EXYNOS5_ARM_COMMON_OPTION);
+	regmap_read(pmu_regmap, EXYNOS5_ARM_COMMON_OPTION, &tmp);
 	tmp |= EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
-	__raw_writel(tmp, EXYNOS5_ARM_COMMON_OPTION);
+	regmap_write(pmu_regmap, EXYNOS5_ARM_COMMON_OPTION, tmp);
 
 	/*
 	 * Disable WFI/WFE on XXX_OPTION
 	 */
 	for (i = 0 ; i < ARRAY_SIZE(exynos5_list_diable_wfi_wfe) ; i++) {
-		tmp = __raw_readl(exynos5_list_diable_wfi_wfe[i]);
+		tmp = regmap_read(pmu_regmap, exynos5_list_diable_wfi_wfe[i],
+				&tmp);
 		tmp &= ~(EXYNOS5_OPTION_USE_STANDBYWFE |
 			 EXYNOS5_OPTION_USE_STANDBYWFI);
-		__raw_writel(tmp, exynos5_list_diable_wfi_wfe[i]);
+		regmap_write(pmu_regmap, exynos5_list_diable_wfi_wfe[i], tmp);
 	}
 }
 
@@ -377,14 +380,14 @@ void exynos_sys_powerdown_conf(enum sys_powerdown mode)
 	if (soc_is_exynos5250())
 		exynos5_init_pmu();
 
-	for (i = 0; (exynos_pmu_config[i].reg != PMU_TABLE_END) ; i++)
-		__raw_writel(exynos_pmu_config[i].val[mode],
-				exynos_pmu_config[i].reg);
+	for (i = 0; (exynos_pmu_config[i].offset != PMU_TABLE_END) ; i++)
+		regmap_write(pmu_regmap, exynos_pmu_config[i].offset,
+				exynos_pmu_config[i].val[mode]);
 
 	if (soc_is_exynos4412()) {
-		for (i = 0; exynos4412_pmu_config[i].reg != PMU_TABLE_END ; i++)
-			__raw_writel(exynos4412_pmu_config[i].val[mode],
-				exynos4412_pmu_config[i].reg);
+		for (i = 0; exynos4412_pmu_config[i].offset != PMU_TABLE_END; i++)
+			regmap_write(pmu_regmap, exynos4412_pmu_config[i].offset,
+					exynos4412_pmu_config[i].val[mode]);
 	}
 }
 
@@ -393,6 +396,7 @@ static int __init exynos_pmu_init(void)
 	unsigned int value;
 
 	exynos_pmu_config = exynos4210_pmu_config;
+	pmu_regmap = get_exynos_pmuregmap();
 
 	if (soc_is_exynos4210()) {
 		exynos_pmu_config = exynos4210_pmu_config;
@@ -405,13 +409,13 @@ static int __init exynos_pmu_init(void)
 		 * When SYS_WDTRESET is set, watchdog timer reset request
 		 * is ignored by power management unit.
 		 */
-		value = __raw_readl(EXYNOS5_AUTO_WDTRESET_DISABLE);
+		regmap_read(pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE, &value);
 		value &= ~EXYNOS5_SYS_WDTRESET;
-		__raw_writel(value, EXYNOS5_AUTO_WDTRESET_DISABLE);
+		regmap_write(pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE, value);
 
-		value = __raw_readl(EXYNOS5_MASK_WDTRESET_REQUEST);
+		regmap_read(pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST, &value);
 		value &= ~EXYNOS5_SYS_WDTRESET;
-		__raw_writel(value, EXYNOS5_MASK_WDTRESET_REQUEST);
+		regmap_write(pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST, value);
 
 		exynos_pmu_config = exynos5250_pmu_config;
 		pr_info("EXYNOS5250 PMU Initialize\n");
diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
index fd8a19d..a72b1bc 100644
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ b/arch/arm/mach-exynos/regs-pmu.h
@@ -14,288 +14,286 @@
 
 #include <mach/map.h>
 
-#define S5P_PMUREG(x)				(S5P_VA_PMU + (x))
-
-#define S5P_CENTRAL_SEQ_CONFIGURATION		S5P_PMUREG(0x0200)
+#define S5P_CENTRAL_SEQ_CONFIGURATION		0x0200
 
 #define S5P_CENTRAL_LOWPWR_CFG			(1 << 16)
 
-#define S5P_CENTRAL_SEQ_OPTION			S5P_PMUREG(0x0208)
+#define S5P_CENTRAL_SEQ_OPTION			0x0208
 
 #define S5P_USE_STANDBY_WFI0			(1 << 16)
 #define S5P_USE_STANDBY_WFE0			(1 << 24)
 
-#define EXYNOS_SWRESET				S5P_PMUREG(0x0400)
-#define EXYNOS5440_SWRESET			S5P_PMUREG(0x00C4)
+#define EXYNOS_SWRESET				0x0400
+#define EXYNOS5440_SWRESET			0x00C4
 
-#define S5P_WAKEUP_STAT				S5P_PMUREG(0x0600)
-#define S5P_EINT_WAKEUP_MASK			S5P_PMUREG(0x0604)
-#define S5P_WAKEUP_MASK				S5P_PMUREG(0x0608)
+#define S5P_WAKEUP_STAT				0x0600
+#define S5P_EINT_WAKEUP_MASK			0x0604
+#define S5P_WAKEUP_MASK				0x0608
 
-#define S5P_INFORM0				S5P_PMUREG(0x0800)
-#define S5P_INFORM1				S5P_PMUREG(0x0804)
-#define S5P_INFORM5				S5P_PMUREG(0x0814)
-#define S5P_INFORM6				S5P_PMUREG(0x0818)
-#define S5P_INFORM7				S5P_PMUREG(0x081C)
+#define S5P_INFORM0				0x0800
+#define S5P_INFORM1				0x0804
+#define S5P_INFORM5				0x0814
+#define S5P_INFORM6				0x0818
+#define S5P_INFORM7				0x081C
 
-#define S5P_ARM_CORE0_LOWPWR			S5P_PMUREG(0x1000)
-#define S5P_DIS_IRQ_CORE0			S5P_PMUREG(0x1004)
-#define S5P_DIS_IRQ_CENTRAL0			S5P_PMUREG(0x1008)
-#define S5P_ARM_CORE1_LOWPWR			S5P_PMUREG(0x1010)
-#define S5P_DIS_IRQ_CORE1			S5P_PMUREG(0x1014)
-#define S5P_DIS_IRQ_CENTRAL1			S5P_PMUREG(0x1018)
-#define S5P_ARM_COMMON_LOWPWR			S5P_PMUREG(0x1080)
-#define S5P_L2_0_LOWPWR				S5P_PMUREG(0x10C0)
-#define S5P_L2_1_LOWPWR				S5P_PMUREG(0x10C4)
-#define S5P_CMU_ACLKSTOP_LOWPWR			S5P_PMUREG(0x1100)
-#define S5P_CMU_SCLKSTOP_LOWPWR			S5P_PMUREG(0x1104)
-#define S5P_CMU_RESET_LOWPWR			S5P_PMUREG(0x110C)
-#define S5P_APLL_SYSCLK_LOWPWR			S5P_PMUREG(0x1120)
-#define S5P_MPLL_SYSCLK_LOWPWR			S5P_PMUREG(0x1124)
-#define S5P_VPLL_SYSCLK_LOWPWR			S5P_PMUREG(0x1128)
-#define S5P_EPLL_SYSCLK_LOWPWR			S5P_PMUREG(0x112C)
-#define S5P_CMU_CLKSTOP_GPS_ALIVE_LOWPWR	S5P_PMUREG(0x1138)
-#define S5P_CMU_RESET_GPSALIVE_LOWPWR		S5P_PMUREG(0x113C)
-#define S5P_CMU_CLKSTOP_CAM_LOWPWR		S5P_PMUREG(0x1140)
-#define S5P_CMU_CLKSTOP_TV_LOWPWR		S5P_PMUREG(0x1144)
-#define S5P_CMU_CLKSTOP_MFC_LOWPWR		S5P_PMUREG(0x1148)
-#define S5P_CMU_CLKSTOP_G3D_LOWPWR		S5P_PMUREG(0x114C)
-#define S5P_CMU_CLKSTOP_LCD0_LOWPWR		S5P_PMUREG(0x1150)
-#define S5P_CMU_CLKSTOP_MAUDIO_LOWPWR		S5P_PMUREG(0x1158)
-#define S5P_CMU_CLKSTOP_GPS_LOWPWR		S5P_PMUREG(0x115C)
-#define S5P_CMU_RESET_CAM_LOWPWR		S5P_PMUREG(0x1160)
-#define S5P_CMU_RESET_TV_LOWPWR			S5P_PMUREG(0x1164)
-#define S5P_CMU_RESET_MFC_LOWPWR		S5P_PMUREG(0x1168)
-#define S5P_CMU_RESET_G3D_LOWPWR		S5P_PMUREG(0x116C)
-#define S5P_CMU_RESET_LCD0_LOWPWR		S5P_PMUREG(0x1170)
-#define S5P_CMU_RESET_MAUDIO_LOWPWR		S5P_PMUREG(0x1178)
-#define S5P_CMU_RESET_GPS_LOWPWR		S5P_PMUREG(0x117C)
-#define S5P_TOP_BUS_LOWPWR			S5P_PMUREG(0x1180)
-#define S5P_TOP_RETENTION_LOWPWR		S5P_PMUREG(0x1184)
-#define S5P_TOP_PWR_LOWPWR			S5P_PMUREG(0x1188)
-#define S5P_LOGIC_RESET_LOWPWR			S5P_PMUREG(0x11A0)
-#define S5P_ONENAND_MEM_LOWPWR			S5P_PMUREG(0x11C0)
-#define S5P_G2D_ACP_MEM_LOWPWR			S5P_PMUREG(0x11C8)
-#define S5P_USBOTG_MEM_LOWPWR			S5P_PMUREG(0x11CC)
-#define S5P_HSMMC_MEM_LOWPWR			S5P_PMUREG(0x11D0)
-#define S5P_CSSYS_MEM_LOWPWR			S5P_PMUREG(0x11D4)
-#define S5P_SECSS_MEM_LOWPWR			S5P_PMUREG(0x11D8)
-#define S5P_PAD_RETENTION_DRAM_LOWPWR		S5P_PMUREG(0x1200)
-#define S5P_PAD_RETENTION_MAUDIO_LOWPWR		S5P_PMUREG(0x1204)
-#define S5P_PAD_RETENTION_GPIO_LOWPWR		S5P_PMUREG(0x1220)
-#define S5P_PAD_RETENTION_UART_LOWPWR		S5P_PMUREG(0x1224)
-#define S5P_PAD_RETENTION_MMCA_LOWPWR		S5P_PMUREG(0x1228)
-#define S5P_PAD_RETENTION_MMCB_LOWPWR		S5P_PMUREG(0x122C)
-#define S5P_PAD_RETENTION_EBIA_LOWPWR		S5P_PMUREG(0x1230)
-#define S5P_PAD_RETENTION_EBIB_LOWPWR		S5P_PMUREG(0x1234)
-#define S5P_PAD_RETENTION_ISOLATION_LOWPWR	S5P_PMUREG(0x1240)
-#define S5P_PAD_RETENTION_ALV_SEL_LOWPWR	S5P_PMUREG(0x1260)
-#define S5P_XUSBXTI_LOWPWR			S5P_PMUREG(0x1280)
-#define S5P_XXTI_LOWPWR				S5P_PMUREG(0x1284)
-#define S5P_EXT_REGULATOR_LOWPWR		S5P_PMUREG(0x12C0)
-#define S5P_GPIO_MODE_LOWPWR			S5P_PMUREG(0x1300)
-#define S5P_GPIO_MODE_MAUDIO_LOWPWR		S5P_PMUREG(0x1340)
-#define S5P_CAM_LOWPWR				S5P_PMUREG(0x1380)
-#define S5P_TV_LOWPWR				S5P_PMUREG(0x1384)
-#define S5P_MFC_LOWPWR				S5P_PMUREG(0x1388)
-#define S5P_G3D_LOWPWR				S5P_PMUREG(0x138C)
-#define S5P_LCD0_LOWPWR				S5P_PMUREG(0x1390)
-#define S5P_MAUDIO_LOWPWR			S5P_PMUREG(0x1398)
-#define S5P_GPS_LOWPWR				S5P_PMUREG(0x139C)
-#define S5P_GPS_ALIVE_LOWPWR			S5P_PMUREG(0x13A0)
+#define S5P_ARM_CORE0_LOWPWR			0x1000
+#define S5P_DIS_IRQ_CORE0			0x1004
+#define S5P_DIS_IRQ_CENTRAL0			0x1008
+#define S5P_ARM_CORE1_LOWPWR			0x1010
+#define S5P_DIS_IRQ_CORE1			0x1014
+#define S5P_DIS_IRQ_CENTRAL1			0x1018
+#define S5P_ARM_COMMON_LOWPWR			0x1080
+#define S5P_L2_0_LOWPWR				0x10C0
+#define S5P_L2_1_LOWPWR				0x10C4
+#define S5P_CMU_ACLKSTOP_LOWPWR			0x1100
+#define S5P_CMU_SCLKSTOP_LOWPWR			0x1104
+#define S5P_CMU_RESET_LOWPWR			0x110C
+#define S5P_APLL_SYSCLK_LOWPWR			0x1120
+#define S5P_MPLL_SYSCLK_LOWPWR			0x1124
+#define S5P_VPLL_SYSCLK_LOWPWR			0x1128
+#define S5P_EPLL_SYSCLK_LOWPWR			0x112C
+#define S5P_CMU_CLKSTOP_GPS_ALIVE_LOWPWR	0x1138
+#define S5P_CMU_RESET_GPSALIVE_LOWPWR		0x113C
+#define S5P_CMU_CLKSTOP_CAM_LOWPWR		0x1140
+#define S5P_CMU_CLKSTOP_TV_LOWPWR		0x1144
+#define S5P_CMU_CLKSTOP_MFC_LOWPWR		0x1148
+#define S5P_CMU_CLKSTOP_G3D_LOWPWR		0x114C
+#define S5P_CMU_CLKSTOP_LCD0_LOWPWR		0x1150
+#define S5P_CMU_CLKSTOP_MAUDIO_LOWPWR		0x1158
+#define S5P_CMU_CLKSTOP_GPS_LOWPWR		0x115C
+#define S5P_CMU_RESET_CAM_LOWPWR		0x1160
+#define S5P_CMU_RESET_TV_LOWPWR			0x1164
+#define S5P_CMU_RESET_MFC_LOWPWR		0x1168
+#define S5P_CMU_RESET_G3D_LOWPWR		0x116C
+#define S5P_CMU_RESET_LCD0_LOWPWR		0x1170
+#define S5P_CMU_RESET_MAUDIO_LOWPWR		0x1178
+#define S5P_CMU_RESET_GPS_LOWPWR		0x117C
+#define S5P_TOP_BUS_LOWPWR			0x1180
+#define S5P_TOP_RETENTION_LOWPWR		0x1184
+#define S5P_TOP_PWR_LOWPWR			0x1188
+#define S5P_LOGIC_RESET_LOWPWR			0x11A0
+#define S5P_ONENAND_MEM_LOWPWR			0x11C0
+#define S5P_G2D_ACP_MEM_LOWPWR			0x11C8
+#define S5P_USBOTG_MEM_LOWPWR			0x11CC
+#define S5P_HSMMC_MEM_LOWPWR			0x11D0
+#define S5P_CSSYS_MEM_LOWPWR			0x11D4
+#define S5P_SECSS_MEM_LOWPWR			0x11D8
+#define S5P_PAD_RETENTION_DRAM_LOWPWR		0x1200
+#define S5P_PAD_RETENTION_MAUDIO_LOWPWR		0x1204
+#define S5P_PAD_RETENTION_GPIO_LOWPWR		0x1220
+#define S5P_PAD_RETENTION_UART_LOWPWR		0x1224
+#define S5P_PAD_RETENTION_MMCA_LOWPWR		0x1228
+#define S5P_PAD_RETENTION_MMCB_LOWPWR		0x122C
+#define S5P_PAD_RETENTION_EBIA_LOWPWR		0x1230
+#define S5P_PAD_RETENTION_EBIB_LOWPWR		0x1234
+#define S5P_PAD_RETENTION_ISOLATION_LOWPWR	0x1240
+#define S5P_PAD_RETENTION_ALV_SEL_LOWPWR	0x1260
+#define S5P_XUSBXTI_LOWPWR			0x1280
+#define S5P_XXTI_LOWPWR				0x1284
+#define S5P_EXT_REGULATOR_LOWPWR		0x12C0
+#define S5P_GPIO_MODE_LOWPWR			0x1300
+#define S5P_GPIO_MODE_MAUDIO_LOWPWR		0x1340
+#define S5P_CAM_LOWPWR				0x1380
+#define S5P_TV_LOWPWR				0x1384
+#define S5P_MFC_LOWPWR				0x1388
+#define S5P_G3D_LOWPWR				0x138C
+#define S5P_LCD0_LOWPWR				0x1390
+#define S5P_MAUDIO_LOWPWR			0x1398
+#define S5P_GPS_LOWPWR				0x139C
+#define S5P_GPS_ALIVE_LOWPWR			0x13A0
 
-#define S5P_ARM_CORE1_CONFIGURATION		S5P_PMUREG(0x2080)
-#define S5P_ARM_CORE1_STATUS			S5P_PMUREG(0x2084)
+#define S5P_ARM_CORE1_CONFIGURATION		0x2080
+#define S5P_ARM_CORE1_STATUS			0x2084
 
-#define S5P_PAD_RET_MAUDIO_OPTION		S5P_PMUREG(0x3028)
-#define S5P_PAD_RET_GPIO_OPTION			S5P_PMUREG(0x3108)
-#define S5P_PAD_RET_UART_OPTION			S5P_PMUREG(0x3128)
-#define S5P_PAD_RET_MMCA_OPTION			S5P_PMUREG(0x3148)
-#define S5P_PAD_RET_MMCB_OPTION			S5P_PMUREG(0x3168)
-#define S5P_PAD_RET_EBIA_OPTION			S5P_PMUREG(0x3188)
-#define S5P_PAD_RET_EBIB_OPTION			S5P_PMUREG(0x31A8)
+#define S5P_PAD_RET_MAUDIO_OPTION		0x3028
+#define S5P_PAD_RET_GPIO_OPTION			0x3108
+#define S5P_PAD_RET_UART_OPTION			0x3128
+#define S5P_PAD_RET_MMCA_OPTION			0x3148
+#define S5P_PAD_RET_MMCB_OPTION			0x3168
+#define S5P_PAD_RET_EBIA_OPTION			0x3188
+#define S5P_PAD_RET_EBIB_OPTION			0x31A8
 
 #define S5P_CORE_LOCAL_PWR_EN			0x3
 
 /* Only for EXYNOS4210 */
-#define S5P_CMU_CLKSTOP_LCD1_LOWPWR	S5P_PMUREG(0x1154)
-#define S5P_CMU_RESET_LCD1_LOWPWR	S5P_PMUREG(0x1174)
-#define S5P_MODIMIF_MEM_LOWPWR		S5P_PMUREG(0x11C4)
-#define S5P_PCIE_MEM_LOWPWR		S5P_PMUREG(0x11E0)
-#define S5P_SATA_MEM_LOWPWR		S5P_PMUREG(0x11E4)
-#define S5P_LCD1_LOWPWR			S5P_PMUREG(0x1394)
+#define S5P_CMU_CLKSTOP_LCD1_LOWPWR	0x1154
+#define S5P_CMU_RESET_LCD1_LOWPWR	0x1174
+#define S5P_MODIMIF_MEM_LOWPWR		0x11C4
+#define S5P_PCIE_MEM_LOWPWR		0x11E0
+#define S5P_SATA_MEM_LOWPWR		0x11E4
+#define S5P_LCD1_LOWPWR			0x1394
 
 /* Only for EXYNOS4x12 */
-#define S5P_ISP_ARM_LOWPWR			S5P_PMUREG(0x1050)
-#define S5P_DIS_IRQ_ISP_ARM_LOCAL_LOWPWR	S5P_PMUREG(0x1054)
-#define S5P_DIS_IRQ_ISP_ARM_CENTRAL_LOWPWR	S5P_PMUREG(0x1058)
-#define S5P_CMU_ACLKSTOP_COREBLK_LOWPWR		S5P_PMUREG(0x1110)
-#define S5P_CMU_SCLKSTOP_COREBLK_LOWPWR		S5P_PMUREG(0x1114)
-#define S5P_CMU_RESET_COREBLK_LOWPWR		S5P_PMUREG(0x111C)
-#define S5P_MPLLUSER_SYSCLK_LOWPWR		S5P_PMUREG(0x1130)
-#define S5P_CMU_CLKSTOP_ISP_LOWPWR		S5P_PMUREG(0x1154)
-#define S5P_CMU_RESET_ISP_LOWPWR		S5P_PMUREG(0x1174)
-#define S5P_TOP_BUS_COREBLK_LOWPWR		S5P_PMUREG(0x1190)
-#define S5P_TOP_RETENTION_COREBLK_LOWPWR	S5P_PMUREG(0x1194)
-#define S5P_TOP_PWR_COREBLK_LOWPWR		S5P_PMUREG(0x1198)
-#define S5P_OSCCLK_GATE_LOWPWR			S5P_PMUREG(0x11A4)
-#define S5P_LOGIC_RESET_COREBLK_LOWPWR		S5P_PMUREG(0x11B0)
-#define S5P_OSCCLK_GATE_COREBLK_LOWPWR		S5P_PMUREG(0x11B4)
-#define S5P_HSI_MEM_LOWPWR			S5P_PMUREG(0x11C4)
-#define S5P_ROTATOR_MEM_LOWPWR			S5P_PMUREG(0x11DC)
-#define S5P_PAD_RETENTION_GPIO_COREBLK_LOWPWR	S5P_PMUREG(0x123C)
-#define S5P_PAD_ISOLATION_COREBLK_LOWPWR	S5P_PMUREG(0x1250)
-#define S5P_GPIO_MODE_COREBLK_LOWPWR		S5P_PMUREG(0x1320)
-#define S5P_TOP_ASB_RESET_LOWPWR		S5P_PMUREG(0x1344)
-#define S5P_TOP_ASB_ISOLATION_LOWPWR		S5P_PMUREG(0x1348)
-#define S5P_ISP_LOWPWR				S5P_PMUREG(0x1394)
-#define S5P_DRAM_FREQ_DOWN_LOWPWR		S5P_PMUREG(0x13B0)
-#define S5P_DDRPHY_DLLOFF_LOWPWR		S5P_PMUREG(0x13B4)
-#define S5P_CMU_SYSCLK_ISP_LOWPWR		S5P_PMUREG(0x13B8)
-#define S5P_CMU_SYSCLK_GPS_LOWPWR		S5P_PMUREG(0x13BC)
-#define S5P_LPDDR_PHY_DLL_LOCK_LOWPWR		S5P_PMUREG(0x13C0)
+#define S5P_ISP_ARM_LOWPWR			0x1050
+#define S5P_DIS_IRQ_ISP_ARM_LOCAL_LOWPWR	0x1054
+#define S5P_DIS_IRQ_ISP_ARM_CENTRAL_LOWPWR	0x1058
+#define S5P_CMU_ACLKSTOP_COREBLK_LOWPWR		0x1110
+#define S5P_CMU_SCLKSTOP_COREBLK_LOWPWR		0x1114
+#define S5P_CMU_RESET_COREBLK_LOWPWR		0x111C
+#define S5P_MPLLUSER_SYSCLK_LOWPWR		0x1130
+#define S5P_CMU_CLKSTOP_ISP_LOWPWR		0x1154
+#define S5P_CMU_RESET_ISP_LOWPWR		0x1174
+#define S5P_TOP_BUS_COREBLK_LOWPWR		0x1190
+#define S5P_TOP_RETENTION_COREBLK_LOWPWR	0x1194
+#define S5P_TOP_PWR_COREBLK_LOWPWR		0x1198
+#define S5P_OSCCLK_GATE_LOWPWR			0x11A4
+#define S5P_LOGIC_RESET_COREBLK_LOWPWR		0x11B0
+#define S5P_OSCCLK_GATE_COREBLK_LOWPWR		0x11B4
+#define S5P_HSI_MEM_LOWPWR			0x11C4
+#define S5P_ROTATOR_MEM_LOWPWR			0x11DC
+#define S5P_PAD_RETENTION_GPIO_COREBLK_LOWPWR	0x123C
+#define S5P_PAD_ISOLATION_COREBLK_LOWPWR	0x1250
+#define S5P_GPIO_MODE_COREBLK_LOWPWR		0x1320
+#define S5P_TOP_ASB_RESET_LOWPWR		0x1344
+#define S5P_TOP_ASB_ISOLATION_LOWPWR		0x1348
+#define S5P_ISP_LOWPWR				0x1394
+#define S5P_DRAM_FREQ_DOWN_LOWPWR		0x13B0
+#define S5P_DDRPHY_DLLOFF_LOWPWR		0x13B4
+#define S5P_CMU_SYSCLK_ISP_LOWPWR		0x13B8
+#define S5P_CMU_SYSCLK_GPS_LOWPWR		0x13BC
+#define S5P_LPDDR_PHY_DLL_LOCK_LOWPWR		0x13C0
 
-#define S5P_ARM_L2_0_OPTION			S5P_PMUREG(0x2608)
-#define S5P_ARM_L2_1_OPTION			S5P_PMUREG(0x2628)
-#define S5P_ONENAND_MEM_OPTION			S5P_PMUREG(0x2E08)
-#define S5P_HSI_MEM_OPTION			S5P_PMUREG(0x2E28)
-#define S5P_G2D_ACP_MEM_OPTION			S5P_PMUREG(0x2E48)
-#define S5P_USBOTG_MEM_OPTION			S5P_PMUREG(0x2E68)
-#define S5P_HSMMC_MEM_OPTION			S5P_PMUREG(0x2E88)
-#define S5P_CSSYS_MEM_OPTION			S5P_PMUREG(0x2EA8)
-#define S5P_SECSS_MEM_OPTION			S5P_PMUREG(0x2EC8)
-#define S5P_ROTATOR_MEM_OPTION			S5P_PMUREG(0x2F48)
+#define S5P_ARM_L2_0_OPTION			0x2608
+#define S5P_ARM_L2_1_OPTION			0x2628
+#define S5P_ONENAND_MEM_OPTION			0x2E08
+#define S5P_HSI_MEM_OPTION			0x2E28
+#define S5P_G2D_ACP_MEM_OPTION			0x2E48
+#define S5P_USBOTG_MEM_OPTION			0x2E68
+#define S5P_HSMMC_MEM_OPTION			0x2E88
+#define S5P_CSSYS_MEM_OPTION			0x2EA8
+#define S5P_SECSS_MEM_OPTION			0x2EC8
+#define S5P_ROTATOR_MEM_OPTION			0x2F48
 
 /* Only for EXYNOS4412 */
-#define S5P_ARM_CORE2_LOWPWR			S5P_PMUREG(0x1020)
-#define S5P_DIS_IRQ_CORE2			S5P_PMUREG(0x1024)
-#define S5P_DIS_IRQ_CENTRAL2			S5P_PMUREG(0x1028)
-#define S5P_ARM_CORE3_LOWPWR			S5P_PMUREG(0x1030)
-#define S5P_DIS_IRQ_CORE3			S5P_PMUREG(0x1034)
-#define S5P_DIS_IRQ_CENTRAL3			S5P_PMUREG(0x1038)
+#define S5P_ARM_CORE2_LOWPWR			0x1020
+#define S5P_DIS_IRQ_CORE2			0x1024
+#define S5P_DIS_IRQ_CENTRAL2			0x1028
+#define S5P_ARM_CORE3_LOWPWR			0x1030
+#define S5P_DIS_IRQ_CORE3			0x1034
+#define S5P_DIS_IRQ_CENTRAL3			0x1038
 
 /* For EXYNOS5 */
 
-#define EXYNOS5_AUTO_WDTRESET_DISABLE				S5P_PMUREG(0x0408)
-#define EXYNOS5_MASK_WDTRESET_REQUEST				S5P_PMUREG(0x040C)
+#define EXYNOS5_AUTO_WDTRESET_DISABLE				0x0408
+#define EXYNOS5_MASK_WDTRESET_REQUEST				0x040C
 
 #define EXYNOS5_SYS_WDTRESET					(1 << 20)
 
-#define EXYNOS5_ARM_CORE0_SYS_PWR_REG				S5P_PMUREG(0x1000)
-#define EXYNOS5_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG		S5P_PMUREG(0x1004)
-#define EXYNOS5_DIS_IRQ_ARM_CORE0_CENTRAL_SYS_PWR_REG		S5P_PMUREG(0x1008)
-#define EXYNOS5_ARM_CORE1_SYS_PWR_REG				S5P_PMUREG(0x1010)
-#define EXYNOS5_DIS_IRQ_ARM_CORE1_LOCAL_SYS_PWR_REG		S5P_PMUREG(0x1014)
-#define EXYNOS5_DIS_IRQ_ARM_CORE1_CENTRAL_SYS_PWR_REG		S5P_PMUREG(0x1018)
-#define EXYNOS5_FSYS_ARM_SYS_PWR_REG				S5P_PMUREG(0x1040)
-#define EXYNOS5_DIS_IRQ_FSYS_ARM_CENTRAL_SYS_PWR_REG		S5P_PMUREG(0x1048)
-#define EXYNOS5_ISP_ARM_SYS_PWR_REG				S5P_PMUREG(0x1050)
-#define EXYNOS5_DIS_IRQ_ISP_ARM_LOCAL_SYS_PWR_REG		S5P_PMUREG(0x1054)
-#define EXYNOS5_DIS_IRQ_ISP_ARM_CENTRAL_SYS_PWR_REG		S5P_PMUREG(0x1058)
-#define EXYNOS5_ARM_COMMON_SYS_PWR_REG				S5P_PMUREG(0x1080)
-#define EXYNOS5_ARM_L2_SYS_PWR_REG				S5P_PMUREG(0x10C0)
-#define EXYNOS5_CMU_ACLKSTOP_SYS_PWR_REG			S5P_PMUREG(0x1100)
-#define EXYNOS5_CMU_SCLKSTOP_SYS_PWR_REG			S5P_PMUREG(0x1104)
-#define EXYNOS5_CMU_RESET_SYS_PWR_REG				S5P_PMUREG(0x110C)
-#define EXYNOS5_CMU_ACLKSTOP_SYSMEM_SYS_PWR_REG			S5P_PMUREG(0x1120)
-#define EXYNOS5_CMU_SCLKSTOP_SYSMEM_SYS_PWR_REG			S5P_PMUREG(0x1124)
-#define EXYNOS5_CMU_RESET_SYSMEM_SYS_PWR_REG			S5P_PMUREG(0x112C)
-#define EXYNOS5_DRAM_FREQ_DOWN_SYS_PWR_REG			S5P_PMUREG(0x1130)
-#define EXYNOS5_DDRPHY_DLLOFF_SYS_PWR_REG			S5P_PMUREG(0x1134)
-#define EXYNOS5_DDRPHY_DLLLOCK_SYS_PWR_REG			S5P_PMUREG(0x1138)
-#define EXYNOS5_APLL_SYSCLK_SYS_PWR_REG				S5P_PMUREG(0x1140)
-#define EXYNOS5_MPLL_SYSCLK_SYS_PWR_REG				S5P_PMUREG(0x1144)
-#define EXYNOS5_VPLL_SYSCLK_SYS_PWR_REG				S5P_PMUREG(0x1148)
-#define EXYNOS5_EPLL_SYSCLK_SYS_PWR_REG				S5P_PMUREG(0x114C)
-#define EXYNOS5_BPLL_SYSCLK_SYS_PWR_REG				S5P_PMUREG(0x1150)
-#define EXYNOS5_CPLL_SYSCLK_SYS_PWR_REG				S5P_PMUREG(0x1154)
-#define EXYNOS5_MPLLUSER_SYSCLK_SYS_PWR_REG			S5P_PMUREG(0x1164)
-#define EXYNOS5_BPLLUSER_SYSCLK_SYS_PWR_REG			S5P_PMUREG(0x1170)
-#define EXYNOS5_TOP_BUS_SYS_PWR_REG				S5P_PMUREG(0x1180)
-#define EXYNOS5_TOP_RETENTION_SYS_PWR_REG			S5P_PMUREG(0x1184)
-#define EXYNOS5_TOP_PWR_SYS_PWR_REG				S5P_PMUREG(0x1188)
-#define EXYNOS5_TOP_BUS_SYSMEM_SYS_PWR_REG			S5P_PMUREG(0x1190)
-#define EXYNOS5_TOP_RETENTION_SYSMEM_SYS_PWR_REG		S5P_PMUREG(0x1194)
-#define EXYNOS5_TOP_PWR_SYSMEM_SYS_PWR_REG			S5P_PMUREG(0x1198)
-#define EXYNOS5_LOGIC_RESET_SYS_PWR_REG				S5P_PMUREG(0x11A0)
-#define EXYNOS5_OSCCLK_GATE_SYS_PWR_REG				S5P_PMUREG(0x11A4)
-#define EXYNOS5_LOGIC_RESET_SYSMEM_SYS_PWR_REG			S5P_PMUREG(0x11B0)
-#define EXYNOS5_OSCCLK_GATE_SYSMEM_SYS_PWR_REG			S5P_PMUREG(0x11B4)
-#define EXYNOS5_USBOTG_MEM_SYS_PWR_REG				S5P_PMUREG(0x11C0)
-#define EXYNOS5_G2D_MEM_SYS_PWR_REG				S5P_PMUREG(0x11C8)
-#define EXYNOS5_USBDRD_MEM_SYS_PWR_REG				S5P_PMUREG(0x11CC)
-#define EXYNOS5_SDMMC_MEM_SYS_PWR_REG				S5P_PMUREG(0x11D0)
-#define EXYNOS5_CSSYS_MEM_SYS_PWR_REG				S5P_PMUREG(0x11D4)
-#define EXYNOS5_SECSS_MEM_SYS_PWR_REG				S5P_PMUREG(0x11D8)
-#define EXYNOS5_ROTATOR_MEM_SYS_PWR_REG				S5P_PMUREG(0x11DC)
-#define EXYNOS5_INTRAM_MEM_SYS_PWR_REG				S5P_PMUREG(0x11E0)
-#define EXYNOS5_INTROM_MEM_SYS_PWR_REG				S5P_PMUREG(0x11E4)
-#define EXYNOS5_JPEG_MEM_SYS_PWR_REG				S5P_PMUREG(0x11E8)
-#define EXYNOS5_HSI_MEM_SYS_PWR_REG				S5P_PMUREG(0x11EC)
-#define EXYNOS5_MCUIOP_MEM_SYS_PWR_REG				S5P_PMUREG(0x11F4)
-#define EXYNOS5_SATA_MEM_SYS_PWR_REG				S5P_PMUREG(0x11FC)
-#define EXYNOS5_PAD_RETENTION_DRAM_SYS_PWR_REG			S5P_PMUREG(0x1200)
-#define EXYNOS5_PAD_RETENTION_MAU_SYS_PWR_REG			S5P_PMUREG(0x1204)
-#define EXYNOS5_PAD_RETENTION_EFNAND_SYS_PWR_REG		S5P_PMUREG(0x1208)
-#define EXYNOS5_PAD_RETENTION_GPIO_SYS_PWR_REG			S5P_PMUREG(0x1220)
-#define EXYNOS5_PAD_RETENTION_UART_SYS_PWR_REG			S5P_PMUREG(0x1224)
-#define EXYNOS5_PAD_RETENTION_MMCA_SYS_PWR_REG			S5P_PMUREG(0x1228)
-#define EXYNOS5_PAD_RETENTION_MMCB_SYS_PWR_REG			S5P_PMUREG(0x122C)
-#define EXYNOS5_PAD_RETENTION_EBIA_SYS_PWR_REG			S5P_PMUREG(0x1230)
-#define EXYNOS5_PAD_RETENTION_EBIB_SYS_PWR_REG			S5P_PMUREG(0x1234)
-#define EXYNOS5_PAD_RETENTION_SPI_SYS_PWR_REG			S5P_PMUREG(0x1238)
-#define EXYNOS5_PAD_RETENTION_GPIO_SYSMEM_SYS_PWR_REG		S5P_PMUREG(0x123C)
-#define EXYNOS5_PAD_ISOLATION_SYS_PWR_REG			S5P_PMUREG(0x1240)
-#define EXYNOS5_PAD_ISOLATION_SYSMEM_SYS_PWR_REG		S5P_PMUREG(0x1250)
-#define EXYNOS5_PAD_ALV_SEL_SYS_PWR_REG				S5P_PMUREG(0x1260)
-#define EXYNOS5_XUSBXTI_SYS_PWR_REG				S5P_PMUREG(0x1280)
-#define EXYNOS5_XXTI_SYS_PWR_REG				S5P_PMUREG(0x1284)
-#define EXYNOS5_EXT_REGULATOR_SYS_PWR_REG			S5P_PMUREG(0x12C0)
-#define EXYNOS5_GPIO_MODE_SYS_PWR_REG				S5P_PMUREG(0x1300)
-#define EXYNOS5_GPIO_MODE_SYSMEM_SYS_PWR_REG			S5P_PMUREG(0x1320)
-#define EXYNOS5_GPIO_MODE_MAU_SYS_PWR_REG			S5P_PMUREG(0x1340)
-#define EXYNOS5_TOP_ASB_RESET_SYS_PWR_REG			S5P_PMUREG(0x1344)
-#define EXYNOS5_TOP_ASB_ISOLATION_SYS_PWR_REG			S5P_PMUREG(0x1348)
-#define EXYNOS5_GSCL_SYS_PWR_REG				S5P_PMUREG(0x1400)
-#define EXYNOS5_ISP_SYS_PWR_REG					S5P_PMUREG(0x1404)
-#define EXYNOS5_MFC_SYS_PWR_REG					S5P_PMUREG(0x1408)
-#define EXYNOS5_G3D_SYS_PWR_REG					S5P_PMUREG(0x140C)
-#define EXYNOS5_DISP1_SYS_PWR_REG				S5P_PMUREG(0x1414)
-#define EXYNOS5_MAU_SYS_PWR_REG					S5P_PMUREG(0x1418)
-#define EXYNOS5_CMU_CLKSTOP_GSCL_SYS_PWR_REG			S5P_PMUREG(0x1480)
-#define EXYNOS5_CMU_CLKSTOP_ISP_SYS_PWR_REG			S5P_PMUREG(0x1484)
-#define EXYNOS5_CMU_CLKSTOP_MFC_SYS_PWR_REG			S5P_PMUREG(0x1488)
-#define EXYNOS5_CMU_CLKSTOP_G3D_SYS_PWR_REG			S5P_PMUREG(0x148C)
-#define EXYNOS5_CMU_CLKSTOP_DISP1_SYS_PWR_REG			S5P_PMUREG(0x1494)
-#define EXYNOS5_CMU_CLKSTOP_MAU_SYS_PWR_REG			S5P_PMUREG(0x1498)
-#define EXYNOS5_CMU_SYSCLK_GSCL_SYS_PWR_REG			S5P_PMUREG(0x14C0)
-#define EXYNOS5_CMU_SYSCLK_ISP_SYS_PWR_REG			S5P_PMUREG(0x14C4)
-#define EXYNOS5_CMU_SYSCLK_MFC_SYS_PWR_REG			S5P_PMUREG(0x14C8)
-#define EXYNOS5_CMU_SYSCLK_G3D_SYS_PWR_REG			S5P_PMUREG(0x14CC)
-#define EXYNOS5_CMU_SYSCLK_DISP1_SYS_PWR_REG			S5P_PMUREG(0x14D4)
-#define EXYNOS5_CMU_SYSCLK_MAU_SYS_PWR_REG			S5P_PMUREG(0x14D8)
-#define EXYNOS5_CMU_RESET_GSCL_SYS_PWR_REG			S5P_PMUREG(0x1580)
-#define EXYNOS5_CMU_RESET_ISP_SYS_PWR_REG			S5P_PMUREG(0x1584)
-#define EXYNOS5_CMU_RESET_MFC_SYS_PWR_REG			S5P_PMUREG(0x1588)
-#define EXYNOS5_CMU_RESET_G3D_SYS_PWR_REG			S5P_PMUREG(0x158C)
-#define EXYNOS5_CMU_RESET_DISP1_SYS_PWR_REG			S5P_PMUREG(0x1594)
-#define EXYNOS5_CMU_RESET_MAU_SYS_PWR_REG			S5P_PMUREG(0x1598)
+#define EXYNOS5_ARM_CORE0_SYS_PWR_REG				0x1000
+#define EXYNOS5_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG		0x1004
+#define EXYNOS5_DIS_IRQ_ARM_CORE0_CENTRAL_SYS_PWR_REG		0x1008
+#define EXYNOS5_ARM_CORE1_SYS_PWR_REG				0x1010
+#define EXYNOS5_DIS_IRQ_ARM_CORE1_LOCAL_SYS_PWR_REG		0x1014
+#define EXYNOS5_DIS_IRQ_ARM_CORE1_CENTRAL_SYS_PWR_REG		0x1018
+#define EXYNOS5_FSYS_ARM_SYS_PWR_REG				0x1040
+#define EXYNOS5_DIS_IRQ_FSYS_ARM_CENTRAL_SYS_PWR_REG		0x1048
+#define EXYNOS5_ISP_ARM_SYS_PWR_REG				0x1050
+#define EXYNOS5_DIS_IRQ_ISP_ARM_LOCAL_SYS_PWR_REG		0x1054
+#define EXYNOS5_DIS_IRQ_ISP_ARM_CENTRAL_SYS_PWR_REG		0x1058
+#define EXYNOS5_ARM_COMMON_SYS_PWR_REG				0x1080
+#define EXYNOS5_ARM_L2_SYS_PWR_REG				0x10C0
+#define EXYNOS5_CMU_ACLKSTOP_SYS_PWR_REG			0x1100
+#define EXYNOS5_CMU_SCLKSTOP_SYS_PWR_REG			0x1104
+#define EXYNOS5_CMU_RESET_SYS_PWR_REG				0x110C
+#define EXYNOS5_CMU_ACLKSTOP_SYSMEM_SYS_PWR_REG			0x1120
+#define EXYNOS5_CMU_SCLKSTOP_SYSMEM_SYS_PWR_REG			0x1124
+#define EXYNOS5_CMU_RESET_SYSMEM_SYS_PWR_REG			0x112C
+#define EXYNOS5_DRAM_FREQ_DOWN_SYS_PWR_REG			0x1130
+#define EXYNOS5_DDRPHY_DLLOFF_SYS_PWR_REG			0x1134
+#define EXYNOS5_DDRPHY_DLLLOCK_SYS_PWR_REG			0x1138
+#define EXYNOS5_APLL_SYSCLK_SYS_PWR_REG				0x1140
+#define EXYNOS5_MPLL_SYSCLK_SYS_PWR_REG				0x1144
+#define EXYNOS5_VPLL_SYSCLK_SYS_PWR_REG				0x1148
+#define EXYNOS5_EPLL_SYSCLK_SYS_PWR_REG				0x114C
+#define EXYNOS5_BPLL_SYSCLK_SYS_PWR_REG				0x1150
+#define EXYNOS5_CPLL_SYSCLK_SYS_PWR_REG				0x1154
+#define EXYNOS5_MPLLUSER_SYSCLK_SYS_PWR_REG			0x1164
+#define EXYNOS5_BPLLUSER_SYSCLK_SYS_PWR_REG			0x1170
+#define EXYNOS5_TOP_BUS_SYS_PWR_REG				0x1180
+#define EXYNOS5_TOP_RETENTION_SYS_PWR_REG			0x1184
+#define EXYNOS5_TOP_PWR_SYS_PWR_REG				0x1188
+#define EXYNOS5_TOP_BUS_SYSMEM_SYS_PWR_REG			0x1190
+#define EXYNOS5_TOP_RETENTION_SYSMEM_SYS_PWR_REG		0x1194
+#define EXYNOS5_TOP_PWR_SYSMEM_SYS_PWR_REG			0x1198
+#define EXYNOS5_LOGIC_RESET_SYS_PWR_REG				0x11A0
+#define EXYNOS5_OSCCLK_GATE_SYS_PWR_REG				0x11A4
+#define EXYNOS5_LOGIC_RESET_SYSMEM_SYS_PWR_REG			0x11B0
+#define EXYNOS5_OSCCLK_GATE_SYSMEM_SYS_PWR_REG			0x11B4
+#define EXYNOS5_USBOTG_MEM_SYS_PWR_REG				0x11C0
+#define EXYNOS5_G2D_MEM_SYS_PWR_REG				0x11C8
+#define EXYNOS5_USBDRD_MEM_SYS_PWR_REG				0x11CC
+#define EXYNOS5_SDMMC_MEM_SYS_PWR_REG				0x11D0
+#define EXYNOS5_CSSYS_MEM_SYS_PWR_REG				0x11D4
+#define EXYNOS5_SECSS_MEM_SYS_PWR_REG				0x11D8
+#define EXYNOS5_ROTATOR_MEM_SYS_PWR_REG				0x11DC
+#define EXYNOS5_INTRAM_MEM_SYS_PWR_REG				0x11E0
+#define EXYNOS5_INTROM_MEM_SYS_PWR_REG				0x11E4
+#define EXYNOS5_JPEG_MEM_SYS_PWR_REG				0x11E8
+#define EXYNOS5_HSI_MEM_SYS_PWR_REG				0x11EC
+#define EXYNOS5_MCUIOP_MEM_SYS_PWR_REG				0x11F4
+#define EXYNOS5_SATA_MEM_SYS_PWR_REG				0x11FC
+#define EXYNOS5_PAD_RETENTION_DRAM_SYS_PWR_REG			0x1200
+#define EXYNOS5_PAD_RETENTION_MAU_SYS_PWR_REG			0x1204
+#define EXYNOS5_PAD_RETENTION_EFNAND_SYS_PWR_REG		0x1208
+#define EXYNOS5_PAD_RETENTION_GPIO_SYS_PWR_REG			0x1220
+#define EXYNOS5_PAD_RETENTION_UART_SYS_PWR_REG			0x1224
+#define EXYNOS5_PAD_RETENTION_MMCA_SYS_PWR_REG			0x1228
+#define EXYNOS5_PAD_RETENTION_MMCB_SYS_PWR_REG			0x122C
+#define EXYNOS5_PAD_RETENTION_EBIA_SYS_PWR_REG			0x1230
+#define EXYNOS5_PAD_RETENTION_EBIB_SYS_PWR_REG			0x1234
+#define EXYNOS5_PAD_RETENTION_SPI_SYS_PWR_REG			0x1238
+#define EXYNOS5_PAD_RETENTION_GPIO_SYSMEM_SYS_PWR_REG		0x123C
+#define EXYNOS5_PAD_ISOLATION_SYS_PWR_REG			0x1240
+#define EXYNOS5_PAD_ISOLATION_SYSMEM_SYS_PWR_REG		0x1250
+#define EXYNOS5_PAD_ALV_SEL_SYS_PWR_REG				0x1260
+#define EXYNOS5_XUSBXTI_SYS_PWR_REG				0x1280
+#define EXYNOS5_XXTI_SYS_PWR_REG				0x1284
+#define EXYNOS5_EXT_REGULATOR_SYS_PWR_REG			0x12C0
+#define EXYNOS5_GPIO_MODE_SYS_PWR_REG				0x1300
+#define EXYNOS5_GPIO_MODE_SYSMEM_SYS_PWR_REG			0x1320
+#define EXYNOS5_GPIO_MODE_MAU_SYS_PWR_REG			0x1340
+#define EXYNOS5_TOP_ASB_RESET_SYS_PWR_REG			0x1344
+#define EXYNOS5_TOP_ASB_ISOLATION_SYS_PWR_REG			0x1348
+#define EXYNOS5_GSCL_SYS_PWR_REG				0x1400
+#define EXYNOS5_ISP_SYS_PWR_REG					0x1404
+#define EXYNOS5_MFC_SYS_PWR_REG					0x1408
+#define EXYNOS5_G3D_SYS_PWR_REG					0x140C
+#define EXYNOS5_DISP1_SYS_PWR_REG				0x1414
+#define EXYNOS5_MAU_SYS_PWR_REG					0x1418
+#define EXYNOS5_CMU_CLKSTOP_GSCL_SYS_PWR_REG			0x1480
+#define EXYNOS5_CMU_CLKSTOP_ISP_SYS_PWR_REG			0x1484
+#define EXYNOS5_CMU_CLKSTOP_MFC_SYS_PWR_REG			0x1488
+#define EXYNOS5_CMU_CLKSTOP_G3D_SYS_PWR_REG			0x148C
+#define EXYNOS5_CMU_CLKSTOP_DISP1_SYS_PWR_REG			0x1494
+#define EXYNOS5_CMU_CLKSTOP_MAU_SYS_PWR_REG			0x1498
+#define EXYNOS5_CMU_SYSCLK_GSCL_SYS_PWR_REG			0x14C0
+#define EXYNOS5_CMU_SYSCLK_ISP_SYS_PWR_REG			0x14C4
+#define EXYNOS5_CMU_SYSCLK_MFC_SYS_PWR_REG			0x14C8
+#define EXYNOS5_CMU_SYSCLK_G3D_SYS_PWR_REG			0x14CC
+#define EXYNOS5_CMU_SYSCLK_DISP1_SYS_PWR_REG			0x14D4
+#define EXYNOS5_CMU_SYSCLK_MAU_SYS_PWR_REG			0x14D8
+#define EXYNOS5_CMU_RESET_GSCL_SYS_PWR_REG			0x1580
+#define EXYNOS5_CMU_RESET_ISP_SYS_PWR_REG			0x1584
+#define EXYNOS5_CMU_RESET_MFC_SYS_PWR_REG			0x1588
+#define EXYNOS5_CMU_RESET_G3D_SYS_PWR_REG			0x158C
+#define EXYNOS5_CMU_RESET_DISP1_SYS_PWR_REG			0x1594
+#define EXYNOS5_CMU_RESET_MAU_SYS_PWR_REG			0x1598
 
-#define EXYNOS5_ARM_CORE0_OPTION				S5P_PMUREG(0x2008)
-#define EXYNOS5_ARM_CORE1_OPTION				S5P_PMUREG(0x2088)
-#define EXYNOS5_FSYS_ARM_OPTION					S5P_PMUREG(0x2208)
-#define EXYNOS5_ISP_ARM_OPTION					S5P_PMUREG(0x2288)
-#define EXYNOS5_ARM_COMMON_OPTION				S5P_PMUREG(0x2408)
-#define EXYNOS5_ARM_L2_OPTION					S5P_PMUREG(0x2608)
-#define EXYNOS5_TOP_PWR_OPTION					S5P_PMUREG(0x2C48)
-#define EXYNOS5_TOP_PWR_SYSMEM_OPTION				S5P_PMUREG(0x2CC8)
-#define EXYNOS5_JPEG_MEM_OPTION					S5P_PMUREG(0x2F48)
-#define EXYNOS5_GSCL_OPTION					S5P_PMUREG(0x4008)
-#define EXYNOS5_ISP_OPTION					S5P_PMUREG(0x4028)
-#define EXYNOS5_MFC_OPTION					S5P_PMUREG(0x4048)
-#define EXYNOS5_G3D_OPTION					S5P_PMUREG(0x4068)
-#define EXYNOS5_DISP1_OPTION					S5P_PMUREG(0x40A8)
-#define EXYNOS5_MAU_OPTION					S5P_PMUREG(0x40C8)
+#define EXYNOS5_ARM_CORE0_OPTION				0x2008
+#define EXYNOS5_ARM_CORE1_OPTION				0x2088
+#define EXYNOS5_FSYS_ARM_OPTION					0x2208
+#define EXYNOS5_ISP_ARM_OPTION					0x2288
+#define EXYNOS5_ARM_COMMON_OPTION				0x2408
+#define EXYNOS5_ARM_L2_OPTION					0x2608
+#define EXYNOS5_TOP_PWR_OPTION					0x2C48
+#define EXYNOS5_TOP_PWR_SYSMEM_OPTION				0x2CC8
+#define EXYNOS5_JPEG_MEM_OPTION					0x2F48
+#define EXYNOS5_GSCL_OPTION					0x4008
+#define EXYNOS5_ISP_OPTION					0x4028
+#define EXYNOS5_MFC_OPTION					0x4048
+#define EXYNOS5_G3D_OPTION					0x4068
+#define EXYNOS5_DISP1_OPTION					0x40A8
+#define EXYNOS5_MAU_OPTION					0x40C8
 
 #define EXYNOS5_USE_SC_FEEDBACK					(1 << 1)
 #define EXYNOS5_USE_SC_COUNTER					(1 << 0)
diff --git a/arch/arm/plat-samsung/include/plat/map-s5p.h b/arch/arm/plat-samsung/include/plat/map-s5p.h
index c186786..f5b9d3f 100644
--- a/arch/arm/plat-samsung/include/plat/map-s5p.h
+++ b/arch/arm/plat-samsung/include/plat/map-s5p.h
@@ -15,7 +15,6 @@
 
 #define S5P_VA_CHIPID		S3C_ADDR(0x02000000)
 #define S5P_VA_CMU		S3C_ADDR(0x02100000)
-#define S5P_VA_PMU		S3C_ADDR(0x02180000)
 #define S5P_VA_GPIO		S3C_ADDR(0x02200000)
 #define S5P_VA_GPIO1		S5P_VA_GPIO
 #define S5P_VA_GPIO2		S3C_ADDR(0x02240000)
-- 
1.7.10.4

