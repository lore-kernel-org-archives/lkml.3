Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbaBZKaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 05:30:19 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:48246 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbaBZK34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 05:29:56 -0500
From: Marc Carino <marc.ceeeee@gmail.com>
To: Christian Daudt <bcm@fixthebug.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Marc Carino <marc.ceeeee@gmail.com>,
        Matt Porter <mporter@linaro.org>
Subject: [PATCH v7 9/9] ARM: brcmstb: dts: add a reference DTS for Broadcom 7445
Date: Wed, 26 Feb 2014 02:29:12 -0800
Message-Id: <1393410552-21497-10-git-send-email-marc.ceeeee@gmail.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1393410552-21497-1-git-send-email-marc.ceeeee@gmail.com>
References: <1393410552-21497-1-git-send-email-marc.ceeeee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a sample DTS which will allow bootup of a board populated
with the BCM7445 chip.

Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Matt Porter <mporter@linaro.org>
---
 arch/arm/boot/dts/bcm7445-bcm97445svmb.dts |   14 ++++
 arch/arm/boot/dts/bcm7445.dtsi             |  107 ++++++++++++++++++++++++++++
 2 files changed, 121 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/bcm7445-bcm97445svmb.dts
 create mode 100644 arch/arm/boot/dts/bcm7445.dtsi

diff --git a/arch/arm/boot/dts/bcm7445-bcm97445svmb.dts b/arch/arm/boot/dts/bcm7445-bcm97445svmb.dts
new file mode 100644
index 0000000..9eec2ac
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
index 0000000..f9c9633
--- /dev/null
+++ b/arch/arm/boot/dts/bcm7445.dtsi
@@ -0,0 +1,107 @@
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
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "brcm,brahma-b15";
+			device_type = "cpu";
+			reg = <1>;
+		};
+
+		cpu@2 {
+			compatible = "brcm,brahma-b15";
+			device_type = "cpu";
+			reg = <2>;
+		};
+
+		cpu@3 {
+			compatible = "brcm,brahma-b15";
+			device_type = "cpu";
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
+		serial@406b00 {
+			compatible = "ns16550a";
+			reg = <0x406b00 0x20>;
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
1.7.1

