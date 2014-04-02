Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbaDBHgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:36:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36694 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042AbaDBHeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:34:05 -0400
X-AuditID: cbfee68e-b7f566d000002344-c5-533bbd6bcf6a
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, chow.kim@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Younggun Jang <yg1004.jang@samsung.com>
Subject: [PATCH 07/10] ARM: EXYNOS: Refactored code for PMU register mapping
 via DT
Date: Wed, 02 Apr 2014 16:50:58 +0900
Message-id: <1396425058-4012-8-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+ZkW7OXutgg2mzWC2WTbrLZtG74Cqb
	xdmmN+wWmx5fY7W4vGsOm8WM8/uYLG5f5rVYtPULu8X6Ga9ZLI7NWMJosaNlNYsDt0dLcw+b
	x51re9g8Ni+p9+jbsorR4/MmuQDWKC6blNSczLLUIn27BK6M6V92shbsvc9U0Tl5G3MD4551
	TF2MnBwSAiYSf7+thLLFJC7cW8/WxcjFISSwjFFi6e+ZbDBFL/f8YoRILGKU6DjZwQLhtDFJ
	tO49AtbOJqAr8eT9XGYQW0QgW+LSrFssIDazwCwmickPokBsYYFQiY4HrWBxFgFViUsHprN2
	MXJw8Aq4S5x6WAZiSggoSMyZZANSwSngIXG/pYUdxBYCqph7YycryFoJgX3sEu97TjBDjBGQ
	+Db5EAtEr6zEpgPMEDdLShxccYNlAqPwAkaGVYyiqQXJBcVJ6UVGesWJucWleel6yfm5mxgh
	0dC3g/HmAetDjMlA4yYyS4km5wOjKa8k3tDYzMjC1MTU2Mjc0ow0YSVx3kUPk4KEBNITS1Kz
	U1MLUovii0pzUosPMTJxcEo1MFpYyEw5cvlQWHP6kevT+zjusvVlhM46PFNIvzWJRVB+5YfL
	XT+aLPb/XX1X4Y+Ep+/6bVPT8j2Xr+v+VrDn86nwJoFOjhQ/7UXbltaURewp91rVHVDXZK9t
	8HnPiW05R5PrVjNYLXTdVcagEBvprtnZ0azG/3EZo027+f+FX1ZWLdi0LniqnxJLcUaioRZz
	UXEiALSaBKOcAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t9jAd3svdbBBi2TzS2WTbrLZtG74Cqb
	xdmmN+wWmx5fY7W4vGsOm8WM8/uYLG5f5rVYtPULu8X6Ga9ZLI7NWMJosaNlNYsDt0dLcw+b
	x51re9g8Ni+p9+jbsorR4/MmuQDWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNL
	C3MlhbzE3FRbJRefAF23zBygy5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCB
	hHWMGdO/7GQt2HufqaJz8jbmBsY965i6GDk5JARMJF7u+cUIYYtJXLi3nq2LkYtDSGARo0TH
	yQ4WCKeNSaJ17xGwDjYBXYkn7+cyg9giAtkSl2bdYgGxmQVmMUlMfhAFYgsLhEp0PGgFi7MI
	qEpcOjCdtYuRg4NXwF3i1MMyEFNCQEFiziQbkApOAQ+J+y0t7CC2EFDF3Bs7WScw8i5gZFjF
	KJpakFxQnJSea6hXnJhbXJqXrpecn7uJERxrz6R2MK5ssDjEKMDBqMTDe+C8VbAQa2JZcWXu
	IUYJDmYlEV7OSdbBQrwpiZVVqUX58UWlOanFhxiTgW6ayCwlmpwPTAN5JfGGxiZmRpZGZhZG
	JubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cBYuOCL6JxdhxckNW1gPfZ9iULWy4U/
	GFl/CORwh1ZOvZDLddf58Oad5n/m30uLOjiTcVKWv4THff15lifSd9UV79t4NXlimZDkroft
	v2db/nnRVDJR6OCWiL3Rttssc3w3/V0wRYDpQ91ZnjfntnOx1ExetNmES+aLyBub08aeaVuV
	V2v+f1I5T4mlOCPRUIu5qDgRAMl/KA/5AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes PMU register mapping via iodesc table and updates
