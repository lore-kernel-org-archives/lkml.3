Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001AbaJVU61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 16:58:27 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:33886 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352AbaJVU6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 16:58:22 -0400
X-IronPort-AV: E=Sophos;i="5.04,771,1406617200"; 
   d="scan'208";a="48759414"
From: Scott Branden <sbranden@broadcom.com>
To: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        <bcm-kernel-feedback-list@broadcom.com>,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>
CC: JD Zheng <jdzheng@broadcom.com>, Ray Jui <rjui@broadcom.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Scott Branden <sbranden@broadcom.com>
Subject: [PATCH v7 4/7] ARM: dts: Enable Broadcom Cygnus SoC
Date: Wed, 22 Oct 2014 13:57:51 -0700
Message-ID: <1414011474-11821-5-git-send-email-sbranden@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414011474-11821-1-git-send-email-sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
 <1414011474-11821-1-git-send-email-sbranden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DT files to enable cygnus consisting on reference designs
and cygnus core configuration.

Reviewed-by: Ray Jui <rjui@broadcom.com>
Reviewed-by: Arun Parameswaran <aparames@broadcom.com>
Tested-by: Jonathan Richardson <jonathar@broadcom.com>
Reviewed-by: JD (Jiandong) Zheng <jdzheng@broadcom.com>
Signed-off-by: Scott Branden <sbranden@broadcom.com>
---
 arch/arm/boot/dts/Makefile              |    4 ++
 arch/arm/boot/dts/bcm-cygnus-clock.dtsi |   73 +++++++++++++++++++++
 arch/arm/boot/dts/bcm-cygnus.dtsi       |  109 +++++++++++++++++++++++++++++++
 arch/arm/boot/dts/bcm911360_entphn.dts  |   22 +++++++
 arch/arm/boot/dts/bcm911360k.dts        |   22 +++++++
 arch/arm/boot/dts/bcm958300k.dts        |   22 +++++++
 6 files changed, 252 insertions(+)
 create mode 100644 arch/arm/boot/dts/bcm-cygnus-clock.dtsi
 create mode 100644 arch/arm/boot/dts/bcm-cygnus.dtsi
 create mode 100644 arch/arm/boot/dts/bcm911360_entphn.dts
 create mode 100644 arch/arm/boot/dts/bcm911360k.dts
 create mode 100644 arch/arm/boot/dts/bcm958300k.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 7c80af9..a6b734a 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -54,6 +54,10 @@ dtb-$(CONFIG_ARCH_AT91)	+= at91-sama5d4ek.dtb
 dtb-$(CONFIG_ARCH_ATLAS6) += atlas6-evb.dtb
 dtb-$(CONFIG_ARCH_AXXIA) += axm5516-amarillo.dtb
 dtb-$(CONFIG_ARCH_BCM2835) += bcm2835-rpi-b.dtb
+dtb-$(CONFIG_ARCH_BCM_CYGNUS) += \
+	bcm911360_entphn.dtb \
+	bcm911360k.dtb \
+	bcm958300k.dtb
 dtb-$(CONFIG_ARCH_BCM_5301X) += bcm4708-netgear-r6250.dtb
 dtb-$(CONFIG_ARCH_BCM_63XX) += bcm963138dvt.dtb
 dtb-$(CONFIG_ARCH_BCM_MOBILE) += bcm28155-ap.dtb \
