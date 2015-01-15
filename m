Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbbAOIlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 03:41:50 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45598 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbbAOIls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 03:41:48 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-a5-54b77d492dfb
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Kukjin Kim <kgene@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 3/3] ARM: dts: exynos4412-trats2: Switch max77686 regulators to
 GPIO control
Date: Thu, 15 Jan 2015 09:41:35 +0100
Message-id: <1421311295-18960-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1421311295-18960-1-git-send-email-k.kozlowski@samsung.com>
References: <1421311295-18960-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJJMWRmVeSWpSXmKPExsVy+t/xq7qetdtDDG5OlbGYf+Qcq8XrF4YW
	/Y9fM1tsenyN1eLyrjlsFjPO72NyYPPYtKqTzWPzknqPvi2rGD0+b5ILYInisklJzcksSy3S
	t0vgyujZfYGt4IlERd/ySewNjEeEuxg5OSQETCRut71nhbDFJC7cW8/WxcjFISSwlFHi4tYd
	7BBOH5PEpZvv2ECq2ASMJTYvXwJmiwisAKpqsgSxmQUMJX6++8MOYgsLxEmcPX2fBcRmEVCV
	WN3YCFTPwcEr4C7R114CsUxO4uSxyWCLOQU8JPpOTgdrFQIq6Vkyg30CI+8CRoZVjKKppckF
	xUnpuYZ6xYm5xaV56XrJ+bmbGCHB82UH4+JjVocYBTgYlXh4Gfy2hwixJpYVV+YeYpTgYFYS
	4e3MAQrxpiRWVqUW5ccXleakFh9iZOLglGpgFLNzzPHrMz0e+r14ivDMX17fS+52/PiqMcXg
	StWtqGT9PfW89qkX86tmzH8z48kHiQgupq+r+KJlVn881GX0kjnhcFVfAlO/jJLoHMXZf+0c
	tjO98i/7W5Dww6fnSnz4grQ7c+acLtxrwmsca3f7XMC1ZDev/j3rbx687fHOgrvLzW3u51tJ
	SizFGYmGWsxFxYkAfvvdVfwBAAA=
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
index ef05139506e6..8611c07c2e41 100644
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

