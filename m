Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbaFSN0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:26:38 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:50460 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600AbaFSN0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:26:35 -0400
From: Alban Bedel <alban.bedel@avionic-design.de>
To: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCHv2 1/2] ARM: tegra: tamonten: add the base board regulators
Date: Thu, 19 Jun 2014 15:25:49 +0200
Message-Id: <1403184350-25403-1-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 2.0.0
X-Provags-ID: V02:K0:+q2PrikUvq3HYGvKdnJDd3p/9P8RFouw5NrckHITamh
 /2HOXV6HLYRJg3FHKNZYUeVQcjyOhWpbcjmTkFkkrTA/9EhPL6
 4GtZdprPZ4hj+wrGwnvdmjvaw5ca0VvdNl34kL7fShAvnLGG3U
 6ZasGx2znNbmTokFCHpMpr1Tuzp6RBoxAM9SDw34jR6iZsvOs4
 Q/lQ/AhUT+gDnm3RRbZQzwC88UY1ehKc8uTU5cZjfU9yeM/6K8
 A7wTboAfQpymNIgQV9LnXu2Te7WYtxRiRmcsdW0o9iYX1/FRy5
 86MvKxrJb6qU1sBj4iQ1hGn64AzAwQt2tJo0lABYgfWx63iScY
 uHR27oA/odnS27gzy3fX74foIlvC2DHlwyczS+Mzgs4uGbCINr
 GUo+k4uIxgKy8xPO4SyzMBqbgTDBcWqBX+bnXIGJvJsbDXDQDr
 ND9wx
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the Tamonten DTS define a fixed regulator for the 5V supply.
However this regulator is in fact on the base board. Fix this by
properly defining the regulators found on the base boards.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
v2: * Put the board regualtors in the 'regulator' group with IDs
      starting at 100
---
 arch/arm/boot/dts/tegra20-medcom-wide.dts | 41 +++++++++++++++++++++++++++++++
 arch/arm/boot/dts/tegra20-plutux.dts      | 41 +++++++++++++++++++++++++++++++
 arch/arm/boot/dts/tegra20-tamonten.dtsi   | 10 +-------
 arch/arm/boot/dts/tegra20-tec.dts         | 41 +++++++++++++++++++++++++++++++
 4 files changed, 124 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-medcom-wide.dts b/arch/arm/boot/dts/tegra20-medcom-wide.dts
index 6d3a4cb..0318b84 100644
--- a/arch/arm/boot/dts/tegra20-medcom-wide.dts
+++ b/arch/arm/boot/dts/tegra20-medcom-wide.dts
@@ -64,4 +64,45 @@
 			 <&tegra_car TEGRA20_CLK_CDEV1>;
 		clock-names = "pll_a", "pll_a_out0", "mclk";
 	};
+
+	regulators {
+		vcc_24v_reg: regulator@100 {
+			compatible = "regulator-fixed";
+			reg = <100>;
+			regulator-name = "vcc_24v";
+			regulator-min-microvolt = <24000000>;
+			regulator-max-microvolt = <24000000>;
+			regulator-always-on;
+		};
+
+		vdd_5v0_reg: regulator@101 {
+			compatible = "regulator-fixed";
+			reg = <101>;
+			regulator-name = "vdd_5v0";
+			vin-supply = <&vcc_24v_reg>;
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			regulator-always-on;
+		};
+
+		vdd_3v3_reg: regulator@102 {
+			compatible = "regulator-fixed";
+			reg = <102>;
+			regulator-name = "vdd_3v3";
+			vin-supply = <&vcc_24v_reg>;
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+		};
+
+		vdd_1v8_reg: regulator@103 {
+			compatible = "regulator-fixed";
+			reg = <103>;
+			regulator-name = "vdd_1v8";
+			vin-supply = <&vdd_3v3_reg>;
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-always-on;
+		};
+	};
 };
diff --git a/arch/arm/boot/dts/tegra20-plutux.dts b/arch/arm/boot/dts/tegra20-plutux.dts
index 29051a2..a10b415 100644
--- a/arch/arm/boot/dts/tegra20-plutux.dts
+++ b/arch/arm/boot/dts/tegra20-plutux.dts
@@ -58,4 +58,45 @@
 			 <&tegra_car TEGRA20_CLK_CDEV1>;
 		clock-names = "pll_a", "pll_a_out0", "mclk";
 	};
