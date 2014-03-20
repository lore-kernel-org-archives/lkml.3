Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911AbaCTPzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:55:31 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:60747 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530AbaCTPz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:55:26 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, srinivas.kandagatla@st.com,
        maxime.coquelin@st.com, patrice.chotard@st.com
Subject: [PATCH] ARM: STi: Add support for the FSM Serial Flash Controller
Date: Thu, 20 Mar 2014 15:55:20 +0000
Message-Id: <1395330920-10559-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we add the necessary device nodes required for successful device
probing and Pinctrl setup for the FSM.

Acked-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Acked-by Angus Clark <angus.clark@st.com>
Acked-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih416-pinctrl.dtsi | 13 +++++++++++++
 arch/arm/boot/dts/stih416.dtsi         | 13 +++++++++++++
 arch/arm/boot/dts/stih41x-b2020.dtsi   |  1 +
 arch/arm/boot/dts/stih41x-b2020x.dtsi  | 28 ++++++++++++++++++++++++++++
 4 files changed, 55 insertions(+)
 create mode 100644 arch/arm/boot/dts/stih41x-b2020x.dtsi

diff --git a/arch/arm/boot/dts/stih416-pinctrl.dtsi b/arch/arm/boot/dts/stih416-pinctrl.dtsi
index b29ff4b..81df8e7 100644
--- a/arch/arm/boot/dts/stih416-pinctrl.dtsi
+++ b/arch/arm/boot/dts/stih416-pinctrl.dtsi
@@ -210,6 +210,19 @@
 					};
 				};
 			};
+
+			fsm {
+				pinctrl_fsm: fsm {
+					st,pins {
+						spi-fsm-clk  = <&PIO12 2 ALT1 OUT>;
+						spi-fsm-cs   = <&PIO12 3 ALT1 OUT>;
+						spi-fsm-mosi = <&PIO12 4 ALT1 OUT>;
+						spi-fsm-miso = <&PIO12 5 ALT1 IN>;
+						spi-fsm-hol  = <&PIO12 6 ALT1 OUT>;
+						spi-fsm-wp   = <&PIO12 7 ALT1 OUT>;
+					};
+				};
+			};
 		};
 
 		pin-controller-rear {
diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index b7ab47b..1e24b9e 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -145,5 +145,18 @@
 
 			status		= "disabled";
 		};
+
+		/* FSM */
+		spifsm: spifsm@fe902000 {
+			compatible	   = "st,spi-fsm";
+			reg		   = <0xfe902000 0x1000>;
+			pinctrl-0	   = <&pinctrl_fsm>;
+
+			st,syscfg	   = <&syscfg_rear>;
+			st,boot-device-reg = <0x958>;
+			st,boot-device-spi = <0x1a>;
+
+			status = "disabled";
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/stih41x-b2020.dtsi b/arch/arm/boot/dts/stih41x-b2020.dtsi
index 0ef0a69..01487e0 100644
--- a/arch/arm/boot/dts/stih41x-b2020.dtsi
+++ b/arch/arm/boot/dts/stih41x-b2020.dtsi
@@ -6,6 +6,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * publishhed by the Free Software Foundation.
  */
+#include "stih41x-b2020x.dtsi"
 / {
 	memory{
 		device_type = "memory";
diff --git a/arch/arm/boot/dts/stih41x-b2020x.dtsi b/arch/arm/boot/dts/stih41x-b2020x.dtsi
new file mode 100644
index 0000000..df01c12
--- /dev/null
+++ b/arch/arm/boot/dts/stih41x-b2020x.dtsi
@@ -0,0 +1,28 @@
+/*
+ * Copyright (C) 2013 STMicroelectronics (R&D) Limited.
+ * Author: Lee Jones <lee.jones@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * publishhed by the Free Software Foundation.
+ */
+/ {
+	soc {
+		spifsm: spifsm@fe902000 {
+			#address-cells = <1>;
+			#size-cells    = <1>;
+
+			status = "okay";
+
+			partition@0 {
+				label = "SerialFlash1";
+				reg   = <0x00000000 0x00500000>;
+			};
+
+			partition@500000 {
+				label = "SerialFlash2";
+				reg   = <0x00500000 0x00b00000>;
+			};
+		};
+	};
+};
-- 
1.8.3.2

