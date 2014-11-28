Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbaK1CVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 21:21:53 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:48732 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaK1CVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 21:21:49 -0500
From: Wang Long <long.wanglong@huawei.com>
To: <xuwei5@hisilicon.com>, <arnd@arndb.de>, <yanhaifeng@gmail.com>,
        <zhangfei.gao@linaro.org>, <haojian.zhuang@linaro.org>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <jason@lakedaemon.net>, <jh80.chung@samsung.com>, <khilman@linaro.org>,
        <lee.jones@linaro.org>, <linux@arm.linux.org.uk>,
        <long.wanglong@huawei.com>, <mark.rutland@arm.com>,
        <maxime.ripard@free-electrons.com>, <obh+dt@kernel.org>,
        <olof@lixom.net>, <pawel.moll@arm.com>, <swarren@nvidia.com>,
        <thomas.petazzoni@free-electrons.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <peifeiyue@huawei.com>,
        <huxinwei@huawei.com>
Subject: [PATCH 3/7] ARM: dts: Add hip01-ca9x2 dts file
Date: Fri, 28 Nov 2014 02:15:46 +0000
Message-ID: <1417140950-67103-4-git-send-email-long.wanglong@huawei.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1417140950-67103-1-git-send-email-long.wanglong@huawei.com>
References: <1417140950-67103-1-git-send-email-long.wanglong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.200]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dts file for Hisilicon hip01 ca9x2 board

Signed-off-by: Wang Long <long.wanglong@huawei.com>
---
 .../bindings/arm/hisilicon/hisilicon.txt           |  25 +++++
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/hip01-ca9x2.dts                  |  51 ++++++++++
 arch/arm/boot/dts/hip01.dtsi                       | 110 +++++++++++++++++++++
 4 files changed, 187 insertions(+)
 create mode 100644 arch/arm/boot/dts/hip01-ca9x2.dts
 create mode 100644 arch/arm/boot/dts/hip01.dtsi

diff --git a/Documentation/devicetree/bindings/arm/hisilicon/hisilicon.txt b/Documentation/devicetree/bindings/arm/hisilicon/hisilicon.txt
index f717c7b..35b1bd4 100644
--- a/Documentation/devicetree/bindings/arm/hisilicon/hisilicon.txt
+++ b/Documentation/devicetree/bindings/arm/hisilicon/hisilicon.txt
@@ -9,6 +9,10 @@ HiP04 D01 Board
 Required root node properties:
 	- compatible = "hisilicon,hip04-d01";
 
+HiP01 ca9x2 Board
+Required root node properties:
+	- compatible = "hisilicon,hip01-ca9x2";
+
 
 Hisilicon system controller
 
@@ -37,6 +41,27 @@ Example:
 	};
 
 -----------------------------------------------------------------------
+Hisilicon HiP01 system controller
+
+Required properties:
+- compatible : "hisilicon,hip01-sysctrl"
+- reg : Register address and size
+
+The HiP01 system controller is mostly compatible with hisilicon
+system controller,but it has some specific control registers for
+HIP01 SoC family, such as slave core boot, and also some same
+registers located at different offset.
+
+Example:
+
+	/* for hip01-ca9x2 */
+	sysctrl: system-controller@10000000 {
+		compatible = "hisilicon,hip01-sysctrl", "hisilicon,sysctrl";
+		reg = <0x10000000 0x1000>;
+		reboot-offset = <0x4>;
+	};
+
+-----------------------------------------------------------------------
 Hisilicon CPU controller
 
 Required properties:
diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 38c89ca..0e472e32 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -93,6 +93,7 @@ dtb-$(CONFIG_ARCH_HI3xxx) += hi3620-hi4511.dtb
 dtb-$(CONFIG_ARCH_HIX5HD2) += hisi-x5hd2-dkb.dtb
 dtb-$(CONFIG_ARCH_HIGHBANK) += highbank.dtb \
 	ecx-2000.dtb
+dtb-$(CONFIG_ARCH_HIP01) += hip01-ca9x2.dtb
 dtb-$(CONFIG_ARCH_HIP04) += hip04-d01.dtb
 dtb-$(CONFIG_ARCH_INTEGRATOR) += integratorap.dtb \
 	integratorcp.dtb
