Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaLZJzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 04:55:39 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:33773 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751392AbaLZJzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 04:55:10 -0500
X-Listener-Flag: 11101
From: Eddie Huang <eddie.huang@mediatek.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
CC: <srv_heupstream@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>,
        <yingjoe.chen@mediatek.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@nvidia.com>,
        Jason Cooper <jason@lakedaemon.net>, Lee Jones <lee.jones@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Ray Jui <rjui@broadcom.com>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eddie Huang <eddie.huang@mediatek.com>
Subject: [PATCH 1/2] ARM: mediatek: add UART dts for mt8127 and mt8135
Date: Fri, 26 Dec 2014 17:55:00 +0800
Message-ID: <1419587701-13451-2-git-send-email-eddie.huang@mediatek.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1419587701-13451-1-git-send-email-eddie.huang@mediatek.com>
References: <1419587701-13451-1-git-send-email-eddie.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This add dts support for mt8127 and mt8135 SoC UART

Signed-off-by: Eddie Huang <eddie.huang@mediatek.com>
---
 arch/arm/boot/dts/mt8127.dtsi | 34 ++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/mt8135.dtsi | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/arch/arm/boot/dts/mt8127.dtsi b/arch/arm/boot/dts/mt8127.dtsi
index 93bca88..69b1c39 100644
--- a/arch/arm/boot/dts/mt8127.dtsi
+++ b/arch/arm/boot/dts/mt8127.dtsi
@@ -64,6 +64,12 @@
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
@@ -99,5 +105,33 @@
 			      <0 0x10214000 0 0x2000>,
 			      <0 0x10216000 0 0x2000>;
 		};
+
+		uart0: serial@11002000 {
+			compatible = "mediatek,mt8127-uart","mediatek,mt6577-uart";
+			reg = <0 0x11002000 0 0x400>;
+			interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_LOW>;
+			clocks = <&uart_clk>;
+		};
+
+		uart1: serial@11003000 {
+			compatible = "mediatek,mt8127-uart","mediatek,mt6577-uart";
+			reg = <0 0x11003000 0 0x400>;
+			interrupts = <GIC_SPI 52 IRQ_TYPE_LEVEL_LOW>;
+			clocks = <&uart_clk>;
+		};
+
+		uart2: serial@11004000 {
+			compatible = "mediatek,mt8127-uart","mediatek,mt6577-uart";
+			reg = <0 0x11004000 0 0x400>;
+			interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_LOW>;
+			clocks = <&uart_clk>;
+		};
+
+		uart3: serial@11005000 {
+			compatible = "mediatek,mt8127-uart","mediatek,mt6577-uart";
+			reg = <0 0x11005000 0 0x400>;
+			interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_LOW>;
+			clocks = <&uart_clk>;
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/mt8135.dtsi b/arch/arm/boot/dts/mt8135.dtsi
index c5e04ef..ec83e69 100644
--- a/arch/arm/boot/dts/mt8135.dtsi
+++ b/arch/arm/boot/dts/mt8135.dtsi
@@ -86,6 +86,12 @@
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
@@ -121,5 +127,33 @@
 			      <0 0x10214000 0 0x2000>,
 			      <0 0x10216000 0 0x2000>;
 		};
+
+		uart0: serial@11006000 {
+			compatible = "mediatek,mt8135-uart","mediatek,mt6577-uart";
+			reg = <0 0x11006000 0 0x400>;
+			interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_LOW>;
+			clocks = <&uart_clk>;
+		};
+
+		uart1: serial@11007000 {
+			compatible = "mediatek,mt8135-uart","mediatek,mt6577-uart";
+			reg = <0 0x11007000 0 0x400>;
+			interrupts = <GIC_SPI 52 IRQ_TYPE_LEVEL_LOW>;
+			clocks = <&uart_clk>;
+		};
+
+		uart2: serial@11008000 {
+			compatible = "mediatek,mt8135-uart","mediatek,mt6577-uart";
+			reg = <0 0x11008000 0 0x400>;
+			interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_LOW>;
+			clocks = <&uart_clk>;
+		};
+
+		uart3: serial@11009000 {
+			compatible = "mediatek,mt8135-uart","mediatek,mt6577-uart";
+			reg = <0 0x11009000 0 0x400>;
+			interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_LOW>;
+			clocks = <&uart_clk>;
+		};
 	};
 };
-- 
1.8.1.1

************* Email Confidentiality Notice ********************
The information contained in this e-mail message (including any 
attachments) may be confidential, proprietary, privileged, or otherwise
exempt from disclosure under applicable laws. It is intended to be 
conveyed only to the designated recipient(s). Any use, dissemination, 
distribution, printing, retaining or copying of this e-mail (including its 
attachments) by unintended recipient(s) is strictly prohibited and may 
be unlawful. If you are not an intended recipient of this e-mail, or believe 
that you have received this e-mail in error, please notify the sender 
immediately (by replying to this e-mail), delete any and all copies of 
this e-mail (including any attachments) from your system, and do not
disclose the content of this e-mail to any other person. Thank you!
