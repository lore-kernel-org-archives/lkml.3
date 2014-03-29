Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbaC2Aev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 20:34:51 -0400
Received: from ring0.de ([5.45.105.125]:43231 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305AbaC2Aes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 20:34:48 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        =?UTF-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE=20=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv3 14/14] DTS: ARM: OMAP3-N900: Add modem support
Date: Sat, 29 Mar 2014 01:31:50 +0100
Message-Id: <1396053110-21639-15-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396053110-21639-1-git-send-email-sre@kernel.org>
References: <1396053110-21639-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add modem device tree data to Nokia N900's DTS file.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 arch/arm/boot/dts/omap3-n900.dts | 41 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 5bccd8c..6655790 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -158,6 +158,17 @@
 			0x15a (PIN_OUTPUT | MUX_MODE1)		/* ssi1_wake */
 		>;
 	};
+
+	modem_pins: pinmux_modem {
+		pinctrl-single,pins = <
+			0x0ac (PIN_OUTPUT | MUX_MODE4)		/* gpio 70 => cmt_apeslpx */
+			0x0b0 (PIN_INPUT | WAKEUP_EN | MUX_MODE4) /* gpio 72 => ape_rst_rq */
+			0x0b2 (PIN_OUTPUT | MUX_MODE4)		/* gpio 73 => cmt_rst_rq */
+			0x0b4 (PIN_OUTPUT | MUX_MODE4)		/* gpio 74 => cmt_en */
+			0x0b6 (PIN_OUTPUT | MUX_MODE4)		/* gpio 75 => cmt_rst */
+			0x15e (PIN_OUTPUT | MUX_MODE4)		/* gpio 157 => cmt_bsi */
+		>;
+	};
 };
 
 &i2c1 {
@@ -508,6 +519,36 @@
 	pinctrl-0 = <&ssi_pins>;
 
 	ti,ssi-cawake-gpio = <&gpio5 23 GPIO_ACTIVE_HIGH>; /* 151 */
+
+	modem: hsi-client {
+		compatible = "nokia,n900-modem";
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&modem_pins>;
+
+		reg = <0>, <1>, <2>, <3>;
+		reg-names = "mcsaab-control",
+			    "speech-control",
+			    "speech-data",
+			    "mcsaab-data";
+		hsi-speed-kbps = <55000>;
+		hsi-mode = "frame";
+		hsi-flow = "synchronized";
+		hsi-arb-mode = "round-robin";
+
+		interrupts-extended = <&gpio3 8 IRQ_TYPE_EDGE_FALLING>; /* 72 */
+
+		gpios = <&gpio3  6 GPIO_ACTIVE_HIGH>, /* 70 */
+			<&gpio3  9 GPIO_ACTIVE_HIGH>, /* 73 */
+			<&gpio3 10 GPIO_ACTIVE_HIGH>, /* 74 */
+			<&gpio3 11 GPIO_ACTIVE_HIGH>, /* 75 */
+			<&gpio5 29 GPIO_ACTIVE_HIGH>; /* 157 */
+		gpio-names = "cmt_apeslpx",
+			     "cmt_rst_rq",
+			     "cmt_en",
+			     "cmt_rst",
+			     "cmt_bsi";
+	};
 };
 
 &ssi_port2 {
-- 
1.9.0

