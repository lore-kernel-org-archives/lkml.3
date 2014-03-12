Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbaCLNPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 09:15:39 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:40192 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbaCLNPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 09:15:36 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, alexandre.torgue@st.com,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: [PATCH 3/4] ARM: DT: STi: Add DT node for MiPHY365x
Date: Wed, 12 Mar 2014 13:14:55 +0000
Message-Id: <1394630096-28564-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394630096-28564-1-git-send-email-lee.jones@linaro.org>
References: <1394630096-28564-1-git-send-email-lee.jones@linaro.org>
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
 arch/arm/boot/dts/stih416-b2020-revE.dts |  6 +++++-
 arch/arm/boot/dts/stih416-b2020.dts      |  6 ++++++
 arch/arm/boot/dts/stih416.dtsi           | 14 ++++++++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stih416-b2020-revE.dts b/arch/arm/boot/dts/stih416-b2020-revE.dts
index a874570..047f14d 100644
--- a/arch/arm/boot/dts/stih416-b2020-revE.dts
+++ b/arch/arm/boot/dts/stih416-b2020-revE.dts
@@ -32,6 +32,10 @@
 		ethernet1: ethernet@fef08000 {
 			snps,reset-gpio 	= <&PIO0 7>;
 		};
-	};
 
+		miphy365x_phy: miphy365x@fe382000 {
+			st,pcie-tx-pol-inv;
+			st,sata-gen = <3>;
+		};
+	};
 };
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
index 226d3a9..4f7d3ff 100644
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
@@ -191,5 +193,17 @@
 			clock-names	= "stmmaceth";
 			clocks		= <&CLK_S_ICN_REG_0>;
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

