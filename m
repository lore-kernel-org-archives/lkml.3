Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbbAMNro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:47:44 -0500
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:40243 "EHLO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbbAMNrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:47:43 -0500
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2015 08:47:42 EST
From: Semen Protsenko <semen.protsenko@globallogic.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Marc Zyngier <maz@misterjones.org>,
        Grygorii Strashko <grygorii.strashko@globallogic.com>,
        Illia Smyrnov <illia.smyrnov@globallogic.com>
Subject: [PATCH 4/4] gpio: max732x: Add DT binding documentation
Date: Tue, 13 Jan 2015 15:41:45 +0200
Message-Id: <1421156505-16600-5-git-send-email-semen.protsenko@globallogic.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421156505-16600-1-git-send-email-semen.protsenko@globallogic.com>
References: <1421156505-16600-1-git-send-email-semen.protsenko@globallogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a devicetree binding documentation for the max732x driver.

Signed-off-by: Semen Protsenko <semen.protsenko@globallogic.com>
---
 .../devicetree/bindings/gpio/gpio-max732x.txt      |   59 ++++++++++++++++++++
 1 file changed, 59 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-max732x.txt

diff --git a/Documentation/devicetree/bindings/gpio/gpio-max732x.txt b/Documentation/devicetree/bindings/gpio/gpio-max732x.txt
new file mode 100644
index 0000000..5fdc843
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-max732x.txt
@@ -0,0 +1,59 @@
+* MAX732x-compatible I/O expanders
+
+Required properties:
+  - compatible: Should be one of the following:
+    - "maxim,max7319": For the Maxim MAX7319
+    - "maxim,max7320": For the Maxim MAX7320
+    - "maxim,max7321": For the Maxim MAX7321
+    - "maxim,max7322": For the Maxim MAX7322
+    - "maxim,max7323": For the Maxim MAX7323
+    - "maxim,max7324": For the Maxim MAX7324
+    - "maxim,max7325": For the Maxim MAX7325
+    - "maxim,max7326": For the Maxim MAX7326
+    - "maxim,max7327": For the Maxim MAX7327
+  - reg: I2C slave address for this device.
+  - gpio-controller: Marks the device node as a GPIO controller.
+  - #gpio-cells: Should be 2.
+    - first cell is the GPIO number
+    - second cell specifies GPIO flags, as defined in <dt-bindings/gpio/gpio.h>.
+      Only the GPIO_ACTIVE_HIGH and GPIO_ACTIVE_LOW flags are supported.
+
+Optional properties:
+
+  The I/O expander can detect input state changes, and thus optionally act as
+  an interrupt controller. When the expander interrupt line is connected all the
+  following properties must be set. For more information please see the
+  interrupt controller device tree bindings documentation available at
+  Documentation/devicetree/bindings/interrupt-controller/interrupts.txt.
+
+  - interrupt-controller: Identifies the node as an interrupt controller.
+  - #interrupt-cells: Number of cells to encode an interrupt source, shall be 2.
+    - first cell is the pin number
+    - second cell is used to specify flags
+  - interrupt-parent: phandle of the parent interrupt controller.
+  - interrupts: Interrupt specifier for the controllers interrupt.
+
+Please refer to gpio.txt in this directory for details of the common GPIO
+bindings used by client devices.
+
+Example 1. MAX7325 with interrupt support enabled (CONFIG_GPIO_MAX732X_IRQ=y):
+
+	expander: max7325@6d {
+		compatible = "maxim,max7325";
+		reg = <0x6d>;
+		gpio-controller;
+		#gpio-cells = <2>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+		interrupt-parent = <&gpio4>;
+		interrupts = <29 IRQ_TYPE_EDGE_FALLING>;
+	};
+
+Example 2. MAX7325 with interrupt support disabled (CONFIG_GPIO_MAX732X_IRQ=n):
+
+	expander: max7325@6d {
+		compatible = "maxim,max7325";
+		reg = <0x6d>;
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
-- 
1.7.9.5

