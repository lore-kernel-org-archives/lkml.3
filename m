Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbaLDWai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 17:30:38 -0500
Received: from down.free-electrons.com ([37.187.137.238]:50686 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754632AbaLDWae (ORCPT
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
Subject: [PATCH 4/4] ARM: at91/dt: sama5: move NAND nodes into board dts/dtsi
Date: Thu,  4 Dec 2014 23:30:14 +0100
Message-Id: <1417732214-3292-5-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417732214-3292-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1417732214-3292-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sama5d3 and sama5d4 SoCs provides several CS to interface with external
memories, and in particular NAND chips.
The NAND flash controller embedded in the these SoCs can connect to any of
the available CS (each CS is assigned a memory range, hence the nand@xxx
you're seeing in the DT), thus the NAND chip definition should be part of
the board description because we cannot guess at the SoC level which CS
will be chosen by the board designer.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/at91-sama5d3_xplained.dts | 18 +++++++++++++++++-
 arch/arm/boot/dts/at91-sama5d4ek.dts        | 16 +++++++++++++++-
 arch/arm/boot/dts/sama5d3.dtsi              | 21 ---------------------
 arch/arm/boot/dts/sama5d3xcm.dtsi           | 18 +++++++++++++++++-
 arch/arm/boot/dts/sama5d4.dtsi              | 19 -------------------
 5 files changed, 49 insertions(+), 43 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sama5d3_xplained.dts b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
index fec1fca..860258b 100644
--- a/arch/arm/boot/dts/at91-sama5d3_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
@@ -213,13 +213,29 @@
 		};
 
 		nand0: nand@60000000 {
+			compatible = "atmel,at91rm9200-nand";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+			reg = <	0x60000000 0x01000000	/* EBI CS3 */
+				0xffffc070 0x00000490	/* SMC PMECC regs */
+				0xffffc500 0x00000100	/* SMC PMECC Error Location regs */
+				0x00110000 0x00018000	/* ROM code */
+				>;
+			interrupts = <5 IRQ_TYPE_LEVEL_HIGH 6>;
+			atmel,nand-addr-offset = <21>;
+			atmel,nand-cmd-offset = <22>;
+			atmel,nand-has-dma;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_nand0_ale_cle>;
+			atmel,pmecc-lookup-table-offset = <0x0 0x8000>;
+			atmel,nfc = <&nfc>;
 			nand-bus-width = <8>;
 			nand-ecc-mode = "hw";
 			atmel,has-pmecc;
 			atmel,pmecc-cap = <4>;
 			atmel,pmecc-sector-size = <512>;
 			nand-on-flash-bbt;
-			status = "okay";
 
 			at91bootstrap@0 {
 				label = "at91bootstrap";
diff --git a/arch/arm/boot/dts/at91-sama5d4ek.dts b/arch/arm/boot/dts/at91-sama5d4ek.dts
index b5b8400..5de0d2d 100644
--- a/arch/arm/boot/dts/at91-sama5d4ek.dts
+++ b/arch/arm/boot/dts/at91-sama5d4ek.dts
@@ -204,11 +204,25 @@
 		};
 
 		nand0: nand@80000000 {
+			compatible = "atmel,at91rm9200-nand";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+			reg = <	0x80000000 0x08000000	/* EBI CS3 */
+				0xfc05c070 0x00000490	/* SMC PMECC regs */
+				0xfc05c500 0x00000100	/* SMC PMECC Error Location regs */
+				>;
+			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 6>;
+			atmel,nand-addr-offset = <21>;
+			atmel,nand-cmd-offset = <22>;
+			atmel,nand-has-dma;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_nand>;
+			atmel,nfc = <&nfc>;
 			nand-bus-width = <8>;
 			nand-ecc-mode = "hw";
 			nand-on-flash-bbt;
 			atmel,has-pmecc;
-			status = "okay";
 
 			at91bootstrap@0 {
 				label = "at91bootstrap";
diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index 1749853..0a944e0 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -1397,27 +1397,6 @@
 			status = "disabled";
 		};
 
-		nand0: nand@60000000 {
-			compatible = "atmel,at91rm9200-nand";
-			#address-cells = <1>;
-			#size-cells = <1>;
-			ranges;
-			reg = <	0x60000000 0x01000000	/* EBI CS3 */
-				0xffffc070 0x00000490	/* SMC PMECC regs */
-				0xffffc500 0x00000100	/* SMC PMECC Error Location regs */
-				0x00110000 0x00018000	/* ROM code */
-				>;
-			interrupts = <5 IRQ_TYPE_LEVEL_HIGH 6>;
-			atmel,nand-addr-offset = <21>;
-			atmel,nand-cmd-offset = <22>;
-			atmel,nand-has-dma;
-			pinctrl-names = "default";
-			pinctrl-0 = <&pinctrl_nand0_ale_cle>;
-			atmel,pmecc-lookup-table-offset = <0x0 0x8000>;
-			atmel,nfc = <&nfc>;
-			status = "disabled";
-		};
-
 		nfc: nfc@70000000 {
 			compatible = "atmel,sama5d3-nfc";
 			reg = <0x70000000 0x10000000	/* NFC Command Registers */
diff --git a/arch/arm/boot/dts/sama5d3xcm.dtsi b/arch/arm/boot/dts/sama5d3xcm.dtsi
index cfcd200..e6c2aec 100644
--- a/arch/arm/boot/dts/sama5d3xcm.dtsi
+++ b/arch/arm/boot/dts/sama5d3xcm.dtsi
@@ -76,13 +76,29 @@
 		};
 
 		nand0: nand@60000000 {
+			compatible = "atmel,at91rm9200-nand";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+			reg = <	0x60000000 0x01000000	/* EBI CS3 */
+				0xffffc070 0x00000490	/* SMC PMECC regs */
+				0xffffc500 0x00000100	/* SMC PMECC Error Location regs */
+				0x00110000 0x00018000	/* ROM code */
+				>;
+			interrupts = <5 IRQ_TYPE_LEVEL_HIGH 6>;
+			atmel,nand-addr-offset = <21>;
+			atmel,nand-cmd-offset = <22>;
+			atmel,nand-has-dma;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_nand0_ale_cle>;
+			atmel,pmecc-lookup-table-offset = <0x0 0x8000>;
+			atmel,nfc = <&nfc>;
 			nand-bus-width = <8>;
 			nand-ecc-mode = "hw";
 			atmel,has-pmecc;
 			atmel,pmecc-cap = <4>;
 			atmel,pmecc-sector-size = <512>;
 			nand-on-flash-bbt;
-			status = "okay";
 
 			at91bootstrap@0 {
 				label = "at91bootstrap";
diff --git a/arch/arm/boot/dts/sama5d4.dtsi b/arch/arm/boot/dts/sama5d4.dtsi
index 3b5e9f1..8647eb3 100644
--- a/arch/arm/boot/dts/sama5d4.dtsi
+++ b/arch/arm/boot/dts/sama5d4.dtsi
@@ -265,25 +265,6 @@
 			cache-level = <2>;
 		};
 
-		nand0: nand@80000000 {
-			compatible = "atmel,at91rm9200-nand";
-			#address-cells = <1>;
-			#size-cells = <1>;
-			ranges;
-			reg = <	0x80000000 0x08000000	/* EBI CS3 */
-				0xfc05c070 0x00000490	/* SMC PMECC regs */
-				0xfc05c500 0x00000100	/* SMC PMECC Error Location regs */
-				>;
-			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 6>;
-			atmel,nand-addr-offset = <21>;
-			atmel,nand-cmd-offset = <22>;
-			atmel,nand-has-dma;
-			pinctrl-names = "default";
-			pinctrl-0 = <&pinctrl_nand>;
-			atmel,nfc = <&nfc>;
-			status = "disabled";
-		};
-
 		nfc: nfc@90000000 {
 			compatible = "atmel,sama5d3-nfc";
 			reg = <0x90000000 0x10000000	/* NFC Command Registers */
-- 
1.9.1

