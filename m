Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbaB0SsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 13:48:12 -0500
Received: from top.free-electrons.com ([176.31.233.9]:46614 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751157AbaB0SsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 13:48:09 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 1/7] Documentation: dt: iio: improve atmel-adc documentation
Date: Thu, 27 Feb 2014 19:47:52 +0100
Message-Id: <1393526878-22311-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393526878-22311-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1393526878-22311-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This corrects the example by adding #address-cells, #size-cells and a reg for
each trigger to comply to the ePAPR, as suggested by Mark Rutland in
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-February/234184.html

Also, it removes the properties that are not used anymore, to stop propagating
them.
Also fixes atmel,adc-use-external-triggers property name.

Finally, fixes a few typos.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 .../devicetree/bindings/arm/atmel-adc.txt          | 33 +++++++++++-----------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/atmel-adc.txt b/Documentation/devicetree/bindings/arm/atmel-adc.txt
index d1061469f63d..82061c7e4fea 100644
--- a/Documentation/devicetree/bindings/arm/atmel-adc.txt
+++ b/Documentation/devicetree/bindings/arm/atmel-adc.txt
@@ -5,32 +5,32 @@ Required properties:
     <chip> can be "at91sam9260", "at91sam9g45" or "at91sam9x5"
   - reg: Should contain ADC registers location and length
   - interrupts: Should contain the IRQ line for the ADC
-  - atmel,adc-channels-used: Bitmask of the channels muxed and enable for this
+  - atmel,adc-channels-used: Bitmask of the channels muxed and enabled for this
     device
   - atmel,adc-startup-time: Startup Time of the ADC in microseconds as
     defined in the datasheet
   - atmel,adc-vref: Reference voltage in millivolts for the conversions
-  - atmel,adc-res: List of resolution in bits supported by the ADC. List size
+  - atmel,adc-res: List of resolutions in bits supported by the ADC. List size
 		   must be two at least.
   - atmel,adc-res-names: Contains one identifier string for each resolution
 			 in atmel,adc-res property. "lowres" and "highres"
 			 identifiers are required.
 
 Optional properties:
-  - atmel,adc-use-external: Boolean to enable of external triggers
+  - atmel,adc-use-external-triggers: Boolean to enable the external triggers
   - atmel,adc-use-res: String corresponding to an identifier from
 		       atmel,adc-res-names property. If not specified, the highest
 		       resolution will be used.
   - atmel,adc-sleep-mode: Boolean to enable sleep mode when no conversion
   - atmel,adc-sample-hold-time: Sample and Hold Time in microseconds
-  - atmel,adc-ts-wires: Number of touch screen wires. Should be 4 or 5. If this
-                        value is set, then adc driver will enable touch screen
+  - atmel,adc-ts-wires: Number of touchscreen wires. Should be 4 or 5. If this
+                        value is set, then the adc driver will enable touchscreen
                         support.
-    NOTE: when adc touch screen enabled, the adc hardware trigger will be
-          disabled. Since touch screen will occupied the trigger register.
+    NOTE: when adc touchscreen is enabled, the adc hardware trigger will be
+          disabled. Since touchscreen will occupy the trigger register.
   - atmel,adc-ts-pressure-threshold: a pressure threshold for touchscreen. It
-                                     make touch detect more precision.
- 
+                                     makes touch detection more precise.
+
 Optional trigger Nodes:
   - Required properties:
     * trigger-name: Name of the trigger exposed to the user
@@ -41,40 +41,41 @@ Optional trigger Nodes:
 
 Examples:
 adc0: adc@fffb0000 {
+	#address-cells = <1>;
+	#size-cells = <0>;
 	compatible = "atmel,at91sam9260-adc";
 	reg = <0xfffb0000 0x100>;
-	interrupts = <20 4>;
-	atmel,adc-channel-base = <0x30>;
+	interrupts = <20 IRQ_TYPE_LEVEL_HIGH 0>;
 	atmel,adc-channels-used = <0xff>;
-	atmel,adc-drdy-mask = <0x10000>;
-	atmel,adc-num-channels = <8>;
 	atmel,adc-startup-time = <40>;
-	atmel,adc-status-register = <0x1c>;
-	atmel,adc-trigger-register = <0x08>;
-	atmel,adc-use-external;
+	atmel,adc-use-external-triggers;
 	atmel,adc-vref = <3300>;
 	atmel,adc-res = <8 10>;
 	atmel,adc-res-names = "lowres", "highres";
 	atmel,adc-use-res = "lowres";
 
 	trigger@0 {
+		reg = <0>;
 		trigger-name = "external-rising";
 		trigger-value = <0x1>;
 		trigger-external;
 	};
 	trigger@1 {
+		reg = <1>;
 		trigger-name = "external-falling";
 		trigger-value = <0x2>;
 		trigger-external;
 	};
 
 	trigger@2 {
+		reg = <2>;
 		trigger-name = "external-any";
 		trigger-value = <0x3>;
 		trigger-external;
 	};
 
 	trigger@3 {
+		reg = <3>;
 		trigger-name = "continuous";
 		trigger-value = <0x6>;
 	};
-- 
1.8.3.2

