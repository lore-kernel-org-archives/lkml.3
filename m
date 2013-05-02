Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761383Ab3EBRVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:21:01 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45648 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761134Ab3EBRUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:20:52 -0400
From: Nishanth Menon <nm@ti.com>
To: Mark Brown <broonie@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Andrii.Tseglytskyi" <andrii.tseglytskyi@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH v3 3/5] ARM: dts: OMAP443x: Add device nodes for ABB
Date: Thu, 2 May 2013 12:20:12 -0500
Message-ID: <1367515215-30753-4-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367515215-30753-1-git-send-email-nm@ti.com>
References: <1367515215-30753-1-git-send-email-nm@ti.com>
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

[nm@ti.com: co-developer]
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Andrii.Tseglytskyi <andrii.tseglytskyi@ti.com>
---
 arch/arm/boot/dts/omap4.dtsi    |   32 ++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/omap443x.dtsi |   26 ++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 1c6d969..8f6a1fb 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -108,6 +108,11 @@
 			ti,hwmods = "counter_32k";
 		};
 
+		sysclk_in: sys_clkin {
+			#clock-cells = <0>;
+			compatible = "ti,omap-clock";
+		};
+
 		dpll_mpu: dpll_mpu {
 			#clock-cells = <0>;
 			compatible = "ti,omap-clock";
@@ -667,5 +672,32 @@
 			ram-bits = <12>;
 			ti,has-mailbox;
 		};
+
+		abb_mpu: regulator-abb-mpu {
+			compatible = "ti,abb-v2";
+			regulator-name = "abb_mpu";
+			#address-cells = <0>;
+			#size-cells = <0>;
+			ti,tranxdone-status-mask = <0x80>;
+			clocks = <&sysclk_in>;
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
+			clocks = <&sysclk_in>;
+			ti,settling-time = <50>;
+			ti,clock-cycles = <16>;
+
+			status = "disabled";
+		};
+
 	};
 };
diff --git a/arch/arm/boot/dts/omap443x.dtsi b/arch/arm/boot/dts/omap443x.dtsi
index cccf39a..377e519 100644
--- a/arch/arm/boot/dts/omap443x.dtsi
+++ b/arch/arm/boot/dts/omap443x.dtsi
@@ -24,4 +24,30 @@
 			clock-latency = <300000>; /* From legacy driver */
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
-- 
1.7.9.5

