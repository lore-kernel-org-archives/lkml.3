Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbaJaE12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 00:27:28 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:62700 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbaJaE1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 00:27:25 -0400
From: Tim Harvey <tharvey@gateworks.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Silvio F <silvio.fricke@gmail.com>, Christian Hemp <c.hemp@phytec.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Iain Paton <ipaton0@gmail.com>, devicetree@vger.kernel.org
Subject: [PATCH 5/5] ARM: imx: ventana: enable LDO bypass mode for GW54xx
Date: Thu, 30 Oct 2014 21:27:11 -0700
Message-Id: <1414729631-11005-6-git-send-email-tharvey@gateworks.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1414729631-11005-1-git-send-email-tharvey@gateworks.com>
References: <1414729631-11005-1-git-send-email-tharvey@gateworks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GW54xx baseboard has a PFUZE100 PMIC capable of regulating the
core voltages (VDD_ARM, VDD_SOC) externally such that the internal IMX6
anatop LDO regulators are not needed. This provides a power reduction
(as the PMIC is more efficient than the LDO's) as well as moves some
of the power/thermal burden from the IMX to the PMIC.

Cc: devicetree@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Shawn Guo <shawn.guo@freescale.com>
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
 arch/arm/boot/dts/imx6qdl-gw54xx.dtsi | 55 +++++++++++++++++++++++++----------
 1 file changed, 39 insertions(+), 16 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl-gw54xx.dtsi b/arch/arm/boot/dts/imx6qdl-gw54xx.dtsi
index cf13239..3ab0872 100644
--- a/arch/arm/boot/dts/imx6qdl-gw54xx.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-gw54xx.dtsi
@@ -142,6 +142,11 @@
 	status = "okay";
 };
 
+&cpu0 {
+	arm-supply = <&reg_vdd_arm>;
+	soc-supply = <&reg_vdd_soc>;
+};
+
 &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
@@ -215,7 +220,8 @@
 		reg = <0x08>;
 
 		regulators {
-			sw1a_reg: sw1ab {
+			/* VDD_ARM */
+			reg_vdd_arm: sw1ab {
 				regulator-min-microvolt = <300000>;
 				regulator-max-microvolt = <1875000>;
 				regulator-boot-on;
@@ -223,7 +229,8 @@
 				regulator-ramp-delay = <6250>;
 			};
 
-			sw1c_reg: sw1c {
+			/* VDD_SOC */
+			reg_vdd_soc: sw1c {
 				regulator-min-microvolt = <300000>;
 				regulator-max-microvolt = <1875000>;
 				regulator-boot-on;
@@ -231,77 +238,93 @@
 				regulator-ramp-delay = <6250>;
 			};
 
-			sw2_reg: sw2 {
+			/* VDD_HIGH */
+			reg_3p0v: sw2 {
 				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <3950000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			sw3a_reg: sw3a {
+			/* VDD_DDR */
+			reg_ddra: sw3a {
 				regulator-min-microvolt = <400000>;
 				regulator-max-microvolt = <1975000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			sw3b_reg: sw3b {
+			/* VDD_DDR */
+			reg_ddrb: sw3b {
 				regulator-min-microvolt = <400000>;
 				regulator-max-microvolt = <1975000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			sw4_reg: sw4 {
+			/* VDD_1P8 */
+			reg_1p8v: sw4 {
 				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			swbst_reg: swbst {
+			/* VDD_5P0 */
+			reg_swbst: swbst {
 				regulator-min-microvolt = <5000000>;
 				regulator-max-microvolt = <5150000>;
 			};
 
-			snvs_reg: vsnvs {
+			reg_snvs: vsnvs {
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <3000000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			vref_reg: vrefddr {
+			/* VDD_VREF */
+			reg_vref: vrefddr {
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			vgen1_reg: vgen1 {
+			/* VDD_PCI_1P5_1 */
+			reg_1p5va: vgen1 {
 				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <1550000>;
+				regulator-boot-on;
+				regulator-always-on;
 			};
 
-			vgen2_reg: vgen2 {
+			/* VDD_PCI_1P5_2 */
+			reg_1p5vb: vgen2 {
 				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <1550000>;
+				regulator-boot-on;
+				regulator-always-on;
 			};
 
-			vgen3_reg: vgen3 {
+			/* unused */
+			reg_vgen3: vgen3 {
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			vgen4_reg: vgen4 {
+			/* VDD_AUD_1P8 */
+			reg_aud_1p8v: vgen4 {
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-always-on;
 			};
 
-			vgen5_reg: vgen5 {
+			/* VDD_2P5 */
+			reg_2p5v: vgen5 {
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-always-on;
 			};
 
-			vgen6_reg: vgen6 {
+			/* unused */
+			reg_vgen6: vgen6 {
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-always-on;
@@ -320,7 +343,7 @@
 		compatible = "fsl,sgtl5000";
 		reg = <0x0a>;
 		clocks = <&clks 201>;
-		VDDA-supply = <&sw4_reg>;
+		VDDA-supply = <&reg_1p8v>;
 		VDDIO-supply = <&reg_3p3v>;
 	};
 
-- 
1.8.3.2

