Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161762AbaJaCM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 22:12:29 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33426 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161733AbaJaCM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 22:12:27 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <haojian.zhuang@gmail.com>, <haojian.zhuang@linaro.org>,
        <mturquette@linaro.org>, <chao.xie@marvell.com>,
        <xiechao_mail@163.com>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 13/13] arm: mmp: Make use of the DT supported clock
Date: Fri, 31 Oct 2014 10:13:53 +0800
Message-ID: <1414721633-29508-14-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1414721633-29508-1-git-send-email-chao.xie@marvell.com>
References: <1414721633-29508-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-31_02:2014-10-30,2014-10-31,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1410310021
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chao Xie <chao.xie@marvell.com>

Change the dtsi and dts file, soc initialization code to make
use of DT support clock.
So now in the code we do only need call of_clk_init to initialize
the clocks.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 arch/arm/boot/dts/mmp2.dtsi   | 27 ++++++++++++++++++++
 arch/arm/boot/dts/pxa168.dtsi | 25 +++++++++++++++++++
 arch/arm/boot/dts/pxa910.dtsi | 26 ++++++++++++++++++++
 arch/arm/mach-mmp/Kconfig     | 12 ++++-----
 arch/arm/mach-mmp/mmp-dt.c    | 57 ++++++++++++++-----------------------------
 arch/arm/mach-mmp/mmp2-dt.c   | 26 +++++++-------------
 6 files changed, 111 insertions(+), 62 deletions(-)

diff --git a/arch/arm/boot/dts/mmp2.dtsi b/arch/arm/boot/dts/mmp2.dtsi
index e44f996..766bbb8 100644
--- a/arch/arm/boot/dts/mmp2.dtsi
+++ b/arch/arm/boot/dts/mmp2.dtsi
@@ -8,6 +8,7 @@
  */
 
 #include "skeleton.dtsi"
+#include <dt-bindings/clock/marvell,mmp2.h>
 
 / {
 	aliases {
@@ -135,6 +136,8 @@
 				compatible = "mrvl,mmp-uart";
 				reg = <0xd4030000 0x1000>;
 				interrupts = <27>;
+				clocks = <&soc_clocks MMP2_CLK_UART0>;
+				resets = <&soc_clocks MMP2_CLK_UART0>;
 				status = "disabled";
 			};
 
@@ -142,6 +145,8 @@
 				compatible = "mrvl,mmp-uart";
 				reg = <0xd4017000 0x1000>;
 				interrupts = <28>;
+				clocks = <&soc_clocks MMP2_CLK_UART1>;
+				resets = <&soc_clocks MMP2_CLK_UART1>;
 				status = "disabled";
 			};
 
@@ -149,6 +154,8 @@
 				compatible = "mrvl,mmp-uart";
 				reg = <0xd4018000 0x1000>;
 				interrupts = <24>;
+				clocks = <&soc_clocks MMP2_CLK_UART2>;
+				resets = <&soc_clocks MMP2_CLK_UART2>;
 				status = "disabled";
 			};
 
@@ -156,6 +163,8 @@
 				compatible = "mrvl,mmp-uart";
 				reg = <0xd4016000 0x1000>;
 				interrupts = <46>;
+				clocks = <&soc_clocks MMP2_CLK_UART3>;
+				resets = <&soc_clocks MMP2_CLK_UART3>;
 				status = "disabled";
 			};
 
@@ -168,6 +177,8 @@
 				#gpio-cells = <2>;
 				interrupts = <49>;
 				interrupt-names = "gpio_mux";
+				clocks = <&soc_clocks MMP2_CLK_GPIO>;
+				resets = <&soc_clocks MMP2_CLK_GPIO>;
 				interrupt-controller;
 				#interrupt-cells = <1>;
 				ranges;
@@ -201,6 +212,8 @@
 				compatible = "mrvl,mmp-twsi";
 				reg = <0xd4011000 0x1000>;
 				interrupts = <7>;
