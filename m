Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbaCCOv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 09:51:27 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:32872 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815AbaCCOvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 09:51:17 -0500
From: Mugunthan V N <mugunthanvnm@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <linux@arm.linux.org.uk>, <akpm@linux-foundation.org>, <nm@ti.com>,
        <balajitk@ti.com>, <r.sricharan@ti.com>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RESEND Patch 6/9] ARM: dts: DRA7: Add device nodes for ABB
Date: Mon, 3 Mar 2014 20:20:23 +0530
Message-ID: <1393858226-32595-8-git-send-email-mugunthanvnm@ti.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393858226-32595-1-git-send-email-mugunthanvnm@ti.com>
References: <1393858226-32595-1-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

Add ABB device nodes for DRA7 family of devices. Data is based on
DRA7 Technical Reference Manual revision I (Sept 2013)

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi | 132 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 132 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 499974a..9e3caf3 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -578,6 +578,138 @@
 			status = "disabled";
 		};
 
+		abb_mpu: regulator-abb-mpu {
+			compatible = "ti,abb-v3";
+			regulator-name = "abb_mpu";
+			#address-cells = <0>;
+			#size-cells = <0>;
+			clocks = <&sys_clkin1>;
+			ti,settling-time = <50>;
+			ti,clock-cycles = <16>;
+
+			reg = <0x4ae07ddc 0x4>, <0x4ae07de0 0x4>,
+			      <0x4ae06014 0x4>, <0x4a003b20 0x8>,
+			      <0x4ae0c158 0x4>;
+			reg-names = "setup-address", "control-address",
+				    "int-address", "efuse-address",
+				    "ldo-address";
+			ti,tranxdone-status-mask = <0x80>;
+			/* LDOVBBMPU_FBB_MUX_CTRL */
+			ti,ldovbb-override-mask = <0x400>;
+			/* LDOVBBMPU_FBB_VSET_OUT */
+			ti,ldovbb-vset-mask = <0x1F>;
+
+			/*
+			 * NOTE: only FBB mode used but actual vset will
+			 * determine final biasing
+			 */
+			ti,abb_info = <
+			/*uV		ABB	efuse	rbb_m fbb_m	vset_m*/
+			1060000		0	0x0	0 0x02000000 0x01F00000
+			1160000		0	0x4	0 0x02000000 0x01F00000
+			1210000		0	0x8	0 0x02000000 0x01F00000
+			>;
+		};
+
+		abb_ivahd: regulator-abb-ivahd {
+			compatible = "ti,abb-v3";
+			regulator-name = "abb_ivahd";
+			#address-cells = <0>;
+			#size-cells = <0>;
+			clocks = <&sys_clkin1>;
+			ti,settling-time = <50>;
+			ti,clock-cycles = <16>;
+
+			reg = <0x4ae07e34 0x4>, <0x4ae07e24 0x4>,
+			      <0x4ae06010 0x4>, <0x4a0025cc 0x8>,
+			      <0x4a002470 0x4>;
+			reg-names = "setup-address", "control-address",
+				    "int-address", "efuse-address",
+				    "ldo-address";
+			ti,tranxdone-status-mask = <0x40000000>;
+			/* LDOVBBIVA_FBB_MUX_CTRL */
+			ti,ldovbb-override-mask = <0x400>;
+			/* LDOVBBIVA_FBB_VSET_OUT */
+			ti,ldovbb-vset-mask = <0x1F>;
+
+			/*
+			 * NOTE: only FBB mode used but actual vset will
+			 * determine final biasing
+			 */
+			ti,abb_info = <
+			/*uV		ABB	efuse	rbb_m fbb_m	vset_m*/
+			1055000		0	0x0	0 0x02000000 0x01F00000
+			1150000		0	0x4	0 0x02000000 0x01F00000
+			1250000		0	0x8	0 0x02000000 0x01F00000
+			>;
+		};
+
+		abb_dspeve: regulator-abb-dspeve {
+			compatible = "ti,abb-v3";
+			regulator-name = "abb_dspeve";
+			#address-cells = <0>;
+			#size-cells = <0>;
+			clocks = <&sys_clkin1>;
+			ti,settling-time = <50>;
+			ti,clock-cycles = <16>;
+
+			reg = <0x4ae07e30 0x4>, <0x4ae07e20 0x4>,
+			      <0x4ae06010 0x4>, <0x4a0025e0 0x8>,
+			      <0x4a00246c 0x4>;
+			reg-names = "setup-address", "control-address",
+				    "int-address", "efuse-address",
+				    "ldo-address";
+			ti,tranxdone-status-mask = <0x20000000>;
+			/* LDOVBBDSPEVE_FBB_MUX_CTRL */
+			ti,ldovbb-override-mask = <0x400>;
+			/* LDOVBBDSPEVE_FBB_VSET_OUT */
+			ti,ldovbb-vset-mask = <0x1F>;
+
+			/*
+			 * NOTE: only FBB mode used but actual vset will
+			 * determine final biasing
+			 */
+			ti,abb_info = <
+			/*uV		ABB	efuse	rbb_m fbb_m	vset_m*/
+			1055000		0	0x0	0 0x02000000 0x01F00000
+			1150000		0	0x4	0 0x02000000 0x01F00000
+			1250000		0	0x8	0 0x02000000 0x01F00000
+			>;
+		};
+
+		abb_gpu: regulator-abb-gpu {
+			compatible = "ti,abb-v3";
+			regulator-name = "abb_gpu";
+			#address-cells = <0>;
+			#size-cells = <0>;
+			clocks = <&sys_clkin1>;
+			ti,settling-time = <50>;
+			ti,clock-cycles = <16>;
+
+			reg = <0x4ae07de4 0x4>, <0x4ae07de8 0x4>,
+			      <0x4ae06010 0x4>, <0x4a003b08 0x8>,
+			      <0x4ae0c154 0x4>;
+			reg-names = "setup-address", "control-address",
+				    "int-address", "efuse-address",
+				    "ldo-address";
+			ti,tranxdone-status-mask = <0x10000000>;
+			/* LDOVBBGPU_FBB_MUX_CTRL */
+			ti,ldovbb-override-mask = <0x400>;
+			/* LDOVBBGPU_FBB_VSET_OUT */
+			ti,ldovbb-vset-mask = <0x1F>;
+
+			/*
+			 * NOTE: only FBB mode used but actual vset will
+			 * determine final biasing
+			 */
+			ti,abb_info = <
+			/*uV		ABB	efuse	rbb_m fbb_m	vset_m*/
+			1090000		0	0x0	0 0x02000000 0x01F00000
+			1210000		0	0x4	0 0x02000000 0x01F00000
+			1280000		0	0x8	0 0x02000000 0x01F00000
+			>;
+		};
+
 		mcspi1: spi@48098000 {
 			compatible = "ti,omap4-mcspi";
 			reg = <0x48098000 0x200>;
-- 
1.9.0

