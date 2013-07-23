Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934476Ab3GWXAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 19:00:04 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51686 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934222Ab3GWWZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:25:28 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Olof Johansson <olof@lixom.net>, albert.u.boot@aribaud.net,
        Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 05/10] ARM: sunxi: Add Allwinner A31 DTSI
Date: Wed, 24 Jul 2013 00:25:07 +0200
Message-Id: <1374618312-19001-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374618312-19001-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1374618312-19001-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/Makefile       |   3 +-
 arch/arm/boot/dts/sun6i-a31.dtsi | 155 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 157 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/sun6i-a31.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 641b3c9..1482533 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -210,7 +210,8 @@ dtb-$(CONFIG_ARCH_SUNXI) += \
 	sun4i-a10-mini-xplus.dtb \
 	sun4i-a10-hackberry.dtb \
 	sun5i-a10s-olinuxino-micro.dtb \
-	sun5i-a13-olinuxino.dtb
+	sun5i-a13-olinuxino.dtb \
+	sun6i-a31-colombus.dtb
 dtb-$(CONFIG_ARCH_TEGRA) += tegra20-harmony.dtb \
 	tegra20-iris-512.dtb \
 	tegra20-medcom-wide.dtb \
diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
new file mode 100644
index 0000000..c6c19a9
--- /dev/null
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -0,0 +1,155 @@
+/*
+ * Copyright 2013 Maxime Ripard
+ *
+ * Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+/include/ "skeleton.dtsi"
+
+/ {
+	interrupt-parent = <&gic>;
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			compatible = "arm,cortex-a7";
+			device_type = "cpu";
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "arm,cortex-a7";
+			device_type = "cpu";
+			reg = <1>;
+		};
+
+		cpu@2 {
+			compatible = "arm,cortex-a7";
+			device_type = "cpu";
+			reg = <2>;
+		};
+
+		cpu@3 {
+			compatible = "arm,cortex-a7";
+			device_type = "cpu";
+			reg = <3>;
+		};
+	};
+
+	memory {
+		reg = <0x40000000 0x80000000>;
+	};
+
+	clocks {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		osc: oscillator {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <24000000>;
+		};
+	};
+
+	soc@01c20000 {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0x01c20000 0x300000>;
+		ranges;
+
+		timer@01c20c00 {
+			compatible = "allwinner,sun4i-timer";
+			reg = <0x01c20c00 0xa0>;
+			interrupts = <
+					0 18 1
+					0 19 1
+					0 20 1
+					0 21 1
+					0 22 1
+					>;
+			clocks = <&osc>;
+		};
+
+		wdt1: watchdog@01c20ca0 {
+			compatible = "allwinner,sun6i-wdt";
+			reg = <0x01c20ca0 0x20>;
+		};
+
+		uart0: serial@01c28000 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c28000 0x400>;
+			interrupts = <0 0 1>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc>;
+			status = "disabled";
+		};
+
+		uart1: serial@01c28400 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c28400 0x400>;
+			interrupts = <0 1 1>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc>;
+			status = "disabled";
+		};
+
+		uart2: serial@01c28800 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c28800 0x400>;
+			interrupts = <0 2 1>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc>;
+			status = "disabled";
+		};
+
+		uart3: serial@01c28c00 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c28c00 0x400>;
+			interrupts = <0 3 1>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc>;
+			status = "disabled";
+		};
+
+		uart4: serial@01c29000 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c29000 0x400>;
+			interrupts = <0 4 1>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc>;
+			status = "disabled";
+		};
+
+		uart5: serial@01c29400 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c29400 0x400>;
+			interrupts = <0 5 1>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc>;
+			status = "disabled";
+		};
+
+		gic: interrupt-controller@01c81000 {
+			compatible = "arm,cortex-a7-gic";
+			reg = <0x01c81000 0x1000>, <0x01c82000 0x100>;
+			interrupt-controller;
+			#interrupt-cells = <3>;
+		};
+	};
+};
-- 
1.8.3.2

