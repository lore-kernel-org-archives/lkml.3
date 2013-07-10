Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab3GJJyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 05:54:35 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:17485 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3GJJyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 05:54:33 -0400
From: Bo Shen <voice.shen@atmel.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: ludovic.desroches@atmel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH 2/3] arm: atmel: at91sam9n12: add qt1070 support
Date: Wed, 10 Jul 2013 17:51:08 +0800
Message-Id: <1373449869-5083-3-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373449869-5083-1-git-send-email-voice.shen@atmel.com>
References: <1373449869-5083-1-git-send-email-voice.shen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add qt1070 support on at91sam9n12ek board

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---
 arch/arm/boot/dts/at91sam9n12ek.dts |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9n12ek.dts b/arch/arm/boot/dts/at91sam9n12ek.dts
index d59b70c..3acac62 100644
--- a/arch/arm/boot/dts/at91sam9n12ek.dts
+++ b/arch/arm/boot/dts/at91sam9n12ek.dts
@@ -40,6 +40,15 @@
 
 			i2c0: i2c@f8010000 {
 				status = "okay";
+
+				qt1070: keyboard@1b {
+					compatible = "qt1070";
+					reg = <0x1b>;
+					interrupt-parent = <&pioA>;
+					interrupts = <2 0x0>;
+					pinctrl-names = "default";
+					pinctrl-0 = <&pinctrl_qt1070_irq>;
+				};
 			};
 
 			i2c1: i2c@f8014000 {
@@ -66,6 +75,13 @@
 							<AT91_PIOA 7 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>;	/* PA7 gpio CD pin pull up and deglitch */
 					};
 				};
+
+				qt1070 {
+					pinctrl_qt1070_irq: qt1070_irq {
+						atmel,pins =
+							<AT91_PIOA 2 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>; /* PA2 GPIO with pull up deglith */
+					};
+				};
 			};
 
 			spi0: spi@f0000000 {
-- 
1.7.9.5

