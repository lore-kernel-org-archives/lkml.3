Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab3LBQSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 11:18:55 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:18132 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab3LBQSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 11:18:51 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Boris BREZILLON <b.brezillon@overkiz.com>
CC: <linux-kernel@vger.kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91: add i2c2 pinctrl speficifation to sama5d3 DT
Date: Mon, 2 Dec 2013 17:18:48 +0100
Message-ID: <1386001128-29147-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/sama5d3.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index f520b0236671..f5fd111b5ee6 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -304,6 +304,8 @@
 				dmas = <&dma1 2 AT91_DMA_CFG_PER_ID(11)>,
 				       <&dma1 2 AT91_DMA_CFG_PER_ID(12)>;
 				dma-names = "tx", "rx";
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_i2c2>;
 				#address-cells = <1>;
 				#size-cells = <0>;
 				clocks = <&twi2_clk>;
@@ -494,6 +496,14 @@
 					};
 				};
 
+				i2c2 {
+					pinctrl_i2c2: i2c2-0 {
+						atmel,pins =
+							<AT91_PIOA 18 AT91_PERIPH_B AT91_PINCTRL_NONE	/* TWD2 pin, conflicts with LCDDAT18, ISI_D2 */
+							 AT91_PIOA 19 AT91_PERIPH_B AT91_PINCTRL_NONE>; /* TWCK2 pin, conflicts with LCDDAT19, ISI_D3 */
+					};
+				};
+
 				isi {
 					pinctrl_isi: isi-0 {
 						atmel,pins =
-- 
1.8.2.2

