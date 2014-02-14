Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaBNXHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 18:07:39 -0500
Received: from ring0.de ([5.45.105.125]:33089 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258AbaBNXHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 18:07:07 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Luciano Coelho <luca@coelho.fi>,
        Tony Lindgren <tony@atomide.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, Sebastian Reichel <sre@debian.org>
Subject: [PATCHv2 5/5] Documentation: dt: wireless: Add wl1251
Date: Sat, 15 Feb 2014 00:05:56 +0100
Message-Id: <1392419156-14394-6-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392419156-14394-1-git-send-email-sre@debian.org>
References: <20140125000929.GD25488@atomide.com>
 <1392419156-14394-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree binding documentation for Texas Instrument's wl1251
wireless lan chip. For now only the SPI binding is documented.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 .../devicetree/bindings/net/wireless/ti,wl1251.txt | 39 ++++++++++++++++++++++
 1 file changed, 39 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt b/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
new file mode 100644
index 0000000..189ae5c
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
@@ -0,0 +1,39 @@
+* Texas Instruments wl1251 wireless lan controller
+
+The wl1251 chip can be connected via SPI or via SDIO. This
+document describes the binding for the SPI connected chip.
+
+Required properties:
+- compatible :        Should be "ti,wl1251"
+- reg :               Chip select address of device
+- spi-max-frequency : Maximum SPI clocking speed of device in Hz
+- interrupts :        Should contain interrupt line
+- interrupt-parent :  Should be the phandle for the interrupt controller
+                      that services interrupts for this device
+- vio-supply :        phandle to regulator providing VIO
+- ti,power-gpio :     GPIO connected to chip's PMEN pin
+
+Optional properties:
+- ti,wl1251-has-eeprom : boolean, the wl1251 has an eeprom connected, which
+                         provides configuration data (calibration, MAC, ...)
+- Please consult Documentation/devicetree/bindings/spi/spi-bus.txt
+  for optional SPI connection related properties,
+
+Examples:
+
+&spi1 {
+	wl1251@0 {
+		compatible = "ti,wl1251";
+
+		reg = <0>;
+		spi-max-frequency = <48000000>;
+		spi-cpol;
+		spi-cpha;
+
+		interrupt-parent = <&gpio2>;
+		interrupts = <10 IRQ_TYPE_NONE>; /* gpio line 42 */
+
+		vio-supply = <&vio>;
+		ti,power-gpio = <&gpio3 23 GPIO_ACTIVE_HIGH>; /* 87 */
+	};
+};
-- 
1.8.5.3

