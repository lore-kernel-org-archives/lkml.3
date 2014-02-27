Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbaB0Su0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 13:50:26 -0500
Received: from top.free-electrons.com ([176.31.233.9]:46630 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753266AbaB0SsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 13:48:11 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 4/7] ARM: at91/dt: at91sam9260: remove useless adc properties
Date: Thu, 27 Feb 2014 19:47:55 +0100
Message-Id: <1393526878-22311-5-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393526878-22311-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1393526878-22311-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the properties that are not used anymore by the at91_adc driver.

Also, add #address-cells, #size-cells and a reg for each trigger to comply to
the ePAPR.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9260.dtsi | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index 997901f7ed73..366fc2cbcd64 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -608,37 +608,38 @@
 			};
 
 			adc0: adc@fffe0000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
 				compatible = "atmel,at91sam9260-adc";
 				reg = <0xfffe0000 0x100>;
 				interrupts = <5 IRQ_TYPE_LEVEL_HIGH 0>;
 				atmel,adc-use-external-triggers;
 				atmel,adc-channels-used = <0xf>;
 				atmel,adc-vref = <3300>;
-				atmel,adc-num-channels = <4>;
 				atmel,adc-startup-time = <15>;
-				atmel,adc-channel-base = <0x30>;
-				atmel,adc-drdy-mask = <0x10000>;
-				atmel,adc-status-register = <0x1c>;
-				atmel,adc-trigger-register = <0x04>;
 				atmel,adc-res = <8 10>;
 				atmel,adc-res-names = "lowres", "highres";
 				atmel,adc-use-res = "highres";
 
 				trigger@0 {
+					reg = <0>;
 					trigger-name = "timer-counter-0";
 					trigger-value = <0x1>;
 				};
 				trigger@1 {
+					reg = <1>;
 					trigger-name = "timer-counter-1";
 					trigger-value = <0x3>;
 				};
 
 				trigger@2 {
+					reg = <2>;
 					trigger-name = "timer-counter-2";
 					trigger-value = <0x5>;
 				};
 
 				trigger@3 {
+					reg = <3>;
 					trigger-name = "external";
 					trigger-value = <0x13>;
 					trigger-external;
-- 
1.8.3.2

