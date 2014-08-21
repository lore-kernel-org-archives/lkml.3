Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaHUQDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:03:05 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51493 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbaHUQCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:02:53 -0400
From: Nishanth Menon <nm@ti.com>
To: Dmitry Torokhov <dtor@mail.ru>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 1/2] doc: dt/bindings: input: introduce palmas power button description
Date: Thu, 21 Aug 2014 11:02:14 -0500
Message-ID: <1408636935-29515-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408636935-29515-1-git-send-email-nm@ti.com>
References: <1408392810-16011-1-git-send-email-nm@ti.com>
 <1408636935-29515-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many palmas family of PMICs have support for interrupt based power
button. This allows the device to notify the processor of external
push button events over the shared palmas interrupt.

Document the hardware support for the same.

Signed-off-by: Nishanth Menon <nm@ti.com>
---

Changes in v2:
 - Added debounce description for palmas variants like TWL6037 that
   actually allow it.
 - Review comments incorportated.
V1: https://patchwork.kernel.org/patch/4739061/

 .../bindings/input/ti,palmas-pwrbutton.txt         |   36 ++++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/ti,palmas-pwrbutton.txt

diff --git a/Documentation/devicetree/bindings/input/ti,palmas-pwrbutton.txt b/Documentation/devicetree/bindings/input/ti,palmas-pwrbutton.txt
new file mode 100644
index 0000000..a3dde8c
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/ti,palmas-pwrbutton.txt
@@ -0,0 +1,36 @@
+Texas Instruments Palmas family power button module
+
+This module is part of the Palmas family of PMICs. For more details
+about the whole chip see:
+Documentation/devicetree/bindings/mfd/palmas.txt.
+
+This module provides a simple power button event via an Interrupt.
+
+Required properties:
+- compatible: should be one of the following
+   - "ti,palmas-pwrbutton": For Palmas compatible power on button
+- interrupt-parent: Parent interrupt device, must be handle of palmas node.
+- interrupts: Interrupt number of power button submodule on device.
+
+Optional Properties:
+
+- ti,palmas-long-press-seconds: Duration in seconds which the power
+  button should be kept pressed for Palmas to power off automatically.
+  NOTE: This depends on OTP support and POWERHOLD signal configuration
+  on platform. Valid values are 6, 8, 10 and 12.
+- ti,palmas-pwron-debounce-milli-seconds: Duration in milliseconds
+  which the power button should be kept pressed for Palmas to register
+  a press for debouncing purposes. NOTE: This depends on specific
+  Palmas variation capability. Valid values are 15, 100, 500 and 1000.
+
+Example:
+
+&palmas {
+	palmas_pwr_button: pwrbutton {
+		compatible = "ti,palmas-pwrbutton";
+		interrupt-parent = <&tps659038>;
+		interrupts = <1 IRQ_TYPE_EDGE_FALLING>;
+		ti,palmas-long-press-seconds = <12>;
+		ti,palmas-pwron-debounce-milli-seconds = <15>;
+	};
+};
-- 
1.7.9.5

