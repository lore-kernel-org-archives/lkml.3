Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbaDDXPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 19:15:04 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:55163 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbaDDXOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 19:14:54 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH v2 5/5] ARM: zynq: dt: Use #defines for clock specifiers
Date: Fri,  4 Apr 2014 16:14:16 -0700
Message-Id: <1396653256-28397-6-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.1.1.gbb9f595
In-Reply-To: <1396653256-28397-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1396653256-28397-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use symbolic names instead of bare numbers to specify clocks.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---

Changes in v2:
 - this patch has been added

---
 arch/arm/boot/dts/zynq-7000.dtsi | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 36a34ffa30af..9a54b49d0fd2 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -13,6 +13,7 @@
 
 #include "skeleton.dtsi"
 #include <dt-bindings/interrupt-controller/arm-gic.h>
+#include <dt-bindings/clock/zynq-7000.h>
 
 / {
 	compatible = "xlnx,zynq-7000";
@@ -25,8 +26,8 @@
 			compatible = "arm,cortex-a9";
 			device_type = "cpu";
 			reg = <0>;
-			clocks = <&clkc 3>;
 			clock-latency = <1000>;
+			clocks = <&clkc ZYNQ_CLK_CPU_6OR4X>;
 			operating-points = <
 				/* kHz    uV */
 				666667  1000000
@@ -39,7 +40,7 @@
 			compatible = "arm,cortex-a9";
 			device_type = "cpu";
 			reg = <1>;
-			clocks = <&clkc 3>;
+			clocks = <&clkc ZYNQ_CLK_CPU_6OR4X>;
 		};
 	};
 
@@ -78,7 +79,8 @@
 		uart0: uart@e0000000 {
 			compatible = "xlnx,xuartps";
 			status = "disabled";
-			clocks = <&clkc 23>, <&clkc 40>;
+			clocks = <&clkc ZYNQ_CLK_UART0>,
+				 <&clkc ZYNQ_CLK_UART0_APER>;
 			clock-names = "ref_clk", "aper_clk";
 			reg = <0xE0000000 0x1000>;
 			interrupts = <GIC_SPI 27 IRQ_TYPE_LEVEL_HIGH>;
@@ -87,7 +89,8 @@
 		uart1: uart@e0001000 {
 			compatible = "xlnx,xuartps";
 			status = "disabled";
-			clocks = <&clkc 24>, <&clkc 41>;
+			clocks = <&clkc ZYNQ_CLK_UART1>,
+				 <&clkc ZYNQ_CLK_UART1_APER>;
 			clock-names = "ref_clk", "aper_clk";
 			reg = <0xE0001000 0x1000>;
 			interrupts = <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>;
@@ -98,7 +101,9 @@
 			reg = <0xe000b000 0x4000>;
 			status = "disabled";
 			interrupts = <GIC_SPI 22 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&clkc 30>, <&clkc 30>, <&clkc 13>;
+			clocks = <&clkc ZYNQ_CLK_GEM0_APER>,
+				 <&clkc ZYNQ_CLK_GEM0_APER>,
+				 <&clkc ZYNQ_CLK_GEM0>;
 			clock-names = "pclk", "hclk", "tx_clk";
 		};
 
@@ -107,7 +112,9 @@
 			reg = <0xe000c000 0x4000>;
 			status = "disabled";
 			interrupts = <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&clkc 31>, <&clkc 31>, <&clkc 14>;
+			clocks = <&clkc ZYNQ_CLK_GEM1_APER>,
+				 <&clkc ZYNQ_CLK_GEM1_APER>,
+				 <&clkc ZYNQ_CLK_GEM1>;
 			clock-names = "pclk", "hclk", "tx_clk";
 		};
 
@@ -115,7 +122,8 @@
 			compatible = "arasan,sdhci-8.9a";
 			status = "disabled";
 			clock-names = "clk_xin", "clk_ahb";
-			clocks = <&clkc 21>, <&clkc 32>;
+			clocks = <&clkc ZYNQ_CLK_SDIO0>,
+				 <&clkc ZYNQ_CLK_SDIO0_APER>;
 			interrupt-parent = <&intc>;
 			interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
 			reg = <0xe0100000 0x1000>;
@@ -125,7 +133,8 @@
 			compatible = "arasan,sdhci-8.9a";
 			status = "disabled";
 			clock-names = "clk_xin", "clk_ahb";
-			clocks = <&clkc 22>, <&clkc 33>;
+			clocks = <&clkc ZYNQ_CLK_SDIO1>,
+				 <&clkc ZYNQ_CLK_SDIO1_APER>;
 			interrupt-parent = <&intc>;
 			interrupts = <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>;
 			reg = <0xe0101000 0x1000>;
@@ -163,7 +172,7 @@
 			reg = <0xf8f00200 0x20>;
 			interrupts = <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_EDGE_RISING)>;
 			interrupt-parent = <&intc>;
-			clocks = <&clkc 4>;
+			clocks = <&clkc ZYNQ_CLK_CPU_3OR2X>;
 		};
 
 		ttc0: ttc0@f8001000 {
@@ -172,7 +181,7 @@
 				     <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
 			compatible = "cdns,ttc";
-			clocks = <&clkc 6>;
+			clocks = <&clkc ZYNQ_CLK_CPU_1X>;
 			reg = <0xF8001000 0x1000>;
 		};
 
@@ -182,7 +191,7 @@
 				     <GIC_SPI 38 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>;
 			compatible = "cdns,ttc";
-			clocks = <&clkc 6>;
+			clocks = <&clkc ZYNQ_CLK_CPU_1X>;
 			reg = <0xF8002000 0x1000>;
 		};
 		scutimer: scutimer@f8f00600 {
@@ -190,7 +199,7 @@
 			interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_EDGE_RISING)>;
 			compatible = "arm,cortex-a9-twd-timer";
 			reg = < 0xf8f00600 0x20 >;
-			clocks = <&clkc 4>;
+			clocks = <&clkc ZYNQ_CLK_CPU_3OR2X>;
 		} ;
 	};
 };
-- 
1.9.1.1.gbb9f595

