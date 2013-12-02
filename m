Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab3LBSDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 13:03:10 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:51852 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab3LBSCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 13:02:52 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <cjb@laptop.org>, Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v3 2/2] arm: dt: zynq: Add SDHCI nodes
Date: Mon,  2 Dec 2013 10:02:37 -0800
Message-Id: <1386007357-11956-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1386007357-11956-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1386007357-11956-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add nodes for the Arasan SDHCI controller to Zynq dts files.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
v2:
 - update compatibilty string according to changes in 1/2 (append
   '-8.9a' IP version string)
---
 arch/arm/boot/dts/zynq-7000.dtsi | 20 ++++++++++++++++++++
 arch/arm/boot/dts/zynq-zc702.dts |  4 ++++
 arch/arm/boot/dts/zynq-zc706.dts |  4 ++++
 arch/arm/boot/dts/zynq-zed.dts   |  4 ++++
 4 files changed, 32 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index e7f73b2e4550..4aecd1baf435 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -65,6 +65,26 @@
 			interrupts = <0 50 4>;
 		};
 
+		sdhci0: ps7-sdhci@e0100000 {
+			compatible = "arasan,sdhci-8.9a";
+			status = "disabled";
+			clock-names = "clk_xin", "clk_ahb";
+			clocks = <&clkc 21>, <&clkc 32>;
+			interrupt-parent = <&intc>;
+			interrupts = <0 24 4>;
+			reg = <0xe0100000 0x1000>;
+		} ;
+
+		sdhci1: ps7-sdhci@e0101000 {
+			compatible = "arasan,sdhci-8.9a";
+			status = "disabled";
+			clock-names = "clk_xin", "clk_ahb";
+			clocks = <&clkc 22>, <&clkc 33>;
+			interrupt-parent = <&intc>;
+			interrupts = <0 47 4>;
+			reg = <0xe0101000 0x1000>;
+		} ;
+
 		slcr: slcr@f8000000 {
 			compatible = "xlnx,zynq-slcr";
 			reg = <0xF8000000 0x1000>;
diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
index 21aea99a067b..454394453e9c 100644
--- a/arch/arm/boot/dts/zynq-zc702.dts
+++ b/arch/arm/boot/dts/zynq-zc702.dts
@@ -29,6 +29,10 @@
 
 };
 
+&sdhci0 {
+	status = "okay";
+};
+
 &uart1 {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/zynq-zc706.dts b/arch/arm/boot/dts/zynq-zc706.dts
index 79009e0b74b9..d734d5411760 100644
--- a/arch/arm/boot/dts/zynq-zc706.dts
+++ b/arch/arm/boot/dts/zynq-zc706.dts
@@ -30,6 +30,10 @@
 
 };
 
+&sdhci0 {
+	status = "okay";
+};
+
 &uart1 {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/zynq-zed.dts b/arch/arm/boot/dts/zynq-zed.dts
index d6acf2b1cdf4..cd259dd13cdc 100644
--- a/arch/arm/boot/dts/zynq-zed.dts
+++ b/arch/arm/boot/dts/zynq-zed.dts
@@ -30,6 +30,10 @@
 
 };
 
+&sdhci0 {
+	status = "okay";
+};
+
 &uart1 {
 	status = "okay";
 };
-- 
1.8.4.4

