Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab3GJQWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 12:22:50 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55634 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab3GJQWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 12:22:48 -0400
From: Roger Quadros <rogerq@ti.com>
To: <stern@rowland.harvard.edu>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <sergei.shtylyov@cogentembedded.com>, <khilman@linaro.org>,
        <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH 2/6] ARM: dts: omap3beagle-xm: Add idle state pins for USB host
Date: Wed, 10 Jul 2013 19:22:18 +0300
Message-ID: <1373473338-27433-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1373473081-27181-1-git-send-email-rogerq@ti.com>
References: <1373473081-27181-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the Idle state pins for USB host and enable WAKEUP on
DIR, DAT0-3, so that the PHY can wakeup the OMAP SoC from
sleep on any USB activity (e.g. remote wakeup or connect/disconnect).

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap3-beagle-xm.dts |   29 +++++++++++++++++++++++------
 1 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts b/arch/arm/boot/dts/omap3-beagle-xm.dts
index 371b1e2..91d19fa 100644
--- a/arch/arm/boot/dts/omap3-beagle-xm.dts
+++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
@@ -113,11 +113,6 @@
 };
 
 &omap3_pmx_core {
-	pinctrl-names = "default";
-	pinctrl-0 = <
-			&hsusbb2_pins
-	>;
-
 	uart3_pins: pinmux_uart3_pins {
 		pinctrl-single,pins = <
 			0x16e (PIN_INPUT | PIN_OFF_WAKEUPENABLE | MUX_MODE0) /* uart3_rx_irrx.uart3_rx_irrx */
@@ -125,7 +120,7 @@
 		>;
 	};
 
-	hsusbb2_pins: pinmux_hsusbb2_pins {
+	hsusb2_pins: pinmux_hsusb2_pins {
 		pinctrl-single,pins = <
 			0x5c0 (PIN_OUTPUT | MUX_MODE3)		/* etk_d10.hsusb2_clk */
 			0x5c2 (PIN_OUTPUT | MUX_MODE3)		/* etk_d11.hsusb2_stp */
@@ -141,6 +136,25 @@
 			0x1ae (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_cs1.hsusb2_data3 */
 		>;
 	};
+
+	/* WAKEUP enabled on DIR, DAT0-3 */
+	hsusb2_idle_pins: pinmux_hsusb2_idle_pins {
+		pinctrl-single,pins = <
+			0x5c0 (PIN_OUTPUT | MUX_MODE3)		/* etk_d10.hsusb2_clk */
+			0x5c2 (PIN_OUTPUT | MUX_MODE3)		/* etk_d11.hsusb2_stp */
+			0x5c4 (PIN_INPUT_PULLDOWN | WAKEUP_EN | MUX_MODE3)	/* etk_d12.hsusb2_dir */
+			0x5c6 (PIN_INPUT_PULLDOWN | MUX_MODE3)			/* etk_d13.hsusb2_nxt */
+			0x5c8 (PIN_INPUT_PULLDOWN | WAKEUP_EN | MUX_MODE3)	/* etk_d14.hsusb2_data0 */
+			0x5cA (PIN_INPUT_PULLDOWN | WAKEUP_EN | MUX_MODE3)	/* etk_d15.hsusb2_data1 */
+			0x1a4 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi1_cs3.hsusb2_data2 */
+			0x1a6 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_clk.hsusb2_data7 */
+			0x1a8 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_simo.hsusb2_data4 */
+			0x1aa (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_somi.hsusb2_data5 */
+			0x1ac (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_cs0.hsusb2_data6 */
+			0x1ae (PIN_INPUT_PULLDOWN | WAKEUP_EN | MUX_MODE3)	/* mcspi2_cs1.hsusb2_data3 */
+		>;
+		interrupts = <77>; /* route padconf wakeup to EHCI IRQ */
+	};
 };
 
 &i2c1 {
@@ -223,6 +237,9 @@
 };
 
 &usbhshost {
+	pinctrl-names = "default", "idle";
+	pinctrl-0 = <&hsusb2_pins>;
+	pinctrl-1 = <&hsusb2_idle_pins>;
 	port2-mode = "ehci-phy";
 };
 
-- 
1.7.4.1

