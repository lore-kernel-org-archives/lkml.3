Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab3KZToU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 14:44:20 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47293 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab3KZToP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 14:44:15 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-gpio@vger.kernel.org>, <nsekhar@ti.com>
CC: <prabhakar.csengg@gmail.com>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC v1 6/9] arm: dts: keystone: add GPIO device entry
Date: Tue, 26 Nov 2013 21:40:12 +0200
Message-ID: <1385494815-15740-7-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385494815-15740-1-git-send-email-grygorii.strashko@ti.com>
References: <1385494815-15740-1-git-send-email-grygorii.strashko@ti.com>
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

