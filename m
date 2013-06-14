Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab3FNJox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 05:44:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37135 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab3FNJov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 05:44:51 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <linux@arm.linux.org.uk>, <grant.likely@secretlab.ca>,
        <linus.walleij@linaro.org>, <rob.herring@calxeda.com>,
        <rob@landley.net>
CC: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <avinashphilip@ti.com>
Subject: [PATCH v2 3/4] ARM: davinci: da850: add GPIO DT entries
Date: Fri, 14 Jun 2013 15:15:55 +0530
Message-ID: <1371203156-15260-4-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371203020-15092-1-git-send-email-avinashphilip@ti.com>
References: <1371203020-15092-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KV Sujith <sujithkv@ti.com>

Add DT entries for Davinci GPIO.

Signed-off-by: KV Sujith <sujithkv@ti.com>
Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
Changes since v1:
	- interrupts member defined as array and with interrupt flags

 arch/arm/boot/dts/da850.dtsi |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
index 3b66020..cd7b362 100644
--- a/arch/arm/boot/dts/da850.dtsi
+++ b/arch/arm/boot/dts/da850.dtsi
@@ -8,6 +8,7 @@
  * option) any later version.
  */
 #include "skeleton.dtsi"
+#include <dt-bindings/interrupt-controller/irq.h>
 
 / {
 	arm {
@@ -126,6 +127,20 @@
 				>;
 			};
 		};
+		gpio: gpio@1e26000 {
+			compatible = "ti,da830-gpio";
+			reg = <0x226000 0x1000>;
+			interrupts = <42 IRQ_TYPE_EDGE_BOTH
+				43 IRQ_TYPE_EDGE_BOTH 44 IRQ_TYPE_EDGE_BOTH
+				45 IRQ_TYPE_EDGE_BOTH 46 IRQ_TYPE_EDGE_BOTH
+				47 IRQ_TYPE_EDGE_BOTH 48 IRQ_TYPE_EDGE_BOTH
+				49 IRQ_TYPE_EDGE_BOTH 50 IRQ_TYPE_EDGE_BOTH>;
+			ngpio = <144>;
+			intc_irq_num = <101>;
+			gpio_unbanked = <0>;
+			status = "disabled";
+		};
 		serial0: serial@1c42000 {
 			compatible = "ns16550a";
 			reg = <0x42000 0x100>;
-- 
1.7.9.5

