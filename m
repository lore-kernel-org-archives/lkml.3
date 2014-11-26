Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaKZVjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 16:39:40 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:59234 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbaKZVji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 16:39:38 -0500
From: Dave Gerlach <d-gerlach@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Benoit Cousson <bcousson@baylibre.com>,
        Kevin Hilman <khilman@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Gerlach <d-gerlach@ti.com>
Subject: [RFC PATCH 1/3] Documentation: dt: add ti,am3352-emif bindings
Date: Wed, 26 Nov 2014 15:39:05 -0600
Message-ID: <8103cf8683cac55efdd690c61f44005289e62856.1417029919.git.d-gerlach@ti.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1417029919.git.d-gerlach@ti.com>
References: <cover.1417029919.git.d-gerlach@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the device tree bindings document for ti,am3352-emif which
is used by the ti-emif-sram driver to provide low-level PM
functionality.

Signed-off-by: Dave Gerlach <d-gerlach@ti.com>
---
 .../bindings/memory-controllers/ti/emif-sram.txt   | 31 ++++++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/ti/emif-sram.txt

diff --git a/Documentation/devicetree/bindings/memory-controllers/ti/emif-sram.txt b/Documentation/devicetree/bindings/memory-controllers/ti/emif-sram.txt
new file mode 100644
index 0000000..72d6db0
--- /dev/null
+++ b/Documentation/devicetree/bindings/memory-controllers/ti/emif-sram.txt
@@ -0,0 +1,31 @@
+EMIF SRAM Driver
+=====================
+
+TI AMx3 family of devices use a similar EMIF to other TI SoCs but have
+different PM requirements. Late suspend code runs from SRAM and requires
+save and restore of EMIF context and placing the SDRAM in and out of
+self-refresh. Because of this, the ti-emif-sram driver introduces
+relocatable PM function that can run from SRAM and place the EMIF in
+the proper state for low-power mode transition.
+
+EMIF Device Node:
+====================
+A emif node is used to represent an EMIF IP instance within an SoC. The node
+must contain a phandle to an sram node so the ti-emif-sram driver can allocate
+space within the sram and copy the relocatable PM functions.
+
+Required properties:
+--------------------
+- compatible:		Should be "ti,am3352-emif" for AM33xx SoCs
+- reg:			Contains the emif register address ranges.
+- sram:			Phandle for generic sram node for the driver
+			to use to copy PM functions to.
+
+Example:
+--------
+/* AM33xx */
+emif: emif@4c000000 {
+	compatible = "ti,am3352-emif";
+	reg =	<0x4C000000 0x1000>;
+	sram = <&ocmcram>;
+};
-- 
2.1.0

