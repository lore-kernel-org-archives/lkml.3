Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbaDYMQG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 08:16:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39628 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbaDYMPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 08:15:07 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-86-535a51c9b922
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, s.nawrocki@samsung.com,
        b.zolnierkie@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2 06/10] ARM: EXYNOS: Add support for mapping PMU base address
 via DT
Date: Fri, 25 Apr 2014 21:32:42 +0900
Message-id: <1398429166-5539-7-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398429166-5539-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
 <1398429166-5539-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+Zse7JwKhggzmvDCw2zljParFs0l02
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGuxaOsXdovDb9pZLdbPeM1icfPZdiaLHS2rWRx4
	PFqae9g8Ni+p9+jbsorR4/MmuQCWKC6blNSczLLUIn27BK6Mcx8fsxdMVq/49SOygXG/Qhcj
	J4eEgInEnEmb2SFsMYkL99azdTFycQgJLGOUaJx8i6mLkQOs6Pr1Moj4IkaJjX9/M0M4bUwS
	R3pXsIB0swnoSjx5P5cZxBYRyJa40ngfzGYWeM8o8fmwOogtLBAh8eXoUrA4i4CqxN5Zv8F6
	eQXcJebf3sEGsUwB6CIbkDCngIfEieUf2SF2tTJKnP99mwXEkRDYxi6x6OsUVohBAhLfJh9i
	gWiWldh0gBniG0mJgytusExgFF7AyLCKUTS1ILmgOCm9yEivODG3uDQvXS85P3cTIyQS+nYw
	3jxgfYgxGWjcRGYp0eR8YCTllcQbGpsZWZiamBobmVuakSasJM676GFSkJBAemJJanZqakFq
	UXxRaU5q8SFGJg5OqQbG6TcufWC03vRBx9LCK7Jczu7YocfN3Yap7eyaHUn+hc2Wi3R/3di+
	/Z/1quN1s5Qq7j5bdeC0wFF1S4W1e1+os7TuWcWs6Zi6auXKm94zdwscCshl2ey4Qszi5ofP
	Unv/sb9Z1hfbcmSLQVYw0+3YQ8W+pRV9jJufMHs/P2KQsWxdXLe5xro2JZbijERDLeai4kQA
	3CnXsJoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jAd2TgVHBBm0rtC02zljParFs0l02
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGuxaOsXdovDb9pZLdbPeM1icfPZdiaLHS2rWRx4
	PFqae9g8Ni+p9+jbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNL
	C3MlhbzE3FRbJRefAF23zBygy5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCB
	hHWMGec+PmYvmKxe8etHZAPjfoUuRg4OCQETievXy7oYOYFMMYkL99azdTFycQgJLGKU2Pj3
	NzOE08YkcaR3BQtIFZuArsST93OZQWwRgWyJK433wWxmgfeMEp8Pq4PYwgIREl+OLgWLswio
	Suyd9Rusl1fAXWL+7R1sEIsVJOZMsgEJcwp4SJxY/pEdYlcro8T537dZJjDyLmBkWMUomlqQ
	XFCclJ5rpFecmFtcmpeul5yfu4kRHGfPpHcwrmqwOMQowMGoxMM7QTYyWIg1say4MvcQowQH
	s5II7we/qGAh3pTEyqrUovz4otKc1OJDjMlAV01klhJNzgemgLySeENjEzMjSyMzCyMTc3PS
	hJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYPTtuhfOOfF5r1xqZan947tciRtO1Dmkff32
	YsYlm7Cet+d1E13TFsjcUDw2/5rT855AjeLDWo6sQp8FjQ8X9cnavee1lV7oLfrLMKTiaoZX
	0/PGK4/bL1+5y+6eM0110oxbNU5+Wu1igbV6Wz/XKNkWnvZ8+Lns4uw/y86rhNw97X1B4OSj
	zUosxRmJhlrMRcWJANryBz/3AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Young-Gun Jang <yg1004.jang@samsung.com>

