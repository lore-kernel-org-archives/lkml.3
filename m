Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751193Ab3JAQUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:20:45 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:9412 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab3JAQUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 12:20:35 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-80-524af652d0c9
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
        Tyrtov Vyacheslav <v.tyrtov@samsung.com>
Subject: [PATCH 1/6] ARM: EXYNOS: Add support for EXYNOS5410 SoC
Date: Tue, 01 Oct 2013 20:17:02 +0400
Message-id: <1380644227-12244-2-git-send-email-v.tyrtov@samsung.com>
X-Mailer: git-send-email 1.8.1.5
In-reply-to: <1380644227-12244-1-git-send-email-v.tyrtov@samsung.com>
References: <1380644227-12244-1-git-send-email-v.tyrtov@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t/xy7pB37yCDF608FpMWneAyWLeZ1mL
	+UfOsVr8f/Sa1eLcq5WMFr0LrrJZbHp8jdViYdsSFovLu+awWcw4v4/J4vZlXoul1y8yWTyd
	cJHNYsL0tSwWh1cAzVj3cjqLxZafHYwWrw62sVisf36K0WLzpqnMFlNn/GB3EPVYM28No0dL
	cw+bx4LPV9g9/q56weyxcvkXNo9Xq2eyety5tofN4925c+wem5fUe7y6xuLRt2UVo8f2a/OY
	PT5vkvPYODc0gC+KyyYlNSezLLVI3y6BK6N53Xy2gmkaFT87mtkaGPuVuhg5OCQETCTuXPbt
	YuQEMsUkLtxbz9bFyMUhJLCUUWLF628sEE4Pk8T6Kw0sIFVsAnoSfa9ugNkiAgoSm3ufsYIU
	MQv8YpX4NPMEM0hCWMBB4sm1yYwgNouAqsSnVTvBbF4BF4npf9pZIdYpSBxte8sOcgWngKvE
	9uYakLAQUMnG5/vZJjDyLmBkWMUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kREjFfdzAuPWZ1
	iFGAg1GJh1fioVeQEGtiWXFl7iFGCQ5mJRFe+7NAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYwu
	K1JeHMnQbz6+dVXo1oMLeELTbFzbfZ6mmtex7VZ7t/9VjUNQkKBj6fONz359/XT8jmzM78Ir
	mSLH95/L8dk3z7rkbcC1uUlOz5i1VOdFWpwrDJb1eGBg3un47Kjg59k3FxZfMr3a9P2ptWuG
	cVlYLH/hj1m/HkxLev/2xq925/vsDawLKqYqsRRnJBpqMRcVJwIATP7bQXYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tarek Dakhran <t.dakhran@samsung.com>

EXYNOS5410 is SoC in Samsung's Exynos5 SoC series.
Add initial support for this SoC.

Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
---
 arch/arm/mach-exynos/Kconfig             | 10 ++++++++++
 arch/arm/mach-exynos/common.c            | 18 ++++++++++++++++++
 arch/arm/mach-exynos/include/mach/map.h  |  1 +
 arch/arm/mach-exynos/mach-exynos5-dt.c   |  1 +
 arch/arm/plat-samsung/include/plat/cpu.h |  8 ++++++++
 5 files changed, 38 insertions(+)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 56fe819..af7e787 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -84,6 +84,16 @@ config SOC_EXYNOS5250
 	help
 	  Enable EXYNOS5250 SoC support
 
+config SOC_EXYNOS5410
+	bool "SAMSUNG EXYNOS5410"
+	default y
+	depends on ARCH_EXYNOS5
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

