Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbaJITa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:30:59 -0400
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:45257
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751918AbaJITaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:30:05 -0400
From: John Crispin <blogic@openwrt.org>
To: Ralf Baechle <ralf@linux-mips.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: [PATCH 3/4] pinctrl: ralink: add binding documentation
Date: Thu,  9 Oct 2014 04:55:26 +0200
Message-Id: <1412823327-10296-4-git-send-email-blogic@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1412823327-10296-1-git-send-email-blogic@openwrt.org>
References: <1412823327-10296-1-git-send-email-blogic@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: John Crispin <blogic@openwrt.org>
---
 .../bindings/pinctrl/ralink,rt2880-pinmux.txt      |   74 ++++++++++++++++++++
 1 file changed, 74 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/ralink,rt2880-pinmux.txt

diff --git a/Documentation/devicetree/bindings/pinctrl/ralink,rt2880-pinmux.txt b/Documentation/devicetree/bindings/pinctrl/ralink,rt2880-pinmux.txt
new file mode 100644
index 0000000..20e6cc0
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/ralink,rt2880-pinmux.txt
@@ -0,0 +1,74 @@
+Ralink rt2880 pinmux controller
+
+Required properties:
+- compatible: "lantiq,rt2880-pinmux"
+- reg: Should contain the physical address and length of the gpio/pinmux
+  register range
+
+The rt2880 pinmux can only set the muxing of pin groups. muxing indiviual pins
+is not supported. There is no pinconf support.
+
+Definition of mux function groups:
+
+Required subnode-properties:
+- ralink,group : An array of strings. Each string contains the name of a group.
+  Valid values for these names are listed below.
+- ralink,function: A string containing the name of the function to mux to the
+  group. Valid values for function names are listed below.
+
+Valid values for group and function names:
+   mux groups (rt2880):
+    i2c, spi, uartlite, jtag, mdio, sdram, pci
+
+   mux functions (rt2880):
+    gpio, i2c, spi, uartlite, jtag, mdio, sdram, pci
+
+   mux groups (rt3050):
+    i2c, spi, uartf, uartlite, jtag, mdio, rgmii, sdram
+
+   mux functions (rt3050):
+    gpio, i2c, spi, uartf, pcm uartf, pcm i2s, i2s uartf, pcm gpio, gpio uartf,
+    gpio i2s, uartlite, jtag, mdio, sdram
+
+   mux groups (rt3352):
+    i2c, spi, uartf, uartlite, jtag, mdio, rgmii, lna, pna, led
+
+   mux functions (rt3050):
+    gpio, i2c, spi, uartf, pcm uartf, pcm i2s, i2s uartf, pcm gpio, gpio uartf,
+    gpio i2s, uartlite, jtag, mdio, lna, pna, led
+
+   mux groups (rt5350):
+    i2c, spi, uartf, uartlite, jtag, pna, led, spi cs1
+
+   mux functions (rt5350):
+    gpio, i2c, spi, uartf, pcm uartf, pcm i2s, i2s uartf, pcm gpio, gpio uartf,
+    gpio i2s, uartlite, jtag, spi_cs1, wdg
+
+
+Example:
+	pinctrl {
+		compatible = "ralink,rt2880-pinmux";
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&state_default>;
+
+		state_default: pinctrl0 {
+			sdram {
+				ralink,group = "sdram";
+				ralink,function = "sdram";
+			};
+		};
+
+		spi_pins: spi {
+			spi {
+				ralink,group = "spi";
+				ralink,function = "spi";
+			};
+		};
+		uartlite_pins: uartlite {
+			uart {
+				ralink,group = "uartlite";
+				ralink,function = "uartlite";
+			};
+		};
+	};
-- 
1.7.10.4

