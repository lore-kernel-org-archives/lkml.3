Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbaLDWag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 17:30:36 -0500
Received: from down.free-electrons.com ([37.187.137.238]:50695 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754835AbaLDWae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 17:30:34 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, Josh Wu <josh.wu@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 3/4] ARM: at91/dt: sama5: move NFC nodes outside of NAND nodes
Date: Thu,  4 Dec 2014 23:30:13 +0100
Message-Id: <1417732214-3292-4-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417732214-3292-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1417732214-3292-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have updated the atmel-nand binding to get a better representation of
the NAND/NFC relationship.
Update the DTs defining those NFC nodes accordingly.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/sama5d3.dtsi | 19 ++++++++-----------
 arch/arm/boot/dts/sama5d4.dtsi | 21 +++++++++------------
 2 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index 5f4144d..1749853 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -1414,19 +1414,16 @@
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_nand0_ale_cle>;
 			atmel,pmecc-lookup-table-offset = <0x0 0x8000>;
+			atmel,nfc = <&nfc>;
 			status = "disabled";
+		};
 
-			nfc@70000000 {
-				compatible = "atmel,sama5d3-nfc";
-				#address-cells = <1>;
-				#size-cells = <1>;
-				reg = <
-					0x70000000 0x10000000	/* NFC Command Registers */
-					0xffffc000 0x00000070	/* NFC HSMC regs */
-					0x00200000 0x00100000	/* NFC SRAM banks */
-					>;
-				clocks = <&hsmc_clk>;
-			};
+		nfc: nfc@70000000 {
+			compatible = "atmel,sama5d3-nfc";
+			reg = <0x70000000 0x10000000	/* NFC Command Registers */
+			       0xffffc000 0x00000070	/* NFC HSMC regs */
+			       0x00200000 0x00100000>;	/* NFC SRAM banks */
+			clocks = <&hsmc_clk>;
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/sama5d4.dtsi b/arch/arm/boot/dts/sama5d4.dtsi
index e0157b0..3b5e9f1 100644
--- a/arch/arm/boot/dts/sama5d4.dtsi
+++ b/arch/arm/boot/dts/sama5d4.dtsi
@@ -280,20 +280,17 @@
 			atmel,nand-has-dma;
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_nand>;
+			atmel,nfc = <&nfc>;
 			status = "disabled";
+		};
 
-			nfc@90000000 {
-				compatible = "atmel,sama5d3-nfc";
-				#address-cells = <1>;
-				#size-cells = <1>;
-				reg = <
-					0x90000000 0x10000000	/* NFC Command Registers */
-					0xfc05c000 0x00000070	/* NFC HSMC regs */
-					0x00100000 0x00100000	/* NFC SRAM banks */
-                                         >;
-				clocks = <&hsmc_clk>;
-				atmel,write-by-sram;
-			};
+		nfc: nfc@90000000 {
+			compatible = "atmel,sama5d3-nfc";
+			reg = <0x90000000 0x10000000	/* NFC Command Registers */
+			       0xfc05c000 0x00000070	/* NFC HSMC regs */
+			       0x00100000 0x00100000>;	/* NFC SRAM banks */
+			clocks = <&hsmc_clk>;
+			atmel,write-by-sram;
 		};
 
 		apb {
-- 
1.9.1

