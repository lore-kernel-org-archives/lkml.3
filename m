Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548Ab3BGMXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 07:23:48 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:40971 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758384Ab3BGMW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 07:22:59 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>, Andrew Lunn <andrew@lunn.ch>,
        Simon Guinot <simon.guinot@sequanux.org>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH] devicetree: Move NS2 LEDs binding into LEDs directory
Date: Thu,  7 Feb 2013 12:22:56 +0000
Message-Id: <1360239776-14889-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

leds-ns2.txt is a binding for LEDs, not GPIOs. Move the documentation in
with the rest of the LEDs bindings.

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Simon Guinot <simon.guinot@sequanux.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 .../devicetree/bindings/gpio/leds-ns2.txt          |   26 --------------------
 .../devicetree/bindings/leds/leds-ns2.txt          |   26 ++++++++++++++++++++
 2 files changed, 26 insertions(+), 26 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/gpio/leds-ns2.txt
 create mode 100644 Documentation/devicetree/bindings/leds/leds-ns2.txt

diff --git a/Documentation/devicetree/bindings/gpio/leds-ns2.txt b/Documentation/devicetree/bindings/gpio/leds-ns2.txt
deleted file mode 100644
index aef3aca..0000000
--- a/Documentation/devicetree/bindings/gpio/leds-ns2.txt
+++ /dev/null
@@ -1,26 +0,0 @@
-Binding for dual-GPIO LED found on Network Space v2 (and parents).
-
-Required properties:
-- compatible: "lacie,ns2-leds".
-
-Each LED is represented as a sub-node of the ns2-leds device.
-
-Required sub-node properties:
-- cmd-gpio: Command LED GPIO. See OF device-tree GPIO specification.
-- slow-gpio: Slow LED GPIO. See OF device-tree GPIO specification.
-
-Optional sub-node properties:
-- label: Name for this LED. If omitted, the label is taken from the node name.
-- linux,default-trigger: Trigger assigned to the LED.
-
-Example:
-
-ns2-leds {
-	compatible = "lacie,ns2-leds";
-
-	blue-sata {
-		label = "ns2:blue:sata";
-		slow-gpio = <&gpio0 29 0>;
-		cmd-gpio = <&gpio0 30 0>;
-	};
-};
diff --git a/Documentation/devicetree/bindings/leds/leds-ns2.txt b/Documentation/devicetree/bindings/leds/leds-ns2.txt
new file mode 100644
index 0000000..aef3aca
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/leds-ns2.txt
@@ -0,0 +1,26 @@
+Binding for dual-GPIO LED found on Network Space v2 (and parents).
+
+Required properties:
+- compatible: "lacie,ns2-leds".
+
+Each LED is represented as a sub-node of the ns2-leds device.
+
+Required sub-node properties:
+- cmd-gpio: Command LED GPIO. See OF device-tree GPIO specification.
+- slow-gpio: Slow LED GPIO. See OF device-tree GPIO specification.
+
+Optional sub-node properties:
+- label: Name for this LED. If omitted, the label is taken from the node name.
+- linux,default-trigger: Trigger assigned to the LED.
+
+Example:
+
+ns2-leds {
+	compatible = "lacie,ns2-leds";
+
+	blue-sata {
+		label = "ns2:blue:sata";
+		slow-gpio = <&gpio0 29 0>;
+		cmd-gpio = <&gpio0 30 0>;
+	};
+};
-- 
1.7.10.4

