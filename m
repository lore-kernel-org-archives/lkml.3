Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaFEPs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:48:58 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58892 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751667AbaFEPsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:48:55 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com, balbi@ti.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] ARM: dts: berlin: add BG2Q nodes for USB support
Date: Thu,  5 Jun 2014 17:48:45 +0200
Message-Id: <1401983326-19205-9-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds nodes describing the Marvell Berlin BG2Q USB PHY and USB. The BG2Q
SoC has 3 USB host controller, compatible with ChipIdea.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 arch/arm/boot/dts/berlin2q.dtsi | 51 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index b74e5ec66354..a6902ea5580c 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -87,6 +87,39 @@
 			#interrupt-cells = <3>;
 		};
 
+		usb_phy2: usbphy@a2f400 {
+			compatible = "marvell,berlin-usbphy";
+			reg = <0xa2f400 0x128>;
+			#phy-cells = <0>;
+			resets = <&chip 14>;
+			status = "disabled";
+		};
+
+		usb2: usb@a30000 {
+			compatible = "marvell,berlin-usb";
+			reg = <0xa30000 0x10000>;
+			interrupts = <GIC_SPI 52 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&chip CLKID_USB2>;
+			marvell,usbphy = <&usb_phy2>;
+			status = "disabled";
+		};
+
+		usb_phy0: usbphy@b74000 {
+			compatible = "marvell,berlin-usbphy";
+			reg = <0xb74000 0x128>;
+			#phy-cells = <0>;
+			resets = <&chip 12>;
+			status = "disabled";
+		};
+
+		usb_phy1: usbphy@b78000 {
+			compatible = "marvell,berlin-usbphy";
+			reg = <0xb78000 0x128>;
+			#phy-cells = <0>;
+			resets = <&chip 13>;
+			status = "disabled";
+		};
+
 		apb@e80000 {
 			compatible = "simple-bus";
 			#address-cells = <1>;
@@ -280,6 +313,24 @@
 			clock-names = "refclk";
 		};
 
+		usb0: usb@ed0000 {
+			compatible = "marvell,berlin-usb";
+			reg = <0xed0000 0x10000>;
+			interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&chip CLKID_USB0>;
+			marvell,usbphy = <&usb_phy0>;
+			status = "disabled";
+		};
+
+		usb1: usb@ee0000 {
+			compatible = "marvell,berlin-usb";
+			reg = <0xee0000 0x10000>;
+			interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&chip CLKID_USB1>;
+			marvell,usbphy = <&usb_phy1>;
+			status = "disabled";
+		};
+
 		apb@fc0000 {
 			compatible = "simple-bus";
 			#address-cells = <1>;
-- 
1.9.1