users of PMU registers for using "get_exynos_pmubase" helper function to
get PMU base address.

CC: Tomasz Figa <t.figa@samsung.com>
CC: Kyungmin Park <kyungmin.park@samsung.com>
CC: Thomas Abraham <thomas.abraham@linaro.org>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Younggun Jang <yg1004.jang@samsung.com>
---
 arch/arm/mach-exynos/common.h           |    4 +-
 arch/arm/mach-exynos/cpuidle.c          |   28 +-
 arch/arm/mach-exynos/exynos.c           |   12 +-
 arch/arm/mach-exynos/hotplug.c          |    4 +-
 arch/arm/mach-exynos/include/mach/map.h |    3 -
 arch/arm/mach-exynos/platsmp.c          |   12 +-
 arch/arm/mach-exynos/pm.c               |   53 ++--
 arch/arm/mach-exynos/pmu.c              |   34 ++-
 arch/arm/mach-exynos/regs-pmu.h         |  506 +++++++++++++++----------------
 9 files changed, 332 insertions(+), 324 deletions(-)

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 9a55cf6..645f4f8 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -44,7 +44,7 @@ extern void exynos_cpu_die(unsigned int cpu);
 
 /* PMU(Power Management Unit) support */
 
-#define PMU_TABLE_END	NULL
+#define PMU_TABLE_END	0xFFFF
 
 enum sys_powerdown {
 	SYS_AFTR,
@@ -55,7 +55,7 @@ enum sys_powerdown {
 
 extern unsigned long l2x0_regs_phys;
 struct exynos_pmu_conf {
-	void __iomem *reg;
+	unsigned int offset;
 	unsigned int val[NUM_SYS_POWERDOWN];
 };
 
diff --git a/arch/arm/mach-exynos/cpuidle.c b/arch/arm/mach-exynos/cpuidle.c
index b9dd8c3..dcf563d 100644
--- a/arch/arm/mach-exynos/cpuidle.c
+++ b/arch/arm/mach-exynos/cpuidle.c
@@ -31,11 +31,15 @@
 #include "common.h"
 
 #define REG_DIRECTGO_ADDR	(samsung_rev() == EXYNOS4210_REV_1_1 ? \
-			S5P_INFORM7 : (samsung_rev() == EXYNOS4210_REV_1_0 ? \
-			(S5P_VA_SYSRAM + 0x24) : S5P_INFORM0))
+			get_exynos_pmubase() + S5P_INFORM7 : \
+			(samsung_rev() == EXYNOS4210_REV_1_0 ? \
+			(S5P_VA_SYSRAM + 0x24) : \
+			get_exynos_pmubase() + S5P_INFORM0))
 #define REG_DIRECTGO_FLAG	(samsung_rev() == EXYNOS4210_REV_1_1 ? \
-			S5P_INFORM6 : (samsung_rev() == EXYNOS4210_REV_1_0 ? \
-			(S5P_VA_SYSRAM + 0x20) : S5P_INFORM1))
+			get_exynos_pmubase() + S5P_INFORM6 : \
+			(samsung_rev() == EXYNOS4210_REV_1_0 ? \
+			(S5P_VA_SYSRAM + 0x20) : \
+			get_exynos_pmubase() + S5P_INFORM1))
 
 #define S5P_CHECK_AFTR		0xFCBA0D10
 
@@ -58,6 +62,8 @@
 #define PWR_CTRL2_CORE2_UP_RATIO		(1 << 4)
 #define PWR_CTRL2_CORE1_UP_RATIO		(1 << 0)
 