+				clocks = <&soc_clocks MMP2_CLK_TWSI0>;
+				resets = <&soc_clocks MMP2_CLK_TWSI0>;
 				#address-cells = <1>;
 				#size-cells = <0>;
 				mrvl,i2c-fast-mode;
@@ -211,6 +224,8 @@
 				compatible = "mrvl,mmp-twsi";
 				reg = <0xd4025000 0x1000>;
 				interrupts = <58>;
+				clocks = <&soc_clocks MMP2_CLK_TWSI1>;
+				resets = <&soc_clocks MMP2_CLK_TWSI1>;
 				status = "disabled";
 			};
 
@@ -220,8 +235,20 @@
 				interrupts = <1 0>;
 				interrupt-names = "rtc 1Hz", "rtc alarm";
 				interrupt-parent = <&intcmux5>;
+				clocks = <&soc_clocks MMP2_CLK_RTC>;
+				resets = <&soc_clocks MMP2_CLK_RTC>;
 				status = "disabled";
 			};
 		};
+
+		soc_clocks: clocks{
+			compatible = "marvell,mmp2-clock";
+			reg = <0xd4050000 0x1000>,
+			      <0xd4282800 0x400>,
+			      <0xd4015000 0x1000>;
+			reg-names = "mpmu", "apmu", "apbc";
+			#clock-cells = <1>;
+			#reset-cells = <1>;
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/pxa168.dtsi b/arch/arm/boot/dts/pxa168.dtsi
index bfcbdef..b899e25 100644
--- a/arch/arm/boot/dts/pxa168.dtsi
+++ b/arch/arm/boot/dts/pxa168.dtsi
@@ -8,6 +8,7 @@
  */
 
 #include "skeleton.dtsi"
+#include <dt-bindings/clock/marvell,pxa168.h>
 
 / {
 	aliases {
@@ -59,6 +60,8 @@
 				compatible = "mrvl,mmp-uart";
 				reg = <0xd4017000 0x1000>;
 				interrupts = <27>;
+				clocks = <&soc_clocks PXA168_CLK_UART0>;
+				resets = <&soc_clocks PXA168_CLK_UART0>;
 				status = "disabled";
 			};
 
@@ -66,6 +69,8 @@
 				compatible = "mrvl,mmp-uart";
 				reg = <0xd4018000 0x1000>;
 				interrupts = <28>;
+				clocks = <&soc_clocks PXA168_CLK_UART1>;
+				resets = <&soc_clocks PXA168_CLK_UART1>;
 				status = "disabled";
 			};
 
@@ -73,6 +78,8 @@
 				compatible = "mrvl,mmp-uart";
 				reg = <0xd4026000 0x1000>;
 				interrupts = <29>;
+				clocks = <&soc_clocks PXA168_CLK_UART2>;
+				resets = <&soc_clocks PXA168_CLK_UART2>;
 				status = "disabled";
 			};
 
@@ -84,6 +91,8 @@
 				gpio-controller;
 				#gpio-cells = <2>;
 				interrupts = <49>;
+				clocks = <&soc_clocks PXA168_CLK_GPIO>;
+				resets = <&soc_clocks PXA168_CLK_GPIO>;
 				interrupt-names = "gpio_mux";
 				interrupt-controller;
 				#interrupt-cells = <1>;
@@ -110,6 +119,8 @@
 				compatible = "mrvl,mmp-twsi";
 				reg = <0xd4011000 0x1000>;
 				interrupts = <7>;
+				clocks = <&soc_clocks PXA168_CLK_TWSI0>;
+				resets = <&soc_clocks PXA168_CLK_TWSI0>;
 				mrvl,i2c-fast-mode;
 				status = "disabled";
 			};
@@ -118,6 +129,8 @@
 				compatible = "mrvl,mmp-twsi";
 				reg = <0xd4025000 0x1000>;
 				interrupts = <58>;
+				clocks = <&soc_clocks PXA168_CLK_TWSI1>;
+				resets = <&soc_clocks PXA168_CLK_TWSI1>;
 				status = "disabled";
 			};
 
