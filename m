Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbbAELu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:50:56 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:41973 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbbAELuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:50:54 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-bf-54aa7a9b21f1
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 5/5] ARM: dts: exynos4412-trats: Switch max77686 regulators
 to GPIO control
Date: Mon, 05 Jan 2015 12:48:45 +0100
Message-id: <1420458525-22576-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420458525-22576-1-git-send-email-k.kozlowski@samsung.com>
References: <1420458525-22576-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmluLIzCtJLcpLzFFi42I5/e/4Zd3ZVatCDC52yFhsnLGe1WLqwyds
	FvOPnGO1eP3C0KL/8Wtmi7NNb9gtvl3pYLLY9Pgaq8XlXXPYLGac38fkwOWxc9Zddo9NqzrZ
	PDYvqffo27KK0ePzJrkA1igum5TUnMyy1CJ9uwSujDcrzrIUPJGouD31C0sD4xHhLkZODgkB
	E4kJry+zQdhiEhfurQeyuTiEBJYySvzum8kM4fQxSWxbd5IJpIpNwFhi8/IlYFUiAh8YJVZN
	+sEK4jALTGOUuHDqO1ALB4ewQIJE92slkAYWAVWJ8z+vM4KEeQXcJe5/zYfYJidx8thkVhCb
	U8BDouvpJ2YQWwioZNrOZuYJjLwLGBlWMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoQE3Ncd
	jEuPWR1iFOBgVOLh9TixMkSINbGsuDL3EKMEB7OSCO+r9FUhQrwpiZVVqUX58UWlOanFhxiZ
	ODilGhhvHPW6XC7xfN23f0dvxhTcvX5ZRiT8nkyEaACL9pqsk+YLt7XEhs2WTk90Dvg7vatn
	6dWVVpee7rWJPel04vfxnhVXDrGtEtA7w7Azdo/9/bDLL/5NuR5257Bhn8MGs62H1RtP88sv
	6Xo6I7hxIZOSn/f5rom/FKKfZpXt8L1/KkDaUexLquh8JZbijERDLeai4kQAl40D5BYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove fixed regulators (duplicating what max77686 provides) and
add GPIO enable control to max77686 regulators.

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
index 405d4f337e89..186c210680c1 100644
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
+					maxim,ena-gpios = <&gpy2 0 GPIO_ACTIVE_HIGH>;
 				};
 
 				ldo22_reg: ldo22 {
@@ -412,6 +394,7 @@
 					regulator-name = "VMEM_VDD_2.8V";
 					regulator-min-microvolt = <2800000>;
 					regulator-max-microvolt = <2800000>;
+					maxim,ena-gpios = <&gpk0 2 GPIO_ACTIVE_HIGH>;
 				};
 
 				ldo23_reg: ldo23 {
@@ -518,6 +501,7 @@
 					regulator-name = "VMEM_VDDF_3.0V";
 					regulator-min-microvolt = <2850000>;
 					regulator-max-microvolt = <2850000>;
+					maxim,ena-gpios = <&gpk0 2 GPIO_ACTIVE_HIGH>;
 				};
 
 				buck9_reg: buck9 {
@@ -525,6 +509,7 @@
 					regulator-name = "CAM_ISP_CORE_1.2V";
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1200000>;
+					maxim,ena-gpios = <&gpm0 3 GPIO_ACTIVE_HIGH>;
 				};
 			};
 		};
@@ -587,7 +572,7 @@
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

