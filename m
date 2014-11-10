Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaKJUfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:35:30 -0500
Received: from ring0.de ([5.45.105.125]:52931 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbaKJUfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:35:22 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv3 2/4] [media] si4713: add DT binding documentation
Date: Mon, 10 Nov 2014 21:34:42 +0100
Message-Id: <1415651684-3894-3-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415651684-3894-1-git-send-email-sre@kernel.org>
References: <1415651684-3894-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the DT bindings documentation for Silicon Labs Si4713 FM
radio transmitter.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 Documentation/devicetree/bindings/media/si4713.txt | 30 ++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/si4713.txt

diff --git a/Documentation/devicetree/bindings/media/si4713.txt b/Documentation/devicetree/bindings/media/si4713.txt
new file mode 100644
index 0000000..5ee5552
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/si4713.txt
@@ -0,0 +1,30 @@
+* Silicon Labs FM Radio transmitter
+
+The Silicon Labs Si4713 is an FM radio transmitter with receive power scan
+supporting 76-108 MHz. It includes an RDS encoder and has both, a stereo-analog
+and a digital interface, which supports I2S, left-justified and a custom
+DSP-mode format. It is programmable through an I2C interface.
+
+Required Properties:
+- compatible: Should contain "silabs,si4713"
+- reg: the I2C address of the device
+
+Optional Properties:
+- interrupts-extended: Interrupt specifier for the chips interrupt
+- reset-gpios: GPIO specifier for the chips reset line
+- vdd-supply: phandle for Vdd regulator
+- vio-supply: phandle for Vio regulator
+
+Example:
+
+&i2c2 {
+        fmtx: si4713@63 {
+                compatible = "silabs,si4713";
+                reg = <0x63>;
+
+                interrupts-extended = <&gpio2 21 IRQ_TYPE_EDGE_FALLING>; /* 53 */
+                reset-gpios = <&gpio6 3 GPIO_ACTIVE_HIGH>; /* 163 */
+                vio-supply = <&vio>;
+                vdd-supply = <&vaux1>;
+        };
+};
-- 
2.1.1

