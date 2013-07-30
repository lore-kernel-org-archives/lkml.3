Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab3G3UVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 16:21:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36560 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab3G3UVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 16:21:44 -0400
From: Luciano Coelho <coelho@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>
CC: <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tony@atomide.com>,
        <nm@ti.com>, <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v3] Documentation: dt: bindings: TI WiLink modules
Date: Tue, 30 Jul 2013 23:21:08 +0300
Message-ID: <1375215668-29171-1-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.8.3.2
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

In v3, use IRQ_TYPE_LEVEL_HIGH in the example, as suggested by Laurent.

 .../devicetree/bindings/net/wireless/ti-wilink.txt | 68 ++++++++++++++++++++++
 1 file changed, 68 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ti-wilink.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/ti-wilink.txt b/Documentation/devicetree/bindings/net/wireless/ti-wilink.txt
new file mode 100644
index 0000000..aafebb1
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/ti-wilink.txt
@@ -0,0 +1,68 @@
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
+- clocks: list of clocks needed by the chip as follows:
+
+  refclock: the internal WLAN reference clock frequency (required for
+	WiLink6 and WiLink7; not used for WiLink8).
+
+  tcxoclock: the internal WLAN TCXO clock frequency (required for
+	WiLink7 not used for WiLink6 and WiLink8).
+
+  The clocks must be defined and named accordingly.  For example:
+
+  clocks = <&refclock>
+  clock-names = "refclock";
+
+  refclock: refclock {
+		     compatible = "ti,wilink-clock";
+		     #clock-cells = <0>;
+		     clock-frequency = <38400000>;
+	};
+
+  Some modules that contain the WiLink chip provide clocks in the
+  module itself.  In this case, we define a "ti,wilink-clock" as shown
+  above.  But any other clock could in theory be used, so the proper
+  clock definition should be used.
+
+
+Example:
+--------
+
+Example definition that can be used in OMAP4 Panda:
+
+wlan {
+	compatible = "ti,wilink6";
+	interrupt-parent = <&gpio2>;
+	interrupts = <21 IRQ_TYPE_LEVEL_HIGH>;	/* gpio line 53 */
+	clocks = <&refclock>;
+	clock-names = "refclock";
+
+	refclock: refclock {
+		compatible = "ti,wilink-clock";
+		#clock-cells = <0>;
+		clock-frequency = <38400000>;
+	};
+};
-- 
1.8.3.2

