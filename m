Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964794AbaFIQJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 12:09:23 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50337 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933399AbaFIQEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 12:04:30 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        David Airlie <airlied@linux.ie>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 4/7] ARM: at91/dt: split sama5d3 lcd pin definitions to match RGB mode configs
Date: Mon,  9 Jun 2014 18:04:17 +0200
Message-Id: <1402329860-27520-5-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402329860-27520-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1402329860-27520-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HLCDC (High LCD Controller) IP supports 4 different output mode
(RGB444, RGB565, RGB666 and RGB888) and the pin muxing depends on the
chosen RGB mode.

Split the pin definition to be able to set the pin config according to the
selected mode.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/sama5d3_lcd.dtsi | 127 ++++++++++++++++++++++++++++---------
 1 file changed, 96 insertions(+), 31 deletions(-)

diff --git a/arch/arm/boot/dts/sama5d3_lcd.dtsi b/arch/arm/boot/dts/sama5d3_lcd.dtsi
index 85d3027..2186b89 100644
--- a/arch/arm/boot/dts/sama5d3_lcd.dtsi
+++ b/arch/arm/boot/dts/sama5d3_lcd.dtsi
@@ -15,38 +15,103 @@
 		apb {
 			pinctrl@fffff200 {
 				lcd {
-					pinctrl_lcd: lcd-0 {
+					pinctrl_lcd_pwm: lcd-pwm-0 {
+						atmel,pins = <AT91_PIOA 24 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* LCDPWM */
+					};
+
+					pinctrl_lcd_base: lcd-base-0 {
+						atmel,pins =
+							<AT91_PIOA 26 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDVSYNC */
+							 AT91_PIOA 27 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDHSYNC */
+							 AT91_PIOA 25 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDDISP */
+							 AT91_PIOA 29 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDDEN */
+							 AT91_PIOA 28 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* LCDPCK */
+					};
+
+					pinctrl_lcd_rgb444: lcd-rgb-0 {
+						atmel,pins =
+							<AT91_PIOA 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD0 pin */
+							 AT91_PIOA 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD1 pin */
+							 AT91_PIOA 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD2 pin */
+							 AT91_PIOA 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD3 pin */
+							 AT91_PIOA 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD4 pin */
+							 AT91_PIOA 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD5 pin */
+							 AT91_PIOA 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD6 pin */
+							 AT91_PIOA 7 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD7 pin */
+							 AT91_PIOA 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD8 pin */
+							 AT91_PIOA 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD9 pin */
+							 AT91_PIOA 10 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD10 pin */
+							 AT91_PIOA 11 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* LCDD11 pin */
+					};
+
+					pinctrl_lcd_rgb565: lcd-rgb-1 {
+						atmel,pins =
+							<AT91_PIOA 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD0 pin */
+							 AT91_PIOA 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD1 pin */
+							 AT91_PIOA 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD2 pin */
+							 AT91_PIOA 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD3 pin */
+							 AT91_PIOA 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD4 pin */
+							 AT91_PIOA 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD5 pin */
+							 AT91_PIOA 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD6 pin */
+							 AT91_PIOA 7 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD7 pin */
+							 AT91_PIOA 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD8 pin */
+							 AT91_PIOA 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD9 pin */
+							 AT91_PIOA 10 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD10 pin */
+							 AT91_PIOA 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD11 pin */
+							 AT91_PIOA 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD12 pin */
+							 AT91_PIOA 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD13 pin */
+							 AT91_PIOA 14 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD14 pin */
+							 AT91_PIOA 15 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* LCDD15 pin */
+					};
+
+					pinctrl_lcd_rgb666: lcd-rgb-2 {
+						atmel,pins =
+							<AT91_PIOA 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD0 pin */
+							 AT91_PIOA 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD1 pin */
+							 AT91_PIOA 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD2 pin */
+							 AT91_PIOA 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD3 pin */
+							 AT91_PIOA 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD4 pin */
+							 AT91_PIOA 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD5 pin */
+							 AT91_PIOA 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD6 pin */
+							 AT91_PIOA 7 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD7 pin */
+							 AT91_PIOA 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD8 pin */
+							 AT91_PIOA 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD9 pin */
+							 AT91_PIOA 10 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD10 pin */
+							 AT91_PIOA 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD11 pin */
+							 AT91_PIOA 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD12 pin */
+							 AT91_PIOA 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD13 pin */
+							 AT91_PIOA 14 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD14 pin */
+							 AT91_PIOA 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD15 pin */
+							 AT91_PIOC 14 AT91_PERIPH_C AT91_PINCTRL_NONE	/* LCDD16 pin */
+							 AT91_PIOC 13 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* LCDD17 pin */
+					};
+
+					pinctrl_lcd_rgb888: lcd-rgb-3 {
 						atmel,pins =
-							<AT91_PIOA 24 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA24 periph A LCDPWM */
-							 AT91_PIOA 26 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA26 periph A LCDVSYNC */
-							 AT91_PIOA 27 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA27 periph A LCDHSYNC */
-							 AT91_PIOA 25 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA25 periph A LCDDISP */
-							 AT91_PIOA 29 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA29 periph A LCDDEN */
-							 AT91_PIOA 28 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA28 periph A LCDPCK */
-							 AT91_PIOA 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA0 periph A LCDD0 pin */
-							 AT91_PIOA 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA1 periph A LCDD1 pin */
-							 AT91_PIOA 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA2 periph A LCDD2 pin */
-							 AT91_PIOA 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA3 periph A LCDD3 pin */
-							 AT91_PIOA 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA4 periph A LCDD4 pin */
-							 AT91_PIOA 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA5 periph A LCDD5 pin */
-							 AT91_PIOA 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA6 periph A LCDD6 pin */
-							 AT91_PIOA 7 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA7 periph A LCDD7 pin */
-							 AT91_PIOA 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA8 periph A LCDD8 pin */
-							 AT91_PIOA 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA9 periph A LCDD9 pin */
-							 AT91_PIOA 10 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA10 periph A LCDD10 pin */
-							 AT91_PIOA 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA11 periph A LCDD11 pin */
-							 AT91_PIOA 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA12 periph A LCDD12 pin */
-							 AT91_PIOA 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA13 periph A LCDD13 pin */
-							 AT91_PIOA 14 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA14 periph A LCDD14 pin */
-							 AT91_PIOA 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA15 periph A LCDD15 pin */
-							 AT91_PIOC 14 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC14 periph C LCDD16 pin */
-							 AT91_PIOC 13 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC13 periph C LCDD17 pin */
-							 AT91_PIOC 12 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC12 periph C LCDD18 pin */
-							 AT91_PIOC 11 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC11 periph C LCDD19 pin */
-							 AT91_PIOC 10 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC10 periph C LCDD20 pin */
-							 AT91_PIOC 15 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC15 periph C LCDD21 pin */
-							 AT91_PIOE 27 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PE27 periph C LCDD22 pin */
-							 AT91_PIOE 28 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PE28 periph C LCDD23 pin */
+							<AT91_PIOA 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD0 pin */
+							 AT91_PIOA 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD1 pin */
+							 AT91_PIOA 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD2 pin */
+							 AT91_PIOA 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD3 pin */
+							 AT91_PIOA 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD4 pin */
+							 AT91_PIOA 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD5 pin */
+							 AT91_PIOA 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD6 pin */
+							 AT91_PIOA 7 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD7 pin */
+							 AT91_PIOA 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD8 pin */
+							 AT91_PIOA 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD9 pin */
+							 AT91_PIOA 10 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD10 pin */
+							 AT91_PIOA 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD11 pin */
+							 AT91_PIOA 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD12 pin */
+							 AT91_PIOA 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD13 pin */
+							 AT91_PIOA 14 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD14 pin */
+							 AT91_PIOA 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* LCDD15 pin */
+							 AT91_PIOC 14 AT91_PERIPH_C AT91_PINCTRL_NONE	/* LCDD16 pin */
+							 AT91_PIOC 13 AT91_PERIPH_C AT91_PINCTRL_NONE	/* LCDD17 pin */
+							 AT91_PIOC 12 AT91_PERIPH_C AT91_PINCTRL_NONE	/* LCDD18 pin */
+							 AT91_PIOC 11 AT91_PERIPH_C AT91_PINCTRL_NONE	/* LCDD19 pin */
+							 AT91_PIOC 10 AT91_PERIPH_C AT91_PINCTRL_NONE	/* LCDD20 pin */
+							 AT91_PIOC 15 AT91_PERIPH_C AT91_PINCTRL_NONE	/* LCDD21 pin */
+							 AT91_PIOE 27 AT91_PERIPH_C AT91_PINCTRL_NONE	/* LCDD22 pin */
+							 AT91_PIOE 28 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* LCDD23 pin */
 					};
 				};
 			};
-- 
1.8.3.2

