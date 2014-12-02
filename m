Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaLBIqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:46:30 -0500
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34734 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaLBIq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:46:28 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
Subject: [PATCH v2] ARM: zynq: DT: Add USB to device tree
Date: Tue,  2 Dec 2014 00:46:18 -0800
Message-Id: <1417509978-19060-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.2.0.1.g9ee0458
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add USB nodes to zc702, zc706 and zed device trees.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
v2:
 - remove '@0' from phy node name
 - don't add bogus space
---
 arch/arm/boot/dts/zynq-7000.dtsi | 20 ++++++++++++++++++++
 arch/arm/boot/dts/zynq-zc702.dts | 11 +++++++++++
 arch/arm/boot/dts/zynq-zc706.dts | 10 ++++++++++
 arch/arm/boot/dts/zynq-zed.dts   | 10 ++++++++++
 4 files changed, 51 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index ce2ef5bec4f2..68096bb027db 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -315,6 +315,26 @@
 			clocks = <&clkc 4>;
 		};
 
+		usb0: usb@e0002000 {
+			compatible = "xlnx,zynq-usb-2.20a", "chipidea,usb2";
+			status = "disabled";
+			clocks = <&clkc 28>;
+			interrupt-parent = <&intc>;
+			interrupts = <0 21 4>;
+			reg = <0xe0002000 0x1000>;
+			phy_type = "ulpi";
+		};
+
+		usb1: usb@e0003000 {
+			compatible = "xlnx,zynq-usb-2.20a", "chipidea,usb2";
+			status = "disabled";
+			clocks = <&clkc 29>;
+			interrupt-parent = <&intc>;
+			interrupts = <0 44 4>;
+			reg = <0xe0003000 0x1000>;
+			phy_type = "ulpi";
+		};
+
 		watchdog0: watchdog@f8005000 {
 			clocks = <&clkc 45>;
 			compatible = "xlnx,zynq-wdt-r1p2";
diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
index 94e2cda6f9b6..f80c6e65f6e8 100644
--- a/arch/arm/boot/dts/zynq-zc702.dts
+++ b/arch/arm/boot/dts/zynq-zc702.dts
@@ -36,6 +36,11 @@
 			linux,default-trigger = "heartbeat";
 		};
 	};
+
+	usb_phy0: usb-phy {
+		compatible = "usb-nop-xceiv";
+		#phy-cells = <0>;
+	};
 };
 
 &can0 {
@@ -135,3 +140,9 @@
 &uart1 {
 	status = "okay";
 };
+
+&usb0 {
+	status = "okay";
+	dr_mode = "host";
+	usb-phy = <&usb_phy0>;
+};
diff --git a/arch/arm/boot/dts/zynq-zc706.dts b/arch/arm/boot/dts/zynq-zc706.dts
index a8bbdfbc7093..bece52e47cfe 100644
--- a/arch/arm/boot/dts/zynq-zc706.dts
+++ b/arch/arm/boot/dts/zynq-zc706.dts
@@ -27,6 +27,10 @@
 		bootargs = "console=ttyPS0,115200 earlyprintk";
 	};
 
+	usb_phy0: usb-phy {
+		compatible = "usb-nop-xceiv";
+		#phy-cells = <0>;
+	};
 };
 
 &gem0 {
@@ -114,3 +118,9 @@
 &uart1 {
 	status = "okay";
 };
+
+&usb0 {
+	status = "okay";
+	dr_mode = "host";
+	usb-phy = <&usb_phy0>;
+};
diff --git a/arch/arm/boot/dts/zynq-zed.dts b/arch/arm/boot/dts/zynq-zed.dts
index 697779a353ed..efecb2379832 100644
--- a/arch/arm/boot/dts/zynq-zed.dts
+++ b/arch/arm/boot/dts/zynq-zed.dts
@@ -27,6 +27,10 @@
 		bootargs = "console=ttyPS0,115200 earlyprintk";
 	};
 
+	usb_phy0: usb-phy {
+		compatible = "usb-nop-xceiv";
+		#phy-cells = <0>;
+	};
 };
 
 &gem0 {
@@ -46,3 +50,9 @@
 &uart1 {
 	status = "okay";
 };
+
+&usb0 {
+	status = "okay";
+	dr_mode = "host";
+	usb-phy = <&usb_phy0>;
+};
-- 
2.2.0.1.g9ee0458

