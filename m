Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025AbaJUObX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:31:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50679 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932875AbaJUObU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:31:20 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 1/3] ARM: dts: dra72-evm: Provide explicit pinmux for TPS PMIC
Date: Tue, 21 Oct 2014 09:30:46 -0500
Message-ID: <1413901848-32268-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413901848-32268-1-git-send-email-nm@ti.com>
References: <1413901848-32268-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even thought sys_nirq1 is hardwired on the SoC for the pin, it is
better to configure the pin to the required mux configuration.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/dra72-evm.dts |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/dra72-evm.dts b/arch/arm/boot/dts/dra72-evm.dts
index 4107428..671e473 100644
--- a/arch/arm/boot/dts/dra72-evm.dts
+++ b/arch/arm/boot/dts/dra72-evm.dts
@@ -26,6 +26,12 @@
 			0x404 (PIN_INPUT | MUX_MODE0) /* i2c1_scl.i2c1_scl */
 		>;
 	};
+
+	tps65917_pins_default: tps65917_pins_default {
+		pinctrl-single,pins = <
+			0x424 (PIN_INPUT_PULLUP | MUX_MODE1) /* wakeup3.sys_nirq1 */
+		>;
+	};
 };
 
 &i2c1 {
@@ -38,6 +44,9 @@
 		compatible = "ti,tps65917";
 		reg = <0x58>;
 
+		pinctrl-names = "default";
+		pinctrl-0 = <&tps65917_pins_default>;
+
 		interrupts = <GIC_SPI 2 IRQ_TYPE_NONE>;  /* IRQ_SYS_1N */
 		interrupt-parent = <&gic>;
 		interrupt-controller;
-- 
1.7.9.5

