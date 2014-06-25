Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbaFYOGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:06:54 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56253 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757165AbaFYOGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:06:51 -0400
X-AuditID: cbfee68f-b7fef6d000003970-c4-53aad779fbd9
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v5 1/5] ARM: EXYNOS: Add support for mapping PMU base address
 via DT
Date: Wed, 25 Jun 2014 19:33:48 +0530
Message-id: <1403705032-14835-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1403705032-14835-1-git-send-email-pankaj.dubey@samsung.com>
References: <1403705032-14835-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSq1t5fVWwQfcPAYtlk+6yWXzf9YXd
	onfBVTaLTY+vsVpc3jWHzWLG+X1MFrcv81p8Ovqf1WLRVqCK9TNes1h0LGO0uPlsO5MDj0dL
	cw+bx+Yl9R59W1YxenzeJBfAEsVlk5Kak1mWWqRvl8CV0X/7ImPBM7GKu5cvMzUwNgp3MXJy
	SAiYSOy7084CYYtJXLi3nq2LkYtDSGApo8TvrztYYIruP1jMCpGYzijx6MAWqKoJTBILrq1h
	BKliE9CVePJ+LjOILSKQLdF/ezULSBGzwGNGiTcrj4IVCQuESSzaexasiEVAVeL3nynsIDav
	gIfE1/vPgVZwAK1TkJgzyQYkzCngKfFp5newEiGQkpn7mUFmSghsY5f4cvY6K8QcAYlvkw+x
	QPTKSmw6wAxxtaTEwRU3WCYwCi9gZFjFKJpakFxQnJReZKxXnJhbXJqXrpecn7uJERgLp/89
	69/BePeA9SHGZKBxE5mlRJPzgbGUVxJvaGxmZGFqYmpsZG5pRpqwkjjv/YdJQUIC6Yklqdmp
	qQWpRfFFpTmpxYcYmTg4pRoYV/k6RVx8KyfIkNfl8Wrjs7bfBvtbH5gqM38OtVOL36pavzjQ
	OPjCN0a93dURnb7cdzw//kwONud3OzM/82zXsfeFaxVKv918cKdEWuLF8kOqstsOZZy80H05
	lUfEh727YK1w6bOQ/C3HQs0urfbad8dSQNXAkK92whHNFwlnb3i8+JEqISGmxFKckWioxVxU
	nAgAvKb/oJsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jQd3K66uCDd79YrNYNukum8X3XV/Y
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS0WbQWqWD/jNYtFxzJGi5vPtjM58Hi0
	NPeweWxeUu/Rt2UVo8fnTXIBLFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbm
	Sgp5ibmptkouPgG6bpk5QIcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlr
	GDP6b19kLHgmVnH38mWmBsZG4S5GTg4JAROJ+w8Ws0LYYhIX7q1n62Lk4hASmM4o8ejAFihn
	ApPEgmtrGEGq2AR0JZ68n8sMYosIZEv0317NAlLELPCYUeLNyqNgRcICYRKL9p4FK2IRUJX4
	/WcKO4jNK+Ah8fX+c6B1HEDrFCTmTLIBCXMKeEp8mvkdrEQIpGTmfuYJjLwLGBlWMYqmFiQX
	FCel5xrpFSfmFpfmpesl5+duYgRH2jPpHYyrGiwOMQpwMCrx8F6YvTJYiDWxrLgy9xCjBAez
	kgiv+/5VwUK8KYmVValF+fFFpTmpxYcYTYGOmsgsJZqcD0wCeSXxhsYm5qbGppYmFiZmlkri
	vAdbrQOFBNITS1KzU1MLUotg+pg4OKUaGPsuT7vlfvHsFpufqXrla5ynz3ok0a11ym7vis4j
	xnLF5kuVu5bOy97QxlRbLHfo1DffFbP+dEetiLcTPXB/33qRY0f+sX7I2HKG/eKnBWLdzIbd
	2ue8A6/MPsQ5/d3uhj3mJ8N1rk1eESP51efi/Nduew9smLr08o7rVa9fRuvY7Hac+UMr2NFC
	iaU4I9FQi7moOBEAlIHHy8oCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for mapping Samsung Power Management Unit (PMU)
base address from device tree.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/common.h |    1 +
 arch/arm/mach-exynos/exynos.c |   45 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 3f25f89..f3114be 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -113,6 +113,7 @@ IS_SAMSUNG_CPU(exynos5800, EXYNOS5800_SOC_ID, EXYNOS5_SOC_MASK)
 
 extern void __iomem *sysram_ns_base_addr;
 extern void __iomem *sysram_base_addr;
+extern void __iomem *pmu_base_addr;
 
 void exynos_firmware_init(void);
 
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 4a69b3f..82dabc8 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -19,6 +19,8 @@
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/pm_domain.h>
+#include <linux/clocksource.h>
+#include <linux/clk-provider.h>
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -31,6 +33,8 @@
 #include "regs-pmu.h"
 #include "regs-sys.h"
 
+void __iomem *pmu_base_addr;
+
 static struct map_desc exynos4_iodesc[] __initdata = {
 	{
 		.virtual	= (unsigned long)S3C_VA_SYS,
@@ -231,6 +235,46 @@ static void __init exynos_init_io(void)
 	exynos_map_io();
 }
 
+static const struct of_device_id exynos_dt_pmu_match[] = {
+	{ .compatible = "samsung,exynos3250-pmu" },
+	{ .compatible = "samsung,exynos4210-pmu" },
+	{ .compatible = "samsung,exynos4212-pmu" },
+	{ .compatible = "samsung,exynos4412-pmu" },
+	{ .compatible = "samsung,exynos5250-pmu" },
+	{ .compatible = "samsung,exynos5420-pmu" },
+	{},
+};
+
+static void exynos_map_pmu(void)
+{
+	struct device_node *np = NULL;
+
+	np = of_find_matching_node(NULL, exynos_dt_pmu_match);
+
+	if (!np) {
+		pr_err("Failed to find PMU node\n");
+		return;
+	}
+
+	pmu_base_addr = of_iomap(np, 0);
+
+	if (!pmu_base_addr)
+		panic("failed to find exynos pmu register\n");
+}
+
+static void __init exynos_init_time(void)
+{
+	/* Nothing to do timer specific.
+	 * Since platsmp.c needs pmu base address by the time
+	 * DT is not unflatten so we can't use DT APIs before
+	 * init_time
+	 */
+	exynos_map_pmu();
+
+	of_clk_init(NULL);
+	clocksource_of_init();
+}
+
 static void __init exynos_dt_machine_init(void)
 {
 	struct device_node *i2c_np;
@@ -306,6 +350,7 @@ DT_MACHINE_START(EXYNOS_DT, "SAMSUNG EXYNOS (Flattened Device Tree)")
 	.smp		= smp_ops(exynos_smp_ops),
 	.map_io		= exynos_init_io,
 	.init_early	= exynos_firmware_init,
+	.init_time	= exynos_init_time,
 	.init_machine	= exynos_dt_machine_init,
 	.init_late	= exynos_init_late,
 	.dt_compat	= exynos_dt_compat,
-- 
1.7.9.5

