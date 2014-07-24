Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934854AbaGXXDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:03:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759848AbaGXXBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:01:14 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v2 05/11] ARM: dts: zynq: Add QSPI for Parallella
Date: Fri, 25 Jul 2014 01:00:14 +0200
Message-Id: <1406242820-20140-6-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406242820-20140-1-git-send-email-afaerber@suse.de>
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare SPI0 and SPI1 while at it.

Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 v2: New
 
 arch/arm/boot/dts/zynq-7000.dtsi      | 37 +++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/zynq-parallella.dts |  4 ++++
 2 files changed, 41 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 8fd826a..eed3df0 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -122,6 +122,30 @@
 			interrupts = <0 50 4>;
 		};
 
+		spi0: spi@e0006000 {
+			compatible = "xlnx,zynq-spi-r1p6";
+			reg = <0xe0006000 0x1000>;
+			status = "disabled";
+			interrupt-parent = <&intc>;
+			interrupts = <0 26 4>;
+			clocks = <&clkc 25>, <&clkc 34>;
+			clock-names = "ref_clk", "pclk";
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		spi1: spi@e0007000 {
+			compatible = "xlnx,zynq-spi-r1p6";
+			reg = <0xe0007000 0x1000>;
+			status = "disabled";
+			interrupt-parent = <&intc>;
+			interrupts = <0 49 4>;
+			clocks = <&clkc 26>, <&clkc 35>;
+			clock-names = "ref_clk", "pclk";
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
 		gem0: ethernet@e000b000 {
 			compatible = "cdns,gem";
 			reg = <0xe000b000 0x4000>;
@@ -140,6 +164,19 @@
 			clock-names = "pclk", "hclk", "tx_clk";
 		};
 
+		qspi: qspi@e000d000 {
+			compatible = "xlnx,zynq-spi-r1p6";
+			reg = <0xe000d000 0x1000>;
+			status = "disabled";
+			interrupt-parent = <&intc>;
+			interrupts = <0 19 4>;
+			clocks = <&clkc 10>, <&clkc 43>;
+			clock-names = "ref_clk", "pclk";
+			num-cs = <1>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
 		sdhci0: sdhci@e0100000 {
 			compatible = "arasan,sdhci-8.9a";
 			status = "disabled";
diff --git a/arch/arm/boot/dts/zynq-parallella.dts b/arch/arm/boot/dts/zynq-parallella.dts
index 41afd9d..56f68ea 100644
--- a/arch/arm/boot/dts/zynq-parallella.dts
+++ b/arch/arm/boot/dts/zynq-parallella.dts
@@ -55,6 +55,10 @@
 	status = "okay";
 };
 
+&qspi {
+	status = "okay";
+};
+
 &sdhci1 {
 	status = "okay";
 };
-- 
1.9.3

