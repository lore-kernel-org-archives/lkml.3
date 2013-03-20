Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab3CTNsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 09:48:03 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16969 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab3CTNr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 09:47:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 20 Mar 2013 06:47:58 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 4/4] ARM: tegra: dalmore: add fixed regulator's node
Date: Wed, 20 Mar 2013 19:14:30 +0530
Message-ID: <1363787070-14801-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1363787070-14801-1-git-send-email-ldewangan@nvidia.com>
References: <1363787070-14801-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NVIDIA's Tegra114 platform Dalmore has some voltage switches
which are controlled by the Tegra GPIOs.

Add dt node for such fixed regulators.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/boot/dts/tegra114-dalmore.dts |   55 ++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
index a47c3d2..86116f1 100644
--- a/arch/arm/boot/dts/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -836,5 +836,60 @@
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

