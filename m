Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965680AbaKNP3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:29:36 -0500
Received: from down.free-electrons.com ([37.187.137.238]:36163 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161471AbaKNP16 (ORCPT
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
Subject: [PATCH v7 10/13] ARM: dts: berlin: add BG2Q nodes for USB support
Date: Fri, 14 Nov 2014 16:26:00 +0100
Message-Id: <1415978763-27345-11-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415978763-27345-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1415978763-27345-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds nodes describing the Marvell Berlin BG2Q USB PHY and USB. The BG2Q
SoC has 3 USB host controller, compatible with ChipIdea.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 arch/arm/boot/dts/berlin2q.dtsi | 55 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index 2de8d6f8973c..834142bdfbb1 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -114,6 +114,40 @@
 			#interrupt-cells = <3>;
 		};
 
+		usb_phy2: phy@a2f400 {
+			compatible = "marvell,berlin2-usb-phy";
+			reg = <0xa2f400 0x128>;
+			#phy-cells = <0>;
+			resets = <&chip 0x104 14>;
+			status = "disabled";
+		};
+
+		usb2: usb@a30000 {
+			compatible = "chipidea,usb2";
+			reg = <0xa30000 0x10000>;
+			interrupts = <GIC_SPI 52 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&chip CLKID_USB2>;
+			phys = <&usb_phy2>;
+			phy-names = "usb-phy";
+			status = "disabled";
+		};
+
+		usb_phy0: phy@b74000 {
+			compatible = "marvell,berlin2-usb-phy";
+			reg = <0xb74000 0x128>;
+			#phy-cells = <0>;
+			resets = <&chip 0x104 12>;
+			status = "disabled";
+		};
+
+		usb_phy1: phy@b78000 {
+			compatible = "marvell,berlin2-usb-phy";
+			reg = <0xb78000 0x128>;
+			#phy-cells = <0>;
+			resets = <&chip 0x104 13>;
+			status = "disabled";
+		};
+
 		eth0: ethernet@b90000 {
 			compatible = "marvell,pxa168-eth";
 			reg = <0xb90000 0x10000>;
@@ -365,6 +399,26 @@
 			};
 		};
 
+		usb0: usb@ed0000 {
+			compatible = "chipidea,usb2";
+			reg = <0xed0000 0x10000>;
+			interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&chip CLKID_USB0>;
+			phys = <&usb_phy0>;
+			phy-names = "usb-phy";
+			status = "disabled";
+		};
+
+		usb1: usb@ee0000 {
+			compatible = "chipidea,usb2";
+			reg = <0xee0000 0x10000>;
+			interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&chip CLKID_USB1>;
+			phys = <&usb_phy1>;
+			phy-names = "usb-phy";
+			status = "disabled";
+		};
+
 		apb@fc0000 {
 			compatible = "simple-bus";
 			#address-cells = <1>;
@@ -457,5 +511,6 @@
 				interrupts = <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
 			};
 		};
+
 	};
 };
-- 
2.1.0

