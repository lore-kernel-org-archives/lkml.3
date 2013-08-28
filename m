Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab3H1Fp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 01:45:26 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:8909 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab3H1FpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 01:45:15 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-c8-521d8e6755cd
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org, rui.zhang@intel.com, eduardo.valentin@ti.com
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        naveenkrishna.ch@gmail.com, devicetree@vger.kernel.org
Subject: [PATCH 3/3] thermal: exynos: Handle the misplaced TRIMINFO register
Date: Wed, 28 Aug 2013 11:15:19 +0530
Message-id: <1377668719-8602-4-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1377668719-8602-1-git-send-email-ch.naveen@samsung.com>
References: <1375336979-14747-1-git-send-email-ch.naveen@samsung.com>
 <1377668719-8602-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42JZI2JSrZveJxtkcGKOhkXD1RCL+UfOsVqs
	2f+TyaJ3wVU2i8u75rBZfO49wmgx4/w+JotF2/4zWzx52MfmwOmxc9Zddo/Fe14yefRtWcXo
	cfzGdiaPz5vkAlijuGxSUnMyy1KL9O0SuDI+3J/MWHBBr+LH/RnMDYyXVLsYOTkkBEwkvkz4
	zQxhi0lcuLeerYuRi0NIYCmjxMYZ79hginaevcsCkVjEKNFxYxYrhNPDJNHy9gpYO5uAmcTB
	RavZQWwRAS+JWQ+vMoEUMQusZ5Q4tH0tWJGwgI9EU9ctJhCbRUBVYuLdSawgNq+Ai8SKQ7+B
	VnAArVOQmDPJBiTMKeAqMX3JS0aIZQ2MEgt+XgZzJAQ2sUsseTyREWKQgMS3yYegmmUlNh2A
	+kdS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAgM/tP/nvXvYLx7wPoQ
	YzLQuInMUqLJ+cDoySuJNzQ2M7IwNTE1NjK3NCNNWEmcV63FOlBIID2xJDU7NbUgtSi+qDQn
	tfgQIxMHp1QDY2rjNfU5N6uXFH2VbXrVLTWB79zhpl7pnCulZj0LvBTzMgJEmVxmvYxLTYva
	vnZn3pmKJWH1Il9dlbkCOFVeTSvIXx8644p/7iRH0e/ykqwJh/vXCvLwsGav+T4h/oih+VSL
	/06FzXemNNwUtzlZcm7F4eN6bLEFLf3pdjanIqP38c5ew7lXiaU4I9FQi7moOBEAFQj/eZQC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t9jAd30Ptkgg5Zb8hYNV0Ms5h85x2qx
	Zv9PJoveBVfZLC7vmsNm8bn3CKPFjPP7mCwWbfvPbPHkYR+bA6fHzll32T0W73nJ5NG3ZRWj
	x/Eb25k8Pm+SC2CNamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVV
	cvEJ0HXLzAE6SEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOY8eH+ZMaC
	C3oVP+7PYG5gvKTaxcjJISFgIrHz7F0WCFtM4sK99WxdjFwcQgKLGCU6bsxihXB6mCRa3l5h
	BqliEzCTOLhoNTuILSLgJTHr4VUmkCJmgfWMEoe2rwUrEhbwkWjqusUEYrMIqEpMvDuJFcTm
	FXCRWHHoN9A6DqB1ChJzJtmAhDkFXCWmL3nJCLGsgVFiwc/LjBMYeRcwMqxiFE0tSC4oTkrP
	NdQrTswtLs1L10vOz93ECI6tZ1I7GFc2WBxiFOBgVOLhtdgsEyTEmlhWXJl7iFGCg1lJhLfk
	P1CINyWxsiq1KD++qDQntfgQYzLQVROZpUST84Fxn1cSb2hsYm5qbGppYmFiZkmasJI474FW
	60AhgfTEktTs1NSC1CKYLUwcnFINjJ09Rw8nhTaHOrc95j8wc/OfA1pMOw4e/yO/yroq8O4Z
	L55E3cNz/PtOBEzjmbwvtubsOpnibaqh3l0mL5de41//+aXmq+7f66pWXT+vETLb/WKV8D+F
	ExP/L4gpv1rltSRvZvh9dhWZiQJbJ5ftr+ArNPj81FKG7ci/7F37J3ZWnbzX1/VMdbMSS3FG
	oqEWc1FxIgDlbjwn8QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code to handle the misplaced TRIMINFO register
incase of Exynos5420.

On Exynos5420 we have a TRIMINFO register being misplaced for
TMU channels 2, 3 and 4

TRIMINFO at 0x1006c000 contains data for TMU channel 3
TRIMINFO at 0x100a0000 contains data for TMU channel 4
TRIMINFO at 0x10068000 contains data for TMU channel 2

The misplaced register address is passed through devicetree and
map it seperately during probe.
Also, adds the documentation under devicetree/bindings/thermal/

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 .../devicetree/bindings/thermal/exynos-thermal.txt |   21 +++++++++++++
 drivers/thermal/samsung/exynos_tmu.c               |   32 +++++++++++++++++---
 2 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
index 284f530..e818473 100644
--- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
+++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
@@ -7,12 +7,21 @@
 	       "samsung,exynos4210-tmu"
 	       "samsung,exynos5250-tmu"
 	       "samsung,exynos5440-tmu"
