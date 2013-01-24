Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab3AXICj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 03:02:39 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:39619 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab3AXICd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 03:02:33 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <hvaibhav@ti.com>,
        <zonque@gmail.com>, <jacmet@sunsite.dk>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH v2 3/3] ARM: dts: AM33XX: Add NAND flash device tree data to am335x-evm
Date: Thu, 24 Jan 2013 13:32:29 +0530
Message-ID: <ebfab3e9123b3e50b9a9678c1480191addd86d59.1359007746.git.avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1359007746.git.avinashphilip@ti.com>
References: <cover.1359007746.git.avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAND flash connected in am335x-evm on GPMC controller. This patch adds
device tree node in am3355-evm with GPMC contoller timing for NAND flash
interface, NAND partition table, ECC scheme, elm handle id.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
 arch/arm/boot/dts/am335x-evm.dts |   98 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 97 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index 0423298..1c2fd89 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -26,7 +26,8 @@
 
 	am33xx_pinmux: pinmux@44e10800 {
 		pinctrl-names = "default";
-		pinctrl-0 = <&matrix_keypad_s0 &volume_keys_s0>;
+		pinctrl-0 = <&matrix_keypad_s0 &volume_keys_s0
+			&nandflash_pins_s0>;
 
 		matrix_keypad_s0: matrix_keypad_s0 {
 			pinctrl-single,pins = <
@@ -44,6 +45,26 @@
 				0x154 0x27	/* spi0_d0.gpio0_3, INPUT | MODE7 */
 			>;
 		};
+
+		nandflash_pins_s0: nandflash_pins_s0 {
+			pinctrl-single,pins = <
+				0x0 0x30	/* gpmc_ad0.gpmc_ad0, INPUT | PULLUP | MODE0 */
+				0x4 0x30	/* gpmc_ad1.gpmc_ad1, INPUT | PULLUP | MODE0 */
+				0x8 0x30	/* gpmc_ad2.gpmc_ad2, INPUT | PULLUP | MODE0 */
+				0xc 0x30	/* gpmc_ad3.gpmc_ad3, INPUT | PULLUP | MODE0 */
+				0x10 0x30	/* gpmc_ad4.gpmc_ad4, INPUT | PULLUP | MODE0 */
+				0x14 0x30	/* gpmc_ad5.gpmc_ad5, INPUT | PULLUP | MODE0 */
+				0x18 0x30	/* gpmc_ad6.gpmc_ad6, INPUT | PULLUP | MODE0 */
+				0x1c 0x30	/* gpmc_ad7.gpmc_ad7, INPUT | PULLUP | MODE0 */
+				0x70 0x30	/* gpmc_wait0.gpmc_wait0, INPUT | PULLUP | MODE0 */
+				0x74 0x37	/* gpmc_wpn.gpio0_30, INPUT | PULLUP | MODE7 */
+				0x7c 0x8	/* gpmc_csn0.gpmc_csn0,  PULL DISA */
+				0x90 0x8	/* gpmc_advn_ale.gpmc_advn_ale, PULL DISA */
+				0x94 0x8	/* gpmc_oen_ren.gpmc_oen_ren, PULL DISA */
+				0x98 0x8	/* gpmc_wen.gpmc_wen, PULL DISA */
+				0x9c 0x8	/* gpmc_be0n_cle.gpmc_be0n_cle, PULL DISA */
+			>;
+		};
 	};
 
 	ocp {
@@ -102,6 +123,81 @@
 				reg = <0x48>;
 			};
 		};
+
+		elm: elm@48080000 {
+			status = "okay";
+		};
+
+		gpmc: gpmc@50000000 {
+			status = "okay";
+			ranges = <0 0 0x08000000 0x10000000>;	/* CS0: NAND */
+
+			nand@0,0 {
+				reg = <0 0 0>; /* CS0, offset 0 */
+				nand-bus-width = <8>;
+				ti,nand-ecc-opt = "bch8";
+
+				gpmc,sync-clk = <0>;
+				gpmc,cs-on = <0>;
+				gpmc,cs-rd-off = <44>;
+				gpmc,cs-wr-off = <44>;
+				gpmc,adv-on = <6>;
+				gpmc,adv-rd-off = <34>;
+				gpmc,adv-wr-off = <44>;
+				gpmc,we-off = <40>;
+				gpmc,oe-off = <54>;
+				gpmc,access = <64>;
+				gpmc,rd-cycle = <82>;
+				gpmc,wr-cycle = <82>;
+				gpmc,wr-access = <40>;
+				gpmc,wr-data-mux-bus = <0>;
+
+				#address-cells = <1>;
+				#size-cells = <1>;
+				elm_id = <&elm>;
+
+				/* MTD partition table */
+				partition@0 {
+					label = "SPL1";
+					reg = <0x00000000 0x000020000>;
+				};
+
+				partition@1 {
+					label = "SPL2";
+					reg = <0x00020000 0x00020000>;
+				};
+
+				partition@2 {
+					label = "SPL3";
+					reg = <0x00040000 0x00020000>;
+				};
+
+				partition@3 {
+					label = "SPL4";
+					reg = <0x00060000 0x00020000>;
+				};
+
+				partition@4 {
+					label = "U-boot";
+					reg = <0x00080000 0x001e0000>;
+				};
+
+				partition@5 {
+					label = "environment";
+					reg = <0x00260000 0x00020000>;
+				};
+
+				partition@6 {
+					label = "Kernel";
+					reg = <0x00280000 0x00500000>;
+				};
+
+				partition@7 {
+					label = "File-System";
+					reg = <0x00780000 0x0F880000>;
+				};
+			};
+		};
 	};
 
 	vbat: fixedregulator@0 {
-- 
1.7.9.5