diff --git a/arch/arm/boot/dts/bcm-cygnus-clock.dtsi b/arch/arm/boot/dts/bcm-cygnus-clock.dtsi
new file mode 100644
index 0000000..d06172b
--- /dev/null
+++ b/arch/arm/boot/dts/bcm-cygnus-clock.dtsi
@@ -0,0 +1,73 @@
+/*
+ * Copyright 2014 Broadcom Corporation.  All rights reserved.
+ *
+ * Unless you and Broadcom execute a separate written software license
+ * agreement governing use of this software, this software is licensed to you
+ * under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+clocks {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	ranges;
+
+	osc: oscillator {
+		compatible = "fixed-clock";
+		#clock-cells = <1>;
+		clock-frequency = <25000000>;
+	};
+
+	apb_clk: apb_clk {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <1000000000>;
+	};
+
+	periph_clk: periph_clk {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <500000000>;
+	};
+
+	sdio_clk: lcpll_ch2 {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <200000000>;
+	};
+
+	axi81_clk: axi81_clk {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <100000000>;
+	};
+
+	keypad_clk: keypad_clk {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <31806>;
+	};
+
+	adc_clk: adc_clk {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <1562500>;
+	};
+
+	pwm_clk: pwm_clk {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <1000000>;
+	};
+
+	lcd_clk: mipipll_ch1 {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <100000000>;
+	};
+};
diff --git a/arch/arm/boot/dts/bcm-cygnus.dtsi b/arch/arm/boot/dts/bcm-cygnus.dtsi
new file mode 100644
index 0000000..a377ab2
--- /dev/null
+++ b/arch/arm/boot/dts/bcm-cygnus.dtsi
@@ -0,0 +1,109 @@
+/*
+ * Copyright 2014 Broadcom Corporation.  All rights reserved.
+ *
+ * Unless you and Broadcom execute a separate written software license
+ * agreement governing use of this software, this software is licensed to you
+ * under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <dt-bindings/interrupt-controller/arm-gic.h>
+#include <dt-bindings/interrupt-controller/irq.h>
+
+#include "skeleton.dtsi"
+
+/ {
+	compatible = "brcm,cygnus";
+	model = "Broadcom Cygnus SoC";
+	interrupt-parent = <&gic>;
+
+	aliases {
+		serial0 = &uart3;
+		serial1 = &uart0;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200 earlyprintk debug";
+	};
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			next-level-cache = <&L2>;
+			reg = <0x0>;
+		};
+	};
+
+	/include/ "bcm-cygnus-clock.dtsi"
+
+	amba {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "arm,amba-bus", "simple-bus";
+		interrupt-parent = <&gic>;
+		ranges;
+
+		wdt@18009000 {
+			 compatible = "arm,sp805" , "arm,primecell";
+			 reg = <0x18009000 0x1000>;
+			 interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
+			 clocks = <&axi81_clk>;
+			 clock-names = "apb_pclk";
+		};
+	};
+
+	uart3: serial@18023000 {
+		compatible = "snps,dw-apb-uart";
+		reg = <0x18023000 0x100>;
+		reg-shift = <2>;
+		reg-io-width = <4>;
+		interrupts = <GIC_SPI 76 IRQ_TYPE_LEVEL_HIGH>;
+		clock-frequency = <100000000>;
+		clocks = <&axi81_clk>;
+		status = "okay";
+	};
+
+	uart0: serial@18020000 {
+		compatible = "snps,dw-apb-uart";
+		reg = <0x18020000 0x100>;
+		reg-shift = <2>;
+		reg-io-width = <4>;
+		interrupts = <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&axi81_clk>;
+		clock-frequency = <100000000>;
+		status = "okay";
+	};
+
+	gic: interrupt-controller@19021000 {
+		compatible = "arm,cortex-a9-gic";
+		#interrupt-cells = <3>;
+		#address-cells = <0>;
+		interrupt-controller;
+		reg = <0x19021000 0x1000>,
+		      <0x19020100 0x100>;
+	};
+
+	L2: l2-cache {
+		compatible = "arm,pl310-cache";
+		reg = <0x19022000 0x1000>;
+		cache-unified;
+		cache-level = <2>;
+	};
+
+	timer@19020200 {
+		compatible = "arm,cortex-a9-global-timer";
+		reg = <0x19020200 0x100>;
+		interrupts = <GIC_PPI 11 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&periph_clk>;
+	};
+
+};
diff --git a/arch/arm/boot/dts/bcm911360_entphn.dts b/arch/arm/boot/dts/bcm911360_entphn.dts
new file mode 100644
index 0000000..c5188d7
--- /dev/null
+++ b/arch/arm/boot/dts/bcm911360_entphn.dts
@@ -0,0 +1,22 @@
+/*
+ * Copyright 2014 Broadcom Corporation.  All rights reserved.
+ *
+ * Unless you and Broadcom execute a separate written software license
+ * agreement governing use of this software, this software is licensed to you
+ * under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/dts-v1/;
+
+#include "bcm-cygnus.dtsi"
+
+/ {
+	model = "Cygnus Enterprise Phone (BCM911360_ENTPHN)";
+	compatible = "brcm,bcm11360", "brcm,cygnus";
+};
diff --git a/arch/arm/boot/dts/bcm911360k.dts b/arch/arm/boot/dts/bcm911360k.dts
new file mode 100644
index 0000000..866d1e1
--- /dev/null
+++ b/arch/arm/boot/dts/bcm911360k.dts
@@ -0,0 +1,22 @@
+/*
+ * Copyright 2014 Broadcom Corporation.  All rights reserved.
+ *
+ * Unless you and Broadcom execute a separate written software license
+ * agreement governing use of this software, this software is licensed to you
+ * under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/dts-v1/;
+
+#include "bcm-cygnus.dtsi"
+
+/ {
+	model = "Cygnus SVK (BCM911360K)";
+	compatible = "brcm,bcm11360", "brcm,cygnus";
+};
diff --git a/arch/arm/boot/dts/bcm958300k.dts b/arch/arm/boot/dts/bcm958300k.dts
new file mode 100644
index 0000000..8739751
--- /dev/null
+++ b/arch/arm/boot/dts/bcm958300k.dts
@@ -0,0 +1,22 @@
+/*
+ * Copyright 2014 Broadcom Corporation.  All rights reserved.
+ *
+ * Unless you and Broadcom execute a separate written software license
+ * agreement governing use of this software, this software is licensed to you
+ * under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/dts-v1/;
+
+#include "bcm-cygnus.dtsi"
+
+/ {
+	model = "Cygnus SVK (BCM958300K)";
+	compatible = "brcm,bcm58300", "brcm,cygnus";
+};
-- 
1.7.9.5

