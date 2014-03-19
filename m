Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278AbaCSK1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 06:27:05 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41239 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758599AbaCSK1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 06:27:03 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] Documentation: dt: list all compatible strings for at91
Date: Wed, 19 Mar 2014 11:26:48 +0100
Message-Id: <1395224808-10133-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoids getting the newly introduced warning:
WARNING: DT compatible string "atmel,at91sam9g45-adc" appears un-documented -- check ./Documentation/devicetree/bindings/
+				compatible = "atmel,at91sam9g45-adc";

Introduced by:
bff5da433525 checkpatch: add DT compatible string documentation checks

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 Documentation/devicetree/bindings/arm/atmel-aic.txt      |  3 +--
 Documentation/devicetree/bindings/arm/atmel-at91.txt     | 10 ++++------
 Documentation/devicetree/bindings/dma/atmel-dma.txt      |  2 +-
 Documentation/devicetree/bindings/gpio/gpio_atmel.txt    |  2 +-
 Documentation/devicetree/bindings/iio/adc/at91_adc.txt   |  4 ++--
 Documentation/devicetree/bindings/serial/atmel-usart.txt | 10 ++++------
 6 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/atmel-aic.txt b/Documentation/devicetree/bindings/arm/atmel-aic.txt
index 2742e9cfd6b1..95f75fd097ba 100644
--- a/Documentation/devicetree/bindings/arm/atmel-aic.txt
+++ b/Documentation/devicetree/bindings/arm/atmel-aic.txt
@@ -1,8 +1,7 @@
 * Advanced Interrupt Controller (AIC)
 
 Required properties:
-- compatible: Should be "atmel,<chip>-aic"
-  <chip> can be "at91rm9200" or "sama5d3"
+- compatible: "atmel,at91rm9200-aic", "atmel,sama5d3-aic"
 - interrupt-controller: Identifies the node as an interrupt controller.
 - interrupt-parent: For single AIC system, it is an empty property.
 - #interrupt-cells: The number of cells to define the interrupts. It should be 3.
diff --git a/Documentation/devicetree/bindings/arm/atmel-at91.txt b/Documentation/devicetree/bindings/arm/atmel-at91.txt
index 16f60b41c147..e79a33315e4f 100644
--- a/Documentation/devicetree/bindings/arm/atmel-at91.txt
+++ b/Documentation/devicetree/bindings/arm/atmel-at91.txt
@@ -14,8 +14,7 @@ System Timer (ST) required properties:
   shared across all System Controller members.
 
 TC/TCLIB Timer required properties:
-- compatible: Should be "atmel,<chip>-tcb".
-  <chip> can be "at91rm9200" or "at91sam9x5"
+- compatible: "atmel,at91rm9200-tcb", "atmel,at91sam9x5-tcb"
 - reg: Should contain registers location and length
 - interrupts: Should contain all interrupts for the TC block
   Note that you can specify several interrupt cells if the TC
@@ -46,8 +45,7 @@ One interrupt per TC channel in a TC block:
 	};
 
 RSTC Reset Controller required properties:
-- compatible: Should be "atmel,<chip>-rstc".
-  <chip> can be "at91sam9260" or "at91sam9g45"
+- compatible: "atmel,at91sam9260-rstc", "atmel,at91sam9g45-rstc"
 - reg: Should contain registers location and length
 
 Example:
@@ -80,8 +78,8 @@ Examples:
 SHDWC Shutdown Controller
 
 required properties:
-- compatible: Should be "atmel,<chip>-shdwc".
-  <chip> can be "at91sam9260", "at91sam9rl" or "at91sam9x5".
+- compatible: "atmel,at91sam9260-shdwc", "atmel,at91sam9rl-shdwc",
+	"atmel,at91sam9x5-shdwc"
 - reg: Should contain registers location and length
 
 optional properties:
