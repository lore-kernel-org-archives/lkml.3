Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946188Ab3FUV3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 17:29:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54500 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946061Ab3FUV0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 17:26:35 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Mark Brown <broonie@kernel.org>, Tony Lindgren <tony@atomide.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>
Subject: [RFC PATCH V2 6/8] ARM: dts: TWL6030/OMAP4: Add OMAP voltage path linkage
Date: Fri, 21 Jun 2013 16:25:47 -0500
Message-ID: <1371849949-12649-7-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371849949-12649-1-git-send-email-nm@ti.com>
References: <1371849949-12649-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP4430 and 4460 platforms use TWL6030 to power voltage rails.
However, on 4460, we use twl6030 only for iva and core voltage rails.

Introduce an twl6030_omap4.dtsi to be able to reuse the base definition
for all OMAP4 platforms and the delta change only for panda-es platform
which is based on 4460.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/omap4-panda-common.dtsi |    1 +
 arch/arm/boot/dts/omap4-panda-es.dts      |   13 +++++++++++
 arch/arm/boot/dts/omap4-sdp.dts           |    1 +
 arch/arm/boot/dts/omap4-var-som.dts       |    1 +
 arch/arm/boot/dts/twl6030_omap4.dtsi      |   35 +++++++++++++++++++++++++++++
 5 files changed, 51 insertions(+)
 create mode 100644 arch/arm/boot/dts/twl6030_omap4.dtsi

diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
index 00cbaa5..2b15c2b 100644
--- a/arch/arm/boot/dts/omap4-panda-common.dtsi
+++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
@@ -199,6 +199,7 @@
 };
 
 #include "twl6030.dtsi"
+#include "twl6030_omap4.dtsi"
 
 &i2c2 {
 	pinctrl-names = "default";
diff --git a/arch/arm/boot/dts/omap4-panda-es.dts b/arch/arm/boot/dts/omap4-panda-es.dts
index 56c4354..49017c5 100644
--- a/arch/arm/boot/dts/omap4-panda-es.dts
+++ b/arch/arm/boot/dts/omap4-panda-es.dts
@@ -62,3 +62,16 @@
 		gpios = <&gpio1 8 GPIO_ACTIVE_HIGH>;
 	};
 };
+
+&omap_twl6030_vcore1 {
+	ti,vp = <&vp_core>;
+};
+
+&omap_twl6030_vcore2 {
+	ti,vp = <&vp_iva>;
+};
+
+&omap_twl6030_vcore3 {
+	/* We use TPS62361 on this platform instead */
+	status = "disabled";
+};
diff --git a/arch/arm/boot/dts/omap4-sdp.dts b/arch/arm/boot/dts/omap4-sdp.dts
index 7951b4e..2f81b4d5 100644
--- a/arch/arm/boot/dts/omap4-sdp.dts
+++ b/arch/arm/boot/dts/omap4-sdp.dts
@@ -337,6 +337,7 @@
 };
 
 #include "twl6030.dtsi"
+#include "twl6030_omap4.dtsi"
 
 &i2c2 {
 	pinctrl-names = "default";
diff --git a/arch/arm/boot/dts/omap4-var-som.dts b/arch/arm/boot/dts/omap4-var-som.dts
index b41269e..6f0b763 100644
--- a/arch/arm/boot/dts/omap4-var-som.dts
+++ b/arch/arm/boot/dts/omap4-var-som.dts
@@ -40,6 +40,7 @@
 };
 
 #include "twl6030.dtsi"
+#include "twl6030_omap4.dtsi"
 
 &i2c2 {
 	clock-frequency = <400000>;
diff --git a/arch/arm/boot/dts/twl6030_omap4.dtsi b/arch/arm/boot/dts/twl6030_omap4.dtsi
new file mode 100644
index 0000000..7724039
--- /dev/null
+++ b/arch/arm/boot/dts/twl6030_omap4.dtsi
@@ -0,0 +1,35 @@
+/*
+ * TWL6030 entries specific for OMAP
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
+ *	Nishanth Menon
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+&twl {
+	omap_twl6030_vcore1: vcore1 {
+		compatible = "ti,omap-twl6030-vcore1";
+		ti,boot-voltage-micro-volts = <1200000>;
+		ti,vp = <&vp_mpu>;
+	};
+
+	omap_twl6030_vcore2: vcore2 {
+		compatible = "ti,omap-twl6030-vcore2";
+		ti,boot-voltage-micro-volts = <1200000>;
+		ti,vp = <&vp_iva>;
+	};
+
+	omap_twl6030_vcore3: vcore3 {
+		compatible = "ti,omap-twl6030-vcore3";
+		ti,boot-voltage-micro-volts = <1200000>;
+		ti,vp = <&vp_core>;
+	};
+};
+
+&vc {
+	ti,i2c-high-speed;
+	ti,i2c-pad-load = <3>;
+};
-- 
1.7.9.5

