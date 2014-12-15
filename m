Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbaLOO5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:57:24 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27914 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbaLOO5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:57:14 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-bc-548ef6c76a13
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene@kernel.org>, Chanwoo Choi <cw00.choi@samsung.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 3/3] ARM: dts: Add devfreq to Exynos3250 and Rinato board
Date: Mon, 15 Dec 2014 15:56:53 +0100
Message-id: <1418655413-25410-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1418655413-25410-1-git-send-email-k.kozlowski@samsung.com>
References: <1418655413-25410-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsVy+t/xq7rHv/WFGCw/JG2xccZ6VovrX56z
	Wsw/co7V4vULQ4v+x6+ZLc42vWG32PT4GqvF5V1z2Cw+9x5htJhxfh+Txdojd9ktll6/yGRx
	u3EFmwOvx5p5axg9Nq3qZPPYvKTeo2/LKkaPz5vkAlijuGxSUnMyy1KL9O0SuDJ+bV7GXHCI
	v6Lv2EemBsYLPF2MnBwSAiYSrdtPMEPYYhIX7q1n62Lk4hASWMoocXjqLyinj0liweXP7CBV
	bALGEpuXLwFLiAg8Z5LYOesNC4jDLDCDUeLewl0sIFXCAj4Sy05sBJvLIqAqsfLYQrBuXgF3
	iSuzLzNB7JOTOHlsMiuIzSngIXHldSNYjRBQzfrTS9kmMPIuYGRYxSiaWppcUJyUnmuoV5yY
	W1yal66XnJ+7iRESkl92MC4+ZnWIUYCDUYmHN2Fvb4gQa2JZcWXuIUYJDmYlEd5Z7/pChHhT
	EiurUovy44tKc1KLDzEycXBKNTDyT79iLxW3daWs4QbX/2Wr9Zx2VS6rE1pp7b3xUdpc3tgo
	Voesuy0H3y8Qffbb0Urcm+X//jVWfYKCV92LOsKWCH39ve+Dk99jhXnff/k+iT3z0mrnh2wn
	rZwQG6cb7qtPHFvzN3PCrHp2/fd7o7cqPXkhbZJWtm2brevrvKtTtj34e+rwid4YJZbijERD
	Leai4kQAYGF04ScCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devfreq to Exynos3250 common file and enable it for Rinato board.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/boot/dts/exynos3250-rinato.dts | 12 ++++++++++++
 arch/arm/boot/dts/exynos3250.dtsi       | 26 ++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 7970b8e91ab2..6def01c61742 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -567,6 +567,18 @@
 	clock-frequency = <24000000>;
 };
 
+&busfreq_mif {
+	vdd-mif-supply = <&buck1_reg>;
+	devfreq-events = <&ppmu_dmc0_3>, <&ppmu_dmc1_3>;
+	status = "okay";
+};
+
+&busfreq_int {
+	vdd-int-supply = <&buck3_reg>;
+	devfreq-events = <&ppmu_leftbus_3>, <&ppmu_rightbus_3>;
+	status = "okay";
+};
+
 &pinctrl_0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&sleep0>;
diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 51e3e7111e59..cc0e30768ec2 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -175,6 +175,32 @@
 			#clock-cells = <1>;
 		};
 
+		busfreq_mif: busfreq@106A0000 {
+			compatible = "samsung,exynos3250-busfreq-mif";
+			clocks = <&cmu_dmc CLK_DIV_DMC>;
+			clock-names = "dmc";
+			status = "disabled";
+		};
+
+		busfreq_int: busfreq@116A0000 {
+			compatible = "samsung,exynos3250-busfreq-int";
+			clocks = <&cmu CLK_DIV_ACLK_400_MCUISP>,
+				<&cmu CLK_DIV_ACLK_266>,
+				<&cmu CLK_DIV_ACLK_200>,
+				<&cmu CLK_DIV_ACLK_160>,
+				<&cmu CLK_DIV_GDL>,
+				<&cmu CLK_DIV_GDR>,
+				<&cmu CLK_DIV_MFC>;
+			clock-names = "aclk_400",
+				"aclk_266",
+				"aclk_200",
+				"aclk_160",
+				"aclk_gdl",
+				"aclk_gdr",
+				"mfc";
+			status = "disabled";
+		};
+
 		rtc: rtc@10070000 {
 			compatible = "samsung,exynos3250-rtc";
 			reg = <0x10070000 0x100>;
-- 
1.9.1

