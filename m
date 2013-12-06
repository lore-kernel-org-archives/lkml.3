Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab3LFAXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 19:23:14 -0500
Received: from ring0.de ([91.143.88.219]:39893 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756554Ab3LFAWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 19:22:46 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Luciano Coelho <luca@coelho.fi>,
        Tony Lindgren <tony@atomide.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, Sebastian Reichel <sre@debian.org>
Subject: [PATCHv2 5/5] Documentation: dt: wireless: Add wl1251
Date: Fri,  6 Dec 2013 01:22:16 +0100
Message-Id: <1386289336-26704-6-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1386289336-26704-1-git-send-email-sre@debian.org>
References: <1382890469-25286-1-git-send-email-sre@debian.org>
 <1386289336-26704-1-git-send-email-sre@debian.org>
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
1.8.4.3