+	       "samsung,exynos5420-tmu"
 - interrupt-parent : The phandle for the interrupt controller
 - reg : Address range of the thermal registers. For soc's which has multiple
 	instances of TMU and some registers are shared across all TMU's like
 	interrupt related then 2 set of register has to supplied. First set
 	belongs	to each instance of TMU and second set belongs to common TMU
 	registers.
+
+ ** NOTE FOR EXYNOS5420 **
+    TRIMINFO register is being misplaced for TMU channels 2, 3 and 4
+
+    TERMINFO for TMU channel 2 is present in address space of TMU channel 3
+    TERMINFO for TMU channel 3 is present in address space of TMU channel 4
+    TERMINFO for TMU channel 4 is present in address space of TMU channel 2
+
 - interrupts : Should contain interrupt for thermal system
 - clocks : The main clock for TMU device
 - clock-names : Thermal system clock name
@@ -43,6 +52,18 @@ Example 2):
 		clock-names = "tmu_apbif";
 	};
 
+Example 3): In case of Exynos5420 TMU channel 3
+
+	/* tmu for CPU3 */
+	tmu@1006c000 {
+		compatible = "samsung,exynos5420-tmu";
+		/* 2nd reg is for the misplaced TRIMINFO register */
+		reg = <0x1006c000 0x100>, <0x100a0000 0x4>;
+		interrupts = <0 185 0>;
+		clocks = <&clock 318>;
+		clock-names = "tmu_apbif";
+	};
+
 Note: For multi-instance tmu each instance should have an alias correctly
 numbered in "aliases" node.
 
diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index bfdfbd6..f95844e 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -42,6 +42,7 @@
  * @pdata: pointer to the tmu platform/configuration data
  * @base: base address of the single instance of the TMU controller.
  * @base_common: base address of the common registers of the TMU controller.
+ * @triminfo_base: misplaced register base for TRIMINFO on Exynos5420 only
  * @irq: irq number of the TMU controller.
  * @soc: id of the SOC type.
  * @irq_work: pointer to the irq work structure.
@@ -57,6 +58,7 @@ struct exynos_tmu_data {
 	struct exynos_tmu_platform_data *pdata;
 	void __iomem *base;
 	void __iomem *base_common;
+	void __iomem *triminfo_base;		/* Needed only Exynos5420 */
 	int irq;
 	enum soc_type soc;
 	struct work_struct irq_work;
@@ -186,7 +188,12 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
 		}
 	} else {
-		trim_info = readl(data->base + reg->triminfo_data);
+		/* On exynos5420 TRIMINFO is misplaced for some channels */
+		if (data->triminfo_base)
+			trim_info = readl(data->triminfo_base +
+						reg->triminfo_data);
+		else
+			trim_info = readl(data->base + reg->triminfo_data);
 	}
 	data->temp_error1 = trim_info & EXYNOS_TMU_TEMP_MASK;
 	data->temp_error2 = ((trim_info >> reg->triminfo_85_shift) &
@@ -586,8 +593,17 @@ static int exynos_map_dt_data(struct platform_device *pdev)
 	 * Check if the TMU shares some registers and then try to map the
 	 * memory of common registers.
 	 */
-	if (!TMU_SUPPORTS(pdata, SHARED_MEMORY))
+	if (!TMU_SUPPORTS(pdata, SHARED_MEMORY)) {
+		/* For Exynos5420 The misplaced TERMINFO register address will
+		 * be passed from device tree node.
+		 *
+		 * We cannot use devm_request_and_ioremap, as the base address
+		 * over laps with the address space of the other TMU channel.
+		 * Check Documentation for details
+		 */
+		data->triminfo_base = of_iomap(pdev->dev.of_node, 1);
 		return 0;
+	}
 
 	if (of_address_to_resource(pdev->dev.of_node, 1, &res)) {
 		dev_err(&pdev->dev, "failed to get Resource 1\n");
@@ -632,12 +648,13 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 	data->clk = devm_clk_get(&pdev->dev, "tmu_apbif");
 	if (IS_ERR(data->clk)) {
 		dev_err(&pdev->dev, "Failed to get clock\n");
-		return  PTR_ERR(data->clk);
+		ret = PTR_ERR(data->clk);
+		goto err_triminfo_base;
 	}
 
 	ret = clk_prepare(data->clk);
 	if (ret)
-		return ret;
+		goto err_triminfo_base;
 
 	if (pdata->type == SOC_ARCH_EXYNOS ||
 		pdata->type == SOC_ARCH_EXYNOS4210 ||
@@ -707,9 +724,13 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 	}
 
 	return 0;
+
 err_clk:
 	clk_unprepare(data->clk);
 	return ret;
+err_triminfo_base:
+	if (data->triminfo_base)
+		iounmap(data->triminfo_base);
 }
 
 static int exynos_tmu_remove(struct platform_device *pdev)
@@ -720,6 +741,9 @@ static int exynos_tmu_remove(struct platform_device *pdev)
 
 	exynos_unregister_thermal(data->reg_conf);
 
+	if (data->triminfo_base)
+		iounmap(data->triminfo_base);
+
 	clk_unprepare(data->clk);
 
 	if (!IS_ERR(data->regulator))
-- 
1.7.9.5

