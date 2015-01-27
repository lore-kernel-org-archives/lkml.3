Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328AbbA0ODp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:03:45 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:19708 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbbA0OCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:02:48 -0500
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
To: <stern@rowland.harvard.edu>
CC: <gregkh@linuxfoundation.org>, <lars@metafoo.de>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <Zubair.Kakakhel@imgtec.com>
Subject: [PATCH_V2 1/3] dt: usb: jz4740: Add DT binding document for OHCI
Date: Tue, 27 Jan 2015 14:02:34 +0000
Message-ID: <1422367356-38012-2-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422367356-38012-1-git-send-email-Zubair.Kakakhel@imgtec.com>
References: <1422367356-38012-1-git-send-email-Zubair.Kakakhel@imgtec.com>
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

V2 Changes: Removed interrupt parent binding as that can be inherited.
Forgot a binding for clock-names
---
 .../bindings/usb/ingenic,jz47xx-ohci.txt           | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/ingenic,jz47xx-ohci.txt

diff --git a/Documentation/devicetree/bindings/usb/ingenic,jz47xx-ohci.txt b/Documentation/devicetree/bindings/usb/ingenic,jz47xx-ohci.txt
new file mode 100644
index 0000000..2e5dce5
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/ingenic,jz47xx-ohci.txt
@@ -0,0 +1,26 @@
+Ingenic JZ47XX SoC OHCI controller binding
+
+The Ingenic JZ47XX SoC includes an OHCI compliant USB host controller
+interface for use with USB 1.1 devices.
+
+Required properties:
+ - compatible: Should be "ingenic,jz4740-ohci"
+ - reg: Should contain the address & size of the OHCI controller registers.
+ - interrupts: Should specify the interrupt line number
+ - clocks: Should contain a single clock specifier for the SoC UHC clock.
+ - clock-names: Must be "uhc"
+
+Example for jz4780:
+
+/ {
+	ohci: jz4780-ohci@0x134a0000 {
+		compatible = "ingenic,jz4780-ohci";
+		reg = <0x134a0000 0x10000>;
+
+		interrupts = <5>;
+
+		clocks = <&cgu JZ4780_CLK_UHC>;
+		clock-names = "uhc";
+	};
+};
+
-- 
1.9.1