diff --git a/Documentation/devicetree/bindings/dma/atmel-dma.txt b/Documentation/devicetree/bindings/dma/atmel-dma.txt
index f69bcf5a6343..410bff989949 100644
--- a/Documentation/devicetree/bindings/dma/atmel-dma.txt
+++ b/Documentation/devicetree/bindings/dma/atmel-dma.txt
@@ -1,7 +1,7 @@
 * Atmel Direct Memory Access Controller (DMA)
 
 Required properties:
-- compatible: Should be "atmel,<chip>-dma".
+- compatible: "atmel,at91sam9rl-dma", "atmel,at91sam9g45-dma"
 - reg: Should contain DMA registers location and length.
 - interrupts: Should contain DMA interrupt.
 - #dma-cells: Must be <2>, used to represent the number of integer cells in
diff --git a/Documentation/devicetree/bindings/gpio/gpio_atmel.txt b/Documentation/devicetree/bindings/gpio/gpio_atmel.txt
index 85f8c0d084fa..1fa10565adcc 100644
--- a/Documentation/devicetree/bindings/gpio/gpio_atmel.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio_atmel.txt
@@ -1,7 +1,7 @@
 * Atmel GPIO controller (PIO)
 
 Required properties:
-- compatible: "atmel,<chip>-gpio", where <chip> is at91rm9200 or at91sam9x5.
+- compatible: "atmel,at91rm9200-gpio", "atmel,at91rm9x5-gpio"
 - reg: Should contain GPIO controller registers location and length
 - interrupts: Should be the port interrupt shared by all the pins.
 - #gpio-cells: Should be two.  The first cell is the pin number and
diff --git a/Documentation/devicetree/bindings/iio/adc/at91_adc.txt b/Documentation/devicetree/bindings/iio/adc/at91_adc.txt
index 82061c7e4fea..ac26cc13dd9f 100644
--- a/Documentation/devicetree/bindings/iio/adc/at91_adc.txt
+++ b/Documentation/devicetree/bindings/iio/adc/at91_adc.txt
@@ -1,8 +1,8 @@
 * AT91's Analog to Digital Converter (ADC)
 
 Required properties:
-  - compatible: Should be "atmel,<chip>-adc"
-    <chip> can be "at91sam9260", "at91sam9g45" or "at91sam9x5"
+  - compatible: "atmel,at91sam9260-adc", "atmel,at91sam9rl-adc",
+  		"atmel,at91sam9g45-adc", "atmel,at91sam9x5-adc",
   - reg: Should contain ADC registers location and length
   - interrupts: Should contain the IRQ line for the ADC
   - atmel,adc-channels-used: Bitmask of the channels muxed and enabled for this
diff --git a/Documentation/devicetree/bindings/serial/atmel-usart.txt b/Documentation/devicetree/bindings/serial/atmel-usart.txt
index 9c5d19ac935c..ebc5b0cb7669 100644
--- a/Documentation/devicetree/bindings/serial/atmel-usart.txt
+++ b/Documentation/devicetree/bindings/serial/atmel-usart.txt
@@ -1,9 +1,7 @@
 * Atmel Universal Synchronous Asynchronous Receiver/Transmitter (USART)
 
 Required properties:
-- compatible: Should be "atmel,<chip>-usart"
-  The compatible <chip> indicated will be the first SoC to support an
-  additional mode or an USART new feature.
+- compatible: Should be "atmel,at91rm9200-usart", "atmel,at91sam9260-usart",
 - reg: Should contain registers location and length
 - interrupts: Should contain interrupt
 - clock-names: tuple listing input clock names.
@@ -19,9 +17,9 @@ Optional properties:
 		Refer to dma.txt and atmel-dma.txt for details.
 	- dma-names: "rx" for RX channel, "tx" for TX channel.
 
-<chip> compatible description:
-- at91rm9200:  legacy USART support
-- at91sam9260: generic USART implementation for SAM9 SoCs
+compatible description:
+- atmel,at91rm9200-usart:  legacy USART support
+- atmel,at91sam9260-usart: generic USART implementation for SAM9 SoCs
 
 Example:
 - use PDC:
-- 
1.8.3.2