+static void __iomem *pmu_base;
+
 static int exynos4_enter_lowpower(struct cpuidle_device *dev,
 				struct cpuidle_driver *drv,
 				int index);
@@ -85,7 +91,7 @@ static struct cpuidle_driver exynos4_idle_driver = {
 /* Ext-GIC nIRQ/nFIQ is the only wakeup source in AFTR */
 static void exynos4_set_wakeupmask(void)
 {
-	__raw_writel(0x0000ff3e, S5P_WAKEUP_MASK);
+	__raw_writel(0x0000ff3e, pmu_base + S5P_WAKEUP_MASK);
 }
 
 static unsigned int g_pwr_ctrl, g_diag_reg;
@@ -131,9 +137,9 @@ static int exynos4_enter_core0_aftr(struct cpuidle_device *dev,
 	save_cpu_arch_register();
 
 	/* Setting Central Sequence Register for power down mode */
-	tmp = __raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
+	tmp = __raw_readl(pmu_base + S5P_CENTRAL_SEQ_CONFIGURATION);
 	tmp &= ~S5P_CENTRAL_LOWPWR_CFG;
-	__raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
+	__raw_writel(tmp, pmu_base + S5P_CENTRAL_SEQ_CONFIGURATION);
 
 	cpu_pm_enter();
 	cpu_suspend(0, idle_finisher);
@@ -152,14 +158,14 @@ static int exynos4_enter_core0_aftr(struct cpuidle_device *dev,
 	 * S5P_CENTRAL_LOWPWR_CFG bit will not be set automatically
 	 * in this situation.
 	 */
-	tmp = __raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
+	tmp = __raw_readl(pmu_base + S5P_CENTRAL_SEQ_CONFIGURATIO);
 	if (!(tmp & S5P_CENTRAL_LOWPWR_CFG)) {
 		tmp |= S5P_CENTRAL_LOWPWR_CFG;
-		__raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
+		__raw_writel(tmp, pmu_base + S5P_CENTRAL_SEQ_CONFIGURATION);
 	}
 
 	/* Clear wakeup state register */
-	__raw_writel(0x0, S5P_WAKEUP_STAT);
+	__raw_writel(0x0, pmu_base + S5P_WAKEUP_STAT);
 
 	return index;
 }
@@ -217,6 +223,8 @@ static int exynos_cpuidle_probe(struct platform_device *pdev)
 	int cpu_id, ret;
 	struct cpuidle_device *device;
 
+	pmu_base = get_exynos_pmubase();
+
 	if (soc_is_exynos5250())
 		exynos5_core_down_clk();
 
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index a5127fb..68e7612 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -64,11 +64,6 @@ static struct map_desc exynos4_iodesc[] __initdata = {
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
@@ -192,11 +187,6 @@ static struct map_desc exynos5_iodesc[] __initdata = {
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
 
@@ -204,7 +194,7 @@ void exynos_restart(enum reboot_mode mode, const char *cmd)
 {
 	struct device_node *np;
 	u32 val = 0x1;
-	void __iomem *addr = EXYNOS_SWRESET;
+	void __iomem *addr = get_exynos_pmubase() + EXYNOS_SWRESET;
 
 	if (of_machine_is_compatible("samsung,exynos5440")) {
 		u32 status;
diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index 33db6ee..94ab653 100644
--- a/arch/arm/mach-exynos/hotplug.c
+++ b/arch/arm/mach-exynos/hotplug.c
@@ -91,11 +91,13 @@ static inline void cpu_leave_lowpower(void)
 
 static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
 {
+	void __iomem *pmu_base = get_exynos_pmubase();
+
 	for (;;) {
 
 		/* make cpu1 to be turned off at next WFI command */
 		if (cpu == 1)
-			__raw_writel(0, S5P_ARM_CORE1_CONFIGURATION);
+			__raw_writel(0, pmu_base + S5P_ARM_CORE1_CONFIGURATION);
 
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
index 3ebb03f..19c2a50 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -31,11 +31,12 @@
 #include "common.h"
 
 extern void exynos4_secondary_startup(void);
+static void __iomem *pmu_base;
 
 static inline void __iomem *cpu_boot_reg_base(void)
 {
 	if (soc_is_exynos4210() && samsung_rev() == EXYNOS4210_REV_1_1)
-		return S5P_INFORM5;
+		return pmu_base + S5P_INFORM5;
 	return S5P_VA_SYSRAM;
 }
 
@@ -90,6 +91,8 @@ static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
 	unsigned long timeout;
 	unsigned long phys_cpu = cpu_logical_map(cpu);
 
+	pmu_base = get_exynos_pmubase();
+
 	/*
 	 * Set synchronisation state between this boot processor
 	 * and the secondary one
@@ -106,14 +109,15 @@ static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
 	 */
 	write_pen_release(phys_cpu);
 
-	if (!(__raw_readl(S5P_ARM_CORE1_STATUS) & S5P_CORE_LOCAL_PWR_EN)) {
+	if (!(__raw_readl(pmu_base + S5P_ARM_CORE1_STATUS)
+				& S5P_CORE_LOCAL_PWR_EN)) {
 		__raw_writel(S5P_CORE_LOCAL_PWR_EN,
-			     S5P_ARM_CORE1_CONFIGURATION);
+			     pmu_base + S5P_ARM_CORE1_CONFIGURATION);
 
 		timeout = 10;
 
 		/* wait max 10 ms until cpu1 is on */
-		while ((__raw_readl(S5P_ARM_CORE1_STATUS)
+		while ((__raw_readl(pmu_base + S5P_ARM_CORE1_STATUS)
 			& S5P_CORE_LOCAL_PWR_EN) != S5P_CORE_LOCAL_PWR_EN) {
 			if (timeout-- == 0)
 				break;
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 875151f..6c147c9 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -119,32 +119,37 @@ static int exynos_cpu_suspend(unsigned long arg)
 	return 1; /* Aborting suspend */
 }
 
+static void __iomem *pmu_base;
+
 static void exynos_pm_prepare(void)
 {
 	unsigned int tmp;
 
 	/* Set wake-up mask registers */
-	__raw_writel(exynos_get_eint_wake_mask(), S5P_EINT_WAKEUP_MASK);
-	__raw_writel(exynos_irqwake_intmask & ~(1 << 31), S5P_WAKEUP_MASK);
+	__raw_writel(exynos_get_eint_wake_mask(),
+			pmu_base + S5P_EINT_WAKEUP_MASK);
+	__raw_writel(exynos_irqwake_intmask & ~(1 << 31),
+			pmu_base + S5P_WAKEUP_MASK);
 
 	s3c_pm_do_save(exynos_core_save, ARRAY_SIZE(exynos_core_save));
 
 	if (soc_is_exynos5250()) {
 		s3c_pm_do_save(exynos5_sys_save, ARRAY_SIZE(exynos5_sys_save));
 		/* Disable USE_RETENTION of JPEG_MEM_OPTION */
-		tmp = __raw_readl(EXYNOS5_JPEG_MEM_OPTION);
+		tmp = __raw_readl(pmu_base + EXYNOS5_JPEG_MEM_OPTION);
 		tmp &= ~EXYNOS5_OPTION_USE_RETENTION;
-		__raw_writel(tmp, EXYNOS5_JPEG_MEM_OPTION);
+		__raw_writel(tmp, pmu_base + EXYNOS5_JPEG_MEM_OPTION);
 	}
 
 	/* Set value of power down register for sleep mode */
 
 	exynos_sys_powerdown_conf(SYS_SLEEP);
-	__raw_writel(S5P_CHECK_SLEEP, S5P_INFORM1);
+	__raw_writel(S5P_CHECK_SLEEP, pmu_base + S5P_INFORM1);
 
 	/* ensure at least INFORM0 has the resume address */
 
-	__raw_writel(virt_to_phys(exynos_cpu_resume), S5P_INFORM0);
+	__raw_writel(virt_to_phys(exynos_cpu_resume),
+			pmu_base + S5P_INFORM0);
 }
 
 static int exynos_pm_suspend(void)
@@ -153,14 +158,14 @@ static int exynos_pm_suspend(void)
 
 	/* Setting Central Sequence Register for power down mode */
 
-	tmp = __raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
+	tmp = __raw_readl(pmu_base + S5P_CENTRAL_SEQ_CONFIGURATION);
 	tmp &= ~S5P_CENTRAL_LOWPWR_CFG;
-	__raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
+	__raw_writel(tmp, pmu_base + S5P_CENTRAL_SEQ_CONFIGURATION);
 
 	/* Setting SEQ_OPTION register */
 
 	tmp = (S5P_USE_STANDBY_WFI0 | S5P_USE_STANDBY_WFE0);
-	__raw_writel(tmp, S5P_CENTRAL_SEQ_OPTION);
+	__raw_writel(tmp, pmu_base + S5P_CENTRAL_SEQ_OPTION);
 
 	if (!soc_is_exynos5250()) {
 		/* Save Power control register */
@@ -187,12 +192,12 @@ static void exynos_pm_resume(void)
 	 * S5P_CENTRAL_LOWPWR_CFG bit will not be set automatically
 	 * in this situation.
 	 */
-	tmp = __raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
+	tmp = __raw_readl(pmu_base + S5P_CENTRAL_SEQ_CONFIGURATION);
 	if (!(tmp & S5P_CENTRAL_LOWPWR_CFG)) {
 		tmp |= S5P_CENTRAL_LOWPWR_CFG;
-		__raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
+		__raw_writel(tmp, pmu_base + S5P_CENTRAL_SEQ_CONFIGURATION);
 		/* clear the wakeup state register */
-		__raw_writel(0x0, S5P_WAKEUP_STAT);
+		__raw_writel(0x0, pmu_base + S5P_WAKEUP_STAT);
 		/* No need to perform below restore code */
 		goto early_wakeup;
 	}
@@ -212,13 +217,13 @@ static void exynos_pm_resume(void)
 
 	/* For release retention */
 
-	__raw_writel((1 << 28), S5P_PAD_RET_MAUDIO_OPTION);
-	__raw_writel((1 << 28), S5P_PAD_RET_GPIO_OPTION);
-	__raw_writel((1 << 28), S5P_PAD_RET_UART_OPTION);
-	__raw_writel((1 << 28), S5P_PAD_RET_MMCA_OPTION);
-	__raw_writel((1 << 28), S5P_PAD_RET_MMCB_OPTION);
-	__raw_writel((1 << 28), S5P_PAD_RET_EBIA_OPTION);
-	__raw_writel((1 << 28), S5P_PAD_RET_EBIB_OPTION);
+	__raw_writel((1 << 28), pmu_base + S5P_PAD_RET_MAUDIO_OPTION);
+	__raw_writel((1 << 28), pmu_base + S5P_PAD_RET_GPIO_OPTION);
+	__raw_writel((1 << 28), pmu_base + S5P_PAD_RET_UART_OPTION);
+	__raw_writel((1 << 28), pmu_base + S5P_PAD_RET_MMCA_OPTION);
+	__raw_writel((1 << 28), pmu_base + S5P_PAD_RET_MMCB_OPTION);
+	__raw_writel((1 << 28), pmu_base + S5P_PAD_RET_EBIA_OPTION);
+	__raw_writel((1 << 28), pmu_base + S5P_PAD_RET_EBIB_OPTION);
 
 	if (soc_is_exynos5250())
 		s3c_pm_do_restore(exynos5_sys_save,
@@ -232,7 +237,7 @@ static void exynos_pm_resume(void)
 early_wakeup:
 
 	/* Clear SLEEP mode set in INFORM1 */
-	__raw_writel(0x0, S5P_INFORM1);
+	__raw_writel(0x0, pmu_base + S5P_INFORM1);
 
 	return;
 }
@@ -276,7 +281,7 @@ static int exynos_suspend_enter(suspend_state_t state)
 	s3c_pm_restore_uarts();
 
 	S3C_PMDBG("%s: wakeup stat: %08x\n", __func__,
-			__raw_readl(S5P_WAKEUP_STAT));
+			__raw_readl(pmu_base + S5P_WAKEUP_STAT));
 
 	s3c_pm_check_restore();
 
@@ -308,13 +313,15 @@ void __init exynos_pm_init(void)
 {
 	u32 tmp;
 
+	pmu_base = get_exynos_pmubase();
+
 	/* Platform-specific GIC callback */
 	gic_arch_extn.irq_set_wake = exynos_irq_set_wake;
 
 	/* All wakeup disable */
-	tmp = __raw_readl(S5P_WAKEUP_MASK);
+	tmp = __raw_readl(pmu_base + S5P_WAKEUP_MASK);
 	tmp |= ((0xFF << 8) | (0x1F << 1));
-	__raw_writel(tmp, S5P_WAKEUP_MASK);
+	__raw_writel(tmp, pmu_base + S5P_WAKEUP_MASK);
 
 	register_syscore_ops(&exynos_pm_syscore_ops);
 	suspend_set_ops(&exynos_suspend_ops);
diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index fb44352..30b20ab 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -18,6 +18,7 @@
 #include "common.h"
 
 static const struct exynos_pmu_conf *exynos_pmu_config;
+static void __iomem *pmu_base;
 
 static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
 	/* { .reg = address, .val = { AFTR, LPA, SLEEP } */
@@ -317,7 +318,7 @@ static const struct exynos_pmu_conf exynos5250_pmu_config[] = {
 	{ PMU_TABLE_END,},
 };
 
-static void __iomem * const exynos5_list_both_cnt_feed[] = {
+static unsigned int const exynos5_list_both_cnt_feed[] = {
 	EXYNOS5_ARM_CORE0_OPTION,
 	EXYNOS5_ARM_CORE1_OPTION,
 	EXYNOS5_ARM_COMMON_OPTION,
@@ -331,7 +332,7 @@ static void __iomem * const exynos5_list_both_cnt_feed[] = {
 	EXYNOS5_TOP_PWR_SYSMEM_OPTION,
 };
 
-static void __iomem * const exynos5_list_diable_wfi_wfe[] = {
+static unsigned int const exynos5_list_diable_wfi_wfe[] = {
 	EXYNOS5_ARM_CORE1_OPTION,
 	EXYNOS5_FSYS_ARM_OPTION,
 	EXYNOS5_ISP_ARM_OPTION,
@@ -346,27 +347,27 @@ static void exynos5_init_pmu(void)
 	 * Enable both SC_FEEDBACK and SC_COUNTER
 	 */
 	for (i = 0 ; i < ARRAY_SIZE(exynos5_list_both_cnt_feed) ; i++) {
-		tmp = __raw_readl(exynos5_list_both_cnt_feed[i]);
+		tmp = __raw_readl(pmu_base + exynos5_list_both_cnt_feed[i]);
 		tmp |= (EXYNOS5_USE_SC_FEEDBACK |
 			EXYNOS5_USE_SC_COUNTER);
-		__raw_writel(tmp, exynos5_list_both_cnt_feed[i]);
+		__raw_writel(tmp, pmu_base + exynos5_list_both_cnt_feed[i]);
 	}
 
 	/*
 	 * SKIP_DEACTIVATE_ACEACP_IN_PWDN_BITFIELD Enable
 	 */
-	tmp = __raw_readl(EXYNOS5_ARM_COMMON_OPTION);
+	tmp = __raw_readl(pmu_base + EXYNOS5_ARM_COMMON_OPTION);
 	tmp |= EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
-	__raw_writel(tmp, EXYNOS5_ARM_COMMON_OPTION);
+	__raw_writel(tmp, pmu_base + EXYNOS5_ARM_COMMON_OPTION);
 
 	/*
 	 * Disable WFI/WFE on XXX_OPTION
 	 */
 	for (i = 0 ; i < ARRAY_SIZE(exynos5_list_diable_wfi_wfe) ; i++) {
-		tmp = __raw_readl(exynos5_list_diable_wfi_wfe[i]);
+		tmp = __raw_readl(pmu_base + exynos5_list_diable_wfi_wfe[i]);
 		tmp &= ~(EXYNOS5_OPTION_USE_STANDBYWFE |
 			 EXYNOS5_OPTION_USE_STANDBYWFI);
-		__raw_writel(tmp, exynos5_list_diable_wfi_wfe[i]);
+		__raw_writel(tmp, pmu_base + exynos5_list_diable_wfi_wfe[i]);
 	}
 }
 
@@ -377,14 +378,14 @@ void exynos_sys_powerdown_conf(enum sys_powerdown mode)
 	if (soc_is_exynos5250())
 		exynos5_init_pmu();
 
-	for (i = 0; (exynos_pmu_config[i].reg != PMU_TABLE_END) ; i++)
+	for (i = 0; (exynos_pmu_config[i].offset != PMU_TABLE_END) ; i++)
 		__raw_writel(exynos_pmu_config[i].val[mode],
-				exynos_pmu_config[i].reg);
+				pmu_base + exynos_pmu_config[i].offset);
 
 	if (soc_is_exynos4412()) {
-		for (i = 0; exynos4412_pmu_config[i].reg != PMU_TABLE_END ; i++)
+		for (i = 0; exynos4412_pmu_config[i].offset != PMU_TABLE_END; i++)
 			__raw_writel(exynos4412_pmu_config[i].val[mode],
-				exynos4412_pmu_config[i].reg);
+					pmu_base + exynos4412_pmu_config[i].offset);
 	}
 }
 
@@ -393,6 +394,7 @@ static int __init exynos_pmu_init(void)
 	unsigned int value;
 
 	exynos_pmu_config = exynos4210_pmu_config;
+	pmu_base = get_exynos_pmubase();
 
 	if (soc_is_exynos4210()) {
 		exynos_pmu_config = exynos4210_pmu_config;
@@ -405,13 +407,13 @@ static int __init exynos_pmu_init(void)
 		 * When SYS_WDTRESET is set, watchdog timer reset request
 		 * is ignored by power management unit.
 		 */
-		value = __raw_readl(EXYNOS5_AUTO_WDTRESET_DISABLE);
+		value = __raw_readl(pmu_base + EXYNOS5_AUTO_WDTRESET_DISABLE);
 		value &= ~EXYNOS5_SYS_WDTRESET;
-		__raw_writel(value, EXYNOS5_AUTO_WDTRESET_DISABLE);
+		__raw_writel(value, pmu_base + EXYNOS5_AUTO_WDTRESET_DISABLE);
 
-		value = __raw_readl(EXYNOS5_MASK_WDTRESET_REQUEST);
+		value = __raw_readl(pmu_base + EXYNOS5_MASK_WDTRESET_REQUEST);
 		value &= ~EXYNOS5_SYS_WDTRESET;
-		__raw_writel(value, EXYNOS5_MASK_WDTRESET_REQUEST);
+		__raw_writel(value, pmu_base + EXYNOS5_MASK_WDTRESET_REQUEST);
 
 		exynos_pmu_config = exynos5250_pmu_config;
 		pr_info("EXYNOS5250 PMU Initialize\n");
diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
index bfebe84..7f3bf65 100644
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ b/arch/arm/mach-exynos/regs-pmu.h
@@ -14,290 +14,288 @@
 
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
 
 #define S5P_CHECK_SLEEP				0x00000BAD
 
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
-- 
1.7.10.4

