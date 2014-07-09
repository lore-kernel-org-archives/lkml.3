Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbaGIEDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 00:03:52 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:55307 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbaGIEDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 00:03:46 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-ad-53bcbf1b02db
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v7 2/4] ARM: EXYNOS: Refactored code for using PMU address via
 DT
Date: Wed, 09 Jul 2014 09:30:53 +0530
Message-id: <1404878455-31518-3-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1404878455-31518-1-git-send-email-pankaj.dubey@samsung.com>
References: <1404878455-31518-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42JZI2JSpyu9f0+wwfxWeYtlk+6yWXzf9YXd
	onfBVTaLTY+vsVpc3jWHzWLG+X1MFrcv81p8Ovqf1WLRVqCK9TNes1h0LGO0uPlsO5MDj0dL
	cw+bx+Yl9R59W1YxenzeJBfAEsVlk5Kak1mWWqRvl8CVcXLDFOaCI6+ZKlYd+svcwDhxJ1MX
	IyeHhICJxPplLWwQtpjEhXvrwWwhgaWMEk/vccPULL62l7mLkQsovohRYvLC94wQzgQmidU9
	GxhBqtgEdCWevJ/LDGKLCGRL9N9ezQJSxCzwmFHizcqjYEXCAsESC/r/gNksAqoSrSsnsILY
	vAIeEr9uTwc6iQNonYLEnEk2IGFOAU+JlunLoS7ykDizbgMryEwJgW3sEl9efGeBmCMg8W3y
	IRaIXlmJTQeYIa6WlDi44gbLBEbhBYwMqxhFUwuSC4qT0osM9YoTc4tL89L1kvNzNzECo+H0
	v2e9OxhvH7A+xJgMNG4is5Rocj4wmvJK4g2NzYwsTE1MjY3MLc1IE1YS5016mBQkJJCeWJKa
	nZpakFoUX1Sak1p8iJGJg1OqgTH2S+js2I8fP0Q/sdqp/1RK4l+l4XYPXaMvq1+lPOOY13ed
	83QZD/etsn631d9Wxosmz5C1WMz0oFC4ek/MT7aZC9Vu+nNnh8nzf66v5lpTXhj3ld1ScI6K
	xif98Fsr+rxKL5r+9Py418CX5fUdUUl3qdmax9XPf3Kae/P7WjH/O7kzd/90+67EUpyRaKjF
	XFScCAC/NUFgnAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jAV3p/XuCDf5/E7ZYNukum8X3XV/Y
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS0WbQWqWD/jNYtFxzJGi5vPtjM58Hi0
	NPeweWxeUu/Rt2UVo8fnTXIBLFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbm
	Sgp5ibmptkouPgG6bpk5QIcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlr
	GDNObpjCXHDkNVPFqkN/mRsYJ+5k6mLk5JAQMJFYfG0vM4QtJnHh3nq2LkYuDiGBRYwSkxe+
	Z4RwJjBJrO7ZwAhSxSagK/Hk/VywDhGBbIn+26tZQIqYBR4zSrxZeRSsSFggWGJB/x8wm0VA
	VaJ15QRWEJtXwEPi1+3pQKs5gNYpSMyZZAMS5hTwlGiZvpwNxBYCKjmzbgPrBEbeBYwMqxhF
	UwuSC4qT0nON9IoTc4tL89L1kvNzNzGCo+2Z9A7GVQ0WhxgFOBiVeHgVePYEC7EmlhVX5h5i
	lOBgVhLh/eYGFOJNSaysSi3Kjy8qzUktPsRoCnTURGYp0eR8YCLIK4k3NDYxNzU2tTSxMDGz
	VBLnPdhqHSgkkJ5YkpqdmlqQWgTTx8TBKdXAuJSL1XeZZO+qUEv/2zarPCbeTWmcuuqUy/yZ
	/PstS+ou3Fz0bfefjpjP/9m2htlvtbFfederhHWR7YwNv55bHvmnLX17b84ugQNPHnhyPH69
	zV2kyeeNBLvgsbwLeyw98kWjI76bf3MyamXdJbH4jUE5U2lH/HwzlxlfPITdbBmc3iq+bJvV
	qcRSnJFoqMVcVJwIAHi/rXvMAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under "arm/mach-exynos" many files are using PMU register offsets.
