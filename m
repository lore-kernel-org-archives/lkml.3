Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbaD2HWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 03:22:03 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:41785 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967AbaD2HVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 03:21:55 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: [PATCH 3/4] ARM: DT: STi: Add DT node for MiPHY365x
Date: Tue, 29 Apr 2014 08:21:33 +0100
Message-Id: <1398756095-32542-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398756095-32542-1-git-send-email-lee.jones@linaro.org>
References: <1398756095-32542-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
devices. It has 2 ports which it can use for either; both SATA, both
PCIe or one of each in any configuration.

Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih416-b2020-revE.dts | 22 ++++++++++++++++++++++
 arch/arm/boot/dts/stih416-b2020.dts      |  6 ++++++
 arch/arm/boot/dts/stih416.dtsi           | 14 ++++++++++++++
 3 files changed, 42 insertions(+)
 create mode 100644 arch/arm/boot/dts/stih416-b2020-revE.dts

diff --git a/arch/arm/boot/dts/stih416-b2020-revE.dts b/arch/arm/boot/dts/stih416-b2020-revE.dts
new file mode 100644
index 0000000..23fdaf7
--- /dev/null
+++ b/arch/arm/boot/dts/stih416-b2020-revE.dts
@@ -0,0 +1,22 @@
+/*
+ * Copyright (C) 2014 STMicroelectronics Limited.
+ * Author: Lee Jones <lee.jones@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * publishhed by the Free Software Foundation.
+ */
+/dts-v1/;
+#include "stih416.dtsi"
+#include "stih41x-b2020.dtsi"
+/ {
+        model = "STiH416 B2020 REV-E";
+	compatible = "st,stih416-b2020", "st,stih416";
+
+	soc {
+		miphy365x_phy: miphy365x@fe382000 {
+			st,pcie-tx-pol-inv;
+			st,sata-gen = <3>;
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/stih416-b2020.dts b/arch/arm/boot/dts/stih416-b2020.dts
index 276f28d..172f222 100644
--- a/arch/arm/boot/dts/stih416-b2020.dts
+++ b/arch/arm/boot/dts/stih416-b2020.dts
@@ -13,4 +13,10 @@
 	model = "STiH416 B2020";
 	compatible = "st,stih416", "st,stih416-b2020";
 
+	soc {
+		miphy365x_phy: miphy365x@fe382000 {
+			st,pcie-tx-pol-inv;
+			st,sata-gen = <3>;
+		};
+	};
 };
diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index 78746d2..00b217a 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -9,6 +9,8 @@
 #include "stih41x.dtsi"
 #include "stih416-clock.dtsi"
 #include "stih416-pinctrl.dtsi"
+
+#include <dt-bindings/phy/phy-miphy365x.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 #include <dt-bindings/reset-controller/stih416-resets.h>
 / {
@@ -224,5 +226,17 @@
 
 			status = "disabled";
 		};
+
+		miphy365x_phy: miphy365x@fe382000 {
+			compatible      = "st,miphy365x-phy";
+			reg        	= <0xfe382000 0x100>,
+					  <0xfe38a000 0x100>,
+					  <0xfe394000 0x100>,
+					  <0xfe804000 0x100>;
+			reg-names  	= "sata0", "sata1", "pcie0", "pcie1";
+
+			#phy-cells 	= <2>;
+			st,syscfg  	= <&syscfg_rear>;
+		};
 	};
 };
-- 
1.8.3.2