Add support for mapping Samsung Power Management Unit (PMU) base address
from device tree. Code will use existing samsung pmu binding information.
This patch also adds two helper functions as "get_exynos_pmuregmap" and
"get_exynos_pmuaddr".
"get_exynos_pmuregmap" returns a regmap based PMU register handle where as
"get_exynos_pmuaddr" returns ioremap virtual address.

Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/Kconfig  |    2 ++
 arch/arm/mach-exynos/common.h |    3 ++
 arch/arm/mach-exynos/exynos.c |   78 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 83 insertions(+)

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
index 31c5964..ecfd0fc 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -57,4 +57,7 @@ struct exynos_pmu_conf {
 
 extern void exynos_sys_powerdown_conf(enum sys_powerdown mode);
 
+extern struct regmap *get_exynos_pmuregmap(void);
+extern void __iomem *get_exynos_pmuaddr(void);
+
 #endif /* __ARCH_ARM_MACH_EXYNOS_COMMON_H */
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index d6f405f..68f60e1 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -19,6 +19,7 @@
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/pm_domain.h>
+#include <linux/mfd/syscon.h>
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -36,6 +37,9 @@
 #define L2_AUX_VAL 0x7C470001
 #define L2_AUX_MASK 0xC200ffff
 
+static struct regmap *exynos_pmu_regmap;
+static void __iomem *exynos_pmu_base;
+
 static struct map_desc exynos4_iodesc[] __initdata = {
 	{
 		.virtual	= (unsigned long)S3C_VA_SYS,
@@ -269,6 +273,46 @@ static int __init exynos_fdt_map_chipid(unsigned long node, const char *uname,
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
+static int __init exynos_fdt_map_pmu(unsigned long node,
+		const char *uname, int depth, void *data)
+{
+	struct map_desc iodesc;
+	__be32 *reg;
+	unsigned long len;
+	phys_addr_t phys_addr;
+	const struct of_device_id *matches = exynos_dt_pmu_match;
+
+	for (; matches->compatible[0]; matches++) {
+		if (!of_flat_dt_is_compatible(node, matches->compatible))
+			continue;
+		reg = of_get_flat_dt_prop(node, "reg", &len);
+		if (reg == NULL || len != (sizeof(unsigned long) * 2))
+			return 0;
+
+		phys_addr = be32_to_cpu(reg[0]);
+		iodesc.pfn = __phys_to_pfn(phys_addr);
+		iodesc.length = be32_to_cpu(reg[1]) - 1;
+		iodesc.virtual = (unsigned long)S5P_VA_PMU;
+		iodesc.type = MT_DEVICE;
+		iotable_init(&iodesc, 1);
+
+		exynos_pmu_base = ioremap(phys_addr, be32_to_cpu(reg[1]));
+		if (WARN_ON(!exynos_pmu_base))
+			return -EFAULT;
+		return 1;
+	}
+
+	return 0;
+}
+
 /*
  * exynos_map_io
  *
@@ -302,6 +346,7 @@ static void __init exynos_init_io(void)
 	debug_ll_io_init();
 
 	of_scan_flat_dt(exynos_fdt_map_chipid, NULL);
+	of_scan_flat_dt(exynos_fdt_map_pmu, NULL);
 
 	/* detect cpu id and rev. */
 	s5p_init_cpu(S5P_VA_CHIPID);
@@ -336,6 +381,38 @@ static int __init exynos4_l2x0_cache_init(void)
 }
 early_initcall(exynos4_l2x0_cache_init);
 
+
+inline struct regmap *get_exynos_pmuregmap()
+{
+	return exynos_pmu_regmap;
+}
+
+inline void __iomem *get_exynos_pmuaddr()
+{
+	return exynos_pmu_base;
+}
+
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
@@ -364,6 +441,7 @@ static void __init exynos_dt_machine_init(void)
 		}
 	}
 
+	exynos_map_pmu();
 	exynos_cpuidle_init();
 	exynos_cpufreq_init();
 
-- 
1.7.10.4

