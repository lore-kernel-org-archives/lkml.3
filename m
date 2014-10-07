Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbaJGVe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 17:34:56 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:39200 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbaJGVey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 17:34:54 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Carlo Caione <carlo@caione.org>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH 3/3] ARM: dts: meson8: add pinctrl and gpio nodes
Date: Tue,  7 Oct 2014 23:32:56 +0200
Message-Id: <1412717576-19737-4-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412717576-19737-1-git-send-email-b.galvani@gmail.com>
References: <1412717576-19737-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pinctrl node to meson8.dtsi and gpio-leds node to
meson8-vega-s89e.dts

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 arch/arm/boot/dts/meson8-vega-s89e.dts | 16 +++++++++++++++-
 arch/arm/boot/dts/meson8.dtsi          | 35 ++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/meson8-vega-s89e.dts b/arch/arm/boot/dts/meson8-vega-s89e.dts
index 950998f..70a05c1 100644
--- a/arch/arm/boot/dts/meson8-vega-s89e.dts
+++ b/arch/arm/boot/dts/meson8-vega-s89e.dts
@@ -45,7 +45,9 @@
 
 
 /dts-v1/;
-/include/ "meson8.dtsi"
+#include "meson8.dtsi"
+#include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/gpio/meson8-gpio.h>
 
 / {
 	model = "Tronsmart Vega S89 Elite";
@@ -58,8 +60,20 @@
 	memory {
 		reg = <0x40000000 0x80000000>;
 	};
+
+	gpio-leds {
+		compatible = "gpio-leds";
+
+		power {
+			gpios = <&gpio_ao GPIO_TEST_N GPIO_ACTIVE_LOW>;
+			linux,default-trigger = "none";
+		};
+	};
+
 };
 
 &uart_AO {
 	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart_ao_a>;
 };
diff --git a/arch/arm/boot/dts/meson8.dtsi b/arch/arm/boot/dts/meson8.dtsi
index 1f442a7..59c3af0 100644
--- a/arch/arm/boot/dts/meson8.dtsi
+++ b/arch/arm/boot/dts/meson8.dtsi
@@ -89,4 +89,39 @@
 		compatible = "fixed-clock";
 		clock-frequency = <141666666>;
 	};
+
+	pinctrl: pinctrl@c1109880 {
+		compatible = "amlogic,meson8-pinctrl";
+		reg = <0xc1109880 0x10>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		gpio: banks@c11080b0 {
+			reg = <0xc11080b0 0x28>,
+			      <0xc11080e4 0x18>,
+			      <0xc1108120 0x18>,
+			      <0xc1108030 0x30>;
+			reg-names = "mux", "pull-enable", "pull", "gpio";
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
+
+		gpio_ao: ao-bank@c1108030 {
+			reg = <0xc8100014 0x4>,
+			      <0xc810002c 0x4>,
+			      <0xc8100024 0x8>;
+			reg-names = "mux", "pull", "gpio";
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
+
+		uart_ao_a: uart_ao_a {
+			uart_ao_a {
+				pins = "uart_tx_ao_a", "uart_rx_ao_a";
+				function = "uart_ao";
+			};
+		};
+	};
+
 }; /* end of / */
-- 
1.9.1

