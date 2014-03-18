Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbaCRXR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 19:17:28 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39349 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758269AbaCRXQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 19:16:38 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 1/3] ARM: at91/dt: sam9g45: improve ADC/touchscreen support
Date: Wed, 19 Mar 2014 00:15:39 +0100
Message-Id: <1395184541-5787-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395184541-5787-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1395184541-5787-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the compatible string, adds the pinmuxing for the ADC pins.

Also, removes atmel,adc-use-external-triggers as it is not possible to remove it
unless redefining the whole adc node

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9g45.dtsi | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index dc4fb7d99902..b1d67282b0b6 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -136,6 +136,36 @@
 				      >;
 
 				/* shared pinctrl settings */
+				adc0 {
+					pinctrl_adc0_adtrg: adc0_adtrg {
+						atmel,pins = <AT91_PIOD 28 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+					pinctrl_adc0_ad0: adc0_ad0 {
+						atmel,pins = <AT91_PIOD 20 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
+					};
+					pinctrl_adc0_ad1: adc0_ad1 {
+						atmel,pins = <AT91_PIOD 21 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
+					};
+					pinctrl_adc0_ad2: adc0_ad2 {
+						atmel,pins = <AT91_PIOD 22 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
+					};
+					pinctrl_adc0_ad3: adc0_ad3 {
+						atmel,pins = <AT91_PIOD 23 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
+					};
+					pinctrl_adc0_ad4: adc0_ad4 {
+						atmel,pins = <AT91_PIOD 24 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
+					};
+					pinctrl_adc0_ad5: adc0_ad5 {
+						atmel,pins = <AT91_PIOD 25 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
+					};
+					pinctrl_adc0_ad6: adc0_ad6 {
+						atmel,pins = <AT91_PIOD 26 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
+					};
+					pinctrl_adc0_ad7: adc0_ad7 {
+						atmel,pins = <AT91_PIOD 27 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
+					};
+				};
+
 				dbgu {
 					pinctrl_dbgu: dbgu-0 {
 						atmel,pins =
@@ -634,10 +664,9 @@
 			adc0: adc@fffb0000 {
 				#address-cells = <1>;
 				#size-cells = <0>;
-				compatible = "atmel,at91sam9260-adc";
+				compatible = "atmel,at91sam9g45-adc";
 				reg = <0xfffb0000 0x100>;
 				interrupts = <20 IRQ_TYPE_LEVEL_HIGH 0>;
-				atmel,adc-use-external-triggers;
 				atmel,adc-channels-used = <0xff>;
 				atmel,adc-vref = <3300>;
 				atmel,adc-startup-time = <40>;
-- 
1.8.3.2

