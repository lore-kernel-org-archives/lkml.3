Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbaD3FCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 01:02:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:47142 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaD3E7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 00:59:44 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-37-5360833e0c9a
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v3 07/12] ARM: EXYNOS: Add support for mapping PMU base address
 via DT
Date: Wed, 30 Apr 2014 14:17:32 +0900
Message-id: <1398835057-3860-8-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
References: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t8zQ1275oRgg/krdCyWTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wm6xfsZrFoubz7YzWexoWc3iwOXR0tzD5rF5Sb1H
	35ZVjB6fN8kFsERx2aSk5mSWpRbp2yVwZXzvO8tesFKm4uImqwbGk+JdjJwcEgImEs+WH2KC
	sMUkLtxbz9bFyMUhJLCMUWLpnzcsMEWP1s1mgUgsYpTo/9/KBOG0MUk8vj6fFaSKTUBX4sn7
	ucwgtohAtsSVxvvMIEXMArsZJRob57GBJIQFIiRW7+wB6ubgYBFQlTjdoAYS5hVwl7h1oRUs
	LCGgIDFnkg1ImFPAQ2Lh7d9g44WAShoaehhBRkoIrGKX6N1/C2wXi4CAxLfJh1ggemUlNh1g
	hjhaUuLgihssExiFFzAyrGIUTS1ILihOSi8y1CtOzC0uzUvXS87P3cQICfreHYy3D1gfYkwG
	GjeRWUo0OR8YNXkl8YbGZkYWpiamxkbmlmakCSuJ8yY9TAoSEkhPLEnNTk0tSC2KLyrNSS0+
	xMjEwSnVwKjf+f5u275j3DeEzu9W3OrpcOxjXWft2bVLPrHX7mDqDP377ebuDluFbRku+wXY
	Vy4Kb/z9OIjho/CcEjHjux86tsXoKGiwL648I7Wk5ii//nz+AgP3CVf3mWm8WXXq94lo568x
	he+aCr7Z/S/7kxWfKKcWyZjYu+Hi/J/JEorKHi9n2h9cHafEUpyRaKjFXFScCAB5qQILkAIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jAV275oRgg22v1SyWTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wm6xfsZrFoubz7YzWexoWc3iwOXR0tzD5rF5Sb1H
	35ZVjB6fN8kFsEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5
	+AToumXmAN2jpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8z43neWvWCl
	TMXFTVYNjCfFuxg5OSQETCQerZvNAmGLSVy4t56ti5GLQ0hgEaNE//9WJginjUni8fX5rCBV
	bAK6Ek/ez2UGsUUEsiWuNN5nBiliFtjNKNHYOI8NJCEsECGxemcPUDcHB4uAqsTpBjWQMK+A
	u8StC61gYQkBBYk5k2xAwpwCHhILb/8GGy8EVNLQ0MM4gZF3ASPDKkbR1ILkguKk9FwjveLE
	3OLSvHS95PzcTYzgmHomvYNxVYPFIUYBDkYlHl6BrfHBQqyJZcWVuYcYJTiYlUR4z1cmBAvx
	piRWVqUW5ccXleakFh9iTAa6aSKzlGhyPjDe80riDY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgk
	kJ5YkpqdmlqQWgSzhYmDU6qBUeDJF+WD0dLNfRr93+/YbFxiu7do73pJ5u8FxsJ6gt2K7/Y+
	k2eMkrzmr6+bzdfDvP/uVibLFMGO55cr8mq7I7y9ihu/BOaW+LGcay9vV/ytyiwgfHsL95Wo
	SKVEs+gZrMUzfCYoealw2DA94HWfJlm+qmTtq9hDkakuvNNvSh/uNosLv6DEUpyRaKjFXFSc
	CAARUiQ17QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Young-Gun Jang <yg1004.jang@samsung.com>

Add support for mapping Samsung Power Management Unit (PMU)
base address from device tree. This patch also adds helper
function as "get_exynos_pmuregmap". This function can be used
by other machine files such as "pm.c", "hotplug.c" for accessing
PMU regmap handle.

Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/Kconfig  |    2 ++
 arch/arm/mach-exynos/common.h |    2 ++
 arch/arm/mach-exynos/exynos.c |   39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index fc8bf18..2f60c90 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -26,6 +26,7 @@ config ARCH_EXYNOS4
 	select PINCTRL
 	select PM_GENERIC_DOMAINS if PM_RUNTIME
 	select S5P_DEV_MFC
+	select MFD_SYSCON
 	help
 	  Samsung EXYNOS4 SoCs based systems
 
@@ -36,6 +37,7 @@ config ARCH_EXYNOS5
 	select HAVE_ARM_SCU if SMP
 	select HAVE_SMP
 	select PINCTRL
+	select MFD_SYSCON
 	help
 	  Samsung EXYNOS5 (Cortex-A15) SoC based systems
 
diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 8a4aa0b..33a2bee 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -55,4 +55,6 @@ struct exynos_pmu_conf {
 extern void exynos_sys_powerdown_conf(enum sys_powerdown mode);
 extern void exynos_enter_aftr(void);
 
+extern struct regmap *get_exynos_pmuregmap(void);
+
 #endif /* __ARCH_ARM_MACH_EXYNOS_COMMON_H */
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index a7b45db..9045fd6 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -19,6 +19,7 @@
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/pm_domain.h>
+#include <linux/mfd/syscon.h>
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -36,6 +37,8 @@
 #define L2_AUX_VAL 0x7C470001
 #define L2_AUX_MASK 0xC200ffff
 
+static struct regmap *exynos_pmu_regmap;
+
 static struct map_desc exynos4_iodesc[] __initdata = {
 	{
 		.virtual	= (unsigned long)S3C_VA_SYS,
@@ -260,6 +263,14 @@ static int __init exynos_fdt_map_chipid(unsigned long node, const char *uname,
 	return 1;
 }
 
+static const struct of_device_id exynos_dt_pmu_match[] = {
+	{ .compatible = "samsung,exynos4210-pmu" },
+	{ .compatible = "samsung,exynos4212-pmu" },
+	{ .compatible = "samsung,exynos4412-pmu" },
+	{ .compatible = "samsung,exynos5250-pmu" },
+	{},
+};
+
 /*
  * exynos_map_io
  *
@@ -327,6 +338,32 @@ static int __init exynos4_l2x0_cache_init(void)
 }
 early_initcall(exynos4_l2x0_cache_init);
 
+
+struct regmap *get_exynos_pmuregmap()
+{
+	return exynos_pmu_regmap;
+}
+
+void __init exynos_map_pmu(void)
+{
+	struct device_node *np = NULL;
+
+	early_syscon_init();
+
+	np = of_find_matching_node(NULL, exynos_dt_pmu_match);
+
+	if (!np) {
+		pr_err("Failed to find PMU node\n");
+		return;
+	} else {
+		exynos_pmu_regmap = syscon_early_regmap_lookup_by_phandle(np,
+				"samsung,syscon-phandle");
+	}
+
+	if (IS_ERR(exynos_pmu_regmap))
+		pr_err("failed to find exynos_pmu_regmap\n");
+}
+
 static void __init exynos_dt_machine_init(void)
 {
 	struct device_node *i2c_np;
@@ -355,6 +392,8 @@ static void __init exynos_dt_machine_init(void)
 		}
 	}
 
+	exynos_map_pmu();
+
 	if (!soc_is_exynos5440())
 		platform_device_register(&exynos_cpuidle);
 
-- 
1.7.10.4

