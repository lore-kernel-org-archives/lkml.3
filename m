Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab3LJOaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 09:30:25 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:11670 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab3LJOaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 09:30:20 -0500
X-AuditID: cbfec7f5-b7fd16d000007299-42-52a7257a94b3
From: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Heiko Stuebner <heiko@sntech.de>,
        Naour Romain <romain.naour@openwide.fr>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Tarek Dakhran <t.dakhran@samsung.com>,
        Tyrtov Vyacheslav <v.tyrtov@samsung.com>, Dave.Martin@arm.com,
        nicolas.pitre@linaro.org, tomasz.figa@gmail.com
Subject: [PATCH v5 1/3] ARM: EXYNOS: Add support for EXYNOS5410 SoC
Date: Tue, 10 Dec 2013 18:26:37 +0400
Message-id: <1386685599-31536-2-git-send-email-v.tyrtov@samsung.com>
X-Mailer: git-send-email 1.8.1.5
In-reply-to: <1386685599-31536-1-git-send-email-v.tyrtov@samsung.com>
References: <1386685599-31536-1-git-send-email-v.tyrtov@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsVy+t/xa7pVqsuDDL40qFhMWneAyWLeZ1mL
	prl7GC3mHznHavH/0WtWi3OvVjJa9C64ymax6fE1VouFbUtYLC7vmsNmMeP8PiaL25d5LZZe
	v8hk8XTCRTaLT8/+sVtMmL6WxeLwCqBp615OZ7HY8rOD0eLVwTYWi/XPTzFabN40ldli1a4/
	jBZTZ/xgd5DwWDNvDaNHS3MPm8eCz1fYPf6uesHssXPWXXaPlcu/sHm8Wj2T1ePOtT1sHu/O
	nWP32Lyk3uPVNRaPvi2rGD22X5vH7PF5k5zHxrmhAfxRXDYpqTmZZalF+nYJXBlzLwUW/Deo
	uPp2I0sD40nNLkZODgkBE4nuydPZIWwxiQv31rN1MXJxCAksZZRYuHQpI0hCSKCHSeLcfDcQ
	m01AT6Lv1Q0WEFtEQEFic+8zVpAGZoFDbBKv799lBkkICzhL/JxwFmwqi4CqxISuuWA2r4CL
	xNq2aawQ2xQkjra9BYtzCrhKzOy5zQyxzEXi0ZKTbBMYeRcwMqxiFE0tTS4oTkrPNdIrTswt
	Ls1L10vOz93ECImsrzsYlx6zOsQowMGoxMMr8W9pkBBrYllxZe4hRgkOZiUR3m0vlgUJ8aYk
	VlalFuXHF5XmpBYfYmTi4JRqYGx+XXZT+NiLy2+2fe8U2FDjc/kyt9bHT795Zjxz2SRZpSHW
	wWDbImv4JH2pULlLxdPjWQ9/b1WPFwqO2h8rIL+un2tjmbnat2/y6yU04mcmTavftbir2eAw
	J/PTRToiHkqeyZv4Xomeyni/s9Wg/mPJ3pnS1ieL3pionXi05890v9yqBQtOliqxFGckGmox
	FxUnAgA8U3CKigIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tarek Dakhran <t.dakhran@samsung.com>

EXYNOS5410 is SoC in Samsung's Exynos5 SoC series.
Add initial support for this SoC.

Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
---
 arch/arm/mach-exynos/Kconfig                 | 10 ++++++++++
 arch/arm/mach-exynos/common.c                | 18 ++++++++++++++++++
 arch/arm/mach-exynos/include/mach/map.h      |  1 +
 arch/arm/mach-exynos/mach-exynos5-dt.c       |  1 +
 arch/arm/mach-exynos/platsmp.c               |  2 ++
 arch/arm/plat-samsung/include/plat/cpu.h     |  8 ++++++++
 arch/arm/plat-samsung/include/plat/map-s5p.h |  3 +++
 7 files changed, 43 insertions(+)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index f9d67a0..1414bc6 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -93,6 +93,16 @@ config SOC_EXYNOS5250
 	help
 	  Enable EXYNOS5250 SoC support
 
+config SOC_EXYNOS5410
+	bool "SAMSUNG EXYNOS5410"
+	default y
+	depends on ARCH_EXYNOS5
+	select PM_GENERIC_DOMAINS if PM_RUNTIME
+	select S5P_PM if PM_SLEEP
+	select S5P_SLEEP if PM_SLEEP
+	help
+	  Enable EXYNOS5410 SoC support
+
 config SOC_EXYNOS5420
 	bool "SAMSUNG EXYNOS5420"
 	default y
diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
index 61d2906..4768608 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -52,6 +52,7 @@ static const char name_exynos4210[] = "EXYNOS4210";
 static const char name_exynos4212[] = "EXYNOS4212";
 static const char name_exynos4412[] = "EXYNOS4412";
 static const char name_exynos5250[] = "EXYNOS5250";
