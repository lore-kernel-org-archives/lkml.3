Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab3HLSr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:47:58 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36037 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab3HLSrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:47:07 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 7/9] ARM: dove: add PCIe controllers to SoC DT
Date: Mon, 12 Aug 2013 20:46:53 +0200
Message-Id: <1376333215-12885-8-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a node for the pcie controllers found on Dove SoCs to the
SoC DT include.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/boot/dts/dove.dtsi |   54 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index d42b323..499abad 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -44,6 +44,60 @@
 			  MBUS_ID(0x03, 0x01) 0 0xc8000000 0x0100000   /* CESA SRAM  1M */
 			  MBUS_ID(0x0d, 0x00) 0 0xf0000000 0x0100000>; /* PMU  SRAM  1M */
 
+		pcie: pcie-controller {
+			compatible = "marvell,dove-pcie";
+			status = "disabled";
+			device_type = "pci";
+			#address-cells = <3>;
+			#size-cells = <2>;
+
+			msi-parent = <&intc>;
+			bus-range = <0x00 0xff>;
+
+			ranges = <0x82000000 0x0 0x40000 MBUS_ID(0xf0, 0x01) 0x40000 0 0x2000
+			          0x82000000 0x0 0x80000 MBUS_ID(0xf0, 0x01) 0x80000 0 0x2000
+				  0x82000000 0x1 0x0 MBUS_ID(0x04, 0xe8) 0 1 0   /* Port 0.0 Mem */
+				  0x81000000 0x1 0x0 MBUS_ID(0x04, 0xe0) 0 1 0   /* Port 0.0 I/O */
+				  0x82000000 0x2 0x0 MBUS_ID(0x08, 0xe8) 0 1 0   /* Port 1.0 Mem */
+				  0x81000000 0x2 0x0 MBUS_ID(0x08, 0xe0) 0 1 0>; /* Port 1.0 I/O */
+
+			pcie-port@0 {
+				device_type = "pci";
+				status = "disabled";
+				assigned-addresses = <0x82000800 0 0x40000 0 0x2000>;
+				reg = <0x0800 0 0 0 0>;
+				clocks = <&gate_clk 4>;
+				marvell,pcie-port = <0>;
+
+				#address-cells = <3>;
+				#size-cells = <2>;
+				ranges = <0x82000000 0 0 0x82000000 0x1 0 1 0
+				          0x81000000 0 0 0x81000000 0x1 0 1 0>;
+
+				#interrupt-cells = <1>;
+				interrupt-map-mask = <0 0 0 0>;
+				interrupt-map = <0 0 0 0 &intc 16>;
+			};
+
+			pcie-port@1 {
+				device_type = "pci";
+				status = "disabled";
+				assigned-addresses = <0x82002800 0 0x80000 0 0x2000>;
+				reg = <0x1000 0 0 0 0>;
+				clocks = <&gate_clk 5>;
+				marvell,pcie-port = <1>;
+
+				#address-cells = <3>;
+				#size-cells = <2>;
+				ranges = <0x82000000 0 0 0x82000000 0x2 0 1 0
+				          0x81000000 0 0 0x81000000 0x2 0 1 0>;
+
+				#interrupt-cells = <1>;
+				interrupt-map-mask = <0 0 0 0>;
+				interrupt-map = <0 0 0 0 &intc 18>;
+			};
+		};
+
 		internal-regs {
 			compatible = "simple-bus";
 			#address-cells = <1>;
-- 
1.7.10.4

