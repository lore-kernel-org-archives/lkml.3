Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbaGIEEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 00:04:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:55307 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaGIEDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 00:03:43 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-a2-53bcbf1892d7
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v7 1/4] ARM: EXYNOS: Add support for mapping PMU base address
 via DT
Date: Wed, 09 Jul 2014 09:30:52 +0530
Message-id: <1404878455-31518-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1404878455-31518-1-git-send-email-pankaj.dubey@samsung.com>
References: <1404878455-31518-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSpyuxf0+wwawNyhbLJt1ls/i+6wu7
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLG5f5rX4dPQ/q8WirUAV62e8ZrHoWMZocfPZdiYHHo+W
	5h42j81L6j36tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEro/vNc5aCHrGKjd9vMDcwHhTqYuTk
	kBAwkdjQe50ZwhaTuHBvPVsXIxeHkMBSRokPx5aywxQ9WrIXKrGIUWL5wz/sEM4EJonu21/Z
	QKrYBHQlnryfCzZKRCBbov/2ahaQImaBx4wSb1YeZQRJCAuESXzd/hKsiEVAVeLMuilgzbwC
	HhJbpt0DauAAWqcgMWeSDUiYU8BTomX6crASIaCSM+s2sILMlBDYxC6x9slqVog5AhLfJh+C
	6pWV2HQA6h1JiYMrbrBMYBRewMiwilE0tSC5oDgpvchUrzgxt7g0L10vOT93EyMwFk7/ezZx
	B+P9A9aHGJOBxk1klhJNzgfGUl5JvKGxmZGFqYmpsZG5pRlpwkrivOmPkoKEBNITS1KzU1ML
	Uovii0pzUosPMTJxcEo1MFaYSDpMXrlyFvO0hYfm1Xjcvao5ldHVId4jz87FNr2f22duwVRv
	Hg8ppdde4tvPRh46KVEby6vUO/HCzrrAs3sW5cloLp295aKuJ2vy7fCPZg1tNoJcL6r4Hgv9
	PF6wp1zpj9osxSfXIq+vO2sYpqcygemifbzhOQ6FEDadztUT7u6IiPigqsRSnJFoqMVcVJwI
	AOR9FICbAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jAV2J/XuCDT78kLRYNukum8X3XV/Y
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS0WbQWqWD/jNYtFxzJGi5vPtjM58Hi0
	NPeweWxeUu/Rt2UVo8fnTXIBLFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbm
	Sgp5ibmptkouPgG6bpk5QIcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlr
	GDO63zxnKegRq9j4/QZzA+NBoS5GTg4JAROJR0v2skHYYhIX7q0Hsrk4hAQWMUosf/iHHcKZ
	wCTRffsrWBUbMJyevJ/LDGKLCGRL9N9ezQJSxCzwmFHizcqjjCAJYYEwia/bX4IVsQioSpxZ
	NwWsmVfAQ2LLtHtADRxA6xQk5kyyAQlzCnhKtExfDlYiBFRyZt0G1gmMvAsYGVYxiqYWJBcU
	J6XnGuoVJ+YWl+al6yXn525iBEfaM6kdjCsbLA4xCnAwKvHwKvDsCRZiTSwrrsw9xCjBwawk
	wvvNDSjEm5JYWZValB9fVJqTWnyI0RToqInMUqLJ+cAkkFcSb2hsYm5qbGppYmFiZqkkznug
	1TpQSCA9sSQ1OzW1ILUIpo+Jg1OqgTGCs1vl0/VH1yNPJMllhSXr+lct1BbdxCay4ZRXUjbn
	hl2J0XMPf9i2ZPXm9BW7FJl2Tme0P7RtUuTynnnXSiVvJ/88+O7Te5MC8da50+t5/xW7T2rN
	XLNxdQ3jQuXobctCj+leVp167ta17Cqx8lqu/rl8FyeXTrDQNXnOvPTDCy1xpX1XOkWUWIoz
	Eg21mIuKEwEEr9/RygIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for mapping Samsung Power Management Unit (PMU)
base address from device tree.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/common.h |    1 +
 arch/arm/mach-exynos/exynos.c |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 152b464..f8daa9c 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -113,6 +113,7 @@ IS_SAMSUNG_CPU(exynos5800, EXYNOS5800_SOC_ID, EXYNOS5_SOC_MASK)
 
 extern void __iomem *sysram_ns_base_addr;
 extern void __iomem *sysram_base_addr;
+extern void __iomem *pmu_base_addr;
 void exynos_sysram_init(void);
 
 void exynos_firmware_init(void);
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 186f35d..173aac8 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -19,6 +19,7 @@
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/pm_domain.h>
+#include <linux/irqchip.h>
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -31,6 +32,8 @@
 #include "regs-pmu.h"
 #include "regs-sys.h"
 
+void __iomem *pmu_base_addr;
+
 static struct map_desc exynos4_iodesc[] __initdata = {
 	{
 		.virtual	= (unsigned long)S3C_VA_SYS,
@@ -253,6 +256,39 @@ static void __init exynos_init_io(void)
 	exynos_map_io();
 }
 
+static const struct of_device_id exynos_dt_pmu_match[] = {
+	{ .compatible = "samsung,exynos3250-pmu" },
+	{ .compatible = "samsung,exynos4210-pmu" },
+	{ .compatible = "samsung,exynos4212-pmu" },
+	{ .compatible = "samsung,exynos4412-pmu" },
+	{ .compatible = "samsung,exynos5250-pmu" },
+	{ .compatible = "samsung,exynos5420-pmu" },
+	{ /*sentinel*/ },
+};
+
+static void exynos_map_pmu(void)
+{
+	struct device_node *np;
+
+	np = of_find_matching_node(NULL, exynos_dt_pmu_match);
+	if (np)
+		pmu_base_addr = of_iomap(np, 0);
+
+	if (!pmu_base_addr)
+		panic("failed to find exynos pmu register\n");
+}
+
+static void __init exynos_init_irq(void)
+{
+	irqchip_init();
+	/*
+	 * Since platsmp.c needs pmu base address by the time
+	 * DT is not unflatten so we can't use DT APIs before
+	 * init_irq
+	 */
+	exynos_map_pmu();
+}
+
 static void __init exynos_dt_machine_init(void)
 {
 	struct device_node *i2c_np;
@@ -336,6 +372,7 @@ DT_MACHINE_START(EXYNOS_DT, "SAMSUNG EXYNOS (Flattened Device Tree)")
 	.smp		= smp_ops(exynos_smp_ops),
 	.map_io		= exynos_init_io,
 	.init_early	= exynos_firmware_init,
+	.init_irq	= exynos_init_irq,
 	.init_machine	= exynos_dt_machine_init,
 	.init_late	= exynos_init_late,
 	.dt_compat	= exynos_dt_compat,
-- 
1.7.9.5

