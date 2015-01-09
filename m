Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbbAIJvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:51:42 -0500
Received: from down.free-electrons.com ([37.187.137.238]:38070 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756220AbbAIJvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 04:51:38 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v2 1/8] ARM: at91/dt: declare atmel,at91rm9200-st as a syscon
Date: Fri,  9 Jan 2015 10:51:27 +0100
Message-Id: <1420797094-9444-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420797094-9444-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1420797094-9444-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The system timer register range is also used for the watchdog. Declare it as a
syscon to be able to get a regmap early enough in the boot process

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 Documentation/devicetree/bindings/arm/atmel-at91.txt | 2 +-
 arch/arm/boot/dts/at91rm9200.dtsi                    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/atmel-at91.txt b/Documentation/devicetree/bindings/arm/atmel-at91.txt
index 562cda9d86d9..938592a3c4e2 100644
--- a/Documentation/devicetree/bindings/arm/atmel-at91.txt
+++ b/Documentation/devicetree/bindings/arm/atmel-at91.txt
@@ -45,7 +45,7 @@ PIT Timer required properties:
   shared across all System Controller members.
 
 System Timer (ST) required properties:
-- compatible: Should be "atmel,at91rm9200-st"
+- compatible: Should be "atmel,at91rm9200-st", "syscon"
 - reg: Should contain registers location and length
 - interrupts: Should contain interrupt for the ST which is the IRQ line
   shared across all System Controller members.
diff --git a/arch/arm/boot/dts/at91rm9200.dtsi b/arch/arm/boot/dts/at91rm9200.dtsi
index 6c97d4af61ee..f77b15c0b1d1 100644
--- a/arch/arm/boot/dts/at91rm9200.dtsi
+++ b/arch/arm/boot/dts/at91rm9200.dtsi
@@ -351,7 +351,7 @@
 			};
 
 			st: timer@fffffd00 {
-				compatible = "atmel,at91rm9200-st";
+				compatible = "atmel,at91rm9200-st", "syscon";
 				reg = <0xfffffd00 0x100>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
 			};
-- 
2.1.0

