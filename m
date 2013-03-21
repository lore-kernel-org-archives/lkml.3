Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243Ab3CUNvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 09:51:04 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11212 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab3CUNu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 09:50:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 21 Mar 2013 06:50:42 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@nvidia.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 3/4] ARM: tegra: dalmore: add fixed regulator node
Date: Thu, 21 Mar 2013 19:17:42 +0530
Message-ID: <1363873663-19272-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1363873663-19272-1-git-send-email-ldewangan@nvidia.com>
References: <1363873663-19272-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NVIDIA's Tegra114 reference platform Dalmore has voltage switch
regulators which are controlled by the Tegra GPIOs.

Add DT node for fixed regulators.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/boot/dts/tegra114-dalmore.dts |   57 +++++++++++++++++++++++++++++++-
 1 files changed, 56 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
index 6e9d757..6ad1f45 100644
--- a/arch/arm/boot/dts/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -752,7 +752,7 @@
 			vsys-l2-supply = <&vdd_ac_bat_reg>;
 
 			regulators {
-				dcdc1 {
+				tps65090_dcdc1_reg: dcdc1 {
 					regulator-name = "vdd-sys-5v0";
 					regulator-always-on;
 					regulator-boot-on;
@@ -838,5 +838,60 @@
 			regulator-max-microvolt = <5000000>;
 			regulator-always-on;
 		};
+
+		dvdd_ts_reg: regulator@1 {
+			compatible = "regulator-fixed";
+			reg = <1>;
+			regulator-name = "dvdd_ts";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			enable-active-high;
+			gpio = <&gpio 61 0>; /* GPIO PH5 */
+		};
+
+		lcd_bl_en_reg: regulator@2 {
+			compatible = "regulator-fixed";
+			reg = <2>;
+			regulator-name = "lcd_bl_en";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			enable-active-high;
+			gpio = <&gpio 58 0>; /* GPIO PH2 */
+		};
+
+		usb1_vbus_reg: regulator@3 {
+			compatible = "regulator-fixed";
+			reg = <3>;
+			regulator-name = "usb1_vbus";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			enable-active-high;
+			gpio = <&gpio 108 0>; /* GPIO PN4 */
+			gpio-open-drain;
+			vin-supply = <&tps65090_dcdc1_reg>;
+		};
+
+		usb3_vbus_reg: regulator@4 {
+			compatible = "regulator-fixed";
+			reg = <4>;
+			regulator-name = "usb2_vbus";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			enable-active-high;
+			gpio = <&gpio 86 0>; /* GPIO PK6 */
+			gpio-open-drain;
+			vin-supply = <&tps65090_dcdc1_reg>;
+		};
+
+		vdd_hdmi_reg: regulator@5 {
+			compatible = "regulator-fixed";
+			reg = <5>;
+			regulator-name = "vdd_hdmi_5v0";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			enable-active-high;
+			gpio = <&gpio 81 0>; /* GPIO PK1 */
+			vin-supply = <&tps65090_dcdc1_reg>;
+		};
 	};
 };
-- 
1.7.1.1

