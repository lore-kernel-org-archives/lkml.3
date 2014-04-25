Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149AbaDYTIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 15:08:13 -0400
Received: from ring0.de ([5.45.105.125]:50555 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108AbaDYTH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 15:07:57 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
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
        Aaro Koskinen <aaro.koskinen@iki.fi>, Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv4 09/13] Documentation: DT: omap-ssi binding documentation
Date: Fri, 25 Apr 2014 21:06:12 +0200
Message-Id: <1398452776-28638-10-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398452776-28638-1-git-send-email-sre@kernel.org>
References: <1398452776-28638-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create device tree binding documentation for
OMAP Synchronous Serial Interface (SSI) device.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
Reviewed-by: Pavel Machek <pavel@ucw.cz>
---
 Documentation/devicetree/bindings/hsi/omap-ssi.txt | 97 ++++++++++++++++++++++
 1 file changed, 97 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/hsi/omap-ssi.txt

diff --git a/Documentation/devicetree/bindings/hsi/omap-ssi.txt b/Documentation/devicetree/bindings/hsi/omap-ssi.txt
new file mode 100644
index 0000000..f26625e
--- /dev/null
+++ b/Documentation/devicetree/bindings/hsi/omap-ssi.txt
@@ -0,0 +1,97 @@
+OMAP SSI controller bindings
+
+OMAP Synchronous Serial Interface (SSI) controller implements a legacy
+variant of MIPI's High Speed Synchronous Serial Interface (HSI).
+
+Required properties:
+- compatible:		Should include "ti,omap3-ssi".
+- reg-names:		Contains the values "sys" and "gdd" (in this order).
+- reg:			Contains a matching register specifier for each entry
+			in reg-names.
+- interrupt-names:	Contains the value "gdd_mpu".
+- interrupts: 		Contains matching interrupt information for each entry
+			in interrupt-names.
+- ranges:		Represents the bus address mapping between the main
+			controller node and the child nodes below.
+- clock-names:		Must include the following entries:
+  "ssi_ssr_fck": The OMAP clock of that name
+  "ssi_sst_fck": The OMAP clock of that name
+  "ssi_ick": The OMAP clock of that name
+- clocks:		Contains a matching clock specifier for each entry in
+			clock-names.
+- #address-cells:	Should be set to <1>
+- #size-cells:		Should be set to <1>
+
+Each port is represented as a sub-node of the ti,omap3-ssi device.
+
+Required Port sub-node properties:
+- compatible:		Should be set to the following value
+			ti,omap3-ssi-port (applicable to OMAP34xx devices)
+- reg-names:		Contains the values "tx" and "rx" (in this order).
+- reg:			Contains a matching register specifier for each entry
+			in reg-names.
+- interrupt-parent	Should be a phandle for the interrupt controller
+- interrupts:		Should contain interrupt specifiers for mpu interrupts
+			0 and 1 (in this order).
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
+	clocks = <&ssi_ssr_fck>,
+		 <&ssi_sst_fck>,
+		 <&ssi_ick>;
+	clock-names = "ssi_ssr_fck",
+		      "ssi_sst_fck",
+		      "ssi_ick";
+
+	#address-cells = <1>;
+	#size-cells = <1>;
+	ranges;
+
+	ssi-port@4805a000 {
+		compatible = "ti,omap3-ssi-port";
+
+		reg = <0x4805a000 0x800>,
+		      <0x4805a800 0x800>;
+		reg-names = "tx",
+			    "rx";
+
+		interrupt-parent = <&intc>;
+		interrupts = <67>,
+			     <68>;
+
+		ti,ssi-cawake-gpio = <&gpio5 23 GPIO_ACTIVE_HIGH>; /* 151 */
+	}
+
+	ssi-port@4805a000 {
+		compatible = "ti,omap3-ssi-port";
+
+		reg = <0x4805b000 0x800>,
+		      <0x4805b800 0x800>;
+		reg-names = "tx",
+			    "rx";
+
+		interrupt-parent = <&intc>;
+		interrupts = <69>,
+			     <70>;
+
+		status = "disabled"; /* second port is not used on N900 */
+	}
+}
-- 
1.9.2

