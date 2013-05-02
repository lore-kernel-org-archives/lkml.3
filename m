Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761438Ab3EBRVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:21:04 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41824 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761322Ab3EBRU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:20:58 -0400
From: Nishanth Menon <nm@ti.com>
To: Mark Brown <broonie@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Andrii.Tseglytskyi" <andrii.tseglytskyi@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH v3 5/5] ARM: dts: OMAP5: Add device nodes for ABB
Date: Thu, 2 May 2013 12:20:14 -0500
Message-ID: <1367515215-30753-6-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367515215-30753-1-git-send-email-nm@ti.com>
References: <1367515215-30753-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Andrii.Tseglytskyi" <andrii.tseglytskyi@ti.com>

Add ABB device nodes for OMAP5 family of devices. Data is based on
OMAP543x Technical Reference Manual revision U (April 2013).
NOTE: clock node has been disabled in this patch due to the lack of
OMAP5 clock data.

[nm@ti.com: co-developer]
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Andrii.Tseglytskyi <andrii.tseglytskyi@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi |   67 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 3dd7ff8..a9d86d2 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -667,5 +667,72 @@
 				ctrl-module = <&omap_control_usb>;
 			};
 		};
+
+		abb_mpu: regulator-abb-mpu {
+			compatible = "ti,abb-v2";
+			regulator-name = "abb_mpu";
+			#address-cells = <0>;
+			#size-cells = <0>;
+			/* clocks = <&sysclk_in>; - once we have clock data */
+			ti,settling-time = <50>;
+			ti,clock-cycles = <16>;
+
+			reg = <0x4ae07cdc 0x8>, <0x4ae06014 0x4>,
+			      <0x4a0021ac 0x18>, <0x4ae0C318 0x4>;
+			reg-names = "base-address", "int-address",
+				    "efuse-address", "ldo-address";
+			ti,tranxdone-status-mask = <0x80>;
+			/* LDOVBBMPU_MUX_CTRL */
+			ti,ldovbb-override-mask = <0x400>;
+			/* LDOVBBMPU_VSET_OUT */
+			ti,ldovbb-vset-mask = <0x1F>;
+
+			/*
+			 * NOTE: only FBB mode used but actual vset will
+			 * determine final biasing
+			 */
+			ti,abb_info = <
+			/*uV		ABB	efuse	rbb_m fbb_m	vset_m*/
+			880000		0	0x4	0 0x20000000 0x1F000000
+			1060000		0	0x8	0 0x20000000 0x1F000000
+			1250000		0	0x10	0 0x20000000 0x1F000000
+			1260000		1	0x14	0 0x20000000 0x1F000000
+			>;
+
+			status = "disabled";
+		};
+
+		abb_mm: regulator-abb-mm {
+			compatible = "ti,abb-v2";
+			regulator-name = "abb_iva";
+			#address-cells = <0>;
+			#size-cells = <0>;
+			/* clocks = <&sysclk_in>; - once we have clock data */
+			ti,settling-time = <50>;
+			ti,clock-cycles = <16>;
+
+			reg = <0x4ae07ce4 0x8>, <0x4ae06010 0x4>,
+			      <0x4a002194 0x14>, <0x4ae0C314 0x4>;
+			reg-names = "base-address", "int-address",
+				    "efuse-address", "ldo-address";
+			ti,tranxdone-status-mask = <0x80000000>;
+			/* LDOVBBMM_MUX_CTRL */
+			ti,ldovbb-override-mask = <0x400>;
+			/* LDOVBBMM_VSET_OUT */
+			ti,ldovbb-vset-mask = <0x1F>;
+
+			/*
+			 * NOTE: only FBB mode used but actual vset will
+			 * determine final biasing
+			 */
+			ti,abb_info = <
+			/*uV		ABB	efuse	rbb_m fbb_m	vset_m*/
+			880000		0	0x4	0 0x20000000 0x1F000000
+			1025000		0	0x8	0 0x20000000 0x1F000000
+			1120000		1	0x10	0 0x20000000 0x1F000000
+			>;
+
+			status = "disabled";
+		};
 	};
 };
-- 
1.7.9.5

