Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbbA2FMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 00:12:33 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:49121 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbbA2FMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 00:12:30 -0500
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
To: <stern@rowland.harvard.edu>
CC: <gregkh@linuxfoundation.org>, <lars@metafoo.de>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <Zubair.Kakakhel@imgtec.com>
Subject: [PATCH_V3 1/3] dt: usb: jz4740: Add DT binding document for OHCI
Date: Wed, 28 Jan 2015 13:26:03 +0000
Message-ID: <1422451565-29096-2-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422451565-29096-1-git-send-email-Zubair.Kakakhel@imgtec.com>
References: <1422451565-29096-1-git-send-email-Zubair.Kakakhel@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Burton <paul.burton@imgtec.com>

Add the binding documentation for the JZ4740 OHCI controller.

Signed-off-by: Paul Burton <paul.burton@imgtec.com>
Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>

---
The jz4740 is platform only at the moment.

But DT support is being added

See http://patchwork.linux-mips.org/bundle/paulburton/ci20-v3.20/

V3 Changes: named binding jz4740 instead of confusing it with jz47xx.
The driver name is jz4740. And will not be renamed

V2 Changes: Removed interrupt parent binding as that can be inherited.
Forgot a binding for clock-names
---
 .../bindings/usb/ingenic,jz4740-ohci.txt           | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/ingenic,jz4740-ohci.txt

diff --git a/Documentation/devicetree/bindings/usb/ingenic,jz4740-ohci.txt b/Documentation/devicetree/bindings/usb/ingenic,jz4740-ohci.txt
new file mode 100644
index 0000000..9f05cca
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/ingenic,jz4740-ohci.txt
@@ -0,0 +1,26 @@
+Ingenic JZ4740 SoC OHCI controller binding
+
+The Ingenic JZ4740 SoC includes an OHCI compliant USB host controller
+interface for use with USB 1.1 devices.
+
+Required properties:
+ - compatible: Should be "ingenic,jz4740-ohci"
+ - reg: Should contain the address & size of the OHCI controller registers.
+ - interrupts: Should specify the interrupt line number
+ - clocks: Should contain a single clock specifier for the SoC UHC clock.
+ - clock-names: Must be "uhc"
+
+Example for jz4740:
+
+/ {
+	ohci: jz4780-ohci@0x134a0000 {
+		compatible = "ingenic,jz4740-ohci";
+		reg = <0x134a0000 0x10000>;
+
+		interrupts = <5>;
+
+		clocks = <&cgu JZ4740_CLK_UHC>;
+		clock-names = "uhc";
+	};
+};
+
-- 
1.9.1

