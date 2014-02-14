Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbaBNLYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:24:16 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:51587 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbaBNLYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:24:15 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: alexandre.torgue@st.com, Lee Jones <lee.jones@linaro.org>,
        devicetree@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: [PATCH 3/4] ARM: DT: STi: Add DT node for MiPHY365x
Date: Fri, 14 Feb 2014 11:23:55 +0000
Message-Id: <1392377036-12816-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392377036-12816-1-git-send-email-lee.jones@linaro.org>
References: <1392377036-12816-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
devices. It has 2 ports which it can use for either; both SATA, both
PCIe or one of each in any configuration.

Cc: devicetree@vger.kernel.org
Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih416-b2020-revE.dts |  6 +++++-
 arch/arm/boot/dts/stih416-b2020.dts      |  6 ++++++
 arch/arm/boot/dts/stih416.dtsi           | 13 +++++++++++++
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stih416-b2020-revE.dts b/arch/arm/boot/dts/stih416-b2020-revE.dts
index a874570..dbe67fa 100644
--- a/arch/arm/boot/dts/stih416-b2020-revE.dts
+++ b/arch/arm/boot/dts/stih416-b2020-revE.dts
@@ -32,6 +32,10 @@
 		ethernet1: ethernet@fef08000 {
 			snps,reset-gpio 	= <&PIO0 7>;
 		};
-	};
 
+		miphy365x_phy: miphy365x@0 {
+			st,pcie_tx_pol_inv = <1>;
+			st,sata_gen = "gen3";
+		};
+	};
 };
diff --git a/arch/arm/boot/dts/stih416-b2020.dts b/arch/arm/boot/dts/stih416-b2020.dts
index 276f28d..fd9cbad 100644
--- a/arch/arm/boot/dts/stih416-b2020.dts
+++ b/arch/arm/boot/dts/stih416-b2020.dts
@@ -13,4 +13,10 @@
 	model = "STiH416 B2020";
 	compatible = "st,stih416", "st,stih416-b2020";
 
+	soc {
+		miphy365x_phy: miphy365x@0 {
+			st,pcie_tx_pol_inv = <1>;
+			st,sata_gen = "gen3";
+		};
+	};
 };
diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index 85b8063..9fd8efb 100644
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
@@ -140,5 +142,16 @@
 			clocks		= <&CLK_S_ICN_REG_0>;
 		};
 
+		miphy365x_phy: miphy365x@0 {
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

