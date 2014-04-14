Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaDNHSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:18:18 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:44124 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbaDNHSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:18:04 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-52-534b8ba97429
From: Tarek Dakhran <t.dakhran@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Romain Naour <romain.naour@openwide.fr>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Tarek Dakhran <t.dakhran@gmail.com>,
        Tarek Dakhran <t.dakhran@samsung.com>
Subject: [PATCH v8 1/3] ARM: EXYNOS: Add support for EXYNOS5410 SoC
Date: Mon, 14 Apr 2014 11:17:38 +0400
Message-id: <1397459860-21869-2-git-send-email-t.dakhran@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397459860-21869-1-git-send-email-t.dakhran@samsung.com>
References: <1397459860-21869-1-git-send-email-t.dakhran@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsVy+t/xq7oru72DDX7d17WYtO4Ak8XD9TdZ
	LOYfOcdq0f9mIavF/0evWS3OvVrJaNG74CqbxdmmN+wWmx5fY7VY2LaExeLyrjlsFjPO72Oy
	uH2Z12Lp9YtMFk8nXGSzmDB9LYvFupfTWSxa9x5ht9jys4PR4nfPJ2aL9c9PMVqsn/GaxeLY
	jCWMFlNn/GB3kPBYM28No0dLcw+bx+W+XiaPv6teMHvsnHWX3WPl8i9sHptWdbJ5vFo9k9Xj
	zrU9bB6bl9R7vLrG4tG3ZRWjx/Zr85g9Pm+SC+CL4rJJSc3JLEst0rdL4Mq4uf0je8FRy4rT
	u08zNzBeMOhi5OSQEDCRmDZzPTuELSZx4d56ti5GLg4hgaWMEhvmX2KBcDqZJE5MXsPaxcjB
	wSagLbFlhxdIg4iAgsTm3mesIDXMAp/YJH6samICSQgLOEtcuHmBDaSeRUBV4vwyAxCTV8BV
	YuujTBBTAqh1ziQbkGJOATeJjd9WMIPYQkAV36btY5/AyLuAkWEVo2hqaXJBcVJ6rpFecWJu
	cWleul5yfu4mRkg8fd3BuPSY1SFGAQ5GJR5ejq2ewUKsiWXFlbmHGCU4mJVEeLdleAUL8aYk
	VlalFuXHF5XmpBYfYmTi4JRqYLxddo5X/1O5xaOCBXZrt/6c/cqvrJFTsEd61rVTiwqaOUpP
	cDedjtWZFrvsjGdb1H8vbd2D1Wej89Yv31U+O8oy+CdTzOyOnrK1SW8sNA2+hYd7maW2MFku
	Mp5u6Nko4cGfn2LYnXGPP3fVpGLJ5WFhv2znr5fmCU5YIXfVUijEf9/+pfu2KrEUZyQaajEX
	FScCAGXvaqqFAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXYNOS5410 is SoC in Samsung's Exynos5 SoC series.
Add initial support for this SoC.

Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/Kconfig             |    8 ++++++++
 arch/arm/mach-exynos/exynos.c            |   12 ++++++++++++
 arch/arm/mach-exynos/hotplug.c           |    4 ++--
 arch/arm/mach-exynos/include/mach/map.h  |    1 +
 arch/arm/mach-exynos/platsmp.c           |   10 +++++++---
 arch/arm/mach-exynos/regs-pmu.h          |    4 ++--
 arch/arm/plat-samsung/include/plat/cpu.h |   11 ++++++++++-
 7 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index fc8bf18..92f2593 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -84,6 +84,14 @@ config SOC_EXYNOS5250
 	help
 	  Enable EXYNOS5250 SoC support
 
+config SOC_EXYNOS5410
+	bool "SAMSUNG EXYNOS5410"
+	default y
+	depends on ARCH_EXYNOS5
+	select PM_GENERIC_DOMAINS if PM_RUNTIME
+	help
+	  Enable EXYNOS5410 SoC support
+
 config SOC_EXYNOS5420
 	bool "SAMSUNG EXYNOS5420"
 	default y
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index b32a907..fdb3fb5 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -159,6 +159,15 @@ static struct map_desc exynos5250_iodesc[] __initdata = {
 	},
 };
 
