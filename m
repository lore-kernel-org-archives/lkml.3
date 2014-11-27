Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbaK0R4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:56:37 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:63646 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaK0Rzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:55:50 -0500
From: Leif Lindholm <leif.lindholm@linaro.org>
To: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: mark.rutland@arm.com, grant.likely@linaro.org, robh+dt@kernel.org,
        plagnioj@jcrosoft.com, ijc@debian.org, andrew@lunn.ch,
        s.hauer@pengutronix.de
Subject: [PATCH v3 1/3] devicetree: of: Add bindings for chosen node, stdout-path
Date: Thu, 27 Nov 2014 17:56:05 +0000
Message-Id: <1417110967-16284-2-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417110967-16284-1-git-send-email-leif.lindholm@linaro.org>
References: <1417110967-16284-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a global binding for the chosen node.
Include a description of the stdout-path, and an explicit statement on
its extra options in the context of a UART console.

Opening description stolen from www.devicetree.org, and part of the
remaining text provided by Mark Rutland.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 Documentation/devicetree/bindings/chosen.txt |   42 ++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/chosen.txt

diff --git a/Documentation/devicetree/bindings/chosen.txt b/Documentation/devicetree/bindings/chosen.txt
new file mode 100644
index 0000000..9cd74e9
--- /dev/null
+++ b/Documentation/devicetree/bindings/chosen.txt
@@ -0,0 +1,42 @@
+The chosen node
+---------------
+
+The chosen node does not represent a real device, but serves as a place
+for passing data between firmware and the operating system, like boot
+arguments. Data in the chosen node does not represent the hardware.
+
+
+stdout-path property
+--------------------
+
+Device trees may specify the device to be used for boot console output
+with a stdout-path property under /chosen, as described in ePAPR, e.g.
+
+/ {
+	chosen {
+		stdout-path = "/serial@f00:115200";
+	};
+
+	serial@f00 {
+		compatible = "vendor,some-uart";
+		reg = <0xf00 0x10>;
+	};
+};
+
+If the character ":" is present in the value, this terminates the path.
+The meaning of any characters following the ":" is device-specific, and
+must be specified in the relevant binding documentation.
+
+For UART devices, the format supported by uart_parse_options() is the
+expected one. In this case, the format of the string is:
+
+	<baud>{<parity>{<bits>{<flow>}}}
+
+where
+
+	baud	- baud rate in decimal
+	parity	- 'n' (none), 'o', (odd) or 'e' (even)
+	bits	- number of data bits
+	flow	- 'r' (rts)
+
+For example: 115200n8r
-- 
1.7.10.4

