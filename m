Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaG1TyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 15:54:00 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:48026 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaG1Txx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 15:53:53 -0400
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, bcousson@baylibre.com, tony@atomide.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        hns@goldelico.com, Marek Belisko <marek@goldelico.com>
Subject: [PATCH 2/3] arm: dts: Add gta04a3 model
Date: Mon, 28 Jul 2014 21:53:32 +0200
Message-Id: <1406577213-9642-3-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406577213-9642-1-git-send-email-marek@goldelico.com>
References: <1406577213-9642-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add gta04a3 model with additional acceleromer.

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 arch/arm/boot/dts/Makefile          |  1 +
 arch/arm/boot/dts/omap3-gta04a3.dts | 48 +++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)
 create mode 100644 arch/arm/boot/dts/omap3-gta04a3.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 3dc9d44..7d45fde 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -283,6 +283,7 @@ dtb-$(CONFIG_ARCH_OMAP3) += am3517-craneboard.dtb \
 	omap3-devkit8000.dtb \
 	omap3-evm.dtb \
 	omap3-evm-37xx.dtb \
+	omap3-gta04a3.dtb \
 	omap3-gta04a4.dtb \
 	omap3-igep0020.dtb \
 	omap3-igep0030.dtb \
diff --git a/arch/arm/boot/dts/omap3-gta04a3.dts b/arch/arm/boot/dts/omap3-gta04a3.dts
new file mode 100644
index 0000000..3099a89
--- /dev/null
+++ b/arch/arm/boot/dts/omap3-gta04a3.dts
@@ -0,0 +1,48 @@
+/*
+ * Copyright (C) 2014 H. Nikolaus Schaller <hns@goldelico.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "omap3-gta04.dtsi"
+
+/ {
+	model = "Goldelico GTA04A3";
+};
+
+&i2c2 {
+
+	/* alternate accelerometer that might be installed on some GTA04A3 boards */
+	lis302@1d {
+		compatible = "st,lis331dlh", "st,lis3lv02d";
+		reg = <0x1d>;
+		interrupt-parent = <&gpio3>;
+		interrupts = <18 (IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_EDGE_RISING)>;
+		Vdd-supply = <&vaux2>;
+		Vdd_IO-supply = <&vaux2>;
+
+		st,click-single-x;
+		st,click-single-y;
+		st,click-single-z;
+		st,click-thresh-x = <8>;
+		st,click-thresh-y = <8>;
+		st,click-thresh-z = <10>;
+		st,click-click-time-limit = <9>;
+		st,click-latency = <50>;
+		st,irq1-click;
+		st,wakeup-x-lo;
+		st,wakeup-x-hi;
+		st,wakeup-y-lo;
+		st,wakeup-y-hi;
+		st,wakeup-z-lo;
+		st,wakeup-z-hi;
+		st,min-limit-x = <32>;
+		st,min-limit-y = <3>;
+		st,min-limit-z = <3>;
+		st,max-limit-x = <3>;
+		st,max-limit-y = <32>;
+		st,max-limit-z = <32>;
+	};
+};
-- 
1.9.1