Since we have added support for accessing PMU base address via DT,
now we can remove PMU mapping from exynosX_iodesc. Let's convert
all these access using iomapped address.
This will help us in removing static mapping of PMU base address
as well as help in reducing dependency over machine header files.
Thus helping for migration of PMU implementation from machine to
driver folder which can be reused for ARM64 bsed SoC.

Also as we have removed static mappings from "regs-pmu.h" it does
not need map.h anymore. But "platsmp.c" needed this and till now it
got included indirectly. So lets move header inclusion of
"mach/map.h" from "regs-pmu.h" to "platsmp.c".

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/common.h                |   14 +-
 arch/arm/mach-exynos/exynos.c                |   12 +-
 arch/arm/mach-exynos/include/mach/map.h      |    3 -
 arch/arm/mach-exynos/mcpm-exynos.c           |    8 +-
 arch/arm/mach-exynos/platsmp.c               |    4 +-
 arch/arm/mach-exynos/pm.c                    |   76 ++--
 arch/arm/mach-exynos/pmu.c                   |   40 +-
 arch/arm/mach-exynos/regs-pmu.h              |  522 +++++++++++++-------------
 arch/arm/plat-samsung/include/plat/map-s5p.h |    1 -
 9 files changed, 339 insertions(+), 341 deletions(-)

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index f8daa9c..47b904b 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -134,7 +134,7 @@ extern void exynos_cpu_die(unsigned int cpu);
 
 /* PMU(Power Management Unit) support */
 
