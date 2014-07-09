Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbaGILly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:41:54 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:40243 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073AbaGILlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:41:37 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com
Cc: lee.jones@linaro.org, kernel@stlinux.com
Subject: [PATCH v3 5/5] ARM: DT: STi: STiH416: Add DT node for MiPHY365x
Date: Wed,  9 Jul 2014 12:41:14 +0100
Message-Id: <1404906074-31992-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404906074-31992-1-git-send-email-lee.jones@linaro.org>
References: <1404906074-31992-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
devices. It has 2 ports which it can use for either; both SATA, both
PCIe or one of each in any configuration.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih416-b2020-revE.dts | 10 ++++++++++
 arch/arm/boot/dts/stih416-b2020.dts      | 12 ++++++++++++
 arch/arm/boot/dts/stih416.dtsi           | 22 ++++++++++++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/arch/arm/boot/dts/stih416-b2020-revE.dts b/arch/arm/boot/dts/stih416-b2020-revE.dts
index ba0fa2c..80aff0f 100644
--- a/arch/arm/boot/dts/stih416-b2020-revE.dts
+++ b/arch/arm/boot/dts/stih416-b2020-revE.dts
@@ -31,5 +31,15 @@
 		ethernet1: dwmac@fef08000 {
 			snps,reset-gpio = <&PIO0 7>;
 		};
+
+		miphy365x_phy: miphy365x@fe382000 {
+			phy_port0: port@fe382000 {
+				st,sata-gen = <3>;
+			};
+
+			phy_port1: port@fe38a000 {
+				st,pcie-tx-pol-inv;
+			};
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/stih416-b2020.dts b/arch/arm/boot/dts/stih416-b2020.dts
index 4e2df66..c3c2ac6 100644
--- a/arch/arm/boot/dts/stih416-b2020.dts
+++ b/arch/arm/boot/dts/stih416-b2020.dts
@@ -12,4 +12,16 @@
 / {
 	model = "STiH416 B2020";
 	compatible = "st,stih416-b2020", "st,stih416";
+
+	soc {
+		miphy365x_phy: miphy365x@fe382000 {
+			phy_port0: port@fe382000 {
+				st,sata-gen = <3>;
+			};
+
+			phy_port1: port@fe38a000 {
+				st,pcie-tx-pol-inv;
+			};
+		};
+	};
 };
diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index 06473c5..e62fdd3 100644
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
@@ -236,5 +238,25 @@
 			resets	= <&powerdown STIH416_KEYSCAN_POWERDOWN>,
 				  <&softreset STIH416_KEYSCAN_SOFTRESET>;
 		};
+
+		miphy365x_phy: miphy365x@fe382000 {
+			compatible      = "st,miphy365x-phy";
+			st,syscfg  	= <&syscfg_rear>;
+			#address-cells	= <1>;
+			#size-cells	= <1>;
+			ranges;
+
+			phy_port0: port@fe382000 {
+				#phy-cells = <1>;
+				reg = <0xfe382000 0x100>, <0xfe394000 0x100>, <0x824 0x4>;
+				reg-names = "sata", "pcie", "syscfg";
+			};
+
+			phy_port1: port@fe38a000 {
+				#phy-cells = <1>;
+				reg = <0xfe38a000 0x100>, <0xfe804000 0x100>, <0x828 0x4>;
+				reg-names = "sata", "pcie", "syscfg";
+			};
+		};
 	};
 };
-- 
1.8.3.2

