Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbbANLgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 06:36:11 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:41859 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbbANLgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 06:36:09 -0500
From: Matthias Brugger <matthias.bgg@gmail.com>
To: linux@arm.linux.org.uk, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, matthias.bgg@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, howard.chen@linaro.org
Subject: [PATCH 2/2] ARM: mediatek: dts: Add uart to mt6592
Date: Wed, 14 Jan 2015 12:35:56 +0100
Message-Id: <1421235356-6631-2-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421235356-6631-1-git-send-email-matthias.bgg@gmail.com>
References: <1421235356-6631-1-git-send-email-matthias.bgg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the uart ports and the uart clock to Mediateks
mt6592 SoC.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 arch/arm/boot/dts/mt6592.dtsi | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/arm/boot/dts/mt6592.dtsi b/arch/arm/boot/dts/mt6592.dtsi
index 67c8174..c69201f 100644
--- a/arch/arm/boot/dts/mt6592.dtsi
+++ b/arch/arm/boot/dts/mt6592.dtsi
@@ -78,6 +78,12 @@
 		#clock-cells = <0>;
 	};
 
+	uart_clk: dummy26m {
+		compatible = "fixed-clock";
+		clock-frequency = <26000000>;
+		#clock-cells = <0>;
+	};
+
 	timer: timer@10008000 {
 		compatible = "mediatek,mt6577-timer";
 		reg = <0x10008000 0x80>;
@@ -102,4 +108,36 @@
 		reg = <0x10211000 0x1000>,
 		      <0x10212000 0x1000>;
 	};
+
+	uart0: serial@11002000 {
+		compatible = "mediatek,mt6577-uart";
+		reg = <0x11002000 0x400>;
+		interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_LOW>;
+		clocks = <&uart_clk>;
+		status = "disabled";
+	};
+
+	uart1: serial@11003000 {
+		compatible = "mediatek,mt6577-uart";
+		reg = <0x11003000 0x400>;
+		interrupts = <GIC_SPI 52 IRQ_TYPE_LEVEL_LOW>;
+		clocks = <&uart_clk>;
+		status = "disabled";
+	};
+
+	uart2: serial@11004000 {
+		compatible = "mediatek,mt6577-uart";
+		reg = <0x11004000 0x400>;
+		interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_LOW>;
+		clocks = <&uart_clk>;
+		status = "disabled";
+	};
+
+	uart3: serial@11005000 {
+		compatible = "mediatek,mt6577-uart";
+		reg = <0x11005000 0x400>;
+		interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_LOW>;
+		clocks = <&uart_clk>;
+		status = "disabled";
+	};
 };
-- 
1.9.1