-#define PMU_TABLE_END	NULL
+#define PMU_TABLE_END	(-1U)
 
 enum sys_powerdown {
 	SYS_AFTR,
@@ -144,7 +144,7 @@ enum sys_powerdown {
 };
 
 struct exynos_pmu_conf {
-	void __iomem *reg;
+	unsigned int offset;
 	unsigned int val[NUM_SYS_POWERDOWN];
 };
 
@@ -160,4 +160,14 @@ extern void exynos_enter_aftr(void);
 extern void s5p_init_cpu(void __iomem *cpuid_addr);
 extern unsigned int samsung_rev(void);
 
+static inline void pmu_raw_writel(u32 val, u32 offset)
+{
+	__raw_writel(val, pmu_base_addr + offset);
+}
+
+static inline u32 pmu_raw_readl(u32 offset)
+{
+	return __raw_readl(pmu_base_addr + offset);
+}
+
 #endif /* __ARCH_ARM_MACH_EXYNOS_COMMON_H */
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 173aac8..d75d3e8 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -61,11 +61,6 @@ static struct map_desc exynos4_iodesc[] __initdata = {
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
@@ -139,11 +134,6 @@ static struct map_desc exynos5_iodesc[] __initdata = {
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
 
@@ -151,7 +141,7 @@ static void exynos_restart(enum reboot_mode mode, const char *cmd)
 {
 	struct device_node *np;
 	u32 val = 0x1;
-	void __iomem *addr = EXYNOS_SWRESET;
+	void __iomem *addr = pmu_base_addr + EXYNOS_SWRESET;
 
 	if (of_machine_is_compatible("samsung,exynos5440")) {
 		u32 status;
diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
index 963002f..f0b7e92 100644
--- a/arch/arm/mach-exynos/include/mach/map.h
+++ b/arch/arm/mach-exynos/include/mach/map.h
@@ -27,9 +27,6 @@
 #define EXYNOS4_PA_SYSCON		0x10010000
 #define EXYNOS5_PA_SYSCON		0x10050100
 
-#define EXYNOS4_PA_PMU			0x10020000
-#define EXYNOS5_PA_PMU			0x10040000
-
 #define EXYNOS4_PA_CMU			0x10030000
 #define EXYNOS5_PA_CMU			0x10010000
 
diff --git a/arch/arm/mach-exynos/mcpm-exynos.c b/arch/arm/mach-exynos/mcpm-exynos.c
index 9315ba9..70e8ccd 100644
--- a/arch/arm/mach-exynos/mcpm-exynos.c
+++ b/arch/arm/mach-exynos/mcpm-exynos.c
@@ -55,7 +55,7 @@
 	"dsb\n\t" \
 	"ldmfd	sp!, {fp, ip}" \
 	: \
-	: "Ir" (S5P_INFORM0) \
+	: "Ir" (pmu_base_addr + S5P_INFORM0) \
 	: "r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7", \
 	  "r9", "r10", "lr", "memory")
 
@@ -337,7 +337,7 @@ static int __init exynos_mcpm_init(void)
 	 * To increase the stability of KFC reset we need to program
 	 * the PMU SPARE3 register
 	 */
-	__raw_writel(EXYNOS5420_SWRESET_KFC_SEL, S5P_PMU_SPARE3);
+	pmu_raw_writel(EXYNOS5420_SWRESET_KFC_SEL, S5P_PMU_SPARE3);
 
 	exynos_mcpm_usage_count_init();
 
@@ -366,11 +366,11 @@ static int __init exynos_mcpm_init(void)
 	 * turned on before the first man is powered up.
 	 */
 	for (i = 0; i < EXYNOS5420_NR_CLUSTERS; i++) {
-		value = __raw_readl(EXYNOS_COMMON_OPTION(i));
+		value = pmu_raw_readl(EXYNOS_COMMON_OPTION(i));
 		value |= EXYNOS5420_ENABLE_AUTOMATIC_CORE_DOWN |
 			 EXYNOS5420_USE_ARM_CORE_DOWN_STATE    |
 			 EXYNOS5420_USE_L2_COMMON_UP_STATE;
-		__raw_writel(value, EXYNOS_COMMON_OPTION(i));
+		pmu_raw_writel(value, EXYNOS_COMMON_OPTION(i));
 	}
 
 	/*
diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index cd25a9c..dab0784 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -26,6 +26,8 @@
 #include <asm/smp_scu.h>
 #include <asm/firmware.h>
 
+#include <mach/map.h>
+
 #include "common.h"
 #include "regs-pmu.h"
 
@@ -34,7 +36,7 @@ extern void exynos4_secondary_startup(void);
 static inline void __iomem *cpu_boot_reg_base(void)
 {
 	if (soc_is_exynos4210() && samsung_rev() == EXYNOS4210_REV_1_1)
-		return S5P_INFORM5;
+		return pmu_base_addr + S5P_INFORM5;
 	return sysram_base_addr;
 }
 
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index f127c0c..bcb96be 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -111,7 +111,7 @@ static int exynos_irq_set_wake(struct irq_data *data, unsigned int state)
  */
 void exynos_cpu_power_down(int cpu)
 {
-	__raw_writel(0, EXYNOS_ARM_CORE_CONFIGURATION(cpu));
+	pmu_raw_writel(0, EXYNOS_ARM_CORE_CONFIGURATION(cpu));
 }
 
 /**
@@ -122,8 +122,8 @@ void exynos_cpu_power_down(int cpu)
  */
 void exynos_cpu_power_up(int cpu)
 {
-	__raw_writel(S5P_CORE_LOCAL_PWR_EN,
-		     EXYNOS_ARM_CORE_CONFIGURATION(cpu));
+	pmu_raw_writel(S5P_CORE_LOCAL_PWR_EN,
+			EXYNOS_ARM_CORE_CONFIGURATION(cpu));
 }
 
 /**
@@ -133,7 +133,7 @@ void exynos_cpu_power_up(int cpu)
  */
 int exynos_cpu_power_state(int cpu)
 {
-	return (__raw_readl(EXYNOS_ARM_CORE_STATUS(cpu)) &
+	return (pmu_raw_readl(EXYNOS_ARM_CORE_STATUS(cpu)) &
 			S5P_CORE_LOCAL_PWR_EN);
 }
 
@@ -143,7 +143,7 @@ int exynos_cpu_power_state(int cpu)
  */
 void exynos_cluster_power_down(int cluster)
 {
-	__raw_writel(0, EXYNOS_COMMON_CONFIGURATION(cluster));
+	pmu_raw_writel(0, EXYNOS_COMMON_CONFIGURATION(cluster));
 }
 
 /**
@@ -152,8 +152,8 @@ void exynos_cluster_power_down(int cluster)
  */
 void exynos_cluster_power_up(int cluster)
 {
-	__raw_writel(S5P_CORE_LOCAL_PWR_EN,
-		     EXYNOS_COMMON_CONFIGURATION(cluster));
+	pmu_raw_writel(S5P_CORE_LOCAL_PWR_EN,
+			EXYNOS_COMMON_CONFIGURATION(cluster));
 }
 
 /**
@@ -163,16 +163,20 @@ void exynos_cluster_power_up(int cluster)
  */
 int exynos_cluster_power_state(int cluster)
 {
-	return (__raw_readl(EXYNOS_COMMON_STATUS(cluster)) &
+	return (pmu_raw_readl(EXYNOS_COMMON_STATUS(cluster)) &
 			S5P_CORE_LOCAL_PWR_EN);
 }
 
 #define EXYNOS_BOOT_VECTOR_ADDR	(samsung_rev() == EXYNOS4210_REV_1_1 ? \
-			S5P_INFORM7 : (samsung_rev() == EXYNOS4210_REV_1_0 ? \
-			(sysram_base_addr + 0x24) : S5P_INFORM0))
+			pmu_base_addr + S5P_INFORM7 : \
+			(samsung_rev() == EXYNOS4210_REV_1_0 ? \
+			(sysram_base_addr + 0x24) : \
+			pmu_base_addr + S5P_INFORM0))
 #define EXYNOS_BOOT_VECTOR_FLAG	(samsung_rev() == EXYNOS4210_REV_1_1 ? \
-			S5P_INFORM6 : (samsung_rev() == EXYNOS4210_REV_1_0 ? \
-			(sysram_base_addr + 0x20) : S5P_INFORM1))
+			pmu_base_addr + S5P_INFORM6 : \
+			(samsung_rev() == EXYNOS4210_REV_1_0 ? \
+			(sysram_base_addr + 0x20) : \
+			pmu_base_addr + S5P_INFORM1))
 
 #define S5P_CHECK_AFTR  0xFCBA0D10
 #define S5P_CHECK_SLEEP 0x00000BAD
@@ -180,7 +184,7 @@ int exynos_cluster_power_state(int cluster)
 /* Ext-GIC nIRQ/nFIQ is the only wakeup source in AFTR */
 static void exynos_set_wakeupmask(long mask)
 {
-	__raw_writel(mask, S5P_WAKEUP_MASK);
+	pmu_raw_writel(mask, S5P_WAKEUP_MASK);
 }
 
 static void exynos_cpu_set_boot_vector(long flags)
@@ -257,27 +261,27 @@ static void exynos_pm_prepare(void)
 	unsigned int tmp;
 
 	/* Set wake-up mask registers */
-	__raw_writel(exynos_get_eint_wake_mask(), S5P_EINT_WAKEUP_MASK);
-	__raw_writel(exynos_irqwake_intmask & ~(1 << 31), S5P_WAKEUP_MASK);
+	pmu_raw_writel(exynos_get_eint_wake_mask(), S5P_EINT_WAKEUP_MASK);
+	pmu_raw_writel(exynos_irqwake_intmask & ~(1 << 31), S5P_WAKEUP_MASK);
 
 	s3c_pm_do_save(exynos_core_save, ARRAY_SIZE(exynos_core_save));
 
 	if (soc_is_exynos5250()) {
 		s3c_pm_do_save(exynos5_sys_save, ARRAY_SIZE(exynos5_sys_save));
 		/* Disable USE_RETENTION of JPEG_MEM_OPTION */
-		tmp = __raw_readl(EXYNOS5_JPEG_MEM_OPTION);
+		tmp = pmu_raw_readl(EXYNOS5_JPEG_MEM_OPTION);
 		tmp &= ~EXYNOS5_OPTION_USE_RETENTION;
-		__raw_writel(tmp, EXYNOS5_JPEG_MEM_OPTION);
+		pmu_raw_writel(tmp, EXYNOS5_JPEG_MEM_OPTION);
 	}
 
 	/* Set value of power down register for sleep mode */
 
 	exynos_sys_powerdown_conf(SYS_SLEEP);
-	__raw_writel(S5P_CHECK_SLEEP, S5P_INFORM1);
+	pmu_raw_writel(S5P_CHECK_SLEEP, S5P_INFORM1);
 
 	/* ensure at least INFORM0 has the resume address */
 
-	__raw_writel(virt_to_phys(exynos_cpu_resume), S5P_INFORM0);
+	pmu_raw_writel(virt_to_phys(exynos_cpu_resume), S5P_INFORM0);
 }
 
 static void exynos_pm_central_suspend(void)
@@ -285,9 +289,9 @@ static void exynos_pm_central_suspend(void)
 	unsigned long tmp;
 
 	/* Setting Central Sequence Register for power down mode */
-	tmp = __raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
+	tmp = pmu_raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
 	tmp &= ~S5P_CENTRAL_LOWPWR_CFG;
-	__raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
+	pmu_raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
 }
 
 static int exynos_pm_suspend(void)
