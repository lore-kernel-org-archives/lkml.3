Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934010Ab3JOVLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 17:11:22 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:58760 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933818Ab3JOVLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 17:11:20 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/5] mfd: tc3589x: add device tree bindings
Date: Tue, 15 Oct 2013 23:11:15 +0200
Message-Id: <1381871475-21543-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This defines the device tree bindings for the Toshiba TC3589x
series of multi-purpose expanders. Only the stuff I can test
is defined: GPIO and keypad. Others may implement more
subdevices further down the road.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/devicetree/bindings/mfd/tc3589x.txt | 61 +++++++++++++++++++++++
 1 file changed, 61 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/tc3589x.txt

diff --git a/Documentation/devicetree/bindings/mfd/tc3589x.txt b/Documentation/devicetree/bindings/mfd/tc3589x.txt
new file mode 100644
index 0000000..121301d
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/tc3589x.txt
@@ -0,0 +1,61 @@
+* Toshiba TC3589x multi-purpose expander
+
+The Toshiba TC3589x series are I2C-based MFD devices which may expose the
+following built-in devices: gpio, keypad, rotator (vibrator), PWM (for
+e.g. LEDs or vibrators) The included models are:
+
+- TC35890
+- TC35892
+- TC35893
+- TC35894
+- TC35895
+- TC35896
+
+Required properties:
+ - compatible : must be "toshiba,tc35890", "toshiba,tc35892", "toshiba,tc35893",
+   "toshiba,tc35894", "toshiba,tc35895" or "toshiba,tc35896"
+ - reg : I2C address of the device
+ - interrupt-parent : specifies which IRQ controller we're connected to
+ - interrupts : the interrupt on the parent the controller is connected to
+ - interrupt-controller : marks the device node as an interrupt controller
+ - #interrupt-cells : should be <1>, the first cell is the IRQ offset on this
+   TC3589x interrupt controller.
+
+Optional nodes:
+
+- GPIO
+  This GPIO module inside the TC3589x has 24 (TC35890, TC35892) or 20
+  (other models) GPIO lines.
+ - compatible : must be "toshiba,tc3589x-gpio"
+ - interrupts : interrupt on the parent, which must be the tc3589x MFD device
+ - interrupt-controller : marks the device node as an interrupt controller
+ - #interrupt-cells : should be <2>, the first cell is the IRQ offset on this
+   TC3589x GPIO interrupt controller, the second cell is the interrupt flags
+   in accordance with <dt-bindings/interrupt-controller/irq.h>. The following
+   flags are valid:
+   - IRQ_TYPE_LEVEL_LOW
+   - IRQ_TYPE_LEVEL_HIGH
+   - IRQ_TYPE_EDGE_RISING
+   - IRQ_TYPE_EDGE_FALLING
+   - IRQ_TYPE_EDGE_BOTH
+ - gpio-controller : marks the device node as a GPIO controller
+ - #gpio-cells : should be <2>, the first cell is the GPIO offset on this
+   GPIO controller, the second cell is the flags.
+
+- Keypad
+  This keypad is the same on all variants, supporting up to 96 different
+  keys. The linux-specific properties are modeled on those already existing
+  in other input drivers.
+ - compatible : must be "toshiba,tc3589x-keypad"
+ - debounce-delay-ms : debounce interval in milliseconds
+ - keypad,num-rows : number of rows in the matrix, see
+   bindings/input/matrix-keymap.txt
+ - keypad,num-columns : number of columns in the matrix, see
+   bindings/input/matrix-keymap.txt
+ - linux,keymap: the definition can be found in
+   bindings/input/matrix-keymap.txt
+ - linux,no-autorepeat: do no enable autorepeat feature.
+ - linux,wakeup: use any event on keypad as wakeup event.
+
+Example:
+
-- 
1.8.3.1

