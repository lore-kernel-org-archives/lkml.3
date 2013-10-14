Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab3JNQr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 12:47:27 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:47337 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633Ab3JNQrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 12:47:25 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, <ebenard@eukrea.com>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <herbert@gondor.hengli.com.au>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3/3] ARM: at91/dt/sama5d3: add DMA information to SHA/AES/TDES nodes
Date: Mon, 14 Oct 2013 18:46:37 +0200
Message-ID: <269bcba07a15338d3e7a3699ed25c4e775f7fca0.1381769174.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <ba9872c3bb29c9a06f06caa8e0b4528329f07675.1381769174.git.nicolas.ferre@atmel.com>
References: <ba9872c3bb29c9a06f06caa8e0b4528329f07675.1381769174.git.nicolas.ferre@atmel.com>
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
index 99bd4a6..aca3893 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -345,18 +345,26 @@
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