+static struct map_desc exynos5410_iodesc[] __initdata = {
+	{
+		.virtual	= (unsigned long)S5P_VA_SYSRAM_NS,
+		.pfn		= __phys_to_pfn(EXYNOS5410_PA_SYSRAM_NS),
+		.length		= SZ_4K,
+		.type		= MT_DEVICE,
+	},
+};
+
 static struct map_desc exynos5_iodesc[] __initdata = {
 	{
 		.virtual	= (unsigned long)S3C_VA_SYS,
@@ -294,6 +303,8 @@ static void __init exynos_map_io(void)
 		iotable_init(exynos4x12_iodesc, ARRAY_SIZE(exynos4x12_iodesc));
 	if (soc_is_exynos5250())
 		iotable_init(exynos5250_iodesc, ARRAY_SIZE(exynos5250_iodesc));
+	if (soc_is_exynos5410())
+		iotable_init(exynos5410_iodesc, ARRAY_SIZE(exynos5410_iodesc));
 }
 
 void __init exynos_init_io(void)
@@ -376,6 +387,7 @@ static char const *exynos_dt_compat[] __initconst = {
 	"samsung,exynos4412",
 	"samsung,exynos5",
 	"samsung,exynos5250",
+	"samsung,exynos5410",
 	"samsung,exynos5420",
 	"samsung,exynos5440",
 	NULL
diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index 5eead53..83ae5fb 100644
--- a/arch/arm/mach-exynos/hotplug.c
+++ b/arch/arm/mach-exynos/hotplug.c
@@ -95,8 +95,8 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
 	for (;;) {
 
 		/* make cpu1 to be turned off at next WFI command */
-		if (cpu == 1)
-			__raw_writel(0, S5P_ARM_CORE1_CONFIGURATION);
+		if (cpu > 0)
+			__raw_writel(0, S5P_ARM_CORE_CONFIGURATION(cpu));
 
 		/*
 		 * here's the WFI
diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
index 7b046b5..894f431 100644
--- a/arch/arm/mach-exynos/include/mach/map.h
+++ b/arch/arm/mach-exynos/include/mach/map.h
@@ -29,6 +29,7 @@
 #define EXYNOS4210_PA_SYSRAM_NS		0x0203F000
 #define EXYNOS4x12_PA_SYSRAM_NS		0x0204F000
 #define EXYNOS5250_PA_SYSRAM_NS		0x0204F000
+#define EXYNOS5410_PA_SYSRAM_NS		0x02073000
 
 #define EXYNOS_PA_CHIPID		0x10000000
 
diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 03e5e9f..dce2841 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -37,6 +37,8 @@ static inline void __iomem *cpu_boot_reg_base(void)
 {
 	if (soc_is_exynos4210() && samsung_rev() == EXYNOS4210_REV_1_1)
 		return S5P_INFORM5;
+	if (soc_is_exynos5410())
+		return S5P_VA_SYSRAM_NS;
 	return S5P_VA_SYSRAM;
 }
 
@@ -47,6 +49,8 @@ static inline void __iomem *cpu_boot_reg(int cpu)
 	boot_reg = cpu_boot_reg_base();
 	if (soc_is_exynos4412())
 		boot_reg += 4*cpu;
+	else if (soc_is_exynos5410())
+		boot_reg += (0x1c);
 	else if (soc_is_exynos5420())
 		boot_reg += 4;
 	return boot_reg;
@@ -107,14 +111,14 @@ static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
 	 */
 	write_pen_release(phys_cpu);
 
-	if (!(__raw_readl(S5P_ARM_CORE1_STATUS) & S5P_CORE_LOCAL_PWR_EN)) {
+	if (!(__raw_readl(S5P_ARM_CORE_STATUS(cpu)) & S5P_CORE_LOCAL_PWR_EN)) {
 		__raw_writel(S5P_CORE_LOCAL_PWR_EN,
-			     S5P_ARM_CORE1_CONFIGURATION);
+			     S5P_ARM_CORE_CONFIGURATION(cpu));
 
 		timeout = 10;
 
 		/* wait max 10 ms until cpu1 is on */
-		while ((__raw_readl(S5P_ARM_CORE1_STATUS)
+		while ((__raw_readl(S5P_ARM_CORE_STATUS(cpu))
 			& S5P_CORE_LOCAL_PWR_EN) != S5P_CORE_LOCAL_PWR_EN) {
 			if (timeout-- == 0)
 				break;
diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
index 4f6a256..14d62cb 100644
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ b/arch/arm/mach-exynos/regs-pmu.h
@@ -105,8 +105,8 @@
 #define S5P_GPS_LOWPWR				S5P_PMUREG(0x139C)
 #define S5P_GPS_ALIVE_LOWPWR			S5P_PMUREG(0x13A0)
 
-#define S5P_ARM_CORE1_CONFIGURATION		S5P_PMUREG(0x2080)
-#define S5P_ARM_CORE1_STATUS			S5P_PMUREG(0x2084)
+#define S5P_ARM_CORE_CONFIGURATION(x)		S5P_PMUREG(0x2000 + (x) * 0x80)
+#define S5P_ARM_CORE_STATUS(x)			S5P_PMUREG(0x2004 + (x) * 0x80)
 
 #define S5P_PAD_RET_MAUDIO_OPTION		S5P_PMUREG(0x3028)
 #define S5P_PAD_RET_GPIO_OPTION			S5P_PMUREG(0x3108)
diff --git a/arch/arm/plat-samsung/include/plat/cpu.h b/arch/arm/plat-samsung/include/plat/cpu.h
index 5992b8d..21db380 100644
--- a/arch/arm/plat-samsung/include/plat/cpu.h
+++ b/arch/arm/plat-samsung/include/plat/cpu.h
@@ -49,6 +49,7 @@ extern unsigned long samsung_cpu_id;
 #define EXYNOS4_CPU_MASK	0xFFFE0000
 
 #define EXYNOS5250_SOC_ID	0x43520000
+#define EXYNOS5410_SOC_ID	0xE5410000
 #define EXYNOS5420_SOC_ID	0xE5420000
 #define EXYNOS5440_SOC_ID	0xE5440000
 #define EXYNOS5_SOC_MASK	0xFFFFF000
@@ -72,6 +73,7 @@ IS_SAMSUNG_CPU(exynos4210, EXYNOS4210_CPU_ID, EXYNOS4_CPU_MASK)
 IS_SAMSUNG_CPU(exynos4212, EXYNOS4212_CPU_ID, EXYNOS4_CPU_MASK)
 IS_SAMSUNG_CPU(exynos4412, EXYNOS4412_CPU_ID, EXYNOS4_CPU_MASK)
 IS_SAMSUNG_CPU(exynos5250, EXYNOS5250_SOC_ID, EXYNOS5_SOC_MASK)
+IS_SAMSUNG_CPU(exynos5410, EXYNOS5410_SOC_ID, EXYNOS5_SOC_MASK)
 IS_SAMSUNG_CPU(exynos5420, EXYNOS5420_SOC_ID, EXYNOS5_SOC_MASK)
 IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS5_SOC_MASK)
 
@@ -154,6 +156,12 @@ IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS5_SOC_MASK)
 # define soc_is_exynos5250()	0
 #endif
 
+#if defined(CONFIG_SOC_EXYNOS5410)
+# define soc_is_exynos5410()	is_samsung_exynos5410()
+#else
+# define soc_is_exynos5410()	0
+#endif
+
 #if defined(CONFIG_SOC_EXYNOS5420)
 # define soc_is_exynos5420()	is_samsung_exynos5420()
 #else
@@ -168,7 +176,8 @@ IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS5_SOC_MASK)
 
 #define soc_is_exynos4() (soc_is_exynos4210() || soc_is_exynos4212() || \
 			  soc_is_exynos4412())
-#define soc_is_exynos5() (soc_is_exynos5250() || soc_is_exynos5420())
+#define soc_is_exynos5() (soc_is_exynos5250() || soc_is_exynos5410() || \
+			  soc_is_exynos5420())
 
 #define IODESC_ENT(x) { (unsigned long)S3C24XX_VA_##x, __phys_to_pfn(S3C24XX_PA_##x), S3C24XX_SZ_##x, MT_DEVICE }
 
-- 
1.7.9.5