@@ -299,7 +303,7 @@ static int exynos_pm_suspend(void)
 	/* Setting SEQ_OPTION register */
 
 	tmp = (S5P_USE_STANDBY_WFI0 | S5P_USE_STANDBY_WFE0);
-	__raw_writel(tmp, S5P_CENTRAL_SEQ_OPTION);
+	pmu_raw_writel(tmp, S5P_CENTRAL_SEQ_OPTION);
 
 	if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A9)
 		exynos_cpu_save_register();
@@ -317,12 +321,12 @@ static int exynos_pm_central_resume(void)
 	 * S5P_CENTRAL_LOWPWR_CFG bit will not be set automatically
 	 * in this situation.
 	 */
-	tmp = __raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
+	tmp = pmu_raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
 	if (!(tmp & S5P_CENTRAL_LOWPWR_CFG)) {
 		tmp |= S5P_CENTRAL_LOWPWR_CFG;
-		__raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
+		pmu_raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
 		/* clear the wakeup state register */
-		__raw_writel(0x0, S5P_WAKEUP_STAT);
+		pmu_raw_writel(0x0, S5P_WAKEUP_STAT);
 		/* No need to perform below restore code */
 		return -1;
 	}
@@ -340,13 +344,13 @@ static void exynos_pm_resume(void)
 
 	/* For release retention */
 
