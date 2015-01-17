Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbbAQSQn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 13:16:43 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37001 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbbAQSQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 13:16:39 -0500
From: Beniamino Galvani <b.galvani@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>, Carlo Caione <carlo@caione.org>
Cc: linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v4 3/3] ARM: dts: meson8: add pinctrl node
Date: Sat, 17 Jan 2015 19:15:16 +0100
Message-Id: <1421518516-26976-4-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421518516-26976-1-git-send-email-b.galvani@gmail.com>
References: <1421518516-26976-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pinctrl node to the DTSI file for meson8 and sub-nodes for some
standard mux configurations.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 arch/arm/boot/dts/meson8.dtsi | 68 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/arch/arm/boot/dts/meson8.dtsi b/arch/arm/boot/dts/meson8.dtsi
index 1f442a7..a2ddcb8 100644
--- a/arch/arm/boot/dts/meson8.dtsi
+++ b/arch/arm/boot/dts/meson8.dtsi
@@ -43,6 +43,7 @@
  *     OTHER DEALINGS IN THE SOFTWARE.
  */
 
+#include <dt-bindings/gpio/meson8-gpio.h>
 /include/ "meson.dtsi"
 
 / {
@@ -89,4 +90,71 @@
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
+			      <0xc11080e8 0x18>,
+			      <0xc1108120 0x18>,
+			      <0xc1108030 0x30>;
+			reg-names = "mux", "pull", "pull-enable", "gpio";
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
+		uart_ao_a_pins: uart_ao_a {
+			mux {
+				groups = "uart_tx_ao_a", "uart_rx_ao_a";
+				function = "uart_ao";
+			};
+		};
+
+		i2c_ao_pins: i2c_mst_ao {
+			mux {
+				groups = "i2c_mst_sck_ao", "i2c_mst_sda_ao";
+				function = "i2c_mst_ao";
+			};
+		};
+
+		spi_nor_pins: nor {
+			mux {
+				groups = "nor_d", "nor_q", "nor_c", "nor_cs";
+				function = "nor";
+			};
+		};
+
+		ir_recv_pins: remote {
+			mux {
+				groups = "remote_input";
+				function = "remote";
+			};
+		};
+
+		eth_pins: ethernet {
+			mux {
+				groups = "eth_tx_clk_50m", "eth_tx_en",
+					 "eth_txd1", "eth_txd0",
+					 "eth_rx_clk_in", "eth_rx_dv",
+					 "eth_rxd1", "eth_rxd0", "eth_mdio",
+					 "eth_mdc";
+				function = "ethernet";
+			};
+		};
+	};
+
 }; /* end of / */
-- 
2.1.4

