Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab3EaPCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:02:32 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:62287 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab3EaPCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:02:17 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 2/2] ARM: at91: dt: at91sam9x5: add SPI DMA client infos
Date: Fri, 31 May 2013 17:02:00 +0200
Message-Id: <1370012520-30539-2-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370012520-30539-1-git-send-email-richard.genoud@gmail.com>
References: <1370012520-30539-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 arch/arm/boot/dts/at91sam9x5.dtsi |    6 ++++++
 1 file changed, 6 insertions(+)

rebased on linux-next next-20130531
plus Ludovic Desroches' patch "ARM: at91: dt: add header to define at_hdmac configuration"
to get the AT91_DMA_CFG_PER_ID() macro

diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index af91599..a5942d0 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -629,6 +629,9 @@
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xf0000000 0x100>;
 				interrupts = <13 IRQ_TYPE_LEVEL_HIGH 3>;
+				dmas = <&dma0 1 AT91_DMA_CFG_PER_ID(1)>,
+				       <&dma0 1 AT91_DMA_CFG_PER_ID(2)>;
+				dma-names = "tx", "rx";
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi0>;
 				status = "disabled";
@@ -640,6 +643,9 @@
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xf0004000 0x100>;
 				interrupts = <14 IRQ_TYPE_LEVEL_HIGH 3>;
+				dmas = <&dma1 1 AT91_DMA_CFG_PER_ID(1)>,
+				       <&dma1 1 AT91_DMA_CFG_PER_ID(2)>;
+				dma-names = "tx", "rx";
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi1>;
 				status = "disabled";
-- 
1.7.10.4

