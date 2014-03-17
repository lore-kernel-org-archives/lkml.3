Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695AbaCQJ4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 05:56:10 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:47735 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210AbaCQJ4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 05:56:08 -0400
X-Mailbox-Line: From 11bf968ac586e4a06d56c97d150ecf2c4afd8f27 Mon Sep 17 00:00:00 2001
Message-Id: <11bf968ac586e4a06d56c97d150ecf2c4afd8f27.1395049204.git.moinejf@free.fr>
In-Reply-To: <cover.1395049204.git.moinejf@free.fr>
References: <cover.1395049204.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Mon, 17 Mar 2014 09:52:29 +0100
Subject: [PATCH RFC 5/5] ARM: AM33XX: dts: Change the tda998x description
To: dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org
Cc: Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tda998x being moved from a 'slave encoder' to a normal DRM
encoder/connector and the tilcdc_slave glue being removed, the
declaration of the HDMI transmitter description must be changed in
the associated DTs.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 arch/arm/boot/dts/am335x-base0033.dts  | 28 +++++++++++++++++++---------
 arch/arm/boot/dts/am335x-boneblack.dts | 21 ++++++++++++++++-----
 2 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-base0033.dts b/arch/arm/boot/dts/am335x-base0033.dts
index 72a9b3f..93cd40b 100644
--- a/arch/arm/boot/dts/am335x-base0033.dts
+++ b/arch/arm/boot/dts/am335x-base0033.dts
@@ -14,15 +14,6 @@
 	model = "IGEP COM AM335x on AQUILA Expansion";
 	compatible = "isee,am335x-base0033", "isee,am335x-igep0033", "ti,am33xx";
 
-	hdmi {
-		compatible = "ti,tilcdc,slave";
-		i2c = <&i2c0>;
-		pinctrl-names = "default", "off";
-		pinctrl-0 = <&nxp_hdmi_pins>;
-		pinctrl-1 = <&nxp_hdmi_off_pins>;
-		status = "okay";
-	};
-
 	leds_base {
 		pinctrl-names = "default";
 		pinctrl-0 = <&leds_base_pins>;
@@ -85,6 +76,11 @@
 
 &lcdc {
 	status = "okay";
+	port {
+		lcd_0: endpoint@0 {
+			remote-endpoint = <&tda998x_0>;
+		};
+	};
 };
 
 &i2c0 {
@@ -92,4 +88,18 @@
 		compatible = "at,24c256";
 		reg = <0x50>;
 	};
+	tda998x: hdmi-encoder {
+		compatible = "nxp,tda998x";
+		reg = <0x70>;
+
+		pinctrl-names = "default", "off";
+		pinctrl-0 = <&nxp_hdmi_pins>;
+		pinctrl-1 = <&nxp_hdmi_off_pins>;
+
+		port {
+			tda998x_0: endpoint@0 {
+				remote-endpoint = <&lcd_0>;
+			};
+		};
+	};
 };
diff --git a/arch/arm/boot/dts/am335x-boneblack.dts b/arch/arm/boot/dts/am335x-boneblack.dts
index 6b71ad9..a530bcb 100644
--- a/arch/arm/boot/dts/am335x-boneblack.dts
+++ b/arch/arm/boot/dts/am335x-boneblack.dts
@@ -64,15 +64,26 @@
 
 &lcdc {
 	status = "okay";
+	port {
+		lcd_0: endpoint@0 {
+			remote-endpoint = <&tda998x_0>;
+		};
+	};
 };
 
-/ {
-	hdmi {
-		compatible = "ti,tilcdc,slave";
-		i2c = <&i2c0>;
+&i2c0 {
+	tda998x: hdmi-encoder {
+		compatible = "nxp,tda998x";
+		reg = <0x70>;
+
 		pinctrl-names = "default", "off";
 		pinctrl-0 = <&nxp_hdmi_bonelt_pins>;
 		pinctrl-1 = <&nxp_hdmi_bonelt_off_pins>;
-		status = "okay";
+
+		port {
+			tda998x_0: endpoint@0 {
+				remote-endpoint = <&lcd_0>;
+			};
+		};
 	};
 };
-- 
1.9.0

