Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbbAGRWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:22:54 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:32726 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbbAGRWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:22:52 -0500
From: Ezequiel Garcia <ezequiel.garcia@imgtec.com>
To: Andrew Bresticker <abrestic@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        James Hartley <james.hartley@imgtec.com>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pwm@vger.kernel.org>,
        Naidu Tellapati <Naidu.Tellapati@imgtec.com>,
        Arul Ramasamy <Arul.Ramasamy@imgtec.com>,
        Ezequiel Garcia <ezequiel.garcia@imgtec.com>
Subject: [PATCH v7 4/4] DT: pdm: Add binding document for IMG PDM DAC
Date: Wed, 7 Jan 2015 14:20:15 -0300
Message-ID: <1420651215-3836-5-git-send-email-ezequiel.garcia@imgtec.com>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1420651215-3836-1-git-send-email-ezequiel.garcia@imgtec.com>
References: <1420651215-3836-1-git-send-email-ezequiel.garcia@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.100.200.91]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naidu Tellapati <Naidu.Tellapati@imgtec.com>

Add binding document for the Pulse Density Modulator (PDM) DAC present on the
Pistachio SOC.

Signed-off-by: Naidu Tellapati <Naidu.Tellapati@imgtec.com>
Signed-off-by: Arul Ramasamy <Arul.Ramasamy@imgtec.com>
Signed-off-by: Ezequiel Garcia <ezequiel.garcia@imgtec.com>
---
 Documentation/devicetree/bindings/misc/img-pdm.txt | 54 ++++++++++++++++++++++
 1 file changed, 54 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/misc/img-pdm.txt

diff --git a/Documentation/devicetree/bindings/misc/img-pdm.txt b/Documentation/devicetree/bindings/misc/img-pdm.txt
new file mode 100644
index 0000000..96fde23
--- /dev/null
+++ b/Documentation/devicetree/bindings/misc/img-pdm.txt
@@ -0,0 +1,54 @@
+Imagination Technologies Pulse Density Modulator (PDM) DAC.
+
+Required properties:
+- compatible: Must be "img,pistachio-pdm"
+- clocks: phandle to input PDM clock
+- clock-names: Must include the following entry:
+  - pdm: input clock to pdm block.
+- img,cr-periph: Must contain a phandle to the peripheral control
+  syscon node which contains PDM control registers.
+- #pdm-cells: Must be 2.
+- The first cell is the PDM channel number (valid values: 0, 1, 2, 3)
+- The second cell is 12-bit pulse-in value
+
+Specifying PDM information for devices
+======================================
+
+1. PDM User nodes
+
+PDM properties should be named "pdms". The exact meaning of each pdms property
+is described above.
+
+	pdm-specifier : array of #pdm-cells specifying the given PDM
+						(controller specific)
+
+The following example could be used to describe a PDM-based backlight device:
+
+	pdm: pdm {
+		#pdm-cells = <2>;
+	};
+
+	[...]
+
+	bl: backlight {
+		pdms = <&pdm 2 0>;
+	};
+
+pdm-specifier typically encodes the chip-relative PDM channel number and the
+12-bit pulse-in value.
+
+2. PDM Controller nodes
+
+PDM controller nodes must specify the number of cells used for the specifier
+using the '#pdm-cells' property.
+
+An example PDM controller might look like this:
+
+Example:
+	pdm: pdm@18148000 {
+		compatible = "img,pistachio-pdm";
+		clocks = <&pdm_clk>;
+		clk-names = "pdm";
+		img,cr-periph = <&cr_periph>;
+		#pdm-cells = <2>;
+	};
-- 
2.2.1

