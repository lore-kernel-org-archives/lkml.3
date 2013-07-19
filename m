Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760413Ab3GSMKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 08:10:24 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:36489 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760393Ab3GSMKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 08:10:22 -0400
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: benoit.cousson@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, nm@ti.com
Subject: [PATCH] arm: dts: twl6030: typical connection to omap4 as a separate dtsi file
Date: Fri, 19 Jul 2013 15:10:14 +0300
Message-Id: <1374235814-17834-1-git-send-email-ruslan.bilovol@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OMAP4 SoC family uses specially-designed
PMIC (power management IC) companion chip for power
management needs: TWL6030/TWL6032.
Therefore there is a typical connection of PMIC to OMAP4
so we can figure it out into separate .dtsi file
and do not duplicate over board-specific files.

Tested on OMAP4 SDP board and compile-tested for Panda board

Signed-off-by: Ruslan Bilovol <ruslan.bilovol@ti.com>
---
 arch/arm/boot/dts/omap4-panda-common.dtsi |   21 +---------------
 arch/arm/boot/dts/omap4-sdp.dts           |   21 +---------------
 arch/arm/boot/dts/twl6030_omap4.dtsi      |   38 +++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 40 deletions(-)
 create mode 100644 arch/arm/boot/dts/twl6030_omap4.dtsi

diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
index faa95b5..d796302 100644
--- a/arch/arm/boot/dts/omap4-panda-common.dtsi
+++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
@@ -109,23 +109,9 @@
 	};
 };
 
-&omap4_pmx_wkup {
-	pinctrl-names = "default";
-	pinctrl-0 = <
-			&twl6030_wkup_pins
-	>;
-
-	twl6030_wkup_pins: pinmux_twl6030_wkup_pins {
-		pinctrl-single,pins = <
-			0x14 (PIN_OUTPUT | MUX_MODE2)		/* fref_clk0_out.sys_drm_msecure */
-		>;
-	};
-};
-
 &omap4_pmx_core {
 	pinctrl-names = "default";
 	pinctrl-0 = <
-			&twl6030_pins
 			&twl6040_pins
 			&mcpdm_pins
 			&mcbsp1_pins
@@ -134,12 +120,6 @@
 			&hsusbb1_pins
 	>;
 
-	twl6030_pins: pinmux_twl6030_pins {
-		pinctrl-single,pins = <
-			0x15e (WAKEUP_EN | PIN_INPUT_PULLUP | MUX_MODE0)	/* sys_nirq1.sys_nirq1 */
-		>;
-	};
-
 	twl6040_pins: pinmux_twl6040_pins {
 		pinctrl-single,pins = <
 			0xe0 (PIN_OUTPUT | MUX_MODE3)	/* hdq_sio.gpio_127 */
@@ -265,6 +245,7 @@
 };
 
 #include "twl6030.dtsi"
+#include "twl6030_omap4.dtsi"
 
 &i2c2 {
 	pinctrl-names = "default";
diff --git a/arch/arm/boot/dts/omap4-sdp.dts b/arch/arm/boot/dts/omap4-sdp.dts
index 7951b4e..91030c3 100644
--- a/arch/arm/boot/dts/omap4-sdp.dts
+++ b/arch/arm/boot/dts/omap4-sdp.dts
@@ -142,23 +142,9 @@
 	};
 };
 
-&omap4_pmx_wkup {
-	pinctrl-names = "default";
-	pinctrl-0 = <
-			&twl6030_wkup_pins
-	>;
-
-	twl6030_wkup_pins: pinmux_twl6030_wkup_pins {
-		pinctrl-single,pins = <
-			0x14 (PIN_OUTPUT | MUX_MODE2)		/* fref_clk0_out.sys_drm_msecure */
-		>;
-	};
-};
-
 &omap4_pmx_core {
 	pinctrl-names = "default";
 	pinctrl-0 = <
-			&twl6030_pins
 			&twl6040_pins
 			&mcpdm_pins
 			&dmic_pins
@@ -193,12 +179,6 @@
 		>;
 	};
 
-	twl6030_pins: pinmux_twl6030_pins {
-		pinctrl-single,pins = <
-			0x15e (WAKEUP_EN | PIN_INPUT_PULLUP | MUX_MODE0)	/* sys_nirq1.sys_nirq1 */
-		>;
-	};
-
 	twl6040_pins: pinmux_twl6040_pins {
 		pinctrl-single,pins = <
 			0xe0 (PIN_OUTPUT | MUX_MODE3)		/* hdq_sio.gpio_127 */
@@ -337,6 +317,7 @@
 };
 
 #include "twl6030.dtsi"
+#include "twl6030_omap4.dtsi"
 
 &i2c2 {
 	pinctrl-names = "default";
diff --git a/arch/arm/boot/dts/twl6030_omap4.dtsi b/arch/arm/boot/dts/twl6030_omap4.dtsi
new file mode 100644
index 0000000..a4fa570
--- /dev/null
+++ b/arch/arm/boot/dts/twl6030_omap4.dtsi
@@ -0,0 +1,38 @@
+/*
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+&twl {
+	/*
+	 * On most OMAP4 platforms, the twl6030 IRQ line is connected
+	 * to the SYS_NIRQ1 line on OMAP and the twl6030 MSECURE line is
+	 * connected to the fref_clk0_out.sys_drm_msecure line.
+	 * Therefore, configure the defaults for the SYS_NIRQ1 and
+	 * fref_clk0_out.sys_drm_msecure pins here.
+	 */
+	pinctrl-names = "default";
+	pinctrl-0 = <
+		&twl6030_pins
+		&twl6030_wkup_pins
+	>;
+};
+
+&omap4_pmx_wkup {
+	twl6030_wkup_pins: pinmux_twl6030_wkup_pins {
+		pinctrl-single,pins = <
+			0x14 (PIN_OUTPUT | MUX_MODE2)		/* fref_clk0_out.sys_drm_msecure */
+		>;
+	};
+};
+
+&omap4_pmx_core {
+	twl6030_pins: pinmux_twl6030_pins {
+		pinctrl-single,pins = <
+			0x15e (WAKEUP_EN | PIN_INPUT_PULLUP | MUX_MODE0)	/* sys_nirq1.sys_nirq1 */
+		>;
+	};
+};
-- 
1.7.9.5

