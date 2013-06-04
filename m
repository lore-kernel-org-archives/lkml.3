Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab3FDO1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:27:32 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42008 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985Ab3FDO12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:27:28 -0400
From: Guodong Xu <guodong.xu@linaro.org>
To: sameo@linux.intel.com, lgirdwood@gmail.com, broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, guodong.xu@linaro.org
Subject: [PATCH 3/3] ARM: dts: add dedicated dtsi for hi6421
Date: Tue,  4 Jun 2013 22:28:43 +0800
Message-Id: <1370356123-22357-4-git-send-email-guodong.xu@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1370356123-22357-1-git-send-email-guodong.xu@linaro.org>
References: <1370356123-22357-1-git-send-email-guodong.xu@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dedicated dtsi file for Hi6421 PMIC SoC.

Hi6421 is a PMIC SoC manufactured by HiSilicon Ltd., which can be
reused in various Hi3620 based boards.

Note: This file is supposed to be included in a board DTS that will
create the pmic node in order to allow the &pmic reference to work.

Exmaple:
...
        pmic: pmic@fcc00000 {
                reg = <0xfcc00000 0x0180>; /* 0x60 << 2 */
        };
...

/include/ "hi6421.dtsi"
...

Signed-off-by: Guodong Xu <guodong.xu@linaro.org>
---
 arch/arm/boot/dts/hi6421.dtsi |  489 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 489 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/hi6421.dtsi

