Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab3LPPoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:44:38 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58270 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325Ab3LPPns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:43:48 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH 1/4] arm: dts: keystone: add GPIO device entry
Date: Mon, 16 Dec 2013 18:39:37 +0200
Message-ID: <1387211981-26045-2-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387211981-26045-1-git-send-email-grygorii.strashko@ti.com>
References: <1387211981-26045-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Keystone GPIO IP device definitions in DT which supports
up to 32 GPIO lines and each GPIO line can be configured as separate
interrupt source (so called "unbanked" IRQ).

For more information see:
 http://www.ti.com/lit/ug/sprugv1/sprugv1.pdf

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 arch/arm/boot/dts/keystone.dtsi |   45 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/arm/boot/dts/keystone.dtsi b/arch/arm/boot/dts/keystone.dtsi
index f6d6d9e..6e93bf5 100644
--- a/arch/arm/boot/dts/keystone.dtsi
+++ b/arch/arm/boot/dts/keystone.dtsi
@@ -7,6 +7,7 @@
  */
 
 #include <dt-bindings/interrupt-controller/arm-gic.h>
+#include <dt-bindings/gpio/gpio.h>
 
 #include "skeleton.dtsi"
 
@@ -181,5 +182,49 @@
 			interrupts = <GIC_SPI 300 IRQ_TYPE_EDGE_RISING>;
 			clocks = <&clkspi>;
 		};
+
+		gpio0: gpio@260bf00 {
+				compatible = "ti,keystone-gpio";
+				reg = <0x0260bf00 0x100>;
+				gpio-controller;
+				#gpio-cells = <2>;
+				/* HW Interrupts mapped to GPIO pins */
+				interrupts = <GIC_SPI 120 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 121 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 122 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 123 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 124 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 125 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 126 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 127 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 128 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 129 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 130 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 131 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 132 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 133 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 134 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 135 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 136 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 137 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 138 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 139 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 140 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 141 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 142 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 143 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 144 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 145 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 146 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 147 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 148 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 149 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 150 IRQ_TYPE_EDGE_RISING
+							  GIC_SPI 151 IRQ_TYPE_EDGE_RISING>;
+				clocks = <&clkgpio>;
+				clock-names = "gpio";
+				ti,ngpio = <32>;
+				ti,davinci-gpio-unbanked = <32>;
+		};
 	};
 };
-- 
1.7.9.5