@@ -126,8 +139,20 @@
 				reg = <0xd4010000 0x1000>;
 				interrupts = <5 6>;
 				interrupt-names = "rtc 1Hz", "rtc alarm";
+				clocks = <&soc_clocks PXA168_CLK_RTC>;
+				resets = <&soc_clocks PXA168_CLK_RTC>;
 				status = "disabled";
 			};
 		};
+
+		soc_clocks: clocks{
+			compatible = "marvell,pxa168-clock";
+			reg = <0xd4050000 0x1000>,
+			      <0xd4282800 0x400>,
+			      <0xd4015000 0x1000>;
+			reg-names = "mpmu", "apmu", "apbc";
+			#clock-cells = <1>;
+			#reset-cells = <1>;
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/pxa910.dtsi b/arch/arm/boot/dts/pxa910.dtsi
index 884c6e8..0868f67 100644
--- a/arch/arm/boot/dts/pxa910.dtsi
+++ b/arch/arm/boot/dts/pxa910.dtsi
@@ -8,6 +8,7 @@
  */
 
 #include "skeleton.dtsi"
+#include <dt-bindings/clock/marvell,pxa910.h>
 
 / {
 	aliases {
@@ -71,6 +72,8 @@
 				compatible = "mrvl,mmp-uart";
 				reg = <0xd4017000 0x1000>;
 				interrupts = <27>;
+				clocks = <&soc_clocks PXA910_CLK_UART0>;
+				resets = <&soc_clocks PXA910_CLK_UART0>;
 				status = "disabled";
 			};
 
@@ -78,6 +81,8 @@
 				compatible = "mrvl,mmp-uart";
 				reg = <0xd4018000 0x1000>;
 				interrupts = <28>;
+				clocks = <&soc_clocks PXA910_CLK_UART1>;
+				resets = <&soc_clocks PXA910_CLK_UART1>;
 				status = "disabled";
 			};
 
@@ -85,6 +90,8 @@
 				compatible = "mrvl,mmp-uart";
 				reg = <0xd4036000 0x1000>;
 				interrupts = <59>;
+				clocks = <&soc_clocks PXA910_CLK_UART2>;
+				resets = <&soc_clocks PXA910_CLK_UART2>;
 				status = "disabled";
 			};
 
@@ -97,6 +104,8 @@
 				#gpio-cells = <2>;
 				interrupts = <49>;
 				interrupt-names = "gpio_mux";
+				clocks = <&soc_clocks PXA910_CLK_GPIO>;
+				resets = <&soc_clocks PXA910_CLK_GPIO>;
 				interrupt-controller;
 				#interrupt-cells = <1>;
 				ranges;
@@ -124,6 +133,8 @@
 				#size-cells = <0>;
 				reg = <0xd4011000 0x1000>;
 				interrupts = <7>;
+				clocks = <&soc_clocks PXA910_CLK_TWSI0>;
+				resets = <&soc_clocks PXA910_CLK_TWSI0>;
 				mrvl,i2c-fast-mode;
 				status = "disabled";
 			};
@@ -134,6 +145,8 @@
 				#size-cells = <0>;
 				reg = <0xd4037000 0x1000>;
 				interrupts = <54>;
+				clocks = <&soc_clocks PXA910_CLK_TWSI1>;
+				resets = <&soc_clocks PXA910_CLK_TWSI1>;
 				status = "disabled";
 			};
 
@@ -142,8 +155,21 @@
 				reg = <0xd4010000 0x1000>;
 				interrupts = <5 6>;
 				interrupt-names = "rtc 1Hz", "rtc alarm";
+				clocks = <&soc_clocks PXA910_CLK_RTC>;
+				resets = <&soc_clocks PXA910_CLK_RTC>;
 				status = "disabled";
 			};
 		};
+
+		soc_clocks: clocks{
+			compatible = "marvell,pxa910-clock";
+			reg = <0xd4050000 0x1000>,
+			      <0xd4282800 0x400>,
+			      <0xd4015000 0x1000>,
+			      <0xd403b000 0x1000>;
+			reg-names = "mpmu", "apmu", "apbc", "apbcp";
+			#clock-cells = <1>;
+			#reset-cells = <1>;
+		};
 	};
 };
