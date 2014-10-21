Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024AbaJUOgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:36:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58787 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932702AbaJUOgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:36:23 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH V2 3/3] ARM: dts: dra72-evm: Add MMC nodes
Date: Tue, 21 Oct 2014 09:35:56 -0500
Message-ID: <1413902156-32684-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413901848-32268-1-git-send-email-nm@ti.com>
References: <1413901848-32268-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MMC1 and 2 nodes. MMC1 is SDcard and MMC2 is eMMC.

NOTE on MMC1 card detect: Ideally, we should be using in-built SDCD
support, but we dont have it yet. So, use the fact that control module
of DRA7 is setup such that no matter what mode one configures it, GPIO
option is always hardwired in - use GPIO mode for SDcard detection.

[peter.ujfalusi@ti.com]
The power line feeding the SD card is also used by other devices on the EVM.
Use generic name instead of mmc2_3v3 so when other devices want to use the
same regulator it will look a bit better.

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---

Apologies on the spam, I got my own name screwed up -fixing that right now

Changes in V2: Fixes the formatting error in author name.
V1: https://patchwork.kernel.org/patch/5125291/

 arch/arm/boot/dts/dra72-evm.dts |   59 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/arch/arm/boot/dts/dra72-evm.dts b/arch/arm/boot/dts/dra72-evm.dts
index 1242a17..945a826 100644
--- a/arch/arm/boot/dts/dra72-evm.dts
+++ b/arch/arm/boot/dts/dra72-evm.dts
@@ -17,6 +17,13 @@
 		device_type = "memory";
 		reg = <0x80000000 0x40000000>; /* 1024 MB */
 	};
+
+	evm_3v3: fixedregulator-evm_3v3 {
+		compatible = "regulator-fixed";
+		regulator-name = "evm_3v3";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+	};
 };
 
 &dra7_pmx_core {
@@ -32,6 +39,33 @@
 			0x424 (PIN_INPUT_PULLUP | MUX_MODE1) /* wakeup3.sys_nirq1 */
 		>;
 	};
+
+	mmc1_pins_default: mmc1_pins_default {
+		pinctrl-single,pins = <
+			0x36c (PIN_INPUT | MUX_MODE14)	/* mmc1sdcd.gpio219 */
+			0x354 (PIN_INPUT_PULLUP | MUX_MODE0) /* mmc1_clk.clk */
+			0x358 (PIN_INPUT_PULLUP | MUX_MODE0) /* mmc1_cmd.cmd */
+			0x35c (PIN_INPUT_PULLUP | MUX_MODE0) /* mmc1_dat0.dat0 */
+			0x360 (PIN_INPUT_PULLUP | MUX_MODE0) /* mmc1_dat1.dat1 */
+			0x364 (PIN_INPUT_PULLUP | MUX_MODE0) /* mmc1_dat2.dat2 */
+			0x368 (PIN_INPUT_PULLUP | MUX_MODE0) /* mmc1_dat3.dat3 */
+		>;
+	};
+
+	mmc2_pins_default: mmc2_pins_default {
+		pinctrl-single,pins = <
+			0x9c (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_a23.mmc2_clk */
+			0xb0 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_cs1.mmc2_cmd */
+			0xa0 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_a24.mmc2_dat0 */
+			0xa4 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_a25.mmc2_dat1 */
+			0xa8 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_a26.mmc2_dat2 */
+			0xac (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_a27.mmc2_dat3 */
+			0x8c (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_a19.mmc2_dat4 */
+			0x90 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_a20.mmc2_dat5 */
+			0x94 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_a21.mmc2_dat6 */
+			0x98 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_a22.mmc2_dat7 */
+		>;
+	};
 };
 
 &i2c1 {
@@ -159,3 +193,28 @@
 &uart1 {
 	status = "okay";
 };
+
+&mmc1 {
+	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&mmc1_pins_default>;
+
+	vmmc-supply = <&ldo1_reg>;
+	bus-width = <4>;
+	/*
+	 * SDCD signal is not being used here - using the fact that GPIO mode
+	 * is a viable alternative
+	 */
+	cd-gpios = <&gpio6 27 0>;
+};
+
+&mmc2 {
+	/* SW5-3 in ON position */
+	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&mmc2_pins_default>;
+
+	vmmc-supply = <&evm_3v3>;
+	bus-width = <8>;
+	ti,non-removable;
+};
-- 
1.7.9.5

