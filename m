Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934594AbaEFIe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:34:58 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20376 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934244AbaEFIdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:33:20 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-92-53689e4b878e
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com, arnd@arndb.de,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: [PATCH v2 3/6] ARM: EXYNOS: remove soc_is_exynos4/5 from exynos.c
Date: Tue, 06 May 2014 17:51:19 +0900
Message-id: <1399366282-4191-4-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399366282-4191-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399366282-4191-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42I5/e+Zga73vIxgg+bXChZ/Jx1jt+hdcJXN
	YtPja6wWl3fNYbOYcX4fk8Xty7wWi7Z+YbdYP+M1i8WxGUsYHTg9Wpp72Dx+/5rE6HHn2h42
	j81L6j36tqxi9Pi8SS6ALYrLJiU1J7MstUjfLoEr4938iewFa+Qr3mxdztTAeEyqi5GTQ0LA
	RGLui2OsELaYxIV769m6GLk4hASWMUr8XNTHBFN0/955qMR0Rokf3yczQThtTBKXm14yglSx
	CehKPHk/lxnEFhHIlrjSeJ8ZpIhZYB+jxMz2qSwgCWEBL4nWn//B9rEIqErs+HwQLM4r4C7R
	PPc0UAMH0DoFiTmTbEDCnAIeEm+uvQUrFwIq2XH/NtgVEgKb2CVO7nzCBjFHQOLb5EMsEL2y
	EpsOMENcLSlxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXGeoVJ+YWl+al6yXn525ihMRA7w7G2wes
	DzEmA42byCwlmpwPjKG8knhDYzMjC1MTU2Mjc0sz0oSVxHmTHiYFCQmkJ5akZqemFqQWxReV
	5qQWH2Jk4uCUamDcb5/4eLGp1/Ub9SG3uyc/mxztK3366PW2qYXc7zQuqrh89nOXlv03w/qq
	/apwtx3zc/IDz4f+sL5la2gtsY1dzqtzq9P67HV3F8iJJF+ySeG4ltXcszBd9V3lzQOSEas/
	CK1UT779/Vi6fcS2rdNifXkWbUl/vnx5ZKuzW2Les5PpzyRSQ8OVWIozEg21mIuKEwEZ69QR
	lwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jQV3veRnBBlMWyFj8nXSM3aJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1i/YzXLBbHZixhdOD0aGnuYfP4/WsSo8eda3vY
	PDYvqffo27KK0ePzJrkAtqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8
	xNxUWyUXnwBdt8wcoKOUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBnv
	5k9kL1gjX/Fm63KmBsZjUl2MnBwSAiYS9++dZ4OwxSQu3FsPZHNxCAlMZ5T48X0yE4TTxiRx
	ueklI0gVm4CuxJP3c5lBbBGBbIkrjfeZQYqYBfYxSsxsn8oCkhAW8JJo/fmfFcRmEVCV2PH5
	IFicV8BdonnuaaAGDqB1ChJzJtmAhDkFPCTeXHsLVi4EVLLj/m22CYy8CxgZVjGKphYkFxQn
	peca6hUn5haX5qXrJefnbmIER9gzqR2MKxssDjEKcDAq8fCeWJkeLMSaWFZcmXuIUYKDWUmE
	tz4/I1iINyWxsiq1KD++qDQntfgQYzLQUROZpUST84HRn1cSb2hsYmZkaWRmYWRibk6asJI4
	74FW60AhgfTEktTs1NSC1CKYLUwcnFINjOV3l9v1r92/0evbv957M1itri+yF+XXybD+VH/z
	lMcBMcmSKVkfja/ftPKWuPJawnHB94gVp2wf9fXMLHlpxP5dYpdT4o2T7ou+rLoi9yYk3F5j
	lXv5zLyUXMWFV7ec3G9t8c26mu3jfaXi8MpXISq+Ga+PrpEV/OblFcod+HeRgZ5lu2yMtBJL
	cUaioRZzUXEiAGoMzpr0AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

