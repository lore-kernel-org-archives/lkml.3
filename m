Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbaEJHBS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 03:01:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35401 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbaEJG74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 02:59:56 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-9e-536dce69943f
From: y@samsung.com
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com, arnd@arndb.de,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: [PATCH v3 3/6] ARM: EXYNOS: Remove soc_is_exynos4/5 from exynos.c
Date: Sat, 10 May 2014 16:18:04 +0900
Message-id: <1399706287-13919-4-git-send-email-y@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399706287-13919-1-git-send-email-y@samsung.com>
References: <1399706287-13919-1-git-send-email-y@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrALMWRmVeSWpSXmKPExsVy+t9jAd3Mc7nBBs2NphZ/Jx1jt+hdcJXN
	YtPja6wWl3fNYbOYcX4fk8Xty7wWi7Z+YbdYP+M1i8WxGUsYHTg9Wpp72Dx+/5rE6HHn2h42
	j81L6j36tqxi9Pi8SS6ALYrLJiU1J7MstUjfLoEro6fnJGPBXfmKtVPOszQwfpDqYuTkkBAw
	kTi0/QgThC0mceHeerYuRi4OIYFFjBJ7e3azQDhtTBKrX29j7GLk4GATEJaYekALpEFEIFvi
	SuN9ZpAaZoF9jBIz26eygCSEBbwktr+/wQxiswioSmz+85MRxOYVsJX4sAtkGwfQNgWJOZNs
	QMKcAnYS17Y1g7UKAZVMOXqYcQIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYweH2
	TGoH48oGi0OMAhyMSjy8BW9zgoVYE8uKK3MPMUpwMCuJ8K44mBssxJuSWFmVWpQfX1Sak1p8
	iFGag0VJnPdAq3WgkEB6YklqdmpqQWoRTJaJg1OqgVHGaN3BsvpVa9ka5ZNVf77Y3mous2od
	62W+t3sfmUq8rTk6v2QL78n1Ik3z2wPnRqTa7Q+u7rW++yvN+61FS2OpR2Ll1rN6k8Xv2uZ+
	bPcNt079cn2zzF19DQ+rJ/NjXh13XNce/2aDyE3NGwub5rrNLpv4fvJ+sTcNT2beOi5vZenT
	6/uIVUGJpTgj0VCLuag4EQAZDaKpMwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pankaj Dubey <pankaj.dubey@samsung.com>

This patch removes usage of soc_is_exynos4/5 from exynos.c.
For this we need to separate machine descriptors for exynos4
and exynos5. While doing this patch does some consolidation also.

CC: Russell King <linux@arm.linux.org.uk>
CC: Thomas Abraham <thomas.abraham@linaro.org>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/exynos.c            |   52 +++++++++++++++++++-----------
 arch/arm/plat-samsung/include/plat/cpu.h |    3 --
 2 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 09063ee..9902e52 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -202,20 +202,6 @@ static const struct of_device_id exynos_dt_pmu_match[] = {
 	{},
 };
 
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
-}
-
 static void __init exynos_init_io(void)
 {
 	debug_ll_io_init();
@@ -224,8 +210,18 @@ static void __init exynos_init_io(void)
 
 	/* detect cpu id and rev. */
 	s5p_init_cpu(S5P_VA_CHIPID);
+}
+
+static void __init exynos5_init_io(void)
+{
+	exynos_init_io();
+	iotable_init(exynos5_iodesc, ARRAY_SIZE(exynos5_iodesc));
+}
 
-	exynos_map_io();
+static void __init exynos4_init_io(void)
+{
+	exynos_init_io();
+	iotable_init(exynos4_iodesc, ARRAY_SIZE(exynos4_iodesc));
 }
 
 struct bus_type exynos_subsys = {
@@ -293,11 +289,15 @@ static void __init exynos_dt_machine_init(void)
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
-static char const *exynos_dt_compat[] __initconst = {
+static char const *exynos4_dt_compat[] __initconst = {
 	"samsung,exynos4",
 	"samsung,exynos4210",
 	"samsung,exynos4212",
 	"samsung,exynos4412",
+	NULL
+};
+
+static char const *exynos5_dt_compat[] __initconst = {
 	"samsung,exynos5",
 	"samsung,exynos5250",
 	"samsung,exynos5420",
@@ -321,15 +321,29 @@ static void __init exynos_reserve(void)
 #endif
 }
 
-DT_MACHINE_START(EXYNOS_DT, "SAMSUNG EXYNOS (Flattened Device Tree)")
+DT_MACHINE_START(EXYNOS5_DT, "SAMSUNG EXYNOS (Flattened Device Tree)")
+	/* Maintainer: Thomas Abraham <thomas.abraham@linaro.org> */
+	/* Maintainer: Kukjin Kim <kgene.kim@samsung.com> */
+	.smp		= smp_ops(exynos_smp_ops),
+	.map_io		= exynos5_init_io,
+	.init_early	= exynos_firmware_init,
+	.init_machine	= exynos_dt_machine_init,
+	.init_late	= exynos_init_late,
+	.dt_compat	= exynos5_dt_compat,
+	.restart	= exynos_restart,
+	.reserve	= exynos_reserve,
+MACHINE_END
+
+
+DT_MACHINE_START(EXYNOS4_DT, "SAMSUNG EXYNOS (Flattened Device Tree)")
 	/* Maintainer: Thomas Abraham <thomas.abraham@linaro.org> */
 	/* Maintainer: Kukjin Kim <kgene.kim@samsung.com> */
 	.smp		= smp_ops(exynos_smp_ops),
-	.map_io		= exynos_init_io,
+	.map_io		= exynos4_init_io,
 	.init_early	= exynos_firmware_init,
 	.init_machine	= exynos_dt_machine_init,
 	.init_late	= exynos_init_late,
-	.dt_compat	= exynos_dt_compat,
+	.dt_compat	= exynos4_dt_compat,
 	.restart	= exynos_restart,
 	.reserve	= exynos_reserve,
 MACHINE_END
diff --git a/arch/arm/plat-samsung/include/plat/cpu.h b/arch/arm/plat-samsung/include/plat/cpu.h
index 5992b8d..18a9a00 100644
--- a/arch/arm/plat-samsung/include/plat/cpu.h
+++ b/arch/arm/plat-samsung/include/plat/cpu.h
@@ -166,9 +166,6 @@ IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS5_SOC_MASK)
 # define soc_is_exynos5440()	0
 #endif
 
-#define soc_is_exynos4() (soc_is_exynos4210() || soc_is_exynos4212() || \
-			  soc_is_exynos4412())
-#define soc_is_exynos5() (soc_is_exynos5250() || soc_is_exynos5420())
 
 #define IODESC_ENT(x) { (unsigned long)S3C24XX_VA_##x, __phys_to_pfn(S3C24XX_PA_##x), S3C24XX_SZ_##x, MT_DEVICE }
 
-- 
1.7.10.4

