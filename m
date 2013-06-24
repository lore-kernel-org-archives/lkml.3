Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab3FXKfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:35:50 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:49245 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab3FXKft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:35:49 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Wenyou Yang <wenyou.yang@atmel.com>, Bo Shen <voice.shen@atmel.com>,
        Josh Wu <josh.wu@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/3] ARM: at91/DT: fix SPI compatibility string
Date: Mon, 24 Jun 2013 12:35:16 +0200
Message-ID: <57756171a0f91838b167ad62c18891172b6fc59c.1372069834.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1372069834.git.nicolas.ferre@atmel.com>
References: <cover.1372069834.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In previous version of SPI driver we where using different compatibility stings
for finding SPI features. We are now using the IP revision information.
So we stay with the unique compatibility string for this driver:
"atmel,at91rm9200-spi".

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/sama5d3.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index bbf88d7..178fd09 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -80,7 +80,7 @@
 			spi0: spi@f0004000 {
 				#address-cells = <1>;
 				#size-cells = <0>;
-				compatible = "atmel,at91sam9x5-spi";
+				compatible = "atmel,at91rm9200-spi";
 				reg = <0xf0004000 0x100>;
 				interrupts = <24 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
@@ -203,7 +203,7 @@
 			spi1: spi@f8008000 {
 				#address-cells = <1>;
 				#size-cells = <0>;
-				compatible = "atmel,at91sam9x5-spi";
+				compatible = "atmel,at91rm9200-spi";
 				reg = <0xf8008000 0x100>;
 				interrupts = <25 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
-- 
1.8.2.2

