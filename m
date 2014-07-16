Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760341AbaGPI3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:29:48 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60637 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756087AbaGPI0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:26:17 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com, balbi@ti.com,
        p.zabel@pengutronix.de
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 10/12] ARM: dts: Berlin: enable USB on the BG2Q DMP
Date: Wed, 16 Jul 2014 10:26:04 +0200
Message-Id: <1405499166-6726-11-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405499166-6726-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1405499166-6726-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the 2 available USB PHY and USB nodes on the Marvell Berlin BG2Q
DMP.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts | 53 ++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
index 995150f93795..0d515046f5f5 100644
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
@@ -37,3 +72,21 @@
 &uart0 {
 	status = "okay";
 };
+
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
-- 
1.9.1

