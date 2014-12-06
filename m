Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbaLFXQG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 18:16:06 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:61050 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaLFXQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 18:16:03 -0500
From: vishnupatekar <vishnupatekar0510@gmail.com>
X-Google-Original-From: vishnupatekar <VishnuPatekar0510@gmail.com>
To: linux-sunxi@googlegroups.com, dmitry.torokhov@gmail.com,
        maxime.ripard@free-electrons.com, linux@arm.linux.org.uk
Cc: leafy.myeh@newbietech.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org,
        vishnupatekar <VishnuPatekar0510@gmail.com>
Subject: [PATCHv2 1/3] sunxi:dts-bindings:input:ps2 bindings for A10/A20 ps2.
Date: Sun,  7 Dec 2014 04:45:17 +0530
Message-Id: <1417907719-26775-2-git-send-email-VishnuPatekar0510@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417907719-26775-1-git-send-email-VishnuPatekar0510@gmail.com>
References: <1417907719-26775-1-git-send-email-VishnuPatekar0510@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A10 and A20 have same PS2 addresses, clocks, interrupts.
added compatible as allwinner,sun4i-a10-ps2.

Signed-off-by: vishnupatekar <VishnuPatekar0510@gmail.com>
---
 .../bindings/input/allwinner,sunxi-ps2.txt         |   23 ++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/allwinner,sunxi-ps2.txt

diff --git a/Documentation/devicetree/bindings/input/allwinner,sunxi-ps2.txt b/Documentation/devicetree/bindings/input/allwinner,sunxi-ps2.txt
new file mode 100644
index 0000000..3a8919a
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/allwinner,sunxi-ps2.txt
@@ -0,0 +1,23 @@
+* Device tree bindings for Allwinner A10, A20 PS2 host controller
+
+A20 PS2 is dual role controller(PS2 host and PS2 device). These bindings are for PS2 host controller.
+IBM compliant IBM PS2 and AT-compatible keyboard and mouse can be connected.
+
+Required properties:
+
+ - reg             : Offset and length of the register set for the device.
+ - compatible      : Should one of the following:
+                     - "allwinner,sun7i-a20-ps2"
+                     - "allwinner,sun4i-a10-ps2"
+ - interrupts      : The interrupt line connected to the PS2.
+ - clocks          : The gate clk connected to the PS2.
+
+
+Example:
+	ps20: ps2@0x01c2a000 {
+		compatible = "allwinner,sun7i-a20-ps2";
+		reg = <0x01c2a000 0x400>;
+		interrupts = <0 62 4>;
+		clocks = <&apb1_gates 6>;
+		status = "disabled";
+	};
-- 
1.7.9.5

