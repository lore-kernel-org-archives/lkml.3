Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaJTDXm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 23:23:42 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:57298 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbaJTDXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 23:23:38 -0400
From: Howard Chen <ibanezchen@gmail.com>
To: matthias.bgg@gmail.com
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek
	SoC...),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 1/3] ARM: mediatek: Add basic support for mt6592
Date: Mon, 20 Oct 2014 11:23:17 +0800
Message-Id: <1413775401-4501-1-git-send-email-ibanezchen@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* A dtsi for boards based on Mediatek MT6592 SoCs
* Compatible string in arch/arm/mach-mediatek/mediatek.c

Signed-off-by: Howard Chen <ibanezchen@gmail.com>
---
 arch/arm/boot/dts/mt6592.dtsi     | 138 ++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-mediatek/mediatek.c |   1 +
 2 files changed, 139 insertions(+)
 create mode 100644 arch/arm/boot/dts/mt6592.dtsi

diff --git a/arch/arm/boot/dts/mt6592.dtsi b/arch/arm/boot/dts/mt6592.dtsi
new file mode 100644
index 0000000..367ba8f
--- /dev/null
+++ b/arch/arm/boot/dts/mt6592.dtsi
@@ -0,0 +1,138 @@
+/*
+ * Copyright (c) 2014 MediaTek Inc.
+ * Author: Howard Chen <ibanezchen@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <dt-bindings/interrupt-controller/irq.h>
+#include <dt-bindings/interrupt-controller/arm-gic.h>
+#include "skeleton.dtsi"
+
+/ {
+	compatible = "mediatek,mt6592";
+	interrupt-parent = <&gic>;
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			reg = <0x0>;
+		};
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			reg = <0x1>;
+		};
+		cpu@2 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			reg = <0x2>;
+		};
+		cpu@3 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			reg = <0x3>;
+		};
+		cpu@4 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			reg = <0x4>;
+		};
+		cpu@5 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			reg = <0x5>;
+		};
+		cpu@6 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			reg = <0x6>;
+		};
+		cpu@7 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			reg = <0x7>;
+		};
+	};
+
+	system_clk: dummy13m {
+		compatible = "fixed-clock";
+		clock-frequency = <13000000>;
+		#clock-cells = <0>;
+	};
+
+	rtc_clk: dummy32k {
+		compatible = "fixed-clock";
+		clock-frequency = <32000>;
+		#clock-cells = <0>;
+	};
+
+	uart_clk: uart_clk {
+		compatible = "fixed-clock";
+		clock-frequency = <26000000>;
+		#clock-cells = <0>;
+	};
+
+	timer: timer@10008000 {
+		compatible = "mediatek,mt6577-timer";
+		reg = <0x10008000 0x80>;
+		interrupts = <GIC_SPI 144 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&system_clk>, <&rtc_clk>;
+		clock-names = "system-clk", "rtc-clk";
+	};
+
+	gic: interrupt-controller@10211000 {
+		compatible = "arm,cortex-a9-gic";
+		interrupt-controller;
+		#interrupt-cells = <3>;
+		reg = <0x10211000 0x1000>,
+			  <0x10212000 0x1000>;
+	};
+
+	uart0: serial@11002000 {
+		compatible = "mediatek,mt6592-uart", "mediatek,mt6577-uart";
+		reg = <0x11002000 0x400>;
+		reg-shift = <2>;
+		interrupts = <GIC_SPI 83 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&uart_clk>;
+		status = "disabled";
+	};
+
+	uart1: serial@11003000 {
+		compatible = "mediatek,mt6592-uart", "mediatek,mt6577-uart";
+		reg = <0x11003000 0x400>;
+		reg-shift = <2>;
+		interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&uart_clk>;
+		status = "disabled";
+	};
+
+	uart2: serial@11004000 {
+		compatible = "mediatek,mt6592-uart", "mediatek,mt6577-uart";
+		reg = <0x11004000 0x400>;
+		reg-shift = <2>;
+		interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&uart_clk>;
+		status = "disabled";
+	};
+
+	uart3: serial@11005000 {
+		compatible = "mediatek,mt6592-uart", "mediatek,mt6577-uart";
+		reg = <0x11005000 0x400>;
+		reg-shift = <2>;
+		interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&uart_clk>;
+		status = "disabled";
+	};
+};
diff --git a/arch/arm/mach-mediatek/mediatek.c b/arch/arm/mach-mediatek/mediatek.c
index f2acf07..88e4626 100644
--- a/arch/arm/mach-mediatek/mediatek.c
+++ b/arch/arm/mach-mediatek/mediatek.c
@@ -19,6 +19,7 @@
 
 static const char * const mediatek_board_dt_compat[] = {
 	"mediatek,mt6589",
+	"mediatek,mt6592",
 	NULL,
 };
 
-- 
1.9.1