-	__raw_writel((1 << 28), S5P_PAD_RET_MAUDIO_OPTION);
-	__raw_writel((1 << 28), S5P_PAD_RET_GPIO_OPTION);
-	__raw_writel((1 << 28), S5P_PAD_RET_UART_OPTION);
-	__raw_writel((1 << 28), S5P_PAD_RET_MMCA_OPTION);
-	__raw_writel((1 << 28), S5P_PAD_RET_MMCB_OPTION);
-	__raw_writel((1 << 28), S5P_PAD_RET_EBIA_OPTION);
-	__raw_writel((1 << 28), S5P_PAD_RET_EBIB_OPTION);
+	pmu_raw_writel((1 << 28), S5P_PAD_RET_MAUDIO_OPTION);
+	pmu_raw_writel((1 << 28), S5P_PAD_RET_GPIO_OPTION);
+	pmu_raw_writel((1 << 28), S5P_PAD_RET_UART_OPTION);
+	pmu_raw_writel((1 << 28), S5P_PAD_RET_MMCA_OPTION);
+	pmu_raw_writel((1 << 28), S5P_PAD_RET_MMCB_OPTION);
+	pmu_raw_writel((1 << 28), S5P_PAD_RET_EBIA_OPTION);
+	pmu_raw_writel((1 << 28), S5P_PAD_RET_EBIB_OPTION);
 
 	if (soc_is_exynos5250())
 		s3c_pm_do_restore(exynos5_sys_save,
@@ -360,7 +364,7 @@ static void exynos_pm_resume(void)
 early_wakeup:
 
 	/* Clear SLEEP mode set in INFORM1 */
-	__raw_writel(0x0, S5P_INFORM1);
+	pmu_raw_writel(0x0, S5P_INFORM1);
 
 	return;
 }
