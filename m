Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbaFGQA0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 12:00:26 -0400
Received: from lnfm1.sai.msu.ru ([93.180.26.255]:47825 "EHLO lnfm1.sai.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbaFGQAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 12:00:25 -0400
Date: Sat, 7 Jun 2014 20:00:10 +0400 (MSK)
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
To: Robert Nelson <robertcnelson@gmail.com>
cc: Benoit Cousson <bcousson@baylibre.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCHv2] dts: Add UARTs to am335x-bone-common.dtsi
In-Reply-To: <CAOCHtYjFT_96wxbsAUY4-aKAC7LmqVpFEGDfyLTODFQ-uy9e+A@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1406071955100.14484@lnfm1.sai.msu.ru>
References: <alpine.LRH.2.00.1406071845220.13290@lnfm1.sai.msu.ru> <CAOCHtYjFT_96wxbsAUY4-aKAC7LmqVpFEGDfyLTODFQ-uy9e+A@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 570b6d0f050aa00d301e2ee9000c8fcb6db75df1 Mon Sep 17 00:00:00 2001
From: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Date: Sat, 7 Jun 2014 17:23:57 +0400
Subject: [PATCH] Add UARTs to am335x-bone-common.dtsi

Add five UARTs pinouts and ports to Beagle Bone common dtsi.

Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
---
Changes from v1 of the patch:
  + add uart5 initially lost
  + left uarts disabled

  arch/arm/boot/dts/am335x-bone-common.dtsi | 50 +++++++++++++++++++++++++++++++
  1 file changed, 50 insertions(+)

diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dts/am335x-bone-common.dtsi
index 2e7d932..dad68a1 100644
--- a/arch/arm/boot/dts/am335x-bone-common.dtsi
+++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
@@ -90,6 +90,36 @@
  			0x174 (PIN_OUTPUT_PULLDOWN | MUX_MODE0)	/* uart0_txd.uart0_txd */
  		>;
  	};
+	uart1_pins: pinmux_uart1_pins {
+		pinctrl-single,pins = <
+			0x180 (PIN_INPUT_PULLUP | MUX_MODE0)	/* uart1_rxd.uart1_rxd */
+			0x184 (PIN_OUTPUT_PULLDOWN | MUX_MODE0)	/* uart1_txd.uart1_txd */
+		>;
+	};
+	uart2_pins: pinmux_uart2_pins {
+		pinctrl-single,pins = <
+			0x150 (PIN_INPUT_PULLUP | MUX_MODE1)	/* spi0_sclk.uart2_rxd */
+			0x154 (PIN_OUTPUT_PULLDOWN | MUX_MODE1)	/* spi0_d0.uart2_txd */
+		>;
+	};
+	uart3_pins: pinmux_uart3_pins {
+		pinctrl-single,pins = <
+	/* Pin 0x160 spi0_cs1.uart3_rxd is not exported to the expansion header. The port is half-duplex */
+			0x164 (PIN_OUTPUT_PULLDOWN | MUX_MODE1)	/* ecap0_in_pwm0_out.uart3_txd */
+		>;
+	};
+	uart4_pins: pinmux_uart4_pins {
+		pinctrl-single,pins = <
+			0x070 (PIN_INPUT_PULLUP | MUX_MODE6)	/* gpmc_wait0.uart4_rxd */
+			0x074 (PIN_OUTPUT_PULLDOWN | MUX_MODE6)	/* gpmc_wpn.uart4_txd */
+		>;
+	};
+	uart5_pins: pinmux_uart5_pins {
+		pinctrl-single,pins = <
+			0x0c4 (PIN_INPUT_PULLUP | MUX_MODE4)	/* lcd_data9.uart5_rxd */
+			0x0c0 (PIN_OUTPUT_PULLDOWN | MUX_MODE4)	/* lcd_data8.uart5_txd */
+		>;
+	};

  	clkout2_pin: pinmux_clkout2_pin {
  		pinctrl-single,pins = <
@@ -179,6 +209,26 @@

  	status = "okay";
  };
+&uart1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart1_pins>;
+};
+&uart2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart2_pins>;
+};
+&uart3 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart3_pins>;
+};
+&uart4 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart4_pins>;
+};
+&uart5 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart5_pins>;
+};

  &usb {
  	status = "okay";
-- 
1.8.1.4


