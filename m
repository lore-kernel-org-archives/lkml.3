Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab3KHWSc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 17:18:32 -0500
Received: from ring0.de ([91.143.88.219]:60327 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758528Ab3KHWSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 17:18:30 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sebastian Reichel <sre@debian.org>
Subject: [PATCHv3 2/2] dt: binding documentation for twl4030-keypad
Date: Fri,  8 Nov 2013 23:14:26 +0100
Message-Id: <1383948866-32672-3-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383948866-32672-1-git-send-email-sre@debian.org>
References: <1383948866-32672-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devicetree binding documentation for twl4030-keypad.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 .../devicetree/bindings/input/twl4030-keypad.txt   | 31 ++++++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/twl4030-keypad.txt

diff --git a/Documentation/devicetree/bindings/input/twl4030-keypad.txt b/Documentation/devicetree/bindings/input/twl4030-keypad.txt
new file mode 100644
index 0000000..901d10f
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/twl4030-keypad.txt
@@ -0,0 +1,31 @@
+* TWL4030's Keypad Controller device tree bindings
+
+TWL4030's Keypad controller is used to interface a SoC with a matrix-type
+keypad device. The keypad controller supports multiple row and column lines.
+A key can be placed at each intersection of a unique row and a unique column.
+The keypad controller can sense a key-press and key-release and report the
+event using a interrupt to the cpu.
+
+This binding is based on the matrix-keymap binding with the following
+changes:
+
+ * keypad,num-rows and keypad,num-columns are required.
+
+Required SoC Specific Properties:
+- compatible: should be one of the following
+   - "ti,twl4030-keypad": For controllers compatible with twl4030 keypad
+      controller.
+- interrupt: should be one of the following
+   - <1>: For controllers compatible with twl4030 keypad controller.
+
+Optional Properties specific to linux:
+- linux,keypad-no-autorepeat: do not enable autorepeat feature.
+
+Example:
+	twl_keypad: keypad {
+		compatible = "ti,twl4030-keypad";
+		interrupts = <1>;
+		keypad,num-rows = <8>;
+		keypad,num-columns = <8>;
+		linux,keypad-no-autorepeat;
+	};
-- 
1.8.4.rc3

