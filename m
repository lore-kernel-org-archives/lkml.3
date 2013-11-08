Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672Ab3KHPJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 10:09:28 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:48073 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506Ab3KHPJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 10:09:26 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, <herbert@gondor.hengli.com.au>,
        <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <eric@eukrea.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH RESEND 3/7] ARM: at91/dt/sama5d3: add DMA information to SHA/AES/TDES nodes
Date: Fri, 8 Nov 2013 16:08:12 +0100
Message-ID: <edc64a2a93504e45ed780095c1076d4ce5298dc1.1383922546.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1383922546.git.nicolas.ferre@atmel.com>
References: <cover.1383922546.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/sama5d3.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index 8716fc2..56c3b01 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -354,18 +354,26 @@
 				compatible = "atmel,at91sam9g46-sha";
 				reg = <0xf8034000 0x100>;
 				interrupts = <42 IRQ_TYPE_LEVEL_HIGH 0>;
+				dmas = <&dma1 2 AT91_DMA_CFG_PER_ID(17)>;
+				dma-names = "tx";
 			};
 
 			aes@f8038000 {
 				compatible = "atmel,at91sam9g46-aes";
 				reg = <0xf8038000 0x100>;
 				interrupts = <43 IRQ_TYPE_LEVEL_HIGH 0>;
+				dmas = <&dma1 2 AT91_DMA_CFG_PER_ID(18)>,
+				       <&dma1 2 AT91_DMA_CFG_PER_ID(19)>;
+				dma-names = "tx", "rx";
 			};
 
 			tdes@f803c000 {
 				compatible = "atmel,at91sam9g46-tdes";
 				reg = <0xf803c000 0x100>;
 				interrupts = <44 IRQ_TYPE_LEVEL_HIGH 0>;
+				dmas = <&dma1 2 AT91_DMA_CFG_PER_ID(20)>,
+				       <&dma1 2 AT91_DMA_CFG_PER_ID(21)>;
+				dma-names = "tx", "rx";
 			};
 
 			dma0: dma-controller@ffffe600 {
-- 
1.8.2.2

