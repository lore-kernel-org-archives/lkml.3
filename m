Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbbASXYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 18:24:41 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:34843 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbbASXYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 18:24:05 -0500
From: Beniamino Galvani <b.galvani@gmail.com>
To: Carlo Caione <carlo@caione.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH 3/3] ARM: dts: meson: add DTS file for MINIX NEO-X8
Date: Tue, 20 Jan 2015 00:22:59 +0100
Message-Id: <1421709779-25691-4-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421709779-25691-1-git-send-email-b.galvani@gmail.com>
References: <1421709779-25691-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a DTS file for MINIX NEO-X8, a Meson8-based digital media player.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 arch/arm/boot/dts/Makefile                |   1 +
 arch/arm/boot/dts/meson8-minix-neo-x8.dts | 128 ++++++++++++++++++++++++++++++
 2 files changed, 129 insertions(+)
 create mode 100644 arch/arm/boot/dts/meson8-minix-neo-x8.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 91bd5bd..e9ffa5f 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -177,6 +177,7 @@ dtb-$(CONFIG_MACH_KIRKWOOD) += kirkwood-b3.dtb \
 dtb-$(CONFIG_ARCH_LPC32XX) += ea3250.dtb phy3250.dtb
 dtb-$(CONFIG_ARCH_MARCO) += marco-evb.dtb
 dtb-$(CONFIG_MACH_MESON6) += meson6-atv1200.dtb
+dtb-$(CONFIG_MACH_MESON8) += meson8-minix-neo-x8.dtb
 dtb-$(CONFIG_ARCH_MMP) += pxa168-aspenite.dtb \
 	pxa910-dkb.dtb \
 	mmp2-brownstone.dtb
diff --git a/arch/arm/boot/dts/meson8-minix-neo-x8.dts b/arch/arm/boot/dts/meson8-minix-neo-x8.dts
new file mode 100644
index 0000000..4f536bb
--- /dev/null
+++ b/arch/arm/boot/dts/meson8-minix-neo-x8.dts
@@ -0,0 +1,128 @@
+/*
+ * Copyright 2014 Beniamino Galvani <b.galvani@gmail.com>
+ *
+ * This file is dual-licensed: you can use it either under the terms
+ * of the GPL or the X11 license, at your option. Note that this dual
+ * licensing only applies to this file, and not this project as a
+ * whole.
+ *
+ *  a) This library is free software; you can redistribute it and/or
+ *     modify it under the terms of the GNU General Public License as
+ *     published by the Free Software Foundation; either version 2 of the
+ *     License, or (at your option) any later version.
+ *
+ *     This library is distributed in the hope that it will be useful,
+ *     but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *     GNU General Public License for more details.
+ *
+ * Or, alternatively,
+ *
+ *  b) Permission is hereby granted, free of charge, to any person
+ *     obtaining a copy of this software and associated documentation
+ *     files (the "Software"), to deal in the Software without
+ *     restriction, including without limitation the rights to use,
+ *     copy, modify, merge, publish, distribute, sublicense, and/or
+ *     sell copies of the Software, and to permit persons to whom the
+ *     Software is furnished to do so, subject to the following
+ *     conditions:
+ *
+ *     The above copyright notice and this permission notice shall be
+ *     included in all copies or substantial portions of the Software.
+ *
+ *     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
+ *     OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
+ *     HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
+ *     WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ *     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ *     OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+/dts-v1/;
+#include <dt-bindings/gpio/gpio.h>
+#include "meson8.dtsi"
+
+/ {
+	model = "MINIX NEO-X8";
+	compatible = "minix,neo-x8", "amlogic,meson8";
+
+	aliases {
+		serial0 = &uart_AO;
+	};
+
+	memory {
+		reg = <0x40000000 0x80000000>;
+	};
+
+	gpio-leds {
+		compatible = "gpio-leds";
+
+		blue {
+			label = "x8:blue:power";
+			gpios = <&gpio_ao GPIO_TEST_N GPIO_ACTIVE_HIGH>;
+		};
+	};
+};
+
+&uart_AO {
+	status = "okay";
+	pinctrl-0 = <&uart_ao_a_pins>;
+	pinctrl-names = "default";
+};
+
+&i2c_AO {
+	status = "okay";
+	pinctrl-0 = <&i2c_ao_pins>;
+	pinctrl-names = "default";
+
+	pmic@32 {
+		compatible = "ricoh,rn5t618";
+		reg = <0x32>;
+
+		regulators {
+		};
+	};
+
+	rtc@51 {
+		compatible = "nxp,pcf8563";
+		reg = <0x51>;
+	};
+};
+
+&spifc {
+	status = "okay";
+	pinctrl-0 = <&spi_nor_pins>;
+	pinctrl-names = "default";
+
+	spi-flash@0 {
+		compatible = "mxicy,mx25l1606e";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0>;
+		spi-max-frequency = <30000000>;
+
+		partition@0 {
+			label = "boot";
+			reg = <0x0 0x100000>;
+		};
+
+		partition@100000 {
+			label = "env";
+			reg = <0x100000 0x10000>;
+		};
+	};
+};
+
+&ir_receiver {
+	status = "okay";
+	pinctrl-0 = <&ir_recv_pins>;
+	pinctrl-names = "default";
+};
+
+&ethmac {
+	status = "okay";
+	pinctrl-0 = <&eth_pins>;
+	pnictrl-names = "default";
+};
-- 
2.1.4