+
+	regulators {
+		vcc_24v_reg: regulator@100 {
+			compatible = "regulator-fixed";
+			reg = <100>;
+			regulator-name = "vcc_24v";
+			regulator-min-microvolt = <24000000>;
+			regulator-max-microvolt = <24000000>;
+			regulator-always-on;
+		};
+
+		vdd_5v0_reg: regulator@101 {
+			compatible = "regulator-fixed";
+			reg = <101>;
+			regulator-name = "vdd_5v0";
+			vin-supply = <&vcc_24v_reg>;
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			regulator-always-on;
+		};
+
+		vdd_3v3_reg: regulator@102 {
+			compatible = "regulator-fixed";
+			reg = <102>;
+			regulator-name = "vdd_3v3";
+			vin-supply = <&vcc_24v_reg>;
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+		};
+
+		vdd_1v8_reg: regulator@103 {
+			compatible = "regulator-fixed";
+			reg = <103>;
+			regulator-name = "vdd_1v8";
+			vin-supply = <&vdd_3v3_reg>;
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-always-on;
+		};
+	};
 };
diff --git a/arch/arm/boot/dts/tegra20-tamonten.dtsi b/arch/arm/boot/dts/tegra20-tamonten.dtsi
index a1b0d96..9c83185 100644
--- a/arch/arm/boot/dts/tegra20-tamonten.dtsi
+++ b/arch/arm/boot/dts/tegra20-tamonten.dtsi
@@ -334,6 +334,7 @@
 			#gpio-cells = <2>;
 			gpio-controller;
 
+			/* vdd_5v0_reg must be provided by the base board */
 			sys-supply = <&vdd_5v0_reg>;
 			vin-sm0-supply = <&sys_reg>;
 			vin-sm1-supply = <&sys_reg>;
@@ -511,15 +512,6 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 
-		vdd_5v0_reg: regulator@0 {
-			compatible = "regulator-fixed";
-			reg = <0>;
-			regulator-name = "vdd_5v0";
-			regulator-min-microvolt = <5000000>;
-			regulator-max-microvolt = <5000000>;
-			regulator-always-on;
-		};
-
 		pci_vdd_reg: regulator@1 {
 			compatible = "regulator-fixed";
 			reg = <1>;
diff --git a/arch/arm/boot/dts/tegra20-tec.dts b/arch/arm/boot/dts/tegra20-tec.dts
index 890562c..c12d8be 100644
--- a/arch/arm/boot/dts/tegra20-tec.dts
+++ b/arch/arm/boot/dts/tegra20-tec.dts
@@ -67,4 +67,45 @@
 			 <&tegra_car TEGRA20_CLK_CDEV1>;
 		clock-names = "pll_a", "pll_a_out0", "mclk";
 	};
+
+	regulators {
+		vcc_24v_reg: regulator@100 {
+			compatible = "regulator-fixed";
+			reg = <100>;
+			regulator-name = "vcc_24v";
+			regulator-min-microvolt = <24000000>;
+			regulator-max-microvolt = <24000000>;
+			regulator-always-on;
+		};
+
+		vdd_5v0_reg: regulator@101 {
+			compatible = "regulator-fixed";
+			reg = <101>;
+			regulator-name = "vdd_5v0";
+			vin-supply = <&vcc_24v_reg>;
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			regulator-always-on;
+		};
+
+		vdd_3v3_reg: regulator@102 {
+			compatible = "regulator-fixed";
+			reg = <102>;
+			regulator-name = "vdd_3v3";
+			vin-supply = <&vcc_24v_reg>;
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+		};
+
+		vdd_1v8_reg: regulator@103 {
+			compatible = "regulator-fixed";
+			reg = <103>;
+			regulator-name = "vdd_1v8";
+			vin-supply = <&vdd_3v3_reg>;
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-always-on;
+		};
+	};
 };
-- 
2.0.0