@@ -404,7 +408,7 @@ static int exynos_suspend_enter(suspend_state_t state)
 	s3c_pm_restore_uarts();
 
 	S3C_PMDBG("%s: wakeup stat: %08x\n", __func__,
-			__raw_readl(S5P_WAKEUP_STAT));
+			pmu_raw_readl(S5P_WAKEUP_STAT));
 
 	s3c_pm_check_restore();
 
@@ -475,9 +479,9 @@ void __init exynos_pm_init(void)
 	gic_arch_extn.irq_set_wake = exynos_irq_set_wake;
 
 	/* All wakeup disable */
-	tmp = __raw_readl(S5P_WAKEUP_MASK);
+	tmp = pmu_raw_readl(S5P_WAKEUP_MASK);
 	tmp |= ((0xFF << 8) | (0x1F << 1));
-	__raw_writel(tmp, S5P_WAKEUP_MASK);
+	pmu_raw_writel(tmp, S5P_WAKEUP_MASK);
 
 	register_syscore_ops(&exynos_pm_syscore_ops);
 	suspend_set_ops(&exynos_suspend_ops);
diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index dcfcb44..ff9d23f 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -18,7 +18,7 @@
 static const struct exynos_pmu_conf *exynos_pmu_config;
 
 static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
-	/* { .reg = address, .val = { AFTR, LPA, SLEEP } */
+	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } */
 	{ S5P_ARM_CORE0_LOWPWR,			{ 0x0, 0x0, 0x2 } },
 	{ S5P_DIS_IRQ_CORE0,			{ 0x0, 0x0, 0x0 } },
 	{ S5P_DIS_IRQ_CENTRAL0,			{ 0x0, 0x0, 0x0 } },
