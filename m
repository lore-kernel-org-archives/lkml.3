Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161528AbaKNP2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:28:05 -0500
Received: from down.free-electrons.com ([37.187.137.238]:36170 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161472AbaKNP16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:27:58 -0500
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com, balbi@ti.com,
        p.zabel@pengutronix.de
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 11/13] ARM: dts: Berlin: enable USB on the BG2Q DMP
Date: Fri, 14 Nov 2014 16:26:01 +0100
Message-Id: <1415978763-27345-12-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415978763-27345-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1415978763-27345-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the 2 available USB PHY and USB nodes on the Marvell Berlin BG2Q
DMP.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts | 53 ++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
index ea1f99b8eed6..f7c25580e122 100644
--- a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
+++ b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
@@ -7,6 +7,8 @@
  */
 
 /dts-v1/;
+
+#include <dt-bindings/gpio/gpio.h>
 #include "berlin2q.dtsi"
 
 / {
@@ -21,6 +23,39 @@
 	choosen {
 		bootargs = "console=ttyS0,115200 earlyprintk";
 	};
+
+	regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		reg_usb0_vbus: regulator@0 {
+			compatible = "regulator-fixed";
+			regulator-name = "usb0_vbus";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			gpio = <&portb 8 GPIO_ACTIVE_HIGH>;
+			enable-active-high;
+		};
+
+		reg_usb1_vbus: regulator@1 {
+			compatible = "regulator-fixed";
+			regulator-name = "usb1_vbus";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			gpio = <&portb 10 GPIO_ACTIVE_HIGH>;
+			enable-active-high;
+		};
+
+		reg_usb2_vbus: regulator@2 {
+			compatible = "regulator-fixed";
+			regulator-name = "usb2_vbus";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			gpio = <&portb 12 GPIO_ACTIVE_HIGH>;
+			enable-active-high;
+		};
+	};
 };
 
 &sdhci1 {
@@ -46,6 +81,24 @@
 	status = "okay";
 };
 
+&usb_phy0 {
+	status = "okay";
+};
+
+&usb_phy2 {
+	status = "okay";
+};
+
+&usb0 {
+	vbus-supply = <&reg_usb0_vbus>;
+	status = "okay";
+};
+
+&usb2 {
+	vbus-supply = <&reg_usb2_vbus>;
+	status = "okay";
+};
+
 &eth0 {
 	status = "okay";
 };
-- 
2.1.0

