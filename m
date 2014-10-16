Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaJPTsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:48:18 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:36822 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbaJPTsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:48:12 -0400
X-Amavis-Alert: BAD HEADER, Duplicate header field: "In-Reply-To"
From: Stefan Agner <stefan@agner.ch>
To: linus.walleij@linaro.org, gnurou@gmail.com, shawn.guo@freescale.com,
        kernel@pengutronix.de
Cc: linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, bpringlemeir@nbsps.com,
        l.stach@pengutronix.de, stefan@agner.ch
Subject: [PATCH v5 4/4] Documentation: dts: add bindings for Vybrid GPIO/PORT module
Date: Thu, 16 Oct 2014 21:48:00 +0200
Message-Id: <12bd7950696ad30aa05348270df2e024ba113e63.1413488264.git.stefan@agner.ch>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <cover.1413488264.git.stefan@agner.ch>
References: <cover.1413488264.git.stefan@agner.ch>
In-Reply-To: <cover.1413488264.git.stefan@agner.ch>
References: <cover.1413488264.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Vybrid SoC device tree (vf610.dtsi) used this bindings since
its initial commit in May 2013. However, a proper gpiolib driver
was missing so far. With the addition of the gpiolib driver,
the bindings proved to be useful and complete, hence a good time
to add the documentation.

Signed-off-by: Stefan Agner <stefan@agner.ch>
Acked-by: Shawn Guo <shawn.guo@freescale.com>
---
 .../devicetree/bindings/gpio/gpio-vf610.txt        | 56 ++++++++++++++++++++++
 1 file changed, 56 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-vf610.txt

diff --git a/Documentation/devicetree/bindings/gpio/gpio-vf610.txt b/Documentation/devicetree/bindings/gpio/gpio-vf610.txt
new file mode 100644
index 0000000..da84121
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-vf610.txt
@@ -0,0 +1,56 @@
+* Freescale VF610 PORT/GPIO module
+
+The Freescale PORT/GPIO modules are two adjacent modules providing GPIO
+functionality. Each pair serves 32 GPIOs. The VF610 has 5 instances of
+each, and each PORT module has its own interrupt.
+
+Required properties for GPIO node:
+- compatible : Should be "fsl,<soc>-gpio", currently "fsl,vf610-gpio"
+- reg : The first reg tuple represents the PORT module, the second tuple
+  the GPIO module.
+- interrupts : Should be the port interrupt shared by all 32 pins.
+- gpio-controller : Marks the device node as a gpio controller.
+- #gpio-cells : Should be two. The first cell is the pin number and
+  the second cell is used to specify the gpio polarity:
+      0 = active high
+      1 = active low
+- interrupt-controller: Marks the device node as an interrupt controller.
+- #interrupt-cells : Should be 2.  The first cell is the GPIO number.
+  The second cell bits[3:0] is used to specify trigger type and level flags:
+      1 = low-to-high edge triggered.
+      2 = high-to-low edge triggered.
+      4 = active high level-sensitive.
+      8 = active low level-sensitive.
+
+Note: Each GPIO port should have an alias correctly numbered in "aliases"
+node.
+
+Examples:
+
+aliases {
+	gpio0 = &gpio1;
+	gpio1 = &gpio2;
+};
+
+gpio1: gpio@40049000 {
+	compatible = "fsl,vf610-gpio";
+	reg = <0x40049000 0x1000 0x400ff000 0x40>;
+	interrupts = <0 107 IRQ_TYPE_LEVEL_HIGH>;
+	gpio-controller;
+	#gpio-cells = <2>;
+	interrupt-controller;
+	#interrupt-cells = <2>;
+	gpio-ranges = <&iomuxc 0 0 32>;
+};
+
+gpio2: gpio@4004a000 {
+	compatible = "fsl,vf610-gpio";
+	reg = <0x4004a000 0x1000 0x400ff040 0x40>;
+	interrupts = <0 108 IRQ_TYPE_LEVEL_HIGH>;
+	gpio-controller;
+	#gpio-cells = <2>;
+	interrupt-controller;
+	#interrupt-cells = <2>;
+	gpio-ranges = <&iomuxc 0 32 32>;
+};
+
-- 
2.1.2