diff --git a/arch/arm/boot/dts/hip01-ca9x2.dts b/arch/arm/boot/dts/hip01-ca9x2.dts
new file mode 100644
index 0000000..619d024
--- /dev/null
+++ b/arch/arm/boot/dts/hip01-ca9x2.dts
@@ -0,0 +1,51 @@
+/*
+ * Hisilicon Ltd. HiP01 SoC
+ *
+ * Copyright (C) 2014 Hisilicon Ltd.
+ * Copyright (C) 2014 Huawei Ltd.
+ *
+ * Author: Wang Long <long.wanglong@huawei.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/dts-v1/;
+
+/* First 8KB reserved for secondary core boot */
+/memreserve/ 0x80000000 0x00002000;
+
+#include "hip01.dtsi"
+
+/ {
+	model = "Hisilicon HIP01 Development Board";
+	compatible = "hisilicon,hip01-ca9x2", "hisilicon,hip01";
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0>;
+		};
+
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <1>;
+		};
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x80000000 0x80000000>;
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
diff --git a/arch/arm/boot/dts/hip01.dtsi b/arch/arm/boot/dts/hip01.dtsi
new file mode 100644
index 0000000..33130f8
--- /dev/null
+++ b/arch/arm/boot/dts/hip01.dtsi
@@ -0,0 +1,110 @@
+/*
+ * Hisilicon Ltd. HiP01 SoC
+ *
+ * Copyright (c) 2014 Hisilicon Ltd.
+ * Copyright (c) 2014 Huawei Ltd.
+ *
+ * Author: Wang Long <long.wanglong@huawei.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "skeleton.dtsi"
+
+/ {
+	interrupt-parent = <&gic>;
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+	gic: interrupt-controller@1e001000 {
+		compatible = "arm,cortex-a9-gic";
+		#interrupt-cells = <3>;
+		#address-cells = <0>;
+		interrupt-controller;
+		reg = <0x1a001000 0x1000>, <0x1a000100 0x1000>;
+	};
+
+	hisi_refclk144mhz: refclk144mkhz {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <144000000>;
+		clock-output-names = "hisi:refclk144khz";
+	};
+
+	soc {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "simple-bus";
+		interrupt-parent = <&gic>;
+		ranges = <0 0x10000000 0x20000000>;
+
+		amba {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "arm,amba-bus";
+			ranges;
+
+			uart0: uart@10001000 {
+				compatible = "snps,dw-apb-uart";
+				reg = <0x10001000 0x1000>;
+				clocks = <&hisi_refclk144mhz>;
+				clock-names = "apb_pclk";
+				reg-shift = <2>;
+				interrupts = <0 32 4>;
+				status = "disabled";
+			};
+
+			uart1: uart@10002000 {
+				compatible = "snps,dw-apb-uart";
+				reg = <0x10002000 0x1000>;
+				clocks = <&hisi_refclk144mhz>;
+				clock-names = "apb_pclk";
+				reg-shift = <2>;
+				interrupts = <0 33 4>;
+				status = "disabled";
+			};
+
+			uart2: uart@10003000 {
+				compatible = "snps,dw-apb-uart";
+				reg = <0x10003000 0x1000>;
+				clocks = <&hisi_refclk144mhz>;
+				clock-names = "apb_pclk";
+				reg-shift = <2>;
+				interrupts = <0 34 4>;
+				status = "disabled";
+			};
+
+			uart3: uart@10006000 {
+				compatible = "snps,dw-apb-uart";
+				reg = <0x10006000 0x1000>;
+				clocks = <&hisi_refclk144mhz>;
+				clock-names = "apb_pclk";
+				reg-shift = <2>;
+				interrupts = <0 4 4>;
+				status = "disabled";
+			};
+		};
+
+		system-controller@10000000 {
+			compatible = "hisilicon,hip01-sysctrl", "hisilicon,sysctrl";
+			reg = <0x10000000 0x1000>;
+			reboot-offset = <0x4>;
+		};
+
+		global_timer@0a000200 {
+			compatible = "arm,cortex-a9-global-timer";
+			reg = <0x0a000200 0x100>;
+			interrupts = <1 11 0xf04>;
+			clocks = <&hisi_refclk144mhz>;
+		};
+
+		local_timer@0a000600 {
+			compatible = "arm,cortex-a9-twd-timer";
+			reg = <0x0a000600 0x100>;
+			interrupts = <1 13 0xf04>;
+			clocks = <&hisi_refclk144mhz>;
+		};
+	};
+};
-- 
1.8.3.4

