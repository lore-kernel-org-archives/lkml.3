Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbaD0Hky (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:40:54 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31141 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbaD0HjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:39:22 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-69-535cb4296005
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, pullip.cho@samsung.com,
        a.motakis@virtualopensystems.com, grundler@chromium.org,
        joro@8bytes.org, prathyush.k@samsung.com, rahul.sharma@samsung.com,
        sachin.kamat@linaro.org, supash.ramaswamy@linaro.org,
        Varun.Sethi@freescale.com, s.nawrocki@samsung.com, t.figa@samsung.com,
        joshi@samsung.com, Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: [PATCH v12 12/31] iommu/exynos: support for device tree
Date: Sun, 27 Apr 2014 13:07:44 +0530
Message-id: <1398584283-22846-13-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsWyRsSkRldzS0ywweJufos7d8+xWsw/AiRe
	HfnBZLFgv7VF5+wN7Bbfd31ht+hdcJXNYtPja6wWl3fNYbOYcX4fk8WFFRvZLf71HmS0mLLo
	MKvF4TftrBYn//QyWhx5uJvdouV6L5PF+hmvWSxW7frDaDHz1hoWBxGPJwfnMXnMbrjI4vHv
	cD+Tx85Zd9k97lzbw+axeUm9x+Qbyxk9+rasYvT4vEnO48rRM0wBXFFcNimpOZllqUX6dglc
	GVe+X2It2CNRcXjPIfYGxjaRLkZODgkBE4kvR68xQdhiEhfurWcDsYUEljJKrDjDAVNzbn4v
	axcjF1B8EaPElyNXmCGcCUwSTee7WUCq2AQMJbbfuwJWJSKwmlGi7+IZdhCHWaCHWeLa/jtg
	O4QFHCTeLFzCCmKzCKhK7Dn2C6ybV8BDonHeFqAaDqB9ChJzJtmAhDmBwk/u7GGBOMld4u2p
	L2ALJAQWckgceH6KHWKOgMS3yYdYIHplJTYdYIY4W1Li4IobLBMYhRcwMqxiFE0tSC4oTkov
	MtIrTswtLs1L10vOz93ECIzM0/+e9e1gvHnA+hBjMtC4icxSosn5wMjOK4k3NDYzsjA1MTU2
	Mrc0I01YSZx30cOkICGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2Mc/5Ftwfekol3TL3O/GWH
	mafe0sri6mvS3g91HvToX93EqqHRVMISlqkUaWubt2rP5UM76h4f+pq3bkMWo83qSYzc639G
	vPCR9d8+R1jZ/UNG+3v/25ZNl3sYfd6G855u+pG27cAWwSRetTz53HlVhbusf4SkXffreqB3
	NatmakmGv6Z8goUSS3FGoqEWc1FxIgB4HkLV4gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsVy+t9jAV3NLTHBBt/3sljcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLf4vusLu0XvgqtsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktDr9pZ7U4+aeX0eLIw93sFi3Xe5ks1s94zWKxatcfRouZt9awOIh4PDk4j8ljdsNFFo9/
	h/uZPHbOusvucefaHjaPzUvqPSbfWM7o0bdlFaPH501yHleOnmEK4IpqYLTJSE1MSS1SSM1L
	zk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAfpPSaEsMacUKBSQWFyspG+H
	aUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hx5fsl1oI9EhWH9xxib2BsE+li5OSQEDCRODe/lxXC
	FpO4cG89WxcjF4eQwCJGiS9HrjBDOBOYJJrOd7OAVLEJGEpsv3eFFSQhIrCaUaLv4hl2EIdZ
	oIdZ4tr+O0wgVcICDhJvFi4Bm8sioCqx59gvsG5eAQ+JxnlbgGo4gPYpSMyZZAMS5gQKP7mz
	B6xESMBd4u2pL6wTGHkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiO/GdSOxhXNlgc
	YhTgYFTi4V0gGRMsxJpYVlyZe4hRgoNZSYSXczpQiDclsbIqtSg/vqg0J7X4EGMy0FETmaVE
	k/OBSSmvJN7Q2MTc1NjU0sTCxMySNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhi5vT83
	Vf8QTi4M/Pgy2na58JFLnwp3ML68fe9gVefldf/WMP1o2Tv/4+vidIYwqz719Jqm/Huvlgr/
	2iRmPlHsXGJaPN/B1m333dYW1myesD8l7GO2zSr1zgjOUL+JixyOX3m16qbFo/Qc5aIyp+dc
	m14+2ZzusUvITequ1dzCyZw13iF614uVWIozEg21mIuKEwFfIb9nQAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

This commit adds device tree support for System MMU.
It also enables iommu support for ARCH_EXYNOS.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 arch/arm/Kconfig             |    2 ++
 drivers/iommu/Kconfig        |    8 +++-----
 drivers/iommu/exynos-iommu.c |   19 +++++++++++++++----
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ab438cb..19689e4 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -834,6 +834,8 @@ config ARCH_EXYNOS
 	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_SPARSEMEM_ENABLE
+	select ARM_AMBA
+	select ARM_DMA_USE_IOMMU
 	select ARM_GIC
 	select COMMON_CLK
 	select CPU_V7
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index df56e4c..5feadb8 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -178,16 +178,14 @@ config TEGRA_IOMMU_SMMU
 
 config EXYNOS_IOMMU
 	bool "Exynos IOMMU Support"
-	depends on ARCH_EXYNOS && EXYNOS_DEV_SYSMMU
+	depends on ARCH_EXYNOS
 	select IOMMU_API
 	help
-	  Support for the IOMMU(System MMU) of Samsung Exynos application
-	  processor family. This enables H/W multimedia accellerators to see
+	  Support for the IOMMU (System MMU) of Samsung Exynos application
+	  processor family. This enables H/W multimedia accelerators to see
 	  non-linear physical memory chunks as a linear memory in their
 	  address spaces
 
-	  If unsure, say N here.
-
 config EXYNOS_IOMMU_DEBUG
 	bool "Debugging log for Exynos IOMMU"
 	depends on EXYNOS_IOMMU
diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 0f1d3f0..cbb9b67 100755
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -25,6 +25,7 @@
 #include <linux/list.h>
 #include <linux/memblock.h>
 #include <linux/export.h>
+#include <linux/of.h>
 
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
@@ -494,7 +495,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 	read_unlock_irqrestore(&data->lock, flags);
 }
 
-static int exynos_sysmmu_probe(struct platform_device *pdev)
+static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 {
 	int irq, ret;
 	struct device *dev = &pdev->dev;
@@ -548,11 +549,21 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_driver exynos_sysmmu_driver = {
-	.probe		= exynos_sysmmu_probe,
-	.driver		= {
+static const struct of_device_id sysmmu_of_match[] __initconst = {
+	{ .compatible	= "samsung,sysmmu-v1", },
+	{ .compatible	= "samsung,sysmmu-v2", },
+	{ .compatible	= "samsung,sysmmu-v3.1", },
+	{ .compatible	= "samsung,sysmmu-v3.2", },
+	{ .compatible	= "samsung,sysmmu-v3.3", },
+	{ },
+};
+
+static struct platform_driver exynos_sysmmu_driver __refdata = {
+	.probe	= exynos_sysmmu_probe,
+	.driver	= {
 		.owner		= THIS_MODULE,
 		.name		= "exynos-sysmmu",
+		.of_match_table	= sysmmu_of_match,
 	}
 };
 
-- 
1.7.9.5

