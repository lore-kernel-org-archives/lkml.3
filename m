Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab3FYIfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:35:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51166 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab3FYIfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:35:39 -0400
From: Luciano Coelho <coelho@ti.com>
To: <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <linux-wireless@vger.kernel.org>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, <linux-arm@vger.kernel.org>
Subject: [PATCH] Documentation: dt: bindings: TI WiLink modules
Date: Tue, 25 Jun 2013 11:35:30 +0300
Message-ID: <1372149330-24335-1-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree bindings documentation for the TI WiLink modules.
Currently only the WLAN part of the WiLink6, WiLink7 and WiLink8
modules is supported.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---

I created a new directory under net to contain wireless bindings documentation.

The actual implementation in the driver will follow separately.

 .../devicetree/bindings/net/wireless/ti-wilink.txt |   46 ++++++++++++++++++++
 1 file changed, 46 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ti-wilink.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/ti-wilink.txt b/Documentation/devicetree/bindings/net/wireless/ti-wilink.txt
new file mode 100644
index 0000000..d8e8bfbb
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/ti-wilink.txt
@@ -0,0 +1,46 @@
+TI WiLink Wireless Modules Device Tree Bindings
+===============================================
+
+The WiLink modules provide wireless connectivity, such as WLAN,
+Bluetooth, FM and NFC.
+
+There are several different modules available, which can be grouped by
+their generation: WiLink6, WiLink7 and WiLink8.  WiLink4 is not
+currently supported with device tree.
+
+Currently, only the WLAN portion of the modules is supported with
+device tree.
+
+Required properties:
+--------------------
+
+- compatible: should be "ti,wilink6", "ti,wilink7" or "ti,wilink8"
+- interrupt-parent: the interrupt controller
+- interrupts: out-of-band WLAN interrupt
+	See the interrupt controller's bindings documentation for
+	detailed definition.
+
+Optional properties:
+--------------------
+
+- refclock: the internal WLAN reference clock frequency (required for
+  WiLink6 and WiLink7; not used for WiLink8).  Must be one of the
+  following:
+	0 = 19.2 MHz
+	1 = 26.0 MHz
+	2 = 38.4 MHz
+	3 = 52.0 MHz
+	4 = 38.4 MHz, XTAL
+	5 = 26.0 MHz, XTAL
+
+- tcxoclock: the internal WLAN TCXO clock frequency (required for
+  WiLink7 not used for WiLink6 and WiLink8).  Must be one of the
+  following:
+	0 = 19.200 MHz
+	1 = 26.000 MHz
+	2 = 38.400 MHz
+	3 = 52.000 MHz
+	4 = 16.368 MHz
+	5 = 32.736 MHz
+	6 = 16.800 MHz
+	7 = 33.600 MHz
-- 
1.7.10.4

