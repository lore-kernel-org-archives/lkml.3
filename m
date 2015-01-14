Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbbANIl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:41:27 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:42917 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbbANIlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:41:24 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: arm@kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH v3 3/4] ARM: digicolor: add minimal device tree description
Date: Wed, 14 Jan 2015 10:40:32 +0200
Message-Id: <474d0849bb30ab4ec323fa4c1bc67b30b31d3884.1421219953.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <cover.1421219953.git.baruch@tkos.co.il>
References: <cover.1421219953.git.baruch@tkos.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cx92755.dtsi describes CX92755 on chip peripherals. conexant_equinox.dts
describes the Equinox evaluation board for the CX92755 SoC.

Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 arch/arm/boot/dts/Makefile             |   1 +
 arch/arm/boot/dts/conexant_equinox.dts |  74 +++++++++++++++++++++++
 arch/arm/boot/dts/cx92755.dtsi         | 107 +++++++++++++++++++++++++++++++++
 3 files changed, 182 insertions(+)
 create mode 100644 arch/arm/boot/dts/conexant_equinox.dts
 create mode 100644 arch/arm/boot/dts/cx92755.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 91bd5bd62857..fbeb65eaddda 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -75,6 +75,7 @@ dtb-$(CONFIG_ARCH_BRCMSTB) += \
 	bcm7445-bcm97445svmb.dtb
 dtb-$(CONFIG_ARCH_DAVINCI) += da850-enbw-cmc.dtb \
 	da850-evm.dtb
+dtb-$(CONFIG_ARCH_DIGICOLOR) += conexant_equinox.dtb
 dtb-$(CONFIG_ARCH_EFM32) += efm32gg-dk3750.dtb
 dtb-$(CONFIG_ARCH_EXYNOS) += exynos3250-monk.dtb \
 	exynos3250-rinato.dtb \
diff --git a/arch/arm/boot/dts/conexant_equinox.dts b/arch/arm/boot/dts/conexant_equinox.dts
new file mode 100644
index 000000000000..f33bf5635d47
--- /dev/null
+++ b/arch/arm/boot/dts/conexant_equinox.dts
@@ -0,0 +1,74 @@
+/*
+ * Device Tree file for the Conexant Equinox CX92755 EVK
+ *
+ * Author: Baruch Siach <baruch@tkos.co.il>
+ *
+ *  Copyright (C) 2014 Paradox Innovation Ltd.
+ *
+ * This file is dual-licensed: you can use it either under the terms
+ * of the GPL or the X11 license, at your option. Note that this dual
+ * licensing only applies to this file, and not this project as a
+ * whole.
+ *
+ *  a) This file is free software; you can redistribute it and/or
+ *     modify it under the terms of the GNU General Public License as
+ *     published by the Free Software Foundation; either version 2 of the
+ *     License, or (at your option) any later version.
+ *
+ *     This file is distributed in the hope that it will be useful,
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
+
+#include "cx92755.dtsi"
+
+/ {
+	model = "Conexant Equinox CX92755 EVK";
+	compatible = "cnxt,equinox", "cnxt,cx92755";
+
+	aliases {
+		serial0 = &uart0;
+		serial1 = &uart1;
+		serial2 = &uart2;
+	};
+
+	memory@0 {
+		reg = <0 0x8000000>;
+		device_type = "memory";
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200";
+		stdout-path = &uart0;
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
diff --git a/arch/arm/boot/dts/cx92755.dtsi b/arch/arm/boot/dts/cx92755.dtsi
new file mode 100644
index 000000000000..984cca90ef9a
--- /dev/null
+++ b/arch/arm/boot/dts/cx92755.dtsi
@@ -0,0 +1,107 @@
+/*
+ * Device Tree Include file for the Conexant Digicolor CX92755 SoC
+ *
+ * Author: Baruch Siach <baruch@tkos.co.il>
+ *
+ *  Copyright (C) 2014 Paradox Innovation Ltd.
+ *
+ * This file is dual-licensed: you can use it either under the terms
+ * of the GPL or the X11 license, at your option. Note that this dual
+ * licensing only applies to this file, and not this project as a
+ * whole.
+ *
+ *  a) This file is free software; you can redistribute it and/or
+ *     modify it under the terms of the GNU General Public License as
+ *     published by the Free Software Foundation; either version 2 of the
+ *     License, or (at your option) any later version.
+ *
+ *     This file is distributed in the hope that it will be useful,
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
+#include "skeleton.dtsi"
+
+/ {
+	compatible = "cnxt,cx92755";
+
+	interrupt-parent = <&intc>;
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a8";
+			reg = <0x0>;
+		};
+	};
+
+	main_clk: main_clk {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency  = <200000000>;
+	};
+
+	intc: intc@f0000000 {
+		compatible = "cnxt,cx92755-ic";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		reg = <0xf0000000 0x1000>;
+	};
+
+	timer@f0000fc0 {
+		compatible = "cnxt,cx92755-timer";
+		reg = <0xf0000fc0 0x40>;
+		interrupts = <19>, <31>, <34>, <35>, <52>, <53>, <54>, <55>;
+		clocks = <&main_clk>;
+	};
+
+	uart0: uart@f0000740 {
+		compatible = "cnxt,cx92755-usart";
+		reg = <0xf0000740 0x20>;
+		clocks = <&main_clk>;
+		interrupts = <44>;
+		status = "disabled";
+	};
+
+	uart1: uart@f0000760 {
+		compatible = "cnxt,cx92755-usart";
+		reg = <0xf0000760 0x20>;
+		clocks = <&main_clk>;
+		interrupts = <45>;
+		status = "disabled";
+	};
+
+	uart2: uart@f0000780 {
+		compatible = "cnxt,cx92755-usart";
+		reg = <0xf0000780 0x20>;
+		clocks = <&main_clk>;
+		interrupts = <46>;
+		status = "disabled";
+	};
+};
-- 
2.1.4

