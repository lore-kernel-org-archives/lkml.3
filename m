Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaGGFWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 01:22:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:53219 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaGGFWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 01:22:17 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-4d-53ba2e869ba6
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v6 1/4] ARM: EXYNOS: Add support for mapping PMU base address
 via DT
Date: Mon, 07 Jul 2014 10:49:33 +0530
Message-id: <1404710376-16448-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1404710376-16448-1-git-send-email-pankaj.dubey@samsung.com>
References: <1404710376-16448-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSq9uutyvY4M0WNotlk+6yWXzf9YXd
	onfBVTaLTY+vsVpc3jWHzWLG+X1MFrcv81p8Ovqf1WLRVqCK9TNes1h0LGO0uPlsO5MDj0dL
	cw+bx+Yl9R59W1YxenzeJBfAEsVlk5Kak1mWWqRvl8CVMffIX/aCu6IV0w60MTYwThfqYuTk
	kBAwkXi+o4MdwhaTuHBvPVsXIxeHkMBSRomOt//YYIq+rj7EDJFYxChxa9cmqKoJTBKbG/uY
	QKrYBHQlnryfywxiiwhkS/TfXs0CUsQs8JhR4s3Ko4wgCWGBMImZPevAbBYBVYnDc2aDNfAK
	eEjcev0DaBAH0DoFiTmTbEDCnAKeEpNf7we7Qgio5O3SP0wgMyUEtrFLvLm9lRlijoDEt8mH
	WCB6ZSU2HWCGuFpS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAiMhdP/
	nk3cwXj/gPUhxmSgcROZpUST84GxlFcSb2hsZmRhamJqbGRuaUaasJI4b/qjpCAhgfTEktTs
	1NSC1KL4otKc1OJDjEwcnFINjNzXXwpuCDJ1033zYt6/72mTNNxTi+a831jSMl3EuKCh5odw
	vvvcRBbDopRycwmF8oj6zi8BH5+HZF91dDvv/EA7iO/dPJZZR5l+PtzW7C7gq2HX/Kkzomhj
	WeRM1RdX3256Pm/l7c9T5zi1V/fVqc9q2zApuSLmxdxSz5V9PMWKBauzin9dVGIpzkg01GIu
	Kk4EAMCFdQ6bAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jAd02vV3BBpuXWlksm3SXzeL7ri/s
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9mdfi09H/rBaLtgJVrJ/xmsWiYxmjxc1n25kceDxa
	mnvYPDYvqffo27KK0ePzJrkAlqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtz
	JYW8xNxUWyUXnwBdt8wcoMOUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1
	jBlzj/xlL7grWjHtQBtjA+N0oS5GTg4JAROJr6sPMUPYYhIX7q1n62Lk4hASWMQocWvXJihn
	ApPE5sY+JpAqNgFdiSfv54J1iAhkS/TfXs0CUsQs8JhR4s3Ko4wgCWGBMImZPevAbBYBVYnD
	c2aDNfAKeEjcev0DaBAH0DoFiTmTbEDCnAKeEpNf72cDsYWASt4u/cM0gZF3ASPDKkbR1ILk
	guKk9FwjveLE3OLSvHS95PzcTYzgSHsmvYNxVYPFIUYBDkYlHt4Dq3YGC7EmlhVX5h5ilOBg
	VhLhPeMGFOJNSaysSi3Kjy8qzUktPsRoCnTURGYp0eR8YBLIK4k3NDYxNzU2tTSxMDGzVBLn
	PdhqHSgkkJ5YkpqdmlqQWgTTx8TBKdXAuK7jw8w5D/5f616zQJz7B+sEh7nbPBYKBehKhBSx
	zVjHHmN+ccV5O57r4qwMGztX7tu7N+D4t03Xpz7ubdzbdWXeucpt747ITP939senPrF9KqEb
	MyfeDxQXqPS6l6d1pdDInO1EA9sPL9etZQIaDvF/7Hm3XI/xSUrw0XW4XrHJIfzEm38Pvyux
	FGckGmoxFxUnAgA8+xnAygIAAA==
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

