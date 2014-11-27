Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbaK0LWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:22:24 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:21828 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbaK0LVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:21:16 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-35-5477092af201
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 7/7] ARM: dts: exynos4412-trats: Switch max77686 regulators
 to GPIO control
Date: Thu, 27 Nov 2014 12:20:53 +0100
Message-id: <1417087253-12306-8-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
References: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xK7panOUhBhufKVhsnLGe1WLqwyds
	FvOPnGO1eP3C0KL/8Wtmi7NNb9gt7n89ymjx7UoHk8Wmx9dYLS7vmsNmMeP8PiaLtUfusjvw
	eOycdZfdY9OqTjaPO9f2sHlsXlLv0bdlFaPH501yAWxRXDYpqTmZZalF+nYJXBknz95jK/gi
	UfF173bGBsbzwl2MHBwSAiYSq6+adzFyApliEhfurWfrYuTiEBJYyiix4Ox5Vginj0lie38D
	C0gVm4CxxOblS9hAbBGBFYwSx28ogtjMAuuZJB5scwKxhQUSJC5/O80KYrMIqEos6Z0P1ssr
	4C4x8/8cZohtchInj00Gq+EU8JDYe+s2WI0QUM2eV3dYJjDyLmBkWMUomlqaXFCclJ5rpFec
	mFtcmpeul5yfu4kREoxfdzAuPWZ1iFGAg1GJh5fhVlmIEGtiWXFl7iFGCQ5mJRFeLsbyECHe
	lMTKqtSi/Pii0pzU4kOMTBycUg2M1prPZ61XTPY/139v026GuZrnopyk/ph7JvLsynt003Gt
	3I/7sy+23Ppz6miBt69FQsn/dx36PTW54rIHu3xmuGbHFORoPQjfMfny/jeMKvM2SW5MvsAu
	n8bRuvZgw6XXfBNnMc5i2NNgNu9+rcfbopW3Ta2nsG7WlAtr/5zQNNvzV8Cy4KVKSizFGYmG
	WsxFxYkAf7fBBSQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove fixed regulators (duplicating what max77686 provides) and
add GPIO control to max77686 regulators. Add of_compatible to
voltage-regulators node.

This gives the system full control over those regulators. Previously
the state of such regulators was a mixture of what max77686 driver set
over I2C and what regulator-fixed set through GPIO.

Removal of 'regulator-always-on' from CAM_ISP_CORE_1.2V (buck9) allows
disabling it when it is not used. Previously this regulator was always
enabled because its enable state is a OR of:
 - ENB9 GPIO (turned always on by regulator-fixed),
 - BUCK9EN field in BUCK9CTRL register (off by max77686 through I2C).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts | 25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 7a68e0832cd6..4ba981eae32e 100644
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
+					ena-gpios = <&gpy2 0 GPIO_ACTIVE_HIGH>;
 				};
 
 				ldo22_reg: ldo22 {
@@ -412,6 +394,7 @@
 					regulator-name = "VMEM_VDD_2.8V";
 					regulator-min-microvolt = <2800000>;
 					regulator-max-microvolt = <2800000>;
+					ena-gpios = <&gpk0 2 GPIO_ACTIVE_HIGH>;
 				};
 
 				ldo23_reg: ldo23 {
@@ -518,6 +501,7 @@
 					regulator-name = "VMEM_VDDF_3.0V";
 					regulator-min-microvolt = <2850000>;
 					regulator-max-microvolt = <2850000>;
+					ena-gpios = <&gpk0 2 GPIO_ACTIVE_HIGH>;
 				};
 
 				buck9_reg: buck9 {
@@ -525,6 +509,7 @@
 					regulator-name = "CAM_ISP_CORE_1.2V";
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1200000>;
+					ena-gpios = <&gpm0 3 GPIO_ACTIVE_HIGH>;
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

