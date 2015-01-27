Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbbA0Nre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 08:47:34 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:26934 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbbA0Nra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 08:47:30 -0500
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
To: <stern@rowland.harvard.edu>
CC: <gregkh@linuxfoundation.org>, <lars@metafoo.de>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <Zubair.Kakakhel@imgtec.com>
Subject: [PATCH 1/3] dt: usb: jz4740: Add DT binding document for OHCI
Date: Tue, 27 Jan 2015 13:47:17 +0000
Message-ID: <1422366439-34641-2-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422366439-34641-1-git-send-email-Zubair.Kakakhel@imgtec.com>
References: <1422366439-34641-1-git-send-email-Zubair.Kakakhel@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Burton <paul.burton@imgtec.com>

Add the binding documentation for the JZ47xx OHCI controller.

Signed-off-by: Paul Burton <paul.burton@imgtec.com>
Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>

---
The jz4740 is platform only at the moment.

But DT support is being added

See http://patchwork.linux-mips.org/bundle/paulburton/ci20-v3.20/

jz47xx is used because jz4780 will also use this driver
---
 .../bindings/usb/ingenic,jz47xx-ohci.txt           | 28 ++++++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/ingenic,jz47xx-ohci.txt

diff --git a/Documentation/devicetree/bindings/usb/ingenic,jz47xx-ohci.txt b/Documentation/devicetree/bindings/usb/ingenic,jz47xx-ohci.txt
new file mode 100644
index 0000000..2fada8b
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/ingenic,jz47xx-ohci.txt
@@ -0,0 +1,28 @@
+Ingenic JZ47XX SoC OHCI controller binding
+
+The Ingenic JZ47XX SoC includes an OHCI compliant USB host controller
+interface for use with USB 1.1 devices.
+
+Required properties:
+ - compatible: Should be "ingenic,jz4740-ohci"
+ - reg: Should contain the address & size of the OHCI controller registers.
+ - interrupt-parent: Should be the phandle of the interrupt controller that
+   delivers interrupts to the OHCI block.
+ - interrupts: Should specify the interrupt provided by interrupt-parent.
+ - clocks: Should contain a single clock specifier for the SoC UHC clock.
+
+Example SoC include file for jz4780:
+
+/ {
+	ohci: jz4780-ohci@0x134a0000 {
+		compatible = "ingenic,jz4780-ohci";
+		reg = <0x134a0000 0x10000>;
+
+		interrupt-parent = <&intc>;
+		interrupts = <5>;
+
+		clocks = <&cgu JZ4780_CLK_UHC>;
+		clock-names = "uhc";
+	};
+};
+
-- 
1.9.1