+static const char name_exynos5410[] = "EXYNOS5410";
 static const char name_exynos5420[] = "EXYNOS5420";
 static const char name_exynos5440[] = "EXYNOS5440";
 
@@ -85,6 +86,12 @@ static struct cpu_table cpu_ids[] __initdata = {
 		.init		= exynos_init,
 		.name		= name_exynos5250,
 	}, {
+		.idcode		= EXYNOS5410_SOC_ID,
+		.idmask		= EXYNOS5_SOC_MASK,
+		.map_io		= exynos5_map_io,
+		.init		= exynos_init,
+		.name		= name_exynos5410,
+	}, {
 		.idcode		= EXYNOS5420_SOC_ID,
 		.idmask		= EXYNOS5_SOC_MASK,
 		.map_io		= exynos5_map_io,
@@ -215,6 +222,15 @@ static struct map_desc exynos4x12_iodesc[] __initdata = {
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
 static struct map_desc exynos5250_iodesc[] __initdata = {
 	{
 		.virtual	= (unsigned long)S5P_VA_SYSRAM_NS,
@@ -374,6 +390,8 @@ static void __init exynos5_map_io(void)
 
 	if (soc_is_exynos5250())
 		iotable_init(exynos5250_iodesc, ARRAY_SIZE(exynos5250_iodesc));
+	if (soc_is_exynos5410())
+		iotable_init(exynos5410_iodesc, ARRAY_SIZE(exynos5410_iodesc));
 }
 
 struct bus_type exynos_subsys = {
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
 
diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
index 1fe075a..7f78f66 100644
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@ -50,6 +50,7 @@ static void __init exynos5_dt_machine_init(void)
 
 static char const *exynos5_dt_compat[] __initdata = {
 	"samsung,exynos5250",
+	"samsung,exynos5410",
 	"samsung,exynos5420",
 	"samsung,exynos5440",
 	NULL
diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 58b43e6..6506ce6 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -40,6 +40,8 @@ static inline void __iomem *cpu_boot_reg_base(void)
 {
 	if (soc_is_exynos4210() && samsung_rev() == EXYNOS4210_REV_1_1)
 		return S5P_INFORM5;
+	if (soc_is_exynos5410())
+		return EXYNOS5410_BOOT_REG;
 	return S5P_VA_SYSRAM;
 }
 
diff --git a/arch/arm/plat-samsung/include/plat/cpu.h b/arch/arm/plat-samsung/include/plat/cpu.h
index 335beb3..8f09488 100644
--- a/arch/arm/plat-samsung/include/plat/cpu.h
+++ b/arch/arm/plat-samsung/include/plat/cpu.h
@@ -46,6 +46,7 @@ extern unsigned long samsung_cpu_id;
 #define EXYNOS4_CPU_MASK	0xFFFE0000
 
 #define EXYNOS5250_SOC_ID	0x43520000
+#define EXYNOS5410_SOC_ID	0xE5410000
 #define EXYNOS5420_SOC_ID	0xE5420000
 #define EXYNOS5440_SOC_ID	0xE5440000
 #define EXYNOS5_SOC_MASK	0xFFFFF000
@@ -68,6 +69,7 @@ IS_SAMSUNG_CPU(exynos4210, EXYNOS4210_CPU_ID, EXYNOS4_CPU_MASK)
 IS_SAMSUNG_CPU(exynos4212, EXYNOS4212_CPU_ID, EXYNOS4_CPU_MASK)
 IS_SAMSUNG_CPU(exynos4412, EXYNOS4412_CPU_ID, EXYNOS4_CPU_MASK)
 IS_SAMSUNG_CPU(exynos5250, EXYNOS5250_SOC_ID, EXYNOS5_SOC_MASK)
+IS_SAMSUNG_CPU(exynos5410, EXYNOS5410_SOC_ID, EXYNOS5_SOC_MASK)
 IS_SAMSUNG_CPU(exynos5420, EXYNOS5420_SOC_ID, EXYNOS5_SOC_MASK)
 IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS5_SOC_MASK)
 
@@ -148,6 +150,12 @@ IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS5_SOC_MASK)
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
diff --git a/arch/arm/plat-samsung/include/plat/map-s5p.h b/arch/arm/plat-samsung/include/plat/map-s5p.h
index c186786..31cac97 100644
--- a/arch/arm/plat-samsung/include/plat/map-s5p.h
+++ b/arch/arm/plat-samsung/include/plat/map-s5p.h
@@ -57,6 +57,9 @@
 #define S3C_UART_OFFSET		(0x400)
 #endif
 
+#define S5P_VA_SYSRAM_NS_X(x)	(S5P_VA_SYSRAM_NS + (x))
+#define EXYNOS5410_BOOT_REG	S5P_VA_SYSRAM_NS_X(0x1c)
+
 #include <plat/map-s3c.h>
 
 #endif /* __ASM_PLAT_MAP_S5P_H */
-- 
1.8.1.5