diff --git a/arch/arm/mach-mmp/Kconfig b/arch/arm/mach-mmp/Kconfig
index ebdba87..fdbfadf 100644
--- a/arch/arm/mach-mmp/Kconfig
+++ b/arch/arm/mach-mmp/Kconfig
@@ -86,11 +86,12 @@ config MACH_GPLUGD
 
 config MACH_MMP_DT
 	bool "Support MMP (ARMv5) platforms from device tree"
-	select CPU_PXA168
-	select CPU_PXA910
 	select USE_OF
 	select PINCTRL
 	select PINCTRL_SINGLE
+	select COMMON_CLK
+	select ARCH_HAS_RESET_CONTROLLER
+	select CPU_MOHAWK
 	help
 	  Include support for Marvell MMP2 based platforms using
 	  the device tree. Needn't select any other machine while
@@ -99,10 +100,12 @@ config MACH_MMP_DT
 config MACH_MMP2_DT
 	bool "Support MMP2 (ARMv7) platforms from device tree"
 	depends on !CPU_MOHAWK
-	select CPU_MMP2
 	select USE_OF
 	select PINCTRL
 	select PINCTRL_SINGLE
+	select COMMON_CLK
+	select ARCH_HAS_RESET_CONTROLLER
+	select CPU_PJ4
 	help
 	  Include support for Marvell MMP2 based platforms using
 	  the device tree.
@@ -111,21 +114,18 @@ endmenu
 
 config CPU_PXA168
 	bool
-	select COMMON_CLK
 	select CPU_MOHAWK
 	help
 	  Select code specific to PXA168
 
 config CPU_PXA910
 	bool
-	select COMMON_CLK
 	select CPU_MOHAWK
 	help
 	  Select code specific to PXA910
 
 config CPU_MMP2
 	bool
-	select COMMON_CLK
 	select CPU_PJ4
 	help
 	  Select code specific to MMP2. MMP2 is ARMv7 compatible.
diff --git a/arch/arm/mach-mmp/mmp-dt.c b/arch/arm/mach-mmp/mmp-dt.c
index cca529c..b2296c9 100644
--- a/arch/arm/mach-mmp/mmp-dt.c
+++ b/arch/arm/mach-mmp/mmp-dt.c
@@ -11,63 +11,42 @@
 
 #include <linux/irqchip.h>
 #include <linux/of_platform.h>
+#include <linux/clk-provider.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/time.h>
+#include <asm/hardware/cache-tauros2.h>
 
 #include "common.h"
 
 extern void __init mmp_dt_init_timer(void);
 
