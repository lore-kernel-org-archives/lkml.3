Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbbAHLKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 06:10:36 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:65388 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbbAHLKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 06:10:34 -0500
From: Matthias Brugger <matthias.bgg@gmail.com>
To: linux-kernel@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, matthias.bgg@gmail.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        s.hauer@pengutronix.de
Subject: [PATCH v2 1/2] ARM: mediatek: dts: Add uart to mt6589
Date: Thu,  8 Jan 2015 12:03:43 +0100
Message-Id: <1420715024-27738-2-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420715024-27738-1-git-send-email-matthias.bgg@gmail.com>
References: <1420715024-27738-1-git-send-email-matthias.bgg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the uart ports to the device tree of Mediatek mt6589 SoC.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 arch/arm/boot/dts/mt6589.dtsi | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/arm/boot/dts/mt6589.dtsi b/arch/arm/boot/dts/mt6589.dtsi
index c91b2a9..106b61b 100644
--- a/arch/arm/boot/dts/mt6589.dtsi
+++ b/arch/arm/boot/dts/mt6589.dtsi
@@ -65,6 +65,12 @@
 			clock-frequency = <32000>;
 			#clock-cells = <0>;
 		};
+
+		uart_clk: dummy26m {
+			compatible = "fixed-clock";
+			clock-frequency = <26000000>;
+			#clock-cells = <0>;
+		};
 	};
 
 	soc {
@@ -100,5 +106,37 @@
 			      <0x10214000 0x2000>,
 			      <0x10216000 0x2000>;
 		};
+
+		uart0: serial@11006000 {
+			compatible = "mediatek,mt6577-uart";
+			reg = <0x11006000 0x400>;
+			interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_LOW>;
+			clocks = <&uart_clk>;
+			status = "disabled";
+		};
+
+		uart1: serial@11007000 {
+			compatible = "mediatek,mt6577-uart";
+			reg = <0x11007000 0x400>;
+			interrupts = <GIC_SPI 52 IRQ_TYPE_LEVEL_LOW>;
+			clocks = <&uart_clk>;
+			status = "disabled";
+		};
+
+		uart2: serial@11008000 {
+			compatible = "mediatek,mt6577-uart";
+			reg = <0x11008000 0x400>;
+			interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_LOW>;
+			clocks = <&uart_clk>;
+			status = "disabled";
+		};
+
+		uart3: serial@11009000 {
+			compatible = "mediatek,mt6577-uart";
+			reg = <0x11009000 0x400>;
+			interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_LOW>;
+			clocks = <&uart_clk>;
+			status = "disabled";
+		};
 	};
 };
-- 
1.9.1

