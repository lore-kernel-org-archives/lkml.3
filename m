Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab3GKDeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 23:34:06 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:16778 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab3GKDeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 23:34:00 -0400
From: Bo Shen <voice.shen@atmel.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: ludovic.desroches@atmel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH v2 1/3] arm: atmel: at91sam9n12: add pinctrl of TWI
Date: Thu, 11 Jul 2013 11:30:44 +0800
Message-Id: <1373513446-18215-2-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373513446-18215-1-git-send-email-voice.shen@atmel.com>
References: <1373513446-18215-1-git-send-email-voice.shen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add pinctrl of TWI for at91sam9n12 SoC

Signed-off-by: Bo Shen <voice.shen@atmel.com>

---
Changes in v2:
  - remove comments as use micro

 arch/arm/boot/dts/at91sam9n12.dtsi |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
index bb7f564..9fb7ffd 100644
--- a/arch/arm/boot/dts/at91sam9n12.dtsi
+++ b/arch/arm/boot/dts/at91sam9n12.dtsi
@@ -291,6 +291,22 @@
 					};
 				};
 
+				i2c0 {
+					pinctrl_i2c0: i2c0-0 {
+						atmel,pins =
+							<AT91_PIOA 30 AT91_PERIPH_A AT91_PINCTRL_NONE
+							 AT91_PIOA 31 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+				};
+
+				i2c1 {
+					pinctrl_i2c1: i2c1-0 {
+						atmel,pins =
+							<AT91_PIOC 0 AT91_PERIPH_C AT91_PINCTRL_NONE
+							 AT91_PIOC 1 AT91_PERIPH_C AT91_PINCTRL_NONE>;
+					};
+				};
+
 				tcb0 {
 					pinctrl_tcb0_tclk0: tcb0_tclk0-0 {
 						atmel,pins = <AT91_PIOA 24 AT91_PERIPH_A AT91_PINCTRL_NONE>;
@@ -471,6 +487,8 @@
 				dma-names = "tx", "rx";
 				#address-cells = <1>;
 				#size-cells = <0>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_i2c0>;
 				status = "disabled";
 			};
 
@@ -483,6 +501,8 @@
 				dma-names = "tx", "rx";
 				#address-cells = <1>;
 				#size-cells = <0>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_i2c1>;
 				status = "disabled";
 			};
 
-- 
1.7.9.5

