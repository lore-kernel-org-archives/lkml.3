Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab3LKRaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 12:30:10 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:44270 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3LKRaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 12:30:08 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Josh Cartwright <josh.cartwright@ni.com>
Subject: [PATCH] ARM: zynq: add gem support
Date: Wed, 11 Dec 2013 09:29:49 -0800
Message-Id: <1386782989-2720-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steffen Trumtrar <s.trumtrar@pengutronix.de>

The zynq includes a Cadence GEM IP core. This is compatible with the macb driver.
Add it to the zynq-7000 DT.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Josh Cartwright <josh.cartwright@ni.com>
[soren: rebased to current Linus tree, added zc706 + zed support, moved phy-mode property to board level dtses]
Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
This has a soft dependency on the net-next tree which has some patches for the
macb driver which are required for full functionality. But adding this patch to
any tree without net-next shouldn't do any harm, network might be
non-operational at the worst - I think.

	Sören

 arch/arm/boot/dts/zynq-7000.dtsi | 18 ++++++++++++++++++
 arch/arm/boot/dts/zynq-zc702.dts |  5 +++++
 arch/arm/boot/dts/zynq-zc706.dts |  5 +++++
 arch/arm/boot/dts/zynq-zed.dts   |  5 +++++
 4 files changed, 33 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index e7f73b2e4550..aebc48d8c397 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -65,6 +65,24 @@
 			interrupts = <0 50 4>;
 		};
 
+		gem0: ethernet@e000b000 {
+			compatible = "cdns,gem";
+			reg = <0xe000b000 0x4000>;
+			status = "disabled";
+			interrupts = <0 22 4>;
+			clocks = <&clkc 30>, <&clkc 30>, <&clkc 13>;
+			clock-names = "pclk", "hclk", "tx_clk";
+		};
+
+		gem1: ethernet@e000c000 {
+			compatible = "cdns,gem";
+			reg = <0xe000c000 0x4000>;
+			status = "disabled";
+			interrupts = <0 45 4>;
+			clocks = <&clkc 31>, <&clkc 31>, <&clkc 14>;
+			clock-names = "pclk", "hclk", "tx_clk";
+		};
+
 		slcr: slcr@f8000000 {
 			compatible = "xlnx,zynq-slcr";
 			reg = <0xF8000000 0x1000>;
diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
index 21aea99a067b..34d680a46b7e 100644
--- a/arch/arm/boot/dts/zynq-zc702.dts
+++ b/arch/arm/boot/dts/zynq-zc702.dts
@@ -29,6 +29,11 @@
 
 };
 
+&gem0 {
+	status = "okay";
+	phy-mode = "rgmii";
+};
+
 &uart1 {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/zynq-zc706.dts b/arch/arm/boot/dts/zynq-zc706.dts
index 79009e0b74b9..b2835d5fc09a 100644
--- a/arch/arm/boot/dts/zynq-zc706.dts
+++ b/arch/arm/boot/dts/zynq-zc706.dts
@@ -30,6 +30,11 @@
 
 };
 
+&gem0 {
+	status = "okay";
+	phy-mode = "rgmii";
+};
+
 &uart1 {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/zynq-zed.dts b/arch/arm/boot/dts/zynq-zed.dts
index d6acf2b1cdf4..2eda06889dfc 100644
--- a/arch/arm/boot/dts/zynq-zed.dts
+++ b/arch/arm/boot/dts/zynq-zed.dts
@@ -30,6 +30,11 @@
 
 };
 
+&gem0 {
+	status = "okay";
+	phy-mode = "rgmii";
+};
+
 &uart1 {
 	status = "okay";
 };
-- 
1.8.5.1

