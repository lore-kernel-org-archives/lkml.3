Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab3AOInl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 03:43:41 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:46194 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756388Ab3AOInf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 03:43:35 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <b-cousson@ti.com>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <arnd@arndb.de>,
        <balbi@ti.com>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: Kishon Vijay Abraham I <kishon@ti.com>
Subject: [RFC PATCH 5/7] ARM: dts: omap: Add usb_otg and glue data
Date: Tue, 15 Jan 2013 14:12:56 +0530
Message-ID: <1358239378-10030-6-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358239378-10030-1-git-send-email-kishon@ti.com>
References: <1358239378-10030-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add usb otg data node in omap4/omap3 device tree file. Also update
the node with board specific setting in omapx-<board>.dts file.
The dt data specifies among others the interface type (ULPI or UTMI), mode
which is mostly OTG, power that specifies the amount of power this can supply
when in host mode.

Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/omap3-beagle-xm.dts |    6 ++++++
 arch/arm/boot/dts/omap3-evm.dts       |    6 ++++++
 arch/arm/boot/dts/omap3-overo.dtsi    |    6 ++++++
 arch/arm/boot/dts/omap3.dtsi          |   11 +++++++++++
 arch/arm/boot/dts/omap4-panda.dts     |    6 ++++++
 arch/arm/boot/dts/omap4-sdp.dts       |    6 ++++++
 arch/arm/boot/dts/omap4.dtsi          |   12 ++++++++++++
 7 files changed, 53 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts b/arch/arm/boot/dts/omap3-beagle-xm.dts
index 3705a81..cb07583 100644
--- a/arch/arm/boot/dts/omap3-beagle-xm.dts
+++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
@@ -107,3 +107,9 @@
 	 */
 	ti,pulldowns = <0x03a1c4>;
 };
+
+&usb_otg_hs {
+	interface_type = <0>;
+	mode = <3>;
+	power = <50>;
+};
diff --git a/arch/arm/boot/dts/omap3-evm.dts b/arch/arm/boot/dts/omap3-evm.dts
index e8ba1c2..afb9ba9 100644
--- a/arch/arm/boot/dts/omap3-evm.dts
+++ b/arch/arm/boot/dts/omap3-evm.dts
@@ -59,3 +59,9 @@
 &twl_gpio {
 	ti,use-leds;
 };
+
+&usb_otg_hs {
+	interface_type = <0>;
+	mode = <3>;
+	power = <50>;
+};
diff --git a/arch/arm/boot/dts/omap3-overo.dtsi b/arch/arm/boot/dts/omap3-overo.dtsi
index 89808ce..4b3d157 100644
--- a/arch/arm/boot/dts/omap3-overo.dtsi
+++ b/arch/arm/boot/dts/omap3-overo.dtsi
@@ -55,3 +55,9 @@
 &twl_gpio {
 	ti,use-leds;
 };
+
+&usb_otg_hs {
+	interface_type = <0>;
+	mode = <3>;
+	power = <50>;
+};
diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
index 1acc261..8d03736 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -397,5 +397,16 @@
 			ti,timer-alwon;
 			ti,timer-secure;
 		};
+
+		usb_otg_hs: usb_otg_hs@480ab000 {
+			compatible = "ti,omap3-musb";
+			reg = <0x480ab000 0x1000>;
+			interrupts = <0 92 0x4>, <0 93 0x4>;
+			interrupt-names = "mc", "dma";
+			ti,hwmods = "usb_otg_hs";
+			multipoint = <1>;
+			num_eps = <16>;
+			ram_bits = <12>;
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/omap4-panda.dts b/arch/arm/boot/dts/omap4-panda.dts
index 4122efe..612c9bb 100644
--- a/arch/arm/boot/dts/omap4-panda.dts
+++ b/arch/arm/boot/dts/omap4-panda.dts
@@ -206,3 +206,9 @@
 &twl_usb_comparator {
 	usb-supply = <&vusb>;
 };
+
+&usb_otg_hs {
+	interface_type = <1>;
+	mode = <3>;
+	power = <50>;
+};
diff --git a/arch/arm/boot/dts/omap4-sdp.dts b/arch/arm/boot/dts/omap4-sdp.dts
index 43e5258..582d7ee 100644
--- a/arch/arm/boot/dts/omap4-sdp.dts
+++ b/arch/arm/boot/dts/omap4-sdp.dts
@@ -428,3 +428,9 @@
 &twl_usb_comparator {
 	usb-supply = <&vusb>;
 };
+
+&usb_otg_hs {
+	interface_type = <1>;
+	mode = <3>;
+	power = <50>;
+};
diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 739bb79..7bbf1fb 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -529,5 +529,17 @@
 			ti,hwmods = "timer11";
 			ti,timer-pwm;
 		};
+
+		usb_otg_hs: usb_otg_hs@4a0ab000 {
+			compatible = "ti,omap4-musb";
+			reg = <0x4a0ab000 0x7ff>;
+			interrupts = <0 92 0x4>, <0 93 0x4>;
+			interrupt-names = "mc", "dma";
+			ti,hwmods = "usb_otg_hs";
+			multipoint = <1>;
+			num_eps = <16>;
+			ram_bits = <12>;
+			ti,has_mailbox;
+		};
 	};
 };
-- 
1.7.9.5

