Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaA2Xrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 18:47:40 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38999 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbaA2Xqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 18:46:45 -0500
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        "Andrii.Tseglytskyi" <andrii.tseglytskyi@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 2/4] ARM: dts: OMAP4: Add device nodes for ABB
Date: Wed, 29 Jan 2014 17:46:14 -0600
Message-ID: <1391039177-25284-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391039177-25284-1-git-send-email-nm@ti.com>
References: <1391039177-25284-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Andrii.Tseglytskyi" <andrii.tseglytskyi@ti.com>

Add ABB device nodes for OMAP443x family of devices. abb_iva is
populated, but disabled as it is not used on current OMAP443x family,
but the node is used on OMAP446x family. Data is based on OMAP443x
Technical Reference Manual revision AN (April 2013).

ABB device nodes for OMAP4460 device Data is based on OMAP4460
Technical Reference Manual revision Z (April 2013)

[nm@ti.com: co-developer]
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Andrii.Tseglytskyi <andrii.tseglytskyi@ti.com>
---
 arch/arm/boot/dts/omap4.dtsi    |   26 ++++++++++++++++++++++++++
 arch/arm/boot/dts/omap443x.dtsi |   26 ++++++++++++++++++++++++++
 arch/arm/boot/dts/omap4460.dtsi |   37 +++++++++++++++++++++++++++++++++++++
 3 files changed, 89 insertions(+)

diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index d3f8a6e..72e6bd7 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -757,6 +757,32 @@
 			dmas = <&sdma 117>, <&sdma 116>;
 			dma-names = "tx", "rx";
 		};
+
+		abb_mpu: regulator-abb-mpu {
+			compatible = "ti,abb-v2";
+			regulator-name = "abb_mpu";
+			#address-cells = <0>;
+			#size-cells = <0>;
+			ti,tranxdone-status-mask = <0x80>;
+			clocks = <&sys_clkin_ck>;
+			ti,settling-time = <50>;
+			ti,clock-cycles = <16>;
+
+			status = "disabled";
+		};
+
+		abb_iva: regulator-abb-iva {
+			compatible = "ti,abb-v2";
+			regulator-name = "abb_iva";
+			#address-cells = <0>;
+			#size-cells = <0>;
+			ti,tranxdone-status-mask = <0x80000000>;
+			clocks = <&sys_clkin_ck>;
+			ti,settling-time = <50>;
+			ti,clock-cycles = <16>;
+
+			status = "disabled";
+		};
 	};
 };
 
diff --git a/arch/arm/boot/dts/omap443x.dtsi b/arch/arm/boot/dts/omap443x.dtsi
index 8c1cfad..0adfa1d 100644
--- a/arch/arm/boot/dts/omap443x.dtsi
+++ b/arch/arm/boot/dts/omap443x.dtsi
@@ -43,6 +43,32 @@
 			#thermal-sensor-cells = <0>;
 		};
 	};
+
+	ocp {
+		abb_mpu: regulator-abb-mpu {
+			status = "okay";
+
+			reg = <0x4a307bd0 0x8>, <0x4a306014 0x4>;
+			reg-names = "base-address", "int-address";
+
+			ti,abb_info = <
+			/*uV		ABB	efuse	rbb_m	fbb_m	vset_m*/
+			1025000		0	0	0	0	0
+			1200000		0	0	0	0	0
+			1313000		0	0	0	0	0
+			1375000		1	0	0	0	0
+			1389000		1	0	0	0	0
+			>;
+		};
+
+		/* Default unused, just provide register info for record */
+		abb_iva: regulator-abb-iva {
+			reg = <0x4a307bd8 0x8>, <0x4a306010 0x4>;
+			reg-names = "base-address", "int-address";
+		};
+
+	};
+
 };
 
 /include/ "omap443x-clocks.dtsi"
diff --git a/arch/arm/boot/dts/omap4460.dtsi b/arch/arm/boot/dts/omap4460.dtsi
index 6b32f52..194f9ef 100644
--- a/arch/arm/boot/dts/omap4460.dtsi
+++ b/arch/arm/boot/dts/omap4460.dtsi
@@ -50,7 +50,44 @@
 
 			#thermal-sensor-cells = <0>;
 		};
+
+		abb_mpu: regulator-abb-mpu {
+			status = "okay";
+
+			reg = <0x4a307bd0 0x8>, <0x4a306014 0x4>,
+			      <0x4A002268 0x4>;
+			reg-names = "base-address", "int-address",
+				    "efuse-address";
+
+			ti,abb_info = <
+			/*uV		ABB	efuse	rbb_m	fbb_m	vset_m*/
+			1025000		0	0	0	0	0
+			1200000		0	0	0	0	0
+			1313000		0	0	0x100000 0x40000 0
+			1375000		1	0	0	0	0
+			1389000		1	0	0	0	0
+			>;
+		};
+
+		abb_iva: regulator-abb-iva {
+			status = "okay";
+
+			reg = <0x4a307bd8 0x8>, <0x4a306010 0x4>,
+			      <0x4A002268 0x4>;
+			reg-names = "base-address", "int-address",
+				    "efuse-address";
+
+			ti,abb_info = <
+			/*uV		ABB	efuse	rbb_m	fbb_m	vset_m*/
+			950000		0	0	0	0	0
+			1140000		0	0	0	0	0
+			1291000		0	0	0x200000 0	0
+			1375000		1	0	0	0	0
+			1376000		1	0	0	0	0
+			>;
+		};
 	};
+
 };
 
 /include/ "omap446x-clocks.dtsi"
-- 
1.7.9.5

