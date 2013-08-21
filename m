Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab3HUFtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 01:49:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53410 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237Ab3HUFrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 01:47:42 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kyungmin.park@samsung.com>, <balbi@ti.com>,
        <kishon@ti.com>, <jg1.han@samsung.com>, <s.nawrocki@samsung.com>,
        <kgene.kim@samsung.com>, <stern@rowland.harvard.edu>,
        <broonie@kernel.org>, <tomasz.figa@gmail.com>, <arnd@arndb.de>
CC: <grant.likely@linaro.org>, <tony@atomide.com>, <swarren@nvidia.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <akpm@linux-foundation.org>,
        <balajitk@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <linux@arm.linux.org.uk>
Subject: [PATCH v11 5/8] ARM: dts: omap: update usb_otg_hs data
Date: Wed, 21 Aug 2013 11:16:10 +0530
Message-ID: <1377063973-22044-6-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1377063973-22044-1-git-send-email-kishon@ti.com>
References: <1377063973-22044-1-git-send-email-kishon@ti.com>
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
Acked-by: Felipe Balbi <balbi@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 Documentation/devicetree/bindings/usb/omap-usb.txt |    5 +++++
 Documentation/devicetree/bindings/usb/usb-phy.txt  |    6 ++++++
 arch/arm/boot/dts/omap3-beagle-xm.dts              |    2 ++
 arch/arm/boot/dts/omap3-evm.dts                    |    2 ++
 arch/arm/boot/dts/omap3-overo.dtsi                 |    2 ++
 arch/arm/boot/dts/omap4.dtsi                       |    3 +++
 arch/arm/boot/dts/twl4030.dtsi                     |    1 +
 7 files changed, 21 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
index 57e71f6..825790d 100644
--- a/Documentation/devicetree/bindings/usb/omap-usb.txt
+++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
@@ -19,6 +19,9 @@ OMAP MUSB GLUE
  - power : Should be "50". This signifies the controller can supply up to
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
diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts b/arch/arm/boot/dts/omap3-beagle-xm.dts
index afdb164..533b2da 100644
--- a/arch/arm/boot/dts/omap3-beagle-xm.dts
+++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
@@ -144,6 +144,8 @@
 &usb_otg_hs {
 	interface-type = <0>;
 	usb-phy = <&usb2_phy>;
+	phys = <&usb2_phy>;
+	phy-names = "usb2-phy";
 	mode = <3>;
 	power = <50>;
 };
diff --git a/arch/arm/boot/dts/omap3-evm.dts b/arch/arm/boot/dts/omap3-evm.dts
index 7d4329d..4134dd0 100644
--- a/arch/arm/boot/dts/omap3-evm.dts
+++ b/arch/arm/boot/dts/omap3-evm.dts
@@ -70,6 +70,8 @@
 &usb_otg_hs {
 	interface-type = <0>;
 	usb-phy = <&usb2_phy>;
+	phys = <&usb2_phy>;
+	phy-names = "usb2-phy";
 	mode = <3>;
 	power = <50>;
 };
diff --git a/arch/arm/boot/dts/omap3-overo.dtsi b/arch/arm/boot/dts/omap3-overo.dtsi
index 8f1abec..a461d2f 100644
--- a/arch/arm/boot/dts/omap3-overo.dtsi
+++ b/arch/arm/boot/dts/omap3-overo.dtsi
@@ -76,6 +76,8 @@
 &usb_otg_hs {
 	interface-type = <0>;
 	usb-phy = <&usb2_phy>;
+	phys = <&usb2_phy>;
+	phy-names = "usb2-phy";
 	mode = <3>;
 	power = <50>;
 };
diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 22d9f2b..1e8e2fe 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -520,6 +520,7 @@
 				compatible = "ti,omap-usb2";
 				reg = <0x4a0ad080 0x58>;
 				ctrl-module = <&omap_control_usb>;
+				#phy-cells = <0>;
 			};
 		};
 
@@ -658,6 +659,8 @@
 			interrupt-names = "mc", "dma";
 			ti,hwmods = "usb_otg_hs";
 			usb-phy = <&usb2_phy>;
+			phys = <&usb2_phy>;
+			phy-names = "usb2-phy";
 			multipoint = <1>;
 			num-eps = <16>;
 			ram-bits = <12>;
diff --git a/arch/arm/boot/dts/twl4030.dtsi b/arch/arm/boot/dts/twl4030.dtsi
index ae6a17a..5aba238 100644
--- a/arch/arm/boot/dts/twl4030.dtsi
+++ b/arch/arm/boot/dts/twl4030.dtsi
@@ -86,6 +86,7 @@
 		usb1v8-supply = <&vusb1v8>;
 		usb3v1-supply = <&vusb3v1>;
 		usb_mode = <1>;
+		#phy-cells = <0>;
 	};
 
 	twl_pwm: pwm {
-- 
1.7.10.4

