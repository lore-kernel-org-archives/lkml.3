Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaJ0PaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:30:00 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52986 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaJ0P3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:29:44 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-b9-544e64e14a53
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 8/8] ARM: dts: exynos4412-trats: Switch max77686 regulators to
 GPIO control
Date: Mon, 27 Oct 2014 16:03:46 +0100
Message-id: <1414422226-10948-9-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com>
References: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xa7oPU/xCDPbsFLXYOGM9q8WkdQeY
	LKY+fMJmcf3Lc1aL+UfOsVoc/V1g8fqFoUXvgqtsFmeb3rBb3P96lNHi25UOJotNj6+xWlze
	NYfNYsb5fUwWty/zWqw9cpfd4nQ3q4OgR0tzD5vH3+fXWTz+rnrB7LFz1l12j02rOtk87lzb
	w+Yx72Sgx+Yl9R59W1YxenzeJBfAFcVlk5Kak1mWWqRvl8CVMXHXAuaCJ+IV81fkNDCeFOpi
	5OSQEDCR2L29hx3CFpO4cG89WxcjF4eQwFJGifd/9jNCOH1MEpNXXWUFqWITMJbYvHwJWJWI
	QCezRM/BXmYQh1lgNZPEzyungBwODmGBWInZc+RAGlgEVCW+L98ItoJXwF3i67HvzBDr5CRO
	HpsMNpRTwEPi9f2vYHEhoJrP77cyTmDkXcDIsIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMj
	JMC/7mBceszqEKMAB6MSD++EYt8QIdbEsuLK3EOMEhzMSiK8pwL8QoR4UxIrq1KL8uOLSnNS
	iw8xMnFwSjUwxht7LjNK+573ScRaceXtnkNtP3eUzjAMeuQkLfSvOTlR6UP9MmYjv1LdW+fY
	xDelib5/aT7ngsf+2Y0vLf6mf/wYF1fN/ceQ5bxjuL/PtQMOXWl7zvRdNTtz5MW3p8p793QY
	zkpMnsdUxZ92lruhSzyL5dkNBjaPsN/pmdcMmbf/co3lFTZUYinOSDTUYi4qTgQAdWZY6U4C	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove fixed regulators (duplicating what max77686 provides) and
add GPIO control to max77686 regulators.

This gives the system full control over those regulators. Previously
the state of such regulators was a mixture of what max77686 driver set
over I2C and what regulator-fixed set through GPIO.

Removal of 'regulator-always-on' from CAM_ISP_CORE_1.2V (buck9) allows
disabling it when it is not used. Previously this regulator was always
enabled because its enable state is a OR of:
 - ENB9 GPIO (turned by regulator-fixed),
 - BUCK9EN field in BUCK9CTRL register (max77686 through I2C).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts | 25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 7a68e0832cd6..ac1baff7130d 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -58,15 +58,6 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 
-		vemmc_reg: regulator-0 {
-			compatible = "regulator-fixed";
-			regulator-name = "VMEM_VDD_2.8V";
-			regulator-min-microvolt = <2800000>;
-			regulator-max-microvolt = <2800000>;
-			gpio = <&gpk0 2 0>;
-			enable-active-high;
-		};
-
 		cam_io_reg: voltage-regulator-1 {
 			compatible = "regulator-fixed";
 			regulator-name = "CAM_SENSOR_A";
@@ -94,16 +85,6 @@
 			enable-active-high;
 		};
 
-		cam_isp_core_reg: voltage-regulator-4 {
-			compatible = "regulator-fixed";
-			regulator-name = "CAM_ISP_CORE_1.2V_EN";
-			regulator-min-microvolt = <1200000>;
-			regulator-max-microvolt = <1200000>;
-			gpio = <&gpm0 3 0>;
-			enable-active-high;
-			regulator-always-on;
-		};
-
 		ps_als_reg: voltage-regulator-5 {
 			compatible = "regulator-fixed";
 			regulator-name = "LED_A_3.0V";
@@ -405,6 +386,7 @@
 					regulator-name = "VTF_2.8V";
 					regulator-min-microvolt = <2800000>;
 					regulator-max-microvolt = <2800000>;
+					gpio = <&gpy2 0 0>;
 				};
 
 				ldo22_reg: ldo22 {
@@ -412,6 +394,7 @@
 					regulator-name = "VMEM_VDD_2.8V";
 					regulator-min-microvolt = <2800000>;
 					regulator-max-microvolt = <2800000>;
+					gpio = <&gpk0 2 0>;
 				};
 
 				ldo23_reg: ldo23 {
@@ -518,6 +501,7 @@
 					regulator-name = "VMEM_VDDF_3.0V";
 					regulator-min-microvolt = <2850000>;
 					regulator-max-microvolt = <2850000>;
+					gpio = <&gpk0 2 0>;
 				};
 
 				buck9_reg: buck9 {
@@ -525,6 +509,7 @@
 					regulator-name = "CAM_ISP_CORE_1.2V";
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1200000>;
+					gpio = <&gpm0 3 0>;
 				};
 			};
 		};
@@ -591,7 +576,7 @@
 		broken-cd;
 		non-removable;
 		card-detect-delay = <200>;
-		vmmc-supply = <&vemmc_reg>;
+		vmmc-supply = <&ldo22_reg>;
 		clock-frequency = <400000000>;
 		samsung,dw-mshc-ciu-div = <0>;
 		samsung,dw-mshc-sdr-timing = <2 3>;
-- 
1.9.1

