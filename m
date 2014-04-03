Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaDCPYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:24:17 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:35000 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbaDCPYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:24:06 -0400
From: jon@ringle.org
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org
Cc: Jon Ringle <jringle@gridpoint.com>
Subject: [PATCH v5 2/2] serial: sc16is7xx: Add bindings documentation for the SC16IS7XX UARTs
Date: Thu,  3 Apr 2014 11:23:35 -0400
Message-Id: <1396538615-9128-2-git-send-email-jon@ringle.org>
X-Mailer: git-send-email 1.8.5.4
In-Reply-To: <1396538615-9128-1-git-send-email-jon@ringle.org>
References: <1396538615-9128-1-git-send-email-jon@ringle.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Ringle <jringle@gridpoint.com>

This patch adds the devicetree documentation for the NXP SC16IS7XX UARTs.

Signed-off-by: Jon Ringle <jringle@gridpoint.com>
---
 .../devicetree/bindings/serial/nxp,sc16is7xx.txt   | 33 ++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/serial/nxp,sc16is7xx.txt

diff --git a/Documentation/devicetree/bindings/serial/nxp,sc16is7xx.txt b/Documentation/devicetree/bindings/serial/nxp,sc16is7xx.txt
new file mode 100644
index 0000000..246c795
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/nxp,sc16is7xx.txt
@@ -0,0 +1,33 @@
+* NXP SC16IS7xx advanced Universal Asynchronous Receiver-Transmitter (UART)
+
+Required properties:
+- compatible: Should be one of the following:
+  - "nxp,sc16is740" for NXP SC16IS740,
+  - "nxp,sc16is741" for NXP SC16IS741,
+  - "nxp,sc16is750" for NXP SC16IS750,
+  - "nxp,sc16is752" for NXP SC16IS752,
+  - "nxp,sc16is760" for NXP SC16IS760,
+  - "nxp,sc16is762" for NXP SC16IS762.
+- reg: I2C address of the SC16IS7xx device.
+- interrupt-parent: The phandle for the interrupt controller that
+  services interrupts for this IC.
+- interrupts: Should contain the UART interrupt
+- clocks: Reference to the IC source clock.
+
+Optional properties:
+- gpio-controller: Marks the device node as a GPIO controller.
+- #gpio-cells: Should be two. The first cell is the GPIO number and
+  the second cell is used to specify the GPIO polarity:
+    0 = active high,
+    1 = active low.
+
+Example:
+        sc16is750: sc16is750@51 {
+                compatible = "nxp,sc16is750";
+                reg = <0x51>;
+                clocks = <&clk20m>;
+                interrupt-parent = <&gpio3>;
+                interrupts = <7 IRQ_TYPE_EDGE_FALLING>;
+                gpio-controller;
+                #gpio-cells = <2>;
+        };
-- 
1.8.5.4

