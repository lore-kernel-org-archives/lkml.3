Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbaAWGjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 01:39:42 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:59057 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaAWGjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 01:39:40 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Rob Herring <robh+dt@kernel.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH] serial: vt8500: Add missing binding document for arch-vt8500 serial driver.
Date: Thu, 23 Jan 2014 19:30:28 +1300
Message-Id: <1390458628-30152-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The binding document for the vt8500/wm8xxx SoC UART driver is missing.
This patch adds the binding document.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 .../devicetree/bindings/serial/vt8500-uart.txt     |   26 ++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/serial/vt8500-uart.txt

diff --git a/Documentation/devicetree/bindings/serial/vt8500-uart.txt b/Documentation/devicetree/bindings/serial/vt8500-uart.txt
new file mode 100644
index 0000000..795c393
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/vt8500-uart.txt
@@ -0,0 +1,26 @@
+* VIA VT8500 and WonderMedia WM8xxx UART Controller
+
+Required properties:
+- compatible: should be "via,vt8500-uart"
+
+- reg: base physical address of the controller and length of memory mapped
+	region.
+
+- interrupts: hardware interrupt number
+
+- clocks: shall be the input parent clock phandle for the clock. This should
+	be the 24Mhz reference clock.
+
+Aliases may be defined to ensure the correct ordering of the uarts.
+
+Example:
+	aliases {
+		serial0 = &uart0;
+	};
+
+	uart0: serial@d8200000 {
+		compatible = "via,vt8500-uart";
+		reg = <0xd8200000 0x1040>;
+		interrupts = <32>;
+		clocks = <&clkuart0>;
+	};
-- 
1.7.9.5

