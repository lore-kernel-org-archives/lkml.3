Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab3K3QyS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 11:54:18 -0500
Received: from ring0.de ([91.143.88.219]:36224 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348Ab3K3Qxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 11:53:44 -0500
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
Subject: [PATCHv4 2/2] dt: binding documentation for twl4030-keypad
Date: Sat, 30 Nov 2013 17:53:36 +0100
Message-Id: <1385830416-12900-3-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1385830416-12900-1-git-send-email-sre@debian.org>
References: <1383948866-32672-1-git-send-email-sre@debian.org>
 <1385830416-12900-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devicetree binding documentation for twl4030-keypad.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 .../devicetree/bindings/input/twl4030-keypad.txt   | 27 ++++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/twl4030-keypad.txt

diff --git a/Documentation/devicetree/bindings/input/twl4030-keypad.txt b/Documentation/devicetree/bindings/input/twl4030-keypad.txt
new file mode 100644
index 0000000..e4be2f7
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/twl4030-keypad.txt
@@ -0,0 +1,27 @@
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
+Example:
+	twl_keypad: keypad {
+		compatible = "ti,twl4030-keypad";
+		interrupts = <1>;
+		keypad,num-rows = <8>;
+		keypad,num-columns = <8>;
+	};
-- 
1.8.4.3

