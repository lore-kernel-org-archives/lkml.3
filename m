Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbaGUVKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:10:42 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:39011 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbaGUVJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:09:42 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: Matt Porter <mporter@linaro.org>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Gregory Fong <gregory.0xf0@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Carino <marc.ceeeee@gmail.com>
Subject: [PATCH v8 09/11] ARM: brcmstb: dts: add a reference DTS for Broadcom 7445
Date: Mon, 21 Jul 2014 14:08:04 -0700
Message-Id: <1405976886-27807-10-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com>
References: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Carino <marc.ceeeee@gmail.com>

Add a sample DTS which will allow bootup of a board populated
with the BCM7445 chip.

Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Cc: Matt Porter <mporter@linaro.org>
---
 arch/arm/boot/dts/Makefile                 |   2 +
 arch/arm/boot/dts/bcm7445-bcm97445svmb.dts |  14 ++++
 arch/arm/boot/dts/bcm7445.dtsi             | 111 +++++++++++++++++++++++++++++
 3 files changed, 127 insertions(+)
 create mode 100644 arch/arm/boot/dts/bcm7445-bcm97445svmb.dts
 create mode 100644 arch/arm/boot/dts/bcm7445.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index adb5ed9e269e..38439ca9b361 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -59,6 +59,8 @@ dtb-$(CONFIG_ARCH_BERLIN) += \
 	berlin2-sony-nsz-gs7.dtb	\
 	berlin2cd-google-chromecast.dtb	\
 	berlin2q-marvell-dmp.dtb
+dtb-$(CONFIG_ARCH_BRCMSTB) += \
+	bcm7445-bcm97445svmb.dtb
 dtb-$(CONFIG_ARCH_DAVINCI) += da850-enbw-cmc.dtb \
 	da850-evm.dtb
 dtb-$(CONFIG_ARCH_EFM32) += efm32gg-dk3750.dtb
diff --git a/arch/arm/boot/dts/bcm7445-bcm97445svmb.dts b/arch/arm/boot/dts/bcm7445-bcm97445svmb.dts
new file mode 100644
index 000000000000..9eec2ac1112f
--- /dev/null
+++ b/arch/arm/boot/dts/bcm7445-bcm97445svmb.dts
@@ -0,0 +1,14 @@
+/dts-v1/;
+#include "bcm7445.dtsi"
+
+/ {
+	model = "Broadcom STB (bcm7445), SVMB reference board";
+	compatible = "brcm,bcm7445", "brcm,brcmstb";
+
+	memory {
+		device_type = "memory";
+		reg = <0x00 0x00000000 0x00 0x40000000>,
+		      <0x00 0x40000000 0x00 0x40000000>,
+		      <0x00 0x80000000 0x00 0x40000000>;
+	};
+};
diff --git a/arch/arm/boot/dts/bcm7445.dtsi b/arch/arm/boot/dts/bcm7445.dtsi
new file mode 100644
index 000000000000..0ca0f4e523d0
--- /dev/null
+++ b/arch/arm/boot/dts/bcm7445.dtsi
@@ -0,0 +1,111 @@
+#include <dt-bindings/interrupt-controller/arm-gic.h>
+
+#include "skeleton.dtsi"
+
+/ {
+	#address-cells = <2>;
+	#size-cells = <2>;
+	model = "Broadcom STB (bcm7445)";
+	compatible = "brcm,bcm7445", "brcm,brcmstb";
+	interrupt-parent = <&gic>;
+
+	chosen {
+		bootargs = "console=ttyS0,115200 earlyprintk";
+	};
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			compatible = "brcm,brahma-b15";
+			device_type = "cpu";
+			enable-method = "brcm,brahma-b15";
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "brcm,brahma-b15";
+			device_type = "cpu";
+			enable-method = "brcm,brahma-b15";
+			reg = <1>;
+		};
+
+		cpu@2 {
+			compatible = "brcm,brahma-b15";
+			device_type = "cpu";
+			enable-method = "brcm,brahma-b15";
+			reg = <2>;
+		};
+
+		cpu@3 {
+			compatible = "brcm,brahma-b15";
+			device_type = "cpu";
+			enable-method = "brcm,brahma-b15";
+			reg = <3>;
+		};
+	};
+
+	gic: interrupt-controller@ffd00000 {
+		compatible = "brcm,brahma-b15-gic", "arm,cortex-a15-gic";
+		reg = <0x00 0xffd01000 0x00 0x1000>,
+		      <0x00 0xffd02000 0x00 0x2000>,
+		      <0x00 0xffd04000 0x00 0x2000>,
+		      <0x00 0xffd06000 0x00 0x2000>;
+		interrupt-controller;
+		#interrupt-cells = <3>;
+	};
+
+	timer {
+		compatible = "arm,armv7-timer";
+		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_RAW(15) | IRQ_TYPE_LEVEL_LOW)>,
+			     <GIC_PPI 14 (GIC_CPU_MASK_RAW(15) | IRQ_TYPE_LEVEL_LOW)>,
+			     <GIC_PPI 11 (GIC_CPU_MASK_RAW(15) | IRQ_TYPE_LEVEL_LOW)>,
+			     <GIC_PPI 10 (GIC_CPU_MASK_RAW(15) | IRQ_TYPE_LEVEL_LOW)>;
+	};
+
+	rdb {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "simple-bus";
+		ranges = <0 0x00 0xf0000000 0x1000000>;
+
+		serial@40ab00 {
+			compatible = "ns16550a";
+			reg = <0x40ab00 0x20>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;
+			clock-frequency = <0x4d3f640>;
+		};
+
+		sun_top_ctrl: syscon@404000 {
+			compatible = "brcm,bcm7445-sun-top-ctrl",
+				     "syscon";
+			reg = <0x404000 0x51c>;
+		};
+
+		hif_cpubiuctrl: syscon@3e2400 {
+			compatible = "brcm,bcm7445-hif-cpubiuctrl",
+				     "syscon";
+			reg = <0x3e2400 0x5b4>;
+		};
+
+		hif_continuation: syscon@452000 {
+			compatible = "brcm,bcm7445-hif-continuation",
+				     "syscon";
+			reg = <0x452000 0x100>;
+		};
+	};
+
+	smpboot {
+		compatible = "brcm,brcmstb-smpboot";
+		syscon-cpu = <&hif_cpubiuctrl 0x88 0x178>;
+		syscon-cont = <&hif_continuation>;
+	};
+
+	reboot {
+		compatible = "brcm,brcmstb-reboot";
+		syscon = <&sun_top_ctrl 0x304 0x308>;
+	};
+};
-- 
1.9.1