diff --git a/arch/arm/boot/dts/hi6421.dtsi b/arch/arm/boot/dts/hi6421.dtsi
new file mode 100644
index 0000000..93647e2
--- /dev/null
+++ b/arch/arm/boot/dts/hi6421.dtsi
@@ -0,0 +1,489 @@
+/*
+ * HiSilicon HI6421 PMIC device tree source
+ *
+ * Copyright (c) <2011-2013> HiSilicon Technologies Co., Ltd.
+ *              http://www.hisilicon.com
+ * Copyright (c) <2011-2013> Linaro Ltd.
+ *              http://www.linaro.org
+ *
+ * Author: Guodong Xu <guodong.xu@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+&pmic {
+	compatible = "hisilicon,hi6421-pmic";
+
+	ldo0: ldo@20 {
+		compatible = "hisilicon,hi6421-ldo";
+		regulator-name = "LDO0";
+		regulator-min-microvolt = <1500000>;
+		regulator-max-microvolt = <3000000>;
+		hisilicon,hi6421-ctrl = <0x20 0x10 0x20>;
+		hisilicon,hi6421-vset = <0x20 0x07>;
+		hisilicon,hi6421-n-voltages = <8>;
+		hisilicon,hi6421-vset-table = <1500000>, <1800000>,
+					      <2400000>, <2500000>,
+					      <2600000>, <2700000>,
+					      <2850000>, <3000000>;
+		hisilicon,hi6421-off-on-delay-us = <10000>;
+		hisilicon,hi6421-enable-time-us = <250>;
+		hisilicon,hi6421-eco-microamp = <8000>;
+	};
+
+	ldo1: ldo@21 {
+		compatible = "hisilicon,hi6421-ldo";
+		regulator-name = "LDO1";
+		regulator-min-microvolt = <1700000>;
+		regulator-max-microvolt = <2000000>;
+		hisilicon,hi6421-ctrl = <0x21 0x10 0x20>;
+		hisilicon,hi6421-vset = <0x21 0x03>;
+		hisilicon,hi6421-n-voltages = <4>;
+		hisilicon,hi6421-vset-table = <1700000>, <1800000>,
+					      <1900000>, <2000000>;
+		hisilicon,hi6421-off-on-delay-us = <10000>;
+		hisilicon,hi6421-enable-time-us = <250>;
+		hisilicon,hi6421-eco-microamp = <5000>;
+	};
+
+	ldo2: ldo@22 {
+		compatible = "hisilicon,hi6421-ldo";
+		regulator-name = "LDO2";
+		regulator-min-microvolt = <1050000>;
+		regulator-max-microvolt = <1400000>;
+		hisilicon,hi6421-ctrl = <0x22 0x10 0x20>;
+		hisilicon,hi6421-vset = <0x22 0x07>;
+		hisilicon,hi6421-n-voltages = <8>;
+		hisilicon,hi6421-vset-table = <1050000>, <1100000>,
+					      <1150000>, <1200000>,
+					      <1250000>, <1300000>,
+					      <1350000>, <1400000>;
+		hisilicon,hi6421-off-on-delay-us = <20000>;
+		hisilicon,hi6421-enable-time-us = <250>;
+		hisilicon,hi6421-eco-microamp = <8000>;
+	};
+
+	ldo3: ldo@23 {
+		compatible = "hisilicon,hi6421-ldo";
+		regulator-name = "LDO3";
+		regulator-min-microvolt = <1050000>;
+		regulator-max-microvolt = <1400000>;
+		hisilicon,hi6421-ctrl = <0x23 0x10 0x20>;
+		hisilicon,hi6421-vset = <0x23 0x07>;
+		hisilicon,hi6421-n-voltages = <8>;
+		hisilicon,hi6421-vset-table = <1050000>, <1100000>,
+					      <1150000>, <1200000>,
+					      <1250000>, <1300000>,
+					      <1350000>, <1400000>;
+		hisilicon,hi6421-off-on-delay-us = <20000>;
+		hisilicon,hi6421-enable-time-us = <250>;
+		hisilicon,hi6421-eco-microamp = <8000>;
+	};
+
+	ldo4: ldo@24 {
+		compatible = "hisilicon,hi6421-ldo";
+		regulator-name = "LDO4";
+		regulator-min-microvolt = <1500000>;
+		regulator-max-microvolt = <3000000>;
+		hisilicon,hi6421-ctrl = <0x24 0x10 0x20>;
+		hisilicon,hi6421-vset = <0x24 0x07>;
+		hisilicon,hi6421-n-voltages = <8>;
+		hisilicon,hi6421-vset-table = <1500000>, <1800000>,
+					      <2400000>, <2500000>,
+					      <2600000>, <2700000>,
+					      <2850000>, <3000000>;
+		hisilicon,hi6421-off-on-delay-us = <20000>;
+		hisilicon,hi6421-enable-time-us = <250>;
+		hisilicon,hi6421-eco-microamp = <8000>;
+	};
+
+	ldo5: ldo@25 {
+		compatible = "hisilicon,hi6421-ldo";
+		regulator-name = "LDO5";
+		regulator-min-microvolt = <1500000>;
+		regulator-max-microvolt = <3000000>;
+		hisilicon,hi6421-ctrl = <0x25 0x10 0x20>;
+		hisilicon,hi6421-vset = <0x25 0x07>;
+		hisilicon,hi6421-n-voltages = <8>;
+		hisilicon,hi6421-vset-table = <1500000>, <1800000>,
+					      <2400000>, <2500000>,
+					      <2600000>, <2700000>,
+					      <2850000>, <3000000>;
+		hisilicon,hi6421-off-on-delay-us = <20000>;
+		hisilicon,hi6421-enable-time-us = <250>;
+		hisilicon,hi6421-eco-microamp = <8000>;
+	};
+
+	ldo6: ldo@26 {
+		compatible = "hisilicon,hi6421-ldo";
+		regulator-name = "LDO6";
+		regulator-min-microvolt = <1500000>;
+		regulator-max-microvolt = <3000000>;
+		hisilicon,hi6421-ctrl = <0x26 0x10 0x20>;
+		hisilicon,hi6421-vset = <0x26 0x07>;
+		hisilicon,hi6421-n-voltages = <8>;
+		hisilicon,hi6421-vset-table = <1500000>, <1800000>,
+					      <2400000>, <2500000>,
+					      <2600000>, <2700000>,
+					      <2850000>, <3000000>;
+		hisilicon,hi6421-off-on-delay-us = <20000>;
+		hisilicon,hi6421-enable-time-us = <250>;
+		hisilicon,hi6421-eco-microamp = <8000>;
+	};
+
+	ldo7: ldo@27 {
+		compatible = "hisilicon,hi6421-ldo";
+		regulator-name = "LDO7";
+		regulator-min-microvolt = <1500000>;
+		regulator-max-microvolt = <3000000>;
+		hisilicon,hi6421-ctrl = <0x27 0x10 0x20>;
+		hisilicon,hi6421-vset = <0x27 0x07>;
+		hisilicon,hi6421-n-voltages = <8>;
+		hisilicon,hi6421-vset-table = <1500000>, <1800000>,
+					      <2400000>, <2500000>,
+					      <2600000>, <2700000>,
+					      <2850000>, <3000000>;
+		hisilicon,hi6421-off-on-delay-us = <20000>;
+		hisilicon,hi6421-enable-time-us = <250>;
+		hisilicon,hi6421-eco-microamp = <5000>;
+	};
+
+	ldo8: ldo@28 {
+		compatible = "hisilicon,hi6421-ldo";
+		regulator-name = "LDO8";
+		regulator-min-microvolt = <1500000>;
+		regulator-max-microvolt = <3300000>;
+		hisilicon,hi6421-ctrl = <0x28 0x10 0x20>;
+		hisilicon,hi6421-vset = <0x28 0x07>;
+		hisilicon,hi6421-n-voltages = <8>;
+		hisilicon,hi6421-vset-table = <1500000>, <1800000>,
+					      <2400000>, <2600000>,
+					      <2700000>, <2850000>,
+					      <3000000>, <3300000>;
+		hisilicon,hi6421-off-on-delay-us = <20000>;
+		hisilicon,hi6421-enable-time-us = <250>;
+		hisilicon,hi6421-eco-microamp = <8000>;
+	};
+
+	ldo9: ldo@29 {
+		compatible = "hisilicon,hi6421-ldo";
+		regulator-name = "LDO9";
+		regulator-min-microvolt = <1500000>;
+		regulator-max-microvolt = <3000000>;
+		hisilicon,hi6421-ctrl = <0x29 0x10 0x20>;
+		hisilicon,hi6421-vset = <0x29 0x07>;
+		hisilicon,hi6421-n-voltages = <8>;
+		hisilicon,hi6421-vset-table = <1500000>, <1800000>,
+					      <2400000>, <2500000>,
+					      <2600000>, <2700000>,
+					      <2850000>, <3000000>;
+		hisilicon,hi6421-off-on-delay-us = <40000>;
+		hisilicon,hi6421-enable-time-us = <250>;
+		hisilicon,hi6421-eco-microamp = <8000>;
+	};
+
+	ldo10: ldo@2a {
+		compatible = "hisilicon,hi6421-ldo";
+		regulator-name = "LDO10";
+		regulator-min-microvolt = <1500000>;
+		regulator-max-microvolt = <3000000>;
+		hisilicon,hi6421-ctrl = <0x2a 0x10 0x20>;
+		hisilicon,hi6421-vset = <0x2a 0x07>;
+		hisilicon,hi6421-n-voltages = <8>;
+		hisilicon,hi6421-vset-table = <1500000>, <1800000>,
+					      <2400000>, <2500000>,
+					      <2600000>, <2700000>,
+					      <2850000>, <3000000>;
+		hisilicon,hi6421-off-on-delay-us = <40000>;
+		hisilicon,hi6421-enable-time-us = <250>;
+		hisilicon,hi6421-eco-microamp = <8000>;
+	};
+
+	ldo11: ldo@2b {
+		compatible = "hisilicon,hi6421-ldo";
+		regulator-name = "LDO11";
+		regulator-min-microvolt = <1500000>;
+		regulator-max-microvolt = <3000000>;
+		hisilicon,hi6421-ctrl = <0x2b 0x10 0x20>;
+		hisilicon,hi6421-vset = <0x2b 0x07>;
+		hisilicon,hi6421-n-voltages = <8>;
+		hisilicon,hi6421-vset-table = <1500000>, <1800000>,
+					      <2400000>, <2500000>,
+					      <2600000>, <2700000>,
+					      <2850000>, <3000000>;
+		hisilicon,hi6421-off-on-delay-us = <40000>;
+		hisilicon,hi6421-enable-time-us = <250>;
+		hisilicon,hi6421-eco-microamp = <8000>;
+	};
+
+	ldo12: ldo@2c {
+		compatible = "hisilicon,hi6421-ldo";
+		regulator-name = "LDO12";
+		regulator-min-microvolt = <1500000>;
+		regulator-max-microvolt = <3000000>;
+		hisilicon,hi6421-ctrl = <0x2c 0x10 0x20>;
+		hisilicon,hi6421-vset = <0x2c 0x07>;
+		hisilicon,hi6421-n-voltages = <8>;
+		hisilicon,hi6421-vset-table = <1500000>, <1800000>,
+					      <2400000>, <2500000>,
+					      <2600000>, <2700000>,
+					      <2850000>, <3000000>;
+		hisilicon,hi6421-off-on-delay-us = <40000>;
+		hisilicon,hi6421-enable-time-us = <250>;
+		hisilicon,hi6421-eco-microamp = <8000>;
+	};
+
+	ldo13: ldo@2d {
+		compatible = "hisilicon,hi6421-ldo";
+		regulator-name = "LDO13";
+		regulator-min-microvolt = <1500000>;
+		regulator-max-microvolt = <3000000>;
+		hisilicon,hi6421-ctrl = <0x2d 0x10 0x20>;
+		hisilicon,hi6421-vset = <0x2d 0x07>;
+		hisilicon,hi6421-n-voltages = <8>;
+		hisilicon,hi6421-vset-table = <1500000>, <1800000>,
+					      <2400000>, <2500000>,
+					      <2600000>, <2700000>,
+					      <2850000>, <3000000>;
+		hisilicon,hi6421-off-on-delay-us = <40000>;
+		hisilicon,hi6421-enable-time-us = <250>;
+		hisilicon,hi6421-eco-microamp = <8000>;
+	};
+
+	ldo14: ldo@2e {
+		compatible = "hisilicon,hi6421-ldo";
+		regulator-name = "LDO14";
+		regulator-min-microvolt = <1500000>;
+		regulator-max-microvolt = <3000000>;
+		hisilicon,hi6421-ctrl = <0x2e 0x10 0x20>;
+		hisilicon,hi6421-vset = <0x2e 0x07>;
+		hisilicon,hi6421-n-voltages = <8>;
+		hisilicon,hi6421-vset-table = <1500000>, <1800000>,
+					      <2400000>, <2500000>,
+					      <2600000>, <2700000>,
+					      <2850000>, <3000000>;
+		hisilicon,hi6421-off-on-delay-us = <40000>;
+		hisilicon,hi6421-enable-time-us = <250>;
+		hisilicon,hi6421-eco-microamp = <8000>;
+	};
+
+	ldo15: ldo@2f {
+		compatible = "hisilicon,hi6421-ldo";
+		regulator-name = "LDO15";
+		regulator-min-microvolt = <1500000>;
+		regulator-max-microvolt = <3300000>;
+		hisilicon,hi6421-ctrl = <0x2f 0x10 0x20>;
+		hisilicon,hi6421-vset = <0x2f 0x07>;
+		hisilicon,hi6421-n-voltages = <8>;
+		hisilicon,hi6421-vset-table = <1500000>, <1800000>,
+					      <2400000>, <2600000>,
+					      <2700000>, <2850000>,
+					      <3000000>, <3300000>;
+		hisilicon,hi6421-off-on-delay-us = <40000>;
+		hisilicon,hi6421-enable-time-us = <250>;
+		hisilicon,hi6421-eco-microamp = <8000>;
+	};
+
+	ldo16: ldo@30 {
+		compatible = "hisilicon,hi6421-ldo";
+		regulator-name = "LDO16";
+		regulator-min-microvolt = <1500000>;
+		regulator-max-microvolt = <3000000>;
+		hisilicon,hi6421-ctrl = <0x30 0x10 0x20>;
+		hisilicon,hi6421-vset = <0x30 0x07>;
+		hisilicon,hi6421-n-voltages = <8>;
+		hisilicon,hi6421-vset-table = <1500000>, <1800000>,
+					      <2400000>, <2500000>,
+					      <2600000>, <2700000>,
+					      <2850000>, <3000000>;
+		hisilicon,hi6421-off-on-delay-us = <40000>;
+		hisilicon,hi6421-enable-time-us = <250>;
+		hisilicon,hi6421-eco-microamp = <8000>;
+	};
+
+	ldo17: ldo@31 {
+		compatible = "hisilicon,hi6421-ldo";
+		regulator-name = "LDO17";
+		regulator-min-microvolt = <1500000>;
+		regulator-max-microvolt = <3000000>;
+		hisilicon,hi6421-ctrl = <0x31 0x10 0x20>;
+		hisilicon,hi6421-vset = <0x31 0x07>;
+		hisilicon,hi6421-n-voltages = <8>;
+		hisilicon,hi6421-vset-table = <1500000>, <1800000>,
+					      <2400000>, <2500000>,
+					      <2600000>, <2700000>,
+					      <2850000>, <3000000>;
+		hisilicon,hi6421-off-on-delay-us = <40000>;
+		hisilicon,hi6421-enable-time-us = <250>;
+		hisilicon,hi6421-eco-microamp = <8000>;
+	};
+
+	ldo18: ldo@32 {
+		compatible = "hisilicon,hi6421-ldo";
+		regulator-name = "LDO18";
+		regulator-min-microvolt = <1500000>;
+		regulator-max-microvolt = <3000000>;
+		hisilicon,hi6421-ctrl = <0x32 0x10 0x20>;
+		hisilicon,hi6421-vset = <0x32 0x07>;
+		hisilicon,hi6421-n-voltages = <8>;
+		hisilicon,hi6421-vset-table = <1500000>, <1800000>,
+					      <2400000>, <2500000>,
+					      <2600000>, <2700000>,
+					      <2850000>, <3000000>;
+		hisilicon,hi6421-off-on-delay-us = <40000>;
+		hisilicon,hi6421-enable-time-us = <250>;
+		hisilicon,hi6421-eco-microamp = <8000>;
+	};
+
+	ldo19: ldo@33 {
+		compatible = "hisilicon,hi6421-ldo";
+		regulator-name = "LDO19";
+		regulator-min-microvolt = <1500000>;
+		regulator-max-microvolt = <3000000>;
+		hisilicon,hi6421-ctrl = <0x2a 0x10 0x20>;
+		hisilicon,hi6421-vset = <0x2a 0x07>;
+		hisilicon,hi6421-n-voltages = <8>;
+		hisilicon,hi6421-vset-table = <1500000>, <1800000>,
+					      <2400000>, <2500000>,
+					      <2600000>, <2700000>,
+					      <2850000>, <3000000>;
+		hisilicon,hi6421-off-on-delay-us = <40000>;
+		hisilicon,hi6421-enable-time-us = <250>;
+		hisilicon,hi6421-eco-microamp = <8000>;
+	};
+
+	ldo20: ldo@34 {
+		compatible = "hisilicon,hi6421-ldo";
+		regulator-name = "LDO20";
+		regulator-min-microvolt = <1500000>;
+		regulator-max-microvolt = <3000000>;
+		hisilicon,hi6421-ctrl = <0x34 0x10 0x20>;
+		hisilicon,hi6421-vset = <0x34 0x07>;
+		hisilicon,hi6421-n-voltages = <8>;
+		hisilicon,hi6421-vset-table = <1500000>, <1800000>,
+					      <2400000>, <2500000>,
+					      <2600000>, <2700000>,
+					      <2850000>, <3000000>;
+		hisilicon,hi6421-off-on-delay-us = <40000>;
+		hisilicon,hi6421-enable-time-us = <250>;
+		hisilicon,hi6421-eco-microamp = <8000>;
+	};
+
+	ldoaudio: ldo@36 {
+		compatible = "hisilicon,hi6421-ldo";
+		regulator-name = "LDOAUDIO";
+		regulator-min-microvolt = <2800000>;
+		regulator-max-microvolt = <3300000>;
+		hisilicon,hi6421-ctrl = <0x36 0x01 0x02>;
+		hisilicon,hi6421-vset = <0x36 0x70>;
+		hisilicon,hi6421-n-voltages = <8>;
+		hisilicon,hi6421-vset-table = <2800000>, <2850000>,
+					      <2900000>, <2950000>,
+					      <3000000>, <3100000>,
+					      <3200000>, <3300000>;
+		hisilicon,hi6421-off-on-delay-us = <40000>;
+		hisilicon,hi6421-enable-time-us = <250>;
+		hisilicon,hi6421-eco-microamp = <5000>;
+	};
+
+	buck0: buck@0c {
+		compatible = "hisilicon,hi6421-buck012";
+		regulator-name = "BUCK0";
+		regulator-min-microvolt = <700000>;
+		regulator-max-microvolt = <1600000>;
+		hisilicon,hi6421-ctrl = <0x0c 0x01 0x10>;
+		hisilicon,hi6421-vset = <0x0d 0x7f>;
+		hisilicon,hi6421-n-voltages = <128>;
+		hisilicon,hi6421-uv-step = <7086>;
+		hisilicon,hi6421-off-on-delay-us = <20000>;
+		hisilicon,hi6421-enable-time-us = <300>;
+	};
+
+	buck1: buck@0e {
+		compatible = "hisilicon,hi6421-buck012";
+		regulator-name = "BUCK1";
+		regulator-min-microvolt = <700000>;
+		regulator-max-microvolt = <1600000>;
+		regulator-boot-on;
+		regulator-always-on;
+		hisilicon,hi6421-ctrl = <0x0e 0x01 0x10>;
+		hisilicon,hi6421-vset = <0x0f 0x7f>;
+		hisilicon,hi6421-n-voltages = <128>;
+		hisilicon,hi6421-uv-step = <7086>;
+		hisilicon,hi6421-off-on-delay-us = <20000>;
+		hisilicon,hi6421-enable-time-us = <300>;
+	};
+
+	buck2: buck@10 {
+		compatible = "hisilicon,hi6421-buck012";
+		regulator-name = "BUCK2";
+		regulator-min-microvolt = <700000>;
+		regulator-max-microvolt = <1600000>;
+		hisilicon,hi6421-ctrl = <0x10 0x01 0x10>;
+		hisilicon,hi6421-vset = <0x11 0x7f>;
+		hisilicon,hi6421-n-voltages = <128>;
+		hisilicon,hi6421-uv-step = <7086>;
+		hisilicon,hi6421-off-on-delay-us = <100>;
+		hisilicon,hi6421-enable-time-us = <250>;
+	};
+
+	buck3: buck@12 {
+		compatible = "hisilicon,hi6421-buck345";
+		regulator-name = "BUCK3";
+		regulator-min-microvolt = <950000>;
+		regulator-max-microvolt = <1200000>;
+		hisilicon,hi6421-ctrl = <0x12 0x01 0x10>;
+		hisilicon,hi6421-vset = <0x13 0x07>;
+		hisilicon,hi6421-n-voltages = <8>;
+		hisilicon,hi6421-vset-table = <950000>, <1050000>,
+					      <1100000>, <1170000>,
+					      <1134000>, <1150000>,
+					      <1167000>, <1200000>;
+		hisilicon,hi6421-off-on-delay-us = <20000>;
+		hisilicon,hi6421-enable-time-us = <250>;
+	};
+
+	buck4: buck@14 {
+		compatible = "hisilicon,hi6421-buck345";
+		regulator-name = "BUCK4";
+		regulator-min-microvolt = <1150000>;
+		regulator-max-microvolt = <2000000>;
+		hisilicon,hi6421-ctrl = <0x14 0x01 0x10>;
+		hisilicon,hi6421-vset = <0x15 0x07>;
+		hisilicon,hi6421-n-voltages = <8>;
+		hisilicon,hi6421-vset-table = <1150000>, <1200000>,
+					      <1250000>, <1350000>,
+					      <1700000>, <1800000>,
+					      <1900000>, <2000000>;
+		hisilicon,hi6421-off-on-delay-us = <20000>;
+		hisilicon,hi6421-enable-time-us = <250>;
+	};
+
+	buck5: buck@16 {
+		compatible = "hisilicon,hi6421-buck345";
+		regulator-name = "BUCK5";
+		regulator-min-microvolt = <1150000>;
+		regulator-max-microvolt = <1900000>;
+		hisilicon,hi6421-ctrl = <0x16 0x01 0x10>;
+		hisilicon,hi6421-vset = <0x17 0x07>;
+		hisilicon,hi6421-n-voltages = <8>;
+		hisilicon,hi6421-vset-table = <1150000>, <1200000>,
+					      <1250000>, <1350000>,
+					      <1600000>, <1700000>,
+					      <1800000>, <1900000>;
+		hisilicon,hi6421-off-on-delay-us = <20000>;
+		hisilicon,hi6421-enable-time-us = <250>;
+	};
+}; /* end of pmic */
-- 
1.7.4.1

