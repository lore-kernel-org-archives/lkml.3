Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab3LJIBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:01:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab3LJIB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:01:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Balaji T K <balajitk@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.12 16/62] ARM: dts: omap4-panda-common: Fix pin muxing for wl12xx
Date: Tue, 10 Dec 2013 00:00:47 -0800
Message-Id: <20131210080058.576284565@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210080057.415644748@linuxfoundation.org>
References: <20131210080057.415644748@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balaji T K <balajitk@ti.com>

commit 2ba2866f782f7f1c38abc3dd56d3295efd289264 upstream.

pin mux wl12xx_gpio and wl12xx_pins should be part of omap4_pmx_core
and not omap4_pmx_wkup. So, move wl12xx_* to omap4_pmx_core.

Fix the following error message:
pinctrl-single 4a31e040.pinmux: mux offset out of range: 0x38 (0x38)
pinctrl-single 4a31e040.pinmux: could not add functions for pinmux_wl12xx_pins 56x

SDIO card is not detected after moving pin mux to omap4_pmx_core since
sdmmc5_clk pull is disabled. Enable Pull up on sdmmc5_clk to detect SDIO card.

This fixes a regression where WLAN did not work after a warm reset
or after one up/down cycle that happened when we move omap4 to boot
using device tree only. For reference, the kernel bug is described at:

https://bugzilla.kernel.org/show_bug.cgi?id=63821

Signed-off-by: Balaji T K <balajitk@ti.com>
[tony@atomide.com: update comments to describe the regression]
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/omap4-panda-common.dtsi |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/arch/arm/boot/dts/omap4-panda-common.dtsi
+++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
@@ -239,15 +239,6 @@
 			0xf0 (PIN_INPUT_PULLUP | MUX_MODE0)	/* i2c4_sda */
 		>;
 	};
-};
-
-&omap4_pmx_wkup {
-	led_wkgpio_pins: pinmux_leds_wkpins {
-		pinctrl-single,pins = <
-			0x1a (PIN_OUTPUT | MUX_MODE3)	/* gpio_wk7 */
-			0x1c (PIN_OUTPUT | MUX_MODE3)	/* gpio_wk8 */
-		>;
-	};
 
 	/*
 	 * wl12xx GPIO outputs for WLAN_EN, BT_EN, FM_EN, BT_WAKEUP
@@ -267,7 +258,7 @@
 		pinctrl-single,pins = <
 			0x38 (PIN_INPUT | MUX_MODE3)		/* gpmc_ncs2.gpio_52 */
 			0x3a (PIN_INPUT | MUX_MODE3)		/* gpmc_ncs3.gpio_53 */
-			0x108 (PIN_OUTPUT | MUX_MODE0)		/* sdmmc5_clk.sdmmc5_clk */
+			0x108 (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc5_clk.sdmmc5_clk */
 			0x10a (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc5_cmd.sdmmc5_cmd */
 			0x10c (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc5_dat0.sdmmc5_dat0 */
 			0x10e (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc5_dat1.sdmmc5_dat1 */
@@ -276,6 +267,15 @@
 		>;
 	};
 };
+
+&omap4_pmx_wkup {
+	led_wkgpio_pins: pinmux_leds_wkpins {
+		pinctrl-single,pins = <
+			0x1a (PIN_OUTPUT | MUX_MODE3)	/* gpio_wk7 */
+			0x1c (PIN_OUTPUT | MUX_MODE3)	/* gpio_wk8 */
+		>;
+	};
+};
 
 &i2c1 {
 	pinctrl-names = "default";


