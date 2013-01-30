Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab3A3DCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 22:02:52 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13643 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab3A3DCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 22:02:44 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 29 Jan 2013 19:00:51 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>, Mark Zhang <markz@nvidia.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 2/4] tegra: ventana: add display and backlight DT nodes
Date: Wed, 30 Jan 2013 12:02:17 +0900
Message-ID: <1359514939-15653-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359514939-15653-1-git-send-email-acourbot@nvidia.com>
References: <1359514939-15653-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/boot/dts/tegra20-ventana.dts | 34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
index adc4754..48f4e6d 100644
--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -10,6 +10,16 @@
 		reg = <0x00000000 0x40000000>;
 	};
 
+	host1x {
+		dc@54200000 {
+			rgb {
+				status = "okay";
+				nvidia,ddc-i2c-bus = <&lcd_ddc>;
+				nvidia,panel = <&panel>;
+			};
+		};
+	};
+
 	pinmux {
 		pinctrl-names = "default";
 		pinctrl-0 = <&state_default>;
@@ -341,7 +351,7 @@
 			#size-cells = <0>;
 		};
 
-		i2c@1 {
+		lcd_ddc: i2c@1 {
 			reg = <1>;
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -516,6 +526,24 @@
 		bus-width = <8>;
 	};
 
+	backlight: backlight {
+		compatible = "pwm-backlight";
+		pwms = <&pwm 2 5000000>;
+
+		brightness-levels = <0 16 32 48 64 80 96 112 128 144 160 176 192 208 224 240 255>;
+		default-brightness-level = <10>;
+	};
+
+	panel: panel {
+		compatible = "chunghwa,claa101wa01a";
+
+		pnl-supply = <&vdd_pnl_reg>;
+		pnl-enable-gpios = <&gpio 10 0>;
+
+		bl-supply = <&vdd_bl_reg>;
+		bl-enable-gpios = <&gpio 28 0>;
+	};
+
 	regulators {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -549,7 +577,7 @@
 			enable-active-high;
 		};
 
-		regulator@3 {
+		vdd_pnl_reg: regulator@3 {
 			compatible = "regulator-fixed";
 			reg = <3>;
 			regulator-name = "vdd_pnl";
@@ -559,7 +587,7 @@
 			enable-active-high;
 		};
 
-		regulator@4 {
+		vdd_bl_reg: regulator@4 {
 			compatible = "regulator-fixed";
 			reg = <4>;
 			regulator-name = "vdd_bl";
-- 
1.8.1.1

