Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237AbaGOM6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 08:58:07 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:45277 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758990AbaGOM42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 08:56:28 -0400
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com, mkl@pengutronix.de
Cc: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH v3 1/4] ARM: dts: vf610: add FlexCAN node
Date: Tue, 15 Jul 2014 14:56:18 +0200
Message-Id: <2be5a3885653a02dc07bf96ce086fddd71285f5a.1405428166.git.stefan@agner.ch>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <cover.1405428166.git.stefan@agner.ch>
References: <cover.1405428166.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add FlexCAN node for the two FlexCAN IP instances in Vybrid.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/vf610.dtsi | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
index 3fb127a..9404853 100644
--- a/arch/arm/boot/dts/vf610.dtsi
+++ b/arch/arm/boot/dts/vf610.dtsi
@@ -14,6 +14,8 @@
 
 / {
 	aliases {
+		can0 = &can0;
+		can1 = &can1;
 		serial0 = &uart0;
 		serial1 = &uart1;
 		serial2 = &uart2;
@@ -103,6 +105,16 @@
 					<&clks VF610_CLK_DMAMUX1>;
 			};
 
+			can0: flexcan@40020000 {
+				compatible = "fsl,vf610-flexcan";
+				reg = <0x40020000 0x4000>;
+				interrupts = <0 58 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clks VF610_CLK_FLEXCAN0>,
+					 <&clks VF610_CLK_FLEXCAN0>;
+				clock-names = "ipg", "per";
+				status = "disabled";
+			};
+
 			uart0: serial@40027000 {
 				compatible = "fsl,vf610-lpuart";
 				reg = <0x40027000 0x1000>;
@@ -414,6 +426,17 @@
 				clock-names = "nfc";
 				status = "disabled";
 			};
+
+			can1: flexcan@400d4000 {
+				compatible = "fsl,vf610-flexcan";
+				reg = <0x400d4000 0x4000>;
+				interrupts = <0 59 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clks VF610_CLK_FLEXCAN1>,
+					 <&clks VF610_CLK_FLEXCAN1>;
+				clock-names = "ipg", "per";
+				status = "disabled";
+			};
+
 		};
 	};
 };
-- 
2.0.1

