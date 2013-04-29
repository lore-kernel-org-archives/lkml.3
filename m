Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab3D2KE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 06:04:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35059 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757487Ab3D2KEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 06:04:24 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@linaro.org>, <tony@atomide.com>, <balbi@ti.com>,
        <kishon@ti.com>, <arnd@arndb.de>, <swarren@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <sylvester.nawrocki@gmail.com>
CC: <rob.herring@calxeda.com>, <rob@landley.net>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <benoit.cousson@linaro.org>, <mchehab@redhat.com>,
        <akpm@linux-foundation.org>, <cesarb@cesarb.net>,
        <davem@davemloft.net>, <rnayak@ti.com>, <shawn.guo@linaro.org>,
        <santosh.shilimkar@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <nsekhar@ti.com>
Subject: [PATCH v6 6/9] ARM: dts: omap: update usb_otg_hs data
Date: Mon, 29 Apr 2013 15:33:29 +0530
Message-ID: <1367229812-30574-7-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367229812-30574-1-git-send-email-kishon@ti.com>
References: <1367229812-30574-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated the usb_otg_hs dt data to include the *phy* and *phy-names*
binding in order for the driver to use the new generic PHY framework.
Also updated the Documentation to include the binding information.
The PHY binding information can be found at
Documentation/devicetree/bindings/phy/phy-bindings.txt

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 Documentation/devicetree/bindings/usb/omap-usb.txt |    5 +++++
 Documentation/devicetree/bindings/usb/usb-phy.txt  |    6 ++++++
 arch/arm/boot/dts/omap3.dtsi                       |    2 ++
 arch/arm/boot/dts/omap4.dtsi                       |    3 +++
 arch/arm/boot/dts/twl4030.dtsi                     |    1 +
 5 files changed, 17 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
index d4769f3..c0871a7 100644
--- a/Documentation/devicetree/bindings/usb/omap-usb.txt
+++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
@@ -19,6 +19,9 @@ OMAP MUSB GLUE
  - power : Should be "50". This signifies the controller can supply upto
    100mA when operating in host mode.
  - usb-phy : the phandle for the PHY device
+ - phys : the phandle for the PHY device (used by generic PHY framework)
+ - phy-names : the names of the PHY corresponding to the PHYs present in the
+   *phy* phandle.
 
 Optional properties:
  - ctrl-module : phandle of the control module this glue uses to write to
@@ -33,6 +36,8 @@ usb_otg_hs: usb_otg_hs@4a0ab000 {
 	num-eps = <16>;
 	ram-bits = <12>;
 	ctrl-module = <&omap_control_usb>;
+	phys = <&usb2_phy>;
+	phy-names = "usb2-phy";
 };
 
 Board specific device node entry
diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Documentation/devicetree/bindings/usb/usb-phy.txt
index 61496f5..c0245c8 100644
--- a/Documentation/devicetree/bindings/usb/usb-phy.txt
+++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
@@ -5,6 +5,8 @@ OMAP USB2 PHY
 Required properties:
  - compatible: Should be "ti,omap-usb2"
  - reg : Address and length of the register set for the device.
+ - #phy-cells: determine the number of cells that should be given in the
+   phandle while referencing this phy.
 
 Optional properties:
  - ctrl-module : phandle of the control module used by PHY driver to power on
@@ -16,6 +18,7 @@ usb2phy@4a0ad080 {
 	compatible = "ti,omap-usb2";
 	reg = <0x4a0ad080 0x58>;
 	ctrl-module = <&omap_control_usb>;
+	#phy-cells = <0>;
 };
 
 OMAP USB3 PHY
@@ -25,6 +28,8 @@ Required properties:
  - reg : Address and length of the register set for the device.
  - reg-names: The names of the register addresses corresponding to the registers
    filled in "reg".
+ - #phy-cells: determine the number of cells that should be given in the
+   phandle while referencing this phy.
 
 Optional properties:
  - ctrl-module : phandle of the control module used by PHY driver to power on
@@ -39,4 +44,5 @@ usb3phy@4a084400 {
 	      <0x4a084c00 0x40>;
 	reg-names = "phy_rx", "phy_tx", "pll_ctrl";
 	ctrl-module = <&omap_control_usb>;
+	#phy-cells = <0>;
 };
diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
index 4ad03d9..51b4bee 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -520,6 +520,8 @@
 			interrupt-names = "mc", "dma";
 			ti,hwmods = "usb_otg_hs";
 			usb-phy = <&usb2_phy>;
+			phys = <&usb2_phy>;
+			phy-names = "usb2-phy";
 			multipoint = <1>;
 			num-eps = <16>;
 			ram-bits = <12>;
diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 2a56428..dae620b 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -517,6 +517,7 @@
 				compatible = "ti,omap-usb2";
 				reg = <0x4a0ad080 0x58>;
 				ctrl-module = <&omap_control_usb>;
+				#phy-cells = <0>;
 			};
 		};
 
@@ -655,6 +656,8 @@
 			interrupt-names = "mc", "dma";
 			ti,hwmods = "usb_otg_hs";
 			usb-phy = <&usb2_phy>;
+			phys = <&usb2_phy>;
+			phy-names = "usb2-phy";
 			multipoint = <1>;
 			num-eps = <16>;
 			ram-bits = <12>;
diff --git a/arch/arm/boot/dts/twl4030.dtsi b/arch/arm/boot/dts/twl4030.dtsi
index b3034da..ce4cd6f 100644
--- a/arch/arm/boot/dts/twl4030.dtsi
+++ b/arch/arm/boot/dts/twl4030.dtsi
@@ -80,6 +80,7 @@
 		usb1v8-supply = <&vusb1v8>;
 		usb3v1-supply = <&vusb3v1>;
 		usb_mode = <1>;
+		#phy-cells = <0>;
 	};
 
 	twl_pwm: pwm {
-- 
1.7.10.4

