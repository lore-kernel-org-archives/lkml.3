Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946150Ab3FUV2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 17:28:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51728 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946138Ab3FUV0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 17:26:36 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Mark Brown <broonie@kernel.org>, Tony Lindgren <tony@atomide.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>
Subject: [RFC PATCH V2 7/8] ARM: dts: omap4-panda-es: add TPS62361 supply for vdd_mpu
Date: Fri, 21 Jun 2013 16:25:48 -0500
Message-ID: <1371849949-12649-8-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371849949-12649-1-git-send-email-nm@ti.com>
References: <1371849949-12649-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike other OMAP4 platforms including the the "vanilla" PandaBoard,
PandaBoard-ES uses TPS62361 to supply vdd_mpu.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/omap4-panda-es.dts |   18 ++++++++++++++++++
 arch/arm/boot/dts/tps62361_omap.dtsi |   18 ++++++++++++++++++
 2 files changed, 36 insertions(+)
 create mode 100644 arch/arm/boot/dts/tps62361_omap.dtsi

diff --git a/arch/arm/boot/dts/omap4-panda-es.dts b/arch/arm/boot/dts/omap4-panda-es.dts
index 49017c5..325816c 100644
--- a/arch/arm/boot/dts/omap4-panda-es.dts
+++ b/arch/arm/boot/dts/omap4-panda-es.dts
@@ -75,3 +75,21 @@
 	/* We use TPS62361 on this platform instead */
 	status = "disabled";
 };
+
+#include "tps62361_omap.dtsi"
+
+&omap4_pmx_wkup {
+	tps62361_wkgpio_pins: pinmux_tps62361_wkpins {
+		pinctrl-single,pins = <
+			0x1a (PIN_OUTPUT | MUX_MODE3 | OFF_EN | OFFOUT_VAL) /* gpio_wk7 */
+		>;
+	};
+};
+
+&omap_tps62361 {
+	pinctrl-names = "default";
+	pinctrl-0 = <
+		&tps62361_wkgpio_pins
+	>;
+	gpios = <&gpio1 7 GPIO_ACTIVE_HIGH>;
+};
diff --git a/arch/arm/boot/dts/tps62361_omap.dtsi b/arch/arm/boot/dts/tps62361_omap.dtsi
new file mode 100644
index 0000000..ee261ec
--- /dev/null
+++ b/arch/arm/boot/dts/tps62361_omap.dtsi
@@ -0,0 +1,18 @@
+/*
+ * TPS62361 entries specific for OMAP
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
+ *	Nishanth Menon
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/ {
+	omap_tps62361: tps62361 {
+		compatible = "ti,omap-tps62361";
+		ti,boot-voltage-micro-volts = <1203000>;
+		ti,vp = <&vp_mpu>;
+	};
+};
-- 
1.7.9.5

