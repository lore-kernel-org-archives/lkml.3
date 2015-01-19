Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbbASJuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:50:39 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50365 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbbASJuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:50:37 -0500
From: Mugunthan V N <mugunthanvnm@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mugunthan V N <mugunthanvnm@ti.com>
Subject: [PATCH 1/1] ARM: dts: dra72-evm: Add qspi device
Date: Mon, 19 Jan 2015 15:19:28 +0530
Message-ID: <1421660968-16134-1-git-send-email-mugunthanvnm@ti.com>
X-Mailer: git-send-email 2.2.1.62.g3f15098
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These add device tree entry for qspi device on dra72-evm.

Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
---

This patch is tested on linux-next and the boot logs is here [1]

[1] - http://pastebin.ubuntu.com/9783555/ 

---
 arch/arm/boot/dts/dra72-evm.dts | 77 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/arch/arm/boot/dts/dra72-evm.dts b/arch/arm/boot/dts/dra72-evm.dts
index 89085d0..cacddd7 100644
--- a/arch/arm/boot/dts/dra72-evm.dts
+++ b/arch/arm/boot/dts/dra72-evm.dts
@@ -121,6 +121,18 @@
 			0x418   (MUX_MODE15)	/* wakeup0.off */
 		>;
 	};
+
+	qspi1_pins: pinmux_qspi1_pins {
+		pinctrl-single,pins = <
+			0x74 (PIN_OUTPUT | MUX_MODE1)	/* gpmc_a13.qspi1_rtclk */
+			0x78 (PIN_INPUT | MUX_MODE1)	/* gpmc_a14.qspi1_d3 */
+			0x7c (PIN_INPUT | MUX_MODE1)	/* gpmc_a15.qspi1_d2 */
+			0x80 (PIN_INPUT | MUX_MODE1)	/* gpmc_a16.qspi1_d1 */
+			0x84 (PIN_INPUT | MUX_MODE1)	/* gpmc_a17.qspi1_d0 */
+			0x88 (PIN_OUTPUT | MUX_MODE1)	/* qpmc_a18.qspi1_sclk */
+			0xb8 (PIN_OUTPUT | MUX_MODE1)	/* gpmc_cs2.qspi1_cs0 */
+		>;
+	};
 };
 
 &i2c1 {
@@ -461,3 +473,68 @@
 	pinctrl-0 = <&dcan1_pins_default>;
 	pinctrl-1 = <&dcan1_pins_sleep>;
 };
+
+&qspi {
+	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&qspi1_pins>;
+
+	spi-max-frequency = <48000000>;
+	m25p80@0 {
+		compatible = "s25fl256s1";
+		spi-max-frequency = <48000000>;
+		reg = <0>;
+		spi-tx-bus-width = <1>;
+		spi-rx-bus-width = <4>;
+		spi-cpol;
+		spi-cpha;
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		/* MTD partition table.
+		 * The ROM checks the first four physical blocks
+		 * for a valid file to boot and the flash here is
+		 * 64KiB block size.
+		 */
+		partition@0 {
+			label = "QSPI.SPL";
+			reg = <0x00000000 0x000010000>;
+		};
+		partition@1 {
+			label = "QSPI.SPL.backup1";
+			reg = <0x00010000 0x00010000>;
+		};
+		partition@2 {
+			label = "QSPI.SPL.backup2";
+			reg = <0x00020000 0x00010000>;
+		};
+		partition@3 {
+			label = "QSPI.SPL.backup3";
+			reg = <0x00030000 0x00010000>;
+		};
+		partition@4 {
+			label = "QSPI.u-boot";
+			reg = <0x00040000 0x00100000>;
+		};
+		partition@5 {
+			label = "QSPI.u-boot-spl-os";
+			reg = <0x00140000 0x00080000>;
+		};
+		partition@6 {
+			label = "QSPI.u-boot-env";
+			reg = <0x001c0000 0x00010000>;
+		};
+		partition@7 {
+			label = "QSPI.u-boot-env.backup1";
+			reg = <0x001d0000 0x0010000>;
+		};
+		partition@8 {
+			label = "QSPI.kernel";
+			reg = <0x001e0000 0x0800000>;
+		};
+		partition@9 {
+			label = "QSPI.file-system";
+			reg = <0x009e0000 0x01620000>;
+		};
+	};
+};
-- 
2.2.1.62.g3f15098

