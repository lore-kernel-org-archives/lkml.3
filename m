Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab3FJJ4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:56:24 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:60403 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751528Ab3FJJ4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:56:20 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux@arm.linux.org.uk,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Olof Johansson <olof@lixom.net>, Rob Herring <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Prisk <linux@prisktech.co.nz>
Subject: =?UTF-8?q?=5BPATCH=20v2=2007/11=5D=20ARM=3Astixxxx=3A=20Add=20STiH416=20SOC=20support?=
Date: Mon, 10 Jun 2013 10:27:05 +0100
Message-Id: <1370856425-7135-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1370855828-5318-1-git-send-email-srinivas.kandagatla@st.com>
References: <1370855828-5318-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The STiH416 is advanced HD AVC processor with 3D graphics acceleration
and 1.2-GHz ARM Cortex-A9 SMP CPU.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
CC: Stephen Gallimore <stephen.gallimore@st.com>
CC: Stuart Menefy <stuart.menefy@st.com>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/arm/stixxxx/stih416-overview.txt |   12 +
 arch/arm/boot/dts/stih416-clock.dtsi           |   41 +++
 arch/arm/boot/dts/stih416-pinctrl.dtsi         |  377 ++++++++++++++++++++++++
 arch/arm/boot/dts/stih416.dtsi                 |  111 +++++++
 arch/arm/mach-stixxxx/board-dt.c               |    3 +-
 5 files changed, 543 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/arm/stixxxx/stih416-overview.txt
 create mode 100644 arch/arm/boot/dts/stih416-clock.dtsi
 create mode 100644 arch/arm/boot/dts/stih416-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/stih416.dtsi

