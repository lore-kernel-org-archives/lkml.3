Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440Ab3JOTIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:08:37 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:40921 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759598Ab3JOTI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:08:27 -0400
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
        devicetree@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 2/2] arm: dt: zynq: Add SDHCI nodes
Date: Tue, 15 Oct 2013 12:08:05 -0700
Message-Id: <1381864085-8806-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381864085-8806-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1381864085-8806-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add nodes for the Arasan SDHCI controller to Zynq dts files.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/boot/dts/zynq-7000.dtsi | 20 ++++++++++++++++++++
 arch/arm/boot/dts/zynq-zc702.dts |  4 ++++
 arch/arm/boot/dts/zynq-zc706.dts |  4 ++++
 arch/arm/boot/dts/zynq-zed.dts   |  4 ++++
 4 files changed, 32 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index e32b92b949d2..75a549f6cbf7 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -65,6 +65,26 @@
 			interrupts = <0 50 4>;
 		};
 
+		sdhci0: ps7-sdhci@e0100000 {
+			compatible = "arasan,sdhci";
+			status = "disabled";
+			clock-names = "clk_xin", "clk_ahb";
+			clocks = <&clkc 21>, <&clkc 32>;
+			interrupt-parent = <&intc>;
+			interrupts = <0 24 4>;
+			reg = <0xe0100000 0x1000>;
+		} ;
+
+		sdhci1: ps7-sdhci@e0101000 {
+			compatible = "arasan,sdhci";
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
1.8.4

