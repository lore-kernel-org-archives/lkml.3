Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbaB0Stf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 13:49:35 -0500
Received: from top.free-electrons.com ([176.31.233.9]:46630 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751157AbaB0SsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 13:48:12 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 6/7] ARM: at91/dt: at91sam9x5: remove useless adc properties
Date: Thu, 27 Feb 2014 19:47:57 +0100
Message-Id: <1393526878-22311-7-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393526878-22311-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1393526878-22311-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the properties that are not used anymore by the at91_adc driver and fix
the atmel,adc-use-external-triggers property name.

Also, add #address-cells, #size-cells and a reg for each trigger to comply to
the ePAPR.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9x5.dtsi | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index 174219de92fa..8ef774a045d2 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -621,41 +621,42 @@
 			};
 
 			adc0: adc@f804c000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
 				compatible = "atmel,at91sam9260-adc";
 				reg = <0xf804c000 0x100>;
 				interrupts = <19 IRQ_TYPE_LEVEL_HIGH 0>;
-				atmel,adc-use-external;
+				atmel,adc-use-external-triggers;
 				atmel,adc-channels-used = <0xffff>;
 				atmel,adc-vref = <3300>;
-				atmel,adc-num-channels = <12>;
 				atmel,adc-startup-time = <40>;
-				atmel,adc-channel-base = <0x50>;
-				atmel,adc-drdy-mask = <0x1000000>;
-				atmel,adc-status-register = <0x30>;
-				atmel,adc-trigger-register = <0xc0>;
 				atmel,adc-res = <8 10>;
 				atmel,adc-res-names = "lowres", "highres";
 				atmel,adc-use-res = "highres";
 
 				trigger@0 {
+					reg = <0>;
 					trigger-name = "external-rising";
 					trigger-value = <0x1>;
 					trigger-external;
 				};
 
 				trigger@1 {
+					reg = <1>;
 					trigger-name = "external-falling";
 					trigger-value = <0x2>;
 					trigger-external;
 				};
 
 				trigger@2 {
+					reg = <2>;
 					trigger-name = "external-any";
 					trigger-value = <0x3>;
 					trigger-external;
 				};
 
 				trigger@3 {
+					reg = <3>;
 					trigger-name = "continuous";
 					trigger-value = <0x6>;
 				};
-- 
1.8.3.2