@@ -212,7 +212,7 @@ static const struct exynos_pmu_conf exynos4412_pmu_config[] = {
 };
 
 static const struct exynos_pmu_conf exynos5250_pmu_config[] = {
-	/* { .reg = address, .val = { AFTR, LPA, SLEEP } */
+	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } */
 	{ EXYNOS5_ARM_CORE0_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
 	{ EXYNOS5_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
 	{ EXYNOS5_DIS_IRQ_ARM_CORE0_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
@@ -315,7 +315,7 @@ static const struct exynos_pmu_conf exynos5250_pmu_config[] = {
 	{ PMU_TABLE_END,},
 };
 
-static void __iomem * const exynos5_list_both_cnt_feed[] = {
+static unsigned int const exynos5_list_both_cnt_feed[] = {
 	EXYNOS5_ARM_CORE0_OPTION,
 	EXYNOS5_ARM_CORE1_OPTION,
 	EXYNOS5_ARM_COMMON_OPTION,
@@ -329,7 +329,7 @@ static void __iomem * const exynos5_list_both_cnt_feed[] = {
 	EXYNOS5_TOP_PWR_SYSMEM_OPTION,
 };
 
-static void __iomem * const exynos5_list_diable_wfi_wfe[] = {
+static unsigned int const exynos5_list_diable_wfi_wfe[] = {
 	EXYNOS5_ARM_CORE1_OPTION,
 	EXYNOS5_FSYS_ARM_OPTION,
 	EXYNOS5_ISP_ARM_OPTION,
@@ -344,27 +344,27 @@ static void exynos5_init_pmu(void)
 	 * Enable both SC_FEEDBACK and SC_COUNTER
 	 */
 	for (i = 0 ; i < ARRAY_SIZE(exynos5_list_both_cnt_feed) ; i++) {
-		tmp = __raw_readl(exynos5_list_both_cnt_feed[i]);
+		tmp = pmu_raw_readl(exynos5_list_both_cnt_feed[i]);
 		tmp |= (EXYNOS5_USE_SC_FEEDBACK |
 			EXYNOS5_USE_SC_COUNTER);
-		__raw_writel(tmp, exynos5_list_both_cnt_feed[i]);
+		pmu_raw_writel(tmp, exynos5_list_both_cnt_feed[i]);
 	}
 
 	/*
 	 * SKIP_DEACTIVATE_ACEACP_IN_PWDN_BITFIELD Enable
 	 */
-	tmp = __raw_readl(EXYNOS5_ARM_COMMON_OPTION);
+	tmp = pmu_raw_readl(EXYNOS5_ARM_COMMON_OPTION);
 	tmp |= EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
-	__raw_writel(tmp, EXYNOS5_ARM_COMMON_OPTION);
+	pmu_raw_writel(tmp, EXYNOS5_ARM_COMMON_OPTION);
 
 	/*
 	 * Disable WFI/WFE on XXX_OPTION
 	 */
 	for (i = 0 ; i < ARRAY_SIZE(exynos5_list_diable_wfi_wfe) ; i++) {
-		tmp = __raw_readl(exynos5_list_diable_wfi_wfe[i]);
+		tmp = pmu_raw_readl(exynos5_list_diable_wfi_wfe[i]);
 		tmp &= ~(EXYNOS5_OPTION_USE_STANDBYWFE |
 			 EXYNOS5_OPTION_USE_STANDBYWFI);
-		__raw_writel(tmp, exynos5_list_diable_wfi_wfe[i]);
+		pmu_raw_writel(tmp, exynos5_list_diable_wfi_wfe[i]);
 	}
 }
 
@@ -375,14 +375,14 @@ void exynos_sys_powerdown_conf(enum sys_powerdown mode)
 	if (soc_is_exynos5250())
 		exynos5_init_pmu();
 
-	for (i = 0; (exynos_pmu_config[i].reg != PMU_TABLE_END) ; i++)
-		__raw_writel(exynos_pmu_config[i].val[mode],
-				exynos_pmu_config[i].reg);
+	for (i = 0; (exynos_pmu_config[i].offset != PMU_TABLE_END) ; i++)
+		pmu_raw_writel(exynos_pmu_config[i].val[mode],
+				exynos_pmu_config[i].offset);
 
 	if (soc_is_exynos4412()) {
-		for (i = 0; exynos4412_pmu_config[i].reg != PMU_TABLE_END ; i++)
-			__raw_writel(exynos4412_pmu_config[i].val[mode],
-				exynos4412_pmu_config[i].reg);
+		for (i = 0; exynos4412_pmu_config[i].offset != PMU_TABLE_END ; i++)
+			pmu_raw_writel(exynos4412_pmu_config[i].val[mode],
+					exynos4412_pmu_config[i].offset);
 	}
 }
 
@@ -403,13 +403,13 @@ static int __init exynos_pmu_init(void)
 		 * When SYS_WDTRESET is set, watchdog timer reset request
 		 * is ignored by power management unit.
 		 */
-		value = __raw_readl(EXYNOS5_AUTO_WDTRESET_DISABLE);
+		value = pmu_raw_readl(EXYNOS5_AUTO_WDTRESET_DISABLE);
 		value &= ~EXYNOS5_SYS_WDTRESET;
-		__raw_writel(value, EXYNOS5_AUTO_WDTRESET_DISABLE);
+		pmu_raw_writel(value, EXYNOS5_AUTO_WDTRESET_DISABLE);
 
-		value = __raw_readl(EXYNOS5_MASK_WDTRESET_REQUEST);
+		value = pmu_raw_readl(EXYNOS5_MASK_WDTRESET_REQUEST);
 		value &= ~EXYNOS5_SYS_WDTRESET;
-		__raw_writel(value, EXYNOS5_MASK_WDTRESET_REQUEST);
+		pmu_raw_writel(value, EXYNOS5_MASK_WDTRESET_REQUEST);
 
 		exynos_pmu_config = exynos5250_pmu_config;
 		pr_info("EXYNOS5250 PMU Initialize\n");
diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
index e5e298c..96a1569 100644
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ b/arch/arm/mach-exynos/regs-pmu.h
@@ -12,106 +12,102 @@
 #ifndef __ASM_ARCH_REGS_PMU_H
 #define __ASM_ARCH_REGS_PMU_H __FILE__
 
-#include <mach/map.h>
-
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
-
-#define S5P_WAKEUP_STAT				S5P_PMUREG(0x0600)
-#define S5P_EINT_WAKEUP_MASK			S5P_PMUREG(0x0604)
-#define S5P_WAKEUP_MASK				S5P_PMUREG(0x0608)
-
-#define S5P_INFORM0				S5P_PMUREG(0x0800)
-#define S5P_INFORM1				S5P_PMUREG(0x0804)
-#define S5P_INFORM5				S5P_PMUREG(0x0814)
-#define S5P_INFORM6				S5P_PMUREG(0x0818)
-#define S5P_INFORM7				S5P_PMUREG(0x081C)
-#define S5P_PMU_SPARE3				S5P_PMUREG(0x090C)
-
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
-
-#define EXYNOS_ARM_CORE0_CONFIGURATION		S5P_PMUREG(0x2000)
+#define EXYNOS_SWRESET				0x0400
+#define EXYNOS5440_SWRESET			0x00C4
+
+#define S5P_WAKEUP_STAT				0x0600
+#define S5P_EINT_WAKEUP_MASK			0x0604
+#define S5P_WAKEUP_MASK				0x0608
+
+#define S5P_INFORM0				0x0800
+#define S5P_INFORM1				0x0804
+#define S5P_INFORM5				0x0814
+#define S5P_INFORM6				0x0818
+#define S5P_INFORM7				0x081C
+#define S5P_PMU_SPARE3				0x090C
+
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
+
+#define EXYNOS_ARM_CORE0_CONFIGURATION		0x2000
 #define EXYNOS_ARM_CORE_CONFIGURATION(_nr)	\
 			(EXYNOS_ARM_CORE0_CONFIGURATION + (0x80 * (_nr)))
 #define EXYNOS_ARM_CORE_STATUS(_nr)		\
 			(EXYNOS_ARM_CORE_CONFIGURATION(_nr) + 0x4)
 
-#define EXYNOS_ARM_COMMON_CONFIGURATION		S5P_PMUREG(0x2500)
+#define EXYNOS_ARM_COMMON_CONFIGURATION		0x2500
 #define EXYNOS_COMMON_CONFIGURATION(_nr)	\
 			(EXYNOS_ARM_COMMON_CONFIGURATION + (0x80 * (_nr)))
 #define EXYNOS_COMMON_STATUS(_nr)		\
@@ -119,195 +115,195 @@
 #define EXYNOS_COMMON_OPTION(_nr)		\
 			(EXYNOS_COMMON_CONFIGURATION(_nr) + 0x8)
 
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
-
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
+
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
-
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
+
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
1.7.9.5

