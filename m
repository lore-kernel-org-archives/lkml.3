Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965324AbaCULdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 07:33:22 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:62997 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760766AbaCULdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 07:33:19 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, srinivas.kandagatla@st.com
Subject: [PATCH RESEND for ARM-SoC 2/2] ARM: STi: stih41x: Add support for the FSM Serial Flash Controller
Date: Fri, 21 Mar 2014 11:33:08 +0000
Message-Id: <1395401588-8825-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395401588-8825-1-git-send-email-lee.jones@linaro.org>
References: <1395401588-8825-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we add the necessary device nodes required for successful device
probing and Pinctrl setup for the FSM when booting on an STiH415 (Orly1)
or STiH416 (Orly2) based b2020 development board.

Acked-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Acked-by Angus Clark <angus.clark@st.com>
Acked-by: Brian Norris <computersforpeace@gmail.com>
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih41x-b2020.dtsi  |  1 +
 arch/arm/boot/dts/stih41x-b2020x.dtsi | 28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)
 create mode 100644 arch/arm/boot/dts/stih41x-b2020x.dtsi

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

