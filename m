Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab3LOX3E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 18:29:04 -0500
Received: from ring0.de ([91.143.88.219]:40150 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab3LOX26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 18:28:58 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        =?UTF-8?q?=27Beno=C3=AEt=20Cousson=27?= <bcousson@baylibre.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        =?UTF-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE=20=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@debian.org>
Subject: [RFCv4 05/11] Documentation: DT: omap-ssi binding documentation
Date: Mon, 16 Dec 2013 00:27:58 +0100
Message-Id: <1387150085-23173-6-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387150085-23173-1-git-send-email-sre@debian.org>
References: <1387150085-23173-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create device tree binding documentation for
OMAP Synchronous Serial Interface (SSI) device.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 Documentation/devicetree/bindings/hsi/omap_ssi.txt | 69 ++++++++++++++++++++++
 1 file changed, 69 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/hsi/omap_ssi.txt

diff --git a/Documentation/devicetree/bindings/hsi/omap_ssi.txt b/Documentation/devicetree/bindings/hsi/omap_ssi.txt
new file mode 100644
index 0000000..0a9efd8
--- /dev/null
+++ b/Documentation/devicetree/bindings/hsi/omap_ssi.txt
@@ -0,0 +1,69 @@
+OMAP SSI controller bindings
+
+Required properties:
+- compatible:		Should include "ti,omap3-ssi".
+- reg-names:		Contains the values "sys" and "gdd".
+- reg:			Contains a register specifier for each entry in
+			reg-names.
+- interrupt-names:      Contains the value "gdd_mpu".
+- interrupts: 		Contains interrupt information for each entry in
+			interrupt-names.
+- ranges		Represents the bus address mapping between the main
+			controller node and the child nodes below.
+- #address-cells	Should be set to <1>
+- #size-cells		Should be set to <1>
+
+Each port is represented as a sub-node of the ti,omap3-ssi device.
+
+Required Port sub-node properties:
+- compatible:		Should be set to the following value
+                        ti,omap3-ssi-port (applicable to OMAP34xx devices)
+- reg-names:		Contains the values "rx" and "tx".
+- reg:			Contains a register specifier for each entry in
+			reg-names.
+- interrupt-parent	Should be a phandle for the interrupt controller
+- interrupt-names:	Contains the values "mpu_irq0" and "mpu_irq1".
+- interrupts:		Contains interrupt information for each entry in
+			interrupt-names.
+- ti,ssi-cawake-gpio:	Defines which GPIO pin is used to signify CAWAKE
+			events for the port. This is an optional board-specific
+			property. If it's missing the port will not be
+			enabled.
+
+Example for Nokia N900:
+
+ssi-controller@48058000 {
+	compatible = "ti,omap3-ssi";
+
+	/* needed until hwmod is updated to use the compatible string */
+	ti,hwmods = "ssi";
+
+	reg = <0x48058000 0x1000>,
+	      <0x48059000 0x1000>;
+	reg-names = "sys",
+		    "gdd";
+
+	interrupts = <55>;
+	interrupt-names = "gdd_mpu";
+
+	#address-cells = <1>;
+	#size-cells = <1>;
+	ranges;
+
+	ssi-port@0 {
+		compatible = "ti,omap3-ssi-port";
+
+		reg = <0x4805a000 0x800>,
+		      <0x4805a800 0x800>;
+		reg-names = "tx",
+			    "rx";
+
+		interrupt-parent = <&intc>;
+		interrupts = <51>,
+			     <52>;
+		interrupt-names = "mpu_irq0",
+				  "mpu_irq1";
+
+		ti,ssi-cawake-gpio = <&gpio5 23 GPIO_ACTIVE_HIGH>; /* 151 */
+	}
+}
-- 
1.8.5.1