-static const struct of_dev_auxdata pxa168_auxdata_lookup[] __initconst = {
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4017000, "pxa2xx-uart.0", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4018000, "pxa2xx-uart.1", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4026000, "pxa2xx-uart.2", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4011000, "pxa2xx-i2c.0", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4025000, "pxa2xx-i2c.1", NULL),
-	OF_DEV_AUXDATA("marvell,mmp-gpio", 0xd4019000, "mmp-gpio", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-rtc", 0xd4010000, "sa1100-rtc", NULL),
-	{}
+static const char *pxa168_dt_board_compat[] __initdata = {
+	"mrvl,pxa168-aspenite",
+	NULL,
 };
 
-static const struct of_dev_auxdata pxa910_auxdata_lookup[] __initconst = {
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4017000, "pxa2xx-uart.0", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4018000, "pxa2xx-uart.1", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4036000, "pxa2xx-uart.2", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4011000, "pxa2xx-i2c.0", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4037000, "pxa2xx-i2c.1", NULL),
-	OF_DEV_AUXDATA("marvell,mmp-gpio", 0xd4019000, "mmp-gpio", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-rtc", 0xd4010000, "sa1100-rtc", NULL),
-	{}
+static const char *pxa910_dt_board_compat[] __initdata = {
+	"mrvl,pxa910-dkb",
+	NULL,
 };
 
-static void __init pxa168_dt_init(void)
-{
-	of_platform_populate(NULL, of_default_bus_match_table,
-			     pxa168_auxdata_lookup, NULL);
-}
-
-static void __init pxa910_dt_init(void)
+static void __init mmp_init_time(void)
 {
-	of_platform_populate(NULL, of_default_bus_match_table,
-			     pxa910_auxdata_lookup, NULL);
+#ifdef CONFIG_CACHE_TAUROS2
+	tauros2_init(0);
+#endif
+	mmp_dt_init_timer();
+	of_clk_init(NULL);
 }
 
-static const char *mmp_dt_board_compat[] __initdata = {
-	"mrvl,pxa168-aspenite",
-	"mrvl,pxa910-dkb",
-	NULL,
-};
-
 DT_MACHINE_START(PXA168_DT, "Marvell PXA168 (Device Tree Support)")
 	.map_io		= mmp_map_io,
-	.init_time	= mmp_dt_init_timer,
-	.init_machine	= pxa168_dt_init,
-	.dt_compat	= mmp_dt_board_compat,
+	.init_time	= mmp_init_time,
+	.dt_compat	= pxa168_dt_board_compat,
 MACHINE_END
 
 DT_MACHINE_START(PXA910_DT, "Marvell PXA910 (Device Tree Support)")
 	.map_io		= mmp_map_io,
-	.init_time	= mmp_dt_init_timer,
-	.init_machine	= pxa910_dt_init,
-	.dt_compat	= mmp_dt_board_compat,
+	.init_time	= mmp_init_time,
+	.dt_compat	= pxa910_dt_board_compat,
 MACHINE_END
diff --git a/arch/arm/mach-mmp/mmp2-dt.c b/arch/arm/mach-mmp/mmp2-dt.c
index 023cb45..998c0f5 100644
--- a/arch/arm/mach-mmp/mmp2-dt.c
+++ b/arch/arm/mach-mmp/mmp2-dt.c
@@ -12,29 +12,22 @@
 #include <linux/io.h>
 #include <linux/irqchip.h>
 #include <linux/of_platform.h>
+#include <linux/clk-provider.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/time.h>
+#include <asm/hardware/cache-tauros2.h>
 
 #include "common.h"
 
 extern void __init mmp_dt_init_timer(void);
 
-static const struct of_dev_auxdata mmp2_auxdata_lookup[] __initconst = {
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4030000, "pxa2xx-uart.0", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4017000, "pxa2xx-uart.1", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4018000, "pxa2xx-uart.2", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4016000, "pxa2xx-uart.3", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4011000, "pxa2xx-i2c.0", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4025000, "pxa2xx-i2c.1", NULL),
-	OF_DEV_AUXDATA("marvell,mmp-gpio", 0xd4019000, "mmp2-gpio", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-rtc", 0xd4010000, "sa1100-rtc", NULL),
-	{}
-};
-
-static void __init mmp2_dt_init(void)
+static void __init mmp_init_time(void)
 {
-	of_platform_populate(NULL, of_default_bus_match_table,
-			     mmp2_auxdata_lookup, NULL);
+#ifdef CONFIG_CACHE_TAUROS2
+	tauros2_init(0);
+#endif
+	mmp_dt_init_timer();
+	of_clk_init(NULL);
 }
 
 static const char *mmp2_dt_board_compat[] __initdata = {
@@ -44,7 +37,6 @@ static const char *mmp2_dt_board_compat[] __initdata = {
 
 DT_MACHINE_START(MMP2_DT, "Marvell MMP2 (Device Tree Support)")
 	.map_io		= mmp_map_io,
-	.init_time	= mmp_dt_init_timer,
-	.init_machine	= mmp2_dt_init,
+	.init_time	= mmp_init_time,
 	.dt_compat	= mmp2_dt_board_compat,
 MACHINE_END
-- 
1.8.3.2

