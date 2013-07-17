Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab3GQLnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 07:43:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52623 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab3GQLni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 07:43:38 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH 3/3] ARM: dts: omap4-sdp: add dynamic pin states for uart3/4
Date: Wed, 17 Jul 2013 14:41:52 +0300
Message-ID: <1374061312-25469-4-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374061312-25469-1-git-send-email-grygorii.strashko@ti.com>
References: <1374061312-25469-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dynamic "active"/"idle" pin states for uart3/4 which will be applied
when uart3/4 state is switched from active to idle and back by Runtime
PM or during system suspend.

CC: Benoit Cousson <benoit.cousson@linaro.org>
CC: Linus Walleij <linus.walleij@linaro.org>
CC: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 arch/arm/boot/dts/omap4-sdp.dts |   34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-sdp.dts b/arch/arm/boot/dts/omap4-sdp.dts
index 7951b4e..2624504 100644
--- a/arch/arm/boot/dts/omap4-sdp.dts
+++ b/arch/arm/boot/dts/omap4-sdp.dts
@@ -181,18 +181,40 @@
 		pinctrl-single,pins = <
 			0x100 (PIN_INPUT_PULLUP | MUX_MODE0)	/* uart3_cts_rctx.uart3_cts_rctx */
 			0x102 (PIN_OUTPUT | MUX_MODE0)		/* uart3_rts_sd.uart3_rts_sd */
-			0x104 (PIN_INPUT | MUX_MODE0)		/* uart3_rx_irrx.uart3_rx_irrx */
 			0x106 (PIN_OUTPUT | MUX_MODE0)		/* uart3_tx_irtx.uart3_tx_irtx */
 		>;
 	};
 
+	uart3_pins_active: pinmux_uart3_pins_active {
+		pinctrl-single,pins = <
+			0x104 (PIN_INPUT | MUX_MODE0)		/* uart3_rx_irrx.uart3_rx_irrx */
+		>;
+	};
+
+	uart3_pins_idle: pinmux_uart3_pins_idle {
+		pinctrl-single,pins = <
+			0x104 (WAKEUP_EN | PIN_INPUT | MUX_MODE0)	/* uart3_rx_irrx.uart3_rx_irrx */
+		>;
+	};
+
 	uart4_pins: pinmux_uart4_pins {
 		pinctrl-single,pins = <
-			0x11c (PIN_INPUT | MUX_MODE0)		/* uart4_rx.uart4_rx */
 			0x11e (PIN_OUTPUT | MUX_MODE0)		/* uart4_tx.uart4_tx */
 		>;
 	};
 
+	uart4_pins_active: pinmux_uart4_pins_active {
+		pinctrl-single,pins = <
+			0x11c (PIN_INPUT | MUX_MODE0)		/* uart3_rx_irrx.uart3_rx_irrx */
+		>;
+	};
+
+	uart4_pins_idle: pinmux_uart4_pins_idle {
+		pinctrl-single,pins = <
+			0x11c (WAKEUP_EN | PIN_INPUT | MUX_MODE0)	/* uart3_rx_irrx.uart3_rx_irrx */
+		>;
+	};
+
 	twl6030_pins: pinmux_twl6030_pins {
 		pinctrl-single,pins = <
 			0x15e (WAKEUP_EN | PIN_INPUT_PULLUP | MUX_MODE0)	/* sys_nirq1.sys_nirq1 */
@@ -510,13 +532,17 @@
 };
 
 &uart3 {
-	pinctrl-names = "default";
+	pinctrl-names = "default", "active", "idle";
 	pinctrl-0 = <&uart3_pins>;
+	pinctrl-1 = <&uart3_pins_active>;
+	pinctrl-2 = <&uart3_pins_idle>;
 };
 
 &uart4 {
-	pinctrl-names = "default";
+	pinctrl-names = "default", "active", "idle";
 	pinctrl-0 = <&uart4_pins>;
+	pinctrl-1 = <&uart4_pins_active>;
+	pinctrl-2 = <&uart4_pins_idle>;
 };
 
 &mcbsp3 {
-- 
1.7.9.5

