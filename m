Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbaEJGlN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 02:41:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44378 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbaEJGi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 02:38:28 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-ef-536dc9622aa4
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v4 06/11] ARM: EXYNOS: Add support for mapping PMU base address
 via DT
Date: Sat, 10 May 2014 15:56:33 +0900
Message-id: <1399704998-13321-7-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t8zI92kk7nBBl3LNS2WTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wm6xfsZrFoubz7YzWexoWc3iwOXR0tzD5rF5Sb1H
	35ZVjB6fN8kFsERx2aSk5mSWpRbp2yVwZdy/uoa9YIpUxZ37a9gbGK+LdjFycEgImEh8/RrU
	xcgJZIpJXLi3nq2LkYtDSGAZo8SnY69YIRImEo/PbmOESExnlJj5ciFUVRuTRPudycwgVWwC
	uhJP3s8Fs0UEsiWuNN5nBiliFtjNKNHYOI8NJCEsECGxY895RhCbRUBVYsr1aSwgNq+Ah8Tk
	zRsZIU5SkJgzyQYkzCngCXTdYiYQWwio5EH3UrCZEgLr2CVebGlih5gjIPFt8iEWiF5ZiU0H
	mCGulpQ4uOIGywRG4QWMDKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLzczcxQsK+dwfj7QPWhxiT
	gcZNZJYSTc4Hxk1eSbyhsZmRhamJqbGRuaUZacJK4rxJD5OChATSE0tSs1NTC1KL4otKc1KL
	DzEycXBKNTDuedMezdc4XXK3bFGxcVzjmTqNWFenWSdE3xsz3/3dJuiwYveb58Xti+b5T70c
	Ns2/peLpzdWtS3947/kf9+vxyuRnixd+njm5f8/FJS9DtNdFJNxv4z155CJPZpe71eRslZ68
	Is9+ddepT1VFYmcssH6WtzlDvdDR8KQe43E/xZZrH1de4JivxFKckWioxVxUnAgAtDKCE5EC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jQd2kk7nBBmfOq1gsm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1i/YzXLBY3n21nstjRsprFgcujpbmHzWPzknqP
	vi2rGD0+b5ILYIlqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5hx/+oa9oIp
	UhV37q9hb2C8LtrFyMkhIWAi8fjsNkYIW0ziwr31bF2MXBxCAtMZJWa+XAjltDFJtN+ZzAxS
	xSagK/Hk/VwwW0QgW+JK431mkCJmgd2MEo2N89hAEsICERI79pwHG8sioCox5fo0FhCbV8BD
	YvLmjUBxDqB1ChJzJtmAhDkFPCW+fl3MBGILAZU86F7KPIGRdwEjwypG0dSC5ILipPRcQ73i
	xNzi0rx0veT83E2M4Lh6JrWDcWWDxSFGAQ5GJR7egrc5wUKsiWXFlbmHGCU4mJVEeFcczA0W
	4k1JrKxKLcqPLyrNSS0+xJgMdNREZinR5HxgzOeVxBsam5gZWRqZWRiZmJuTJqwkznug1TpQ
	SCA9sSQ1OzW1ILUIZgsTB6dUA6OWHY/DyqZkoehZ7RV8yt++vJ6q4dNz/meIZO7/V8/2TOQP
	fPB+r+L5pxKBcX8PqmyfJH6Y53DJquj6W2aNJ/Ofn/2WfyJzN7dGnt7zlwJ+Kz8vSm/a0174
	1qLWK1ihYuPBFyLzXhV9tri8L3zK7TLXecenTa6VsGnikJrcdTB3w1ahtbF2fUeVWIozEg21
	mIuKEwFoYk9n7wIAAA==
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
 arch/arm/Kconfig              |    1 +
 arch/arm/mach-exynos/common.h |    2 ++
 arch/arm/mach-exynos/exynos.c |   39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 732a134..a4eac2f 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -855,6 +855,7 @@ config ARCH_EXYNOS
 	select SPARSE_IRQ
 	select SRAM
 	select USE_OF
+	select MFD_SYSCON
 	help
 	  Support for SAMSUNG's EXYNOS SoCs (EXYNOS4/5)
 
diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 69739e4..d533e2d 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -57,4 +57,6 @@ struct exynos_pmu_conf {
 extern void exynos_sys_powerdown_conf(enum sys_powerdown mode);
 extern void exynos_enter_aftr(void);
 
+extern struct regmap *get_exynos_pmuregmap(void);
+
 #endif /* __ARCH_ARM_MACH_EXYNOS_COMMON_H */
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index e4a4be0..3b1d245 100644
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
@@ -210,6 +213,14 @@ static int __init exynos_fdt_map_chipid(unsigned long node, const char *uname,
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
@@ -263,6 +274,32 @@ static int __init exynos4_l2x0_cache_init(void)
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
+				NULL);
+	}
+
+	if (IS_ERR(exynos_pmu_regmap))
+		pr_err("failed to find exynos_pmu_regmap\n");
+}
+
 static void __init exynos_dt_machine_init(void)
 {
 	struct device_node *i2c_np;
@@ -291,6 +328,8 @@ static void __init exynos_dt_machine_init(void)
 		}
 	}
 
+	exynos_map_pmu();
+
 	if (!soc_is_exynos5440())
 		platform_device_register(&exynos_cpuidle);
 
-- 
1.7.10.4

