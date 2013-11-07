Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab3KGIRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 03:17:11 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61461 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3KGIQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 03:16:50 -0500
X-AuditID: cbfec7f5-b7ef66d00000795a-6b-527b4c706328
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
Subject: [PATCH v3 1/4] ARM: EXYNOS: Add support for EXYNOS5410 SoC
Date: Thu, 07 Nov 2013 12:12:46 +0400
Message-id: <1383811969-32712-2-git-send-email-v.tyrtov@samsung.com>
X-Mailer: git-send-email 1.8.1.5
In-reply-to: <1383811969-32712-1-git-send-email-v.tyrtov@samsung.com>
References: <1383811969-32712-1-git-send-email-v.tyrtov@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t/xq7oFPtVBBr/uCFhMWneAyWLeZ1mL
	prl7GC3mHznHavH/0WtWi3OvVjJa9C64ymax6fE1VouFbUtYLC7vmsNmMeP8PiaL25d5LZZe
	v8hk8XTCRTaLT8/+sVtMmL6WxeLwCqBp615OZ7HY8rOD0eLVwTYWi/XPTzFabN40ldli1a4/
	jBZTZ/xgd5DwWDNvDaNHS3MPm8eCz1fYPf6uesHssXPWXXaPlcu/sHm8Wj2T1ePOtT1sHu/O
	nWP32Lyk3uPVNRaPvi2rGD22X5vH7PF5k5zHxrmhAfxRXDYpqTmZZalF+nYJXBmX7k5kKdip
	UdF19ghTA+MqpS5GTg4JAROJeTOmsELYYhIX7q1n62Lk4hASWMoocWZ6DzuE08Mk8fD6e7Aq
	NgE9ib5XN1hAbBEBBYnNvc9YQYqYBQ6xSby+f5cZJCEs4CzxdO5rMJtFQFXibedKJhCbV8BF
	Yv6yOewQ6xQkjra9BbM5BVwlft6bA7SaA2ibi8Sa9qgJjLwLGBlWMYqmliYXFCel5xrpFSfm
	Fpfmpesl5+duYoTE1tcdjEuPWR1iFOBgVOLhnVFTFSTEmlhWXJl7iFGCg1lJhNfcqDpIiDcl
	sbIqtSg/vqg0J7X4ECMTB6dUA2PgFlubaJaoP7lyHn+S17zUdtjSeYNr3gfVokMXrD3zHULl
	5voJJM76c6o93N16ysSvz53/WLw7tWDfkv+/eLR2NLl8mL1QSdhcI9Lll1sFb9SeWev5f0ol
	6bfUsXYvPNRY1rXMjPXaXq2TTqsnFyy4+SFqXcueWwxXN0w+s7BBll2QYyXLSXMlluKMREMt
	5qLiRADacEvDiwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tarek Dakhran <t.dakhran@samsung.com>

EXYNOS5410 is SoC in Samsung's Exynos5 SoC series.
Add initial support for this SoC.

Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
---
 arch/arm/mach-exynos/Kconfig             | 12 ++++++++++++
 arch/arm/mach-exynos/common.c            | 18 ++++++++++++++++++
 arch/arm/mach-exynos/include/mach/map.h  |  1 +
 arch/arm/mach-exynos/mach-exynos5-dt.c   |  1 +
 arch/arm/plat-samsung/include/plat/cpu.h |  8 ++++++++
 5 files changed, 40 insertions(+)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 56fe819..9ea1799 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -84,6 +84,18 @@ config SOC_EXYNOS5250
 	help
 	  Enable EXYNOS5250 SoC support
 
+config SOC_EXYNOS5410
+	bool "SAMSUNG EXYNOS5410"
+	default y
+	depends on ARCH_EXYNOS5
+	select MCPM
+	select ARM_CCI
+	select PM_GENERIC_DOMAINS if PM
+	select S5P_PM if PM
+	select S5P_SLEEP if PM
+	help
+	  Enable EXYNOS5410 SoC support
+
 config SOC_EXYNOS5420
 	bool "SAMSUNG EXYNOS5420"
 	default y
diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
index ba95e5d..187c0a4 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -53,6 +53,7 @@ static const char name_exynos4210[] = "EXYNOS4210";
 static const char name_exynos4212[] = "EXYNOS4212";
 static const char name_exynos4412[] = "EXYNOS4412";
 static const char name_exynos5250[] = "EXYNOS5250";
+static const char name_exynos5410[] = "EXYNOS5410";
 static const char name_exynos5420[] = "EXYNOS5420";
 static const char name_exynos5440[] = "EXYNOS5440";
 
@@ -86,6 +87,12 @@ static struct cpu_table cpu_ids[] __initdata = {
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
@@ -216,6 +223,15 @@ static struct map_desc exynos4x12_iodesc[] __initdata = {
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
@@ -365,6 +381,8 @@ static void __init exynos5_map_io(void)
 
 	if (soc_is_exynos5250())
 		iotable_init(exynos5250_iodesc, ARRAY_SIZE(exynos5250_iodesc));
+	if (soc_is_exynos5410())
+		iotable_init(exynos5410_iodesc, ARRAY_SIZE(exynos5410_iodesc));
 }
 
 void __init exynos_init_time(void)
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
index f874b77..9515186 100644
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@ -52,6 +52,7 @@ static void __init exynos5_dt_machine_init(void)
 
 static char const *exynos5_dt_compat[] __initdata = {
 	"samsung,exynos5250",
+	"samsung,exynos5410",
 	"samsung,exynos5420",
 	"samsung,exynos5440",
 	NULL
diff --git a/arch/arm/plat-samsung/include/plat/cpu.h b/arch/arm/plat-samsung/include/plat/cpu.h
index 4fb1f03..aad7c40 100644
--- a/arch/arm/plat-samsung/include/plat/cpu.h
+++ b/arch/arm/plat-samsung/include/plat/cpu.h
@@ -46,6 +46,7 @@ extern unsigned long samsung_cpu_id;
 #define EXYNOS4_CPU_MASK	0xFFFE0000
 
 #define EXYNOS5250_SOC_ID	0x43520000
+#define EXYNOS5410_SOC_ID	0xE5410023
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
 
@@ -144,6 +146,12 @@ IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS5_SOC_MASK)
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
-- 
1.8.1.5