diff --git a/Documentation/arm/stixxxx/stih416-overview.txt b/Documentation/arm/stixxxx/stih416-overview.txt
new file mode 100644
index 0000000..e060867
--- /dev/null
+++ b/Documentation/arm/stixxxx/stih416-overview.txt
@@ -0,0 +1,12 @@
+			STiH416 Overview
+			================
+
+Introduction
+------------
+
+    The STiH416 is the next generation of HD, AVC set-top box processors
+    for satellite, cable, terrestrial and IP-STB markets.
+
+    Features
+    - ARM Cortex-A9 1.2 GHz dual core CPU
+    - SATA2×2,USB 2.0×3, PCIe, Gbit Ethernet MAC×2
diff --git a/arch/arm/boot/dts/stih416-clock.dtsi b/arch/arm/boot/dts/stih416-clock.dtsi
new file mode 100644
index 0000000..7026bf1
--- /dev/null
+++ b/arch/arm/boot/dts/stih416-clock.dtsi
@@ -0,0 +1,41 @@
+/*
+ * Copyright (C) 2013 STMicroelectronics R&D Limited
+ * <stlinux-devel@stlinux.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+/ {
+	clocks {
+		/*
+		 * Fixed 30MHz oscillator inputs to SoC
+		 */
+		CLK_SYSIN: CLK_SYSIN {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <30000000>;
+			clock-output-names = "CLK_SYSIN";
+		};
+
+		/*
+		 * ARM Peripheral clock for timers
+		 */
+		arm_periph_clk: arm_periph_clk {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <600000000>;
+		};
+
+		/*
+		 * Bootloader initialized system infrastructure clock for
+		 * serial devices.
+		 */
+		CLK_S_ICN_REG_0: clockgenA0@4 {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <100000000>;
+			clock-output-names = "CLK_S_ICN_REG_0";
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/stih416-pinctrl.dtsi b/arch/arm/boot/dts/stih416-pinctrl.dtsi
new file mode 100644
index 0000000..15843a9
--- /dev/null
+++ b/arch/arm/boot/dts/stih416-pinctrl.dtsi
@@ -0,0 +1,377 @@
+
+/*
+ * Copyright (C) 2013 STMicroelectronics Limited.
+ * Author: Srinivas Kandagatla <srinivas.kandagatla@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * publishhed by the Free Software Foundation.
+ */
+#include "stixxxx-pincfg.h"
+/ {
+
+	aliases {
+		gpio0	= &PIO0;
+		gpio1	= &PIO1;
+		gpio2	= &PIO2;
+		gpio3	= &PIO3;
+		gpio4	= &PIO4;
+		gpio5	= &PIO40;
+		gpio6	= &PIO5;
+		gpio7	= &PIO6;
+		gpio8	= &PIO7;
+		gpio9	= &PIO8;
+		gpio10	= &PIO9;
+		gpio11	= &PIO10;
+		gpio12	= &PIO11;
+		gpio13	= &PIO12;
+		gpio14	= &PIO30;
+		gpio15	= &PIO31;
+		gpio16	= &PIO13;
+		gpio17	= &PIO14;
+		gpio18	= &PIO15;
+		gpio19	= &PIO16;
+		gpio20	= &PIO17;
+		gpio21	= &PIO18;
+		gpio22	= &PIO100;
+		gpio23	= &PIO101;
+		gpio24	= &PIO102;
+		gpio25	= &PIO103;
+		gpio26	= &PIO104;
+		gpio27	= &PIO105;
+		gpio28	= &PIO106;
+		gpio29	= &PIO107;
+	};
+
+	soc {
+		pin-controller-sbc {
+			#address-cells	= <1>;
+			#size-cells	= <1>;
+			compatible	= "st,stih416-pinctrl", "simple-bus";
+			st,retime-in-delay	= <0 300 500 750 1000 1250 1500 1750 2000 2250 2500 2750 3000 3250>;
+			st,retime-out-delay	= <0 300 500 750 1000 1250 1500 1750 2000 2250 2500 2750 3000 3250>;
+			st,syscfg		= <&syscfg_sbc>;
+			st,syscfg-offsets	= <0 40 50 60 100>;
+			ranges;
+			PIO0: pinctrl@fe610000 {
+				#gpio-cells = <1>;
+				compatible = "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfe610000 0x100>;
+				st,bank-name  = "PIO0";
+				st,retime-pin-mask = <0xff>;
+			};
+			PIO1: pinctrl@fe611000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfe611000 0x100>;
+				st,bank-name  = "PIO1";
+				st,retime-pin-mask = <0xff>;
+			};
+			PIO2: pinctrl@fe612000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfe612000 0x100>;
+				st,bank-name  = "PIO2";
+				st,retime-pin-mask = <0xff>;
+			};
+			PIO3: pinctrl@fe613000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfe613000 0x100>;
+				st,bank-name  = "PIO3";
+				st,retime-pin-mask = <0xff>;
+			};
+
+			PIO4: pinctrl@fe614000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfe614000 0x100>;
+				st,bank-name  = "PIO4";
+				st,retime-pin-mask = <0xff>;
+			};
+
+			PIO40: pinctrl@fe615000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfe615000 0x100>;
+				st,bank-name  = "PIO40";
+				st,retime-pin-mask = <0x7f>;
+			};
+
+			sbc_serial1 {
+				pinctrl_sbc_serial1: sbc_serial1 {
+					st,function = <ALT3>;
+					st,pins {
+						tx	= <&PIO2 6 OUT>;
+						rx	= <&PIO2 7 IN>;
+					};
+				};
+			};
+		};
+
+		pin-controller-front {
+			#address-cells	= <1>;
+			#size-cells	= <1>;
+			compatible	= "st,stih416-pinctrl", "simple-bus";
+			st,retime-in-delay	= <0 300 500 750 1000 1250 1500 1750 2000 2250 2500 2750 3000 3250>;
+			st,retime-out-delay	= <0 300 500 750 1000 1250 1500 1750 2000 2250 2500 2750 3000 3250>;
+			st,syscfg		= <&syscfg_front>;
+			st,syscfg-offsets	= <0 40 50 60 100>;
+			ranges;
+
+			PIO5: pinctrl@fee00000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfee00000 0x100>;
+				st,bank-name  = "PIO5";
+				st,retime-pin-mask = <0xff>;
+			};
+			PIO6: pinctrl@fee01000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfee01000 0x100>;
+				st,bank-name  = "PIO6";
+				st,retime-pin-mask = <0xff>;
+			};
+			PIO7: pinctrl@fee02000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfee02000 0x100>;
+				st,bank-name  = "PIO7";
+				st,retime-pin-mask = <0xff>;
+			};
+			PIO8: pinctrl@fee03000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfee03000 0x100>;
+				st,bank-name  = "PIO8";
+				st,retime-pin-mask = <0xff>;
+			};
+
+			PIO9: pinctrl@fee04000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfee04000 0x100>;
+				st,bank-name  = "PIO9";
+				st,retime-pin-mask = <0xff>;
+			};
+			PIO10: pinctrl@fee05000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfee05000 0x100>;
+				st,bank-name  = "PIO10";
+				st,retime-pin-mask = <0xff>;
+			};
+			PIO11: pinctrl@fee06000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfee06000 0x100>;
+				st,bank-name  = "PIO11";
+				st,retime-pin-mask = <0xff>;
+			};
+			PIO12: pinctrl@fee07000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfee07000 0x100>;
+				st,bank-name  = "PIO12";
+				st,retime-pin-mask = <0xff>;
+			};
+
+			PIO30: pinctrl@fee08000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfee08000 0x100>;
+				st,bank-name  = "PIO30";
+				st,retime-pin-mask = <0xff>;
+			};
+
+			PIO31: pinctrl@fee09000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfee09000 0x100>;
+				st,bank-name  = "PIO31";
+				st,retime-pin-mask = <0xff>;
+			};
+		};
+
+		pin-controller-rear {
+			#address-cells	= <1>;
+			#size-cells	= <1>;
+			compatible	= "st,stih416-pinctrl", "simple-bus";
+			st,retime-in-delay	= <0 300 500 750 1000 1250 1500 1750 2000 2250 2500 2750 3000 3250>;
+			st,retime-out-delay	= <0 300 500 750 1000 1250 1500 1750 2000 2250 2500 2750 3000 3250>;
+			st,syscfg		= <&syscfg_rear>;
+			st,syscfg-offsets	= <0 40 50 60 100>;
+			ranges;
+
+			PIO13: pinctrl@fe820000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfe820000 0x100>;
+				st,bank-name  = "PIO13";
+				st,retime-pin-mask = <0xff>;
+			};
+			PIO14: pinctrl@fe821000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfe821000 0x100>;
+				st,bank-name  = "PIO14";
+				st,retime-pin-mask = <0xff>;
+			};
+			PIO15: pinctrl@fe822000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfe822000 0x100>;
+				st,bank-name  = "PIO15";
+				st,retime-pin-mask = <0xff>;
+			};
+			PIO16: pinctrl@fe823000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfe823000 0x100>;
+				st,bank-name  = "PIO16";
+				st,retime-pin-mask = <0xff>;
+			};
+
+			PIO17: pinctrl@fe824000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfe824000 0x100>;
+				st,bank-name  = "PIO17";
+				st,retime-pin-mask = <0xff>;
+			};
+
+			PIO18: pinctrl@fe825000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfe825000 0x100>;
+				st,bank-name  = "PIO18";
+				st,retime-pin-mask = <0xf>;
+			};
+
+			serial2 {
+				pinctrl_serial2: serial2-0 {
+					st,function = <ALT2>;
+					st,pins {
+						tx	= <&PIO17 4 OUT>;
+						rx	= <&PIO17 5 IN>;
+						output-enable	= <&PIO11 3 OUT>;
+					};
+				};
+			};
+		};
+
+		pin-controller-fvdp-fe {
+			#address-cells	= <1>;
+			#size-cells	= <1>;
+			compatible	= "st,stih416-pinctrl", "simple-bus";
+			st,retime-in-delay	= <0 300 500 750 1000 1250 1500 1750 2000 2250 2500 2750 3000 3250>;
+			st,retime-out-delay	= <0 300 500 750 1000 1250 1500 1750 2000 2250 2500 2750 3000 3250>;
+			st,syscfg		= <&syscfg_fvdp_fe>;
+			st,syscfg-offsets	= <0 40 50 60 100>;
+			ranges;
+
+			PIO100: pinctrl@fd6b0000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfd6b0000 0x100>;
+				st,bank-name  = "PIO100";
+				st,retime-pin-mask = <0xff>;
+			};
+
+			PIO101: pinctrl@fd6b1000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfd6b1000 0x100>;
+				st,bank-name  = "PIO101";
+				st,retime-pin-mask = <0xff>;
+			};
+
+			PIO102: pinctrl@fd6b2000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfd6b2000 0x100>;
+				st,bank-name  = "PIO102";
+				st,retime-pin-mask = <0xff>;
+			};
+		};
+
+		pin-controller-fvdp-lite {
+			#address-cells	= <1>;
+			#size-cells	= <1>;
+			compatible	= "st,stih416-pinctrl", "simple-bus";
+			st,retime-in-delay	= <0 300 500 750 1000 1250 1500 1750 2000 2250 2500 2750 3000 3250>;
+			st,retime-out-delay	= <0 300 500 750 1000 1250 1500 1750 2000 2250 2500 2750 3000 3250>;
+			st,syscfg		= <&syscfg_fvdp_lite>;
+			st,syscfg-offsets	= <0 40 50 60 100>;
+			ranges;
+
+			PIO103: pinctrl@fd330000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfd330000 0x100>;
+				st,bank-name  = "PIO103";
+				st,retime-pin-mask = <0xff>;
+			};
+			PIO104: pinctrl@fd331000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfd331000 0x100>;
+				st,bank-name  = "PIO104";
+				st,retime-pin-mask = <0xff>;
+			};
+			PIO105: pinctrl@fd332000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfd332000 0x100>;
+				st,bank-name  = "PIO105";
+				st,retime-pin-mask = <0xff>;
+			};
+			PIO106: pinctrl@fd333000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfd333000 0x100>;
+				st,bank-name  = "PIO106";
+				st,retime-pin-mask = <0xff>;
+			};
+
+			PIO107: pinctrl@fd334000 {
+				#gpio-cells	= <1>;
+				compatible	= "st,stixxxx-gpio";
+				gpio-controller;
+				reg = <0xfd334000 0x100>;
+				st,bank-name  = "PIO107";
+				st,retime-pin-mask = <0xf>;
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
new file mode 100644
index 0000000..7dbe450
--- /dev/null
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -0,0 +1,111 @@
+/*
+ * Copyright (C) 2012 STMicroelectronics Limited.
+ * Author: Srinivas Kandagatla <srinivas.kandagatla@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * publishhed by the Free Software Foundation.
+ */
+#include "stih41x.dtsi"
+#include "stih416-clock.dtsi"
+#include "stih416-pinctrl.dtsi"
+/ {
+	L2: cache-controller {
+		compatible = "arm,pl310-cache";
+		reg = <0xfffe2000 0x1000>;
+		arm,data-latency = <3 3 3>;
+		arm,tag-latency = <2 2 2>;
+		cache-unified;
+		cache-level = <2>;
+	};
+
+	soc {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		interrupt-parent = <&intc>;
+		ranges;
+		compatible	= "simple-bus";
+
+		syscfg_sbc:syscfg@fe600000{
+			compatible	= "st,stih416-syscfg";
+			reg		= <0xfe600000 0x1000>;
+			syscfg-range	= <0 999>;
+			syscfg-name	= "SYSCFG_SBC";
+		};
+		syscfg_front:syscfg@fee10000{
+			compatible	= "st,stih416-syscfg";
+			reg		= <0xfee10000 0x1000>;
+			syscfg-range	= <1000 999>;
+			syscfg-name	= "SYSCFG_FRONT";
+		};
+		syscfg_rear:syscfg@fe830000{
+			compatible	= "st,stih416-syscfg";
+			reg		= <0xfe830000 0x1000>;
+			syscfg-range	= <2000 999>;
+			syscfg-name	= "SYSCFG_REAR";
+		};
+
+		/* MPE */
+		syscfg_fvdp_fe:syscfg@fddf0000{
+			compatible	= "st,stih416-syscfg";
+			reg		= <0xfddf0000 0x1000>;
+			syscfg-range	= <5000 999>;
+			syscfg-name	= "SYSCFG_FVDP_FE";
+		};
+		syscfg_fvdp_lite:syscfg@fd6a0000{
+			compatible	= "st,stih416-syscfg";
+			reg		= <0xfd6a0000 0x1000>;
+			syscfg-range	= <6000 999>;
+			syscfg-name	= "SYSCFG_FVDP_LITE";
+		};
+
+		syscfg_cpu:syscfg@fdde0000{
+			compatible	= "st,stih416-syscfg";
+			reg		= <0xfdde0000 0x1000>;
+			syscfg-range	= <7000 999>;
+			syscfg-name	= "SYSCFG_CPU";
+		};
+
+		syscfg_compo:syscfg@fd320000{
+			compatible	= "st,stih416-syscfg";
+			reg		= <0xfd320000 0x1000>;
+			syscfg-range	= <8000 999>;
+			syscfg-name	= "SYSCFG_COMPO";
+		};
+
+		syscfg_transport:syscfg@fd690000{
+			compatible	= "st,stih416-syscfg";
+			reg		= <0xfd690000 0x1000>;
+			syscfg-range	= <9000 999>;
+			syscfg-name	= "SYSCFG_TRANSPORT";
+		};
+
+		syscfg_lpm:syscfg@fe4b5100{
+			compatible	= "st,stih416-syscfg";
+			reg		= <0xfe4b5100 0x8>;
+			syscfg-range	= <0 10>;
+			syscfg-name	= "LPM_CFG_REGS";
+		};
+
+		serial2: serial@fed32000{
+			compatible	= "st,asc";
+			status 		= "disabled";
+			reg		= <0xfed32000 0x2c>;
+			interrupts	= <0 197 0>;
+			clocks          = <&CLK_S_ICN_REG_0>;
+			pinctrl-names 	= "default";
+			pinctrl-0 	= <&pinctrl_serial2>;
+		};
+
+		/* SBC_UART1 */
+		sbc_serial1: serial@fe531000 {
+			compatible	= "st,asc";
+			status 		= "disabled";
+			reg		= <0xfe531000 0x2c>;
+			interrupts	= <0 210 0>;
+			pinctrl-names 	= "default";
+			pinctrl-0 	= <&pinctrl_sbc_serial1>;
+			clocks          = <&CLK_SYSIN>;
+		};
+	};
+};
diff --git a/arch/arm/mach-stixxxx/board-dt.c b/arch/arm/mach-stixxxx/board-dt.c
index 52ce665..2b2552e 100644
--- a/arch/arm/mach-stixxxx/board-dt.c
+++ b/arch/arm/mach-stixxxx/board-dt.c
@@ -37,10 +37,11 @@ static void __init stih41x_timer_init(void)
 
 static const char *stih41x_dt_match[] __initdata = {
 	"st,stih415",
+	"st,stih416",
 	NULL
 };
 
-DT_MACHINE_START(STM, "STiH415 SoC with Flattened Device Tree")
+DT_MACHINE_START(STM, "STiH415/416 SoC with Flattened Device Tree")
 	.init_time	= stih41x_timer_init,
 	.smp		= smp_ops(stixxxx_smp_ops),
 	.dt_compat	= stih41x_dt_match,
-- 
1.7.6.5

