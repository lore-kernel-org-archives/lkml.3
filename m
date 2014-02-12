Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaBLLG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:06:27 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:42269 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaBLLGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:06:25 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, Josh Wu <josh.wu@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Boris BREZILLON <b.brezillon@overkiz.com>, <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91/DT: add NAND + DMA property
Date: Wed, 12 Feb 2014 12:06:23 +0100
Message-ID: <1392203183-9851-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the "atmel,nand-has-dma" property to NAND node for SoC that
can use the DMA to perform NAND accesses.
Use of this property was added in 1b7192658a08f70df0f290634fd7cd2ecb629fc9
(mtd: atmel_nand: add a new dt binding item for nand dma support).

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91sam9g45.dtsi | 1 +
 arch/arm/boot/dts/at91sam9n12.dtsi | 1 +
 arch/arm/boot/dts/at91sam9x5.dtsi  | 1 +
 arch/arm/boot/dts/sama5d3.dtsi     | 1 +
 4 files changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index cbcc058b26b4..9b6683f252cf 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -817,6 +817,7 @@
 			      >;
 			atmel,nand-addr-offset = <21>;
 			atmel,nand-cmd-offset = <22>;
+			atmel,nand-has-dma;
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_nand>;
 			gpios = <&pioC 8 GPIO_ACTIVE_HIGH
diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
index 394e6ce2afb7..9f04808fc697 100644
--- a/arch/arm/boot/dts/at91sam9n12.dtsi
+++ b/arch/arm/boot/dts/at91sam9n12.dtsi
@@ -570,6 +570,7 @@
 			atmel,pmecc-lookup-table-offset = <0x0 0x8000>;
 			atmel,nand-addr-offset = <21>;
 			atmel,nand-cmd-offset = <22>;
+			atmel,nand-has-dma;
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_nand>;
 			gpios = <&pioD 5 GPIO_ACTIVE_HIGH
diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index 174219de92fa..67e32067eb25 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -790,6 +790,7 @@
 			atmel,pmecc-lookup-table-offset = <0x0 0x8000>;
 			atmel,nand-addr-offset = <21>;
 			atmel,nand-cmd-offset = <22>;
+			atmel,nand-has-dma;
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_nand>;
 			gpios = <&pioD 5 GPIO_ACTIVE_HIGH
diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index 3d5faf85f51b..d075c5326ce7 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -1256,6 +1256,7 @@
 			interrupts = <5 IRQ_TYPE_LEVEL_HIGH 6>;
 			atmel,nand-addr-offset = <21>;
 			atmel,nand-cmd-offset = <22>;
+			atmel,nand-has-dma;
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_nand0_ale_cle>;
 			atmel,pmecc-lookup-table-offset = <0x0 0x8000>;
-- 
1.8.2.2

