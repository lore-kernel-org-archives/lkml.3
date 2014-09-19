Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542AbaISUQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:16:56 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:45786 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687AbaISUOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 16:14:52 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] ARM: mvebu: armada-xp: Move GE0/1 pinctrl settings for RGMII
Date: Fri, 19 Sep 2014 22:14:40 +0200
Message-Id: <1411157684-6991-5-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1411157684-6991-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1411157684-6991-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pinctrl settings for GE0 and GE1 are not only usable on RD-AXPWiFiAP.
Moreover, naming the RGMII settings pmx-ge{0,1} is not precise enough
as there is also a GMII setting for GE0.

Move the pinctrl sub-nodes to the common pinctrl node and rename them
to pmx-ge{0,1}-rgmii.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/armada-xp-axpwifiap.dts | 18 ++----------------
 arch/arm/boot/dts/armada-xp.dtsi          | 16 ++++++++++++++++
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/arch/arm/boot/dts/armada-xp-axpwifiap.dts b/arch/arm/boot/dts/armada-xp-axpwifiap.dts
index cdab007fbaf4..0e53fad111de 100644
--- a/arch/arm/boot/dts/armada-xp-axpwifiap.dts
+++ b/arch/arm/boot/dts/armada-xp-axpwifiap.dts
@@ -84,14 +84,14 @@
 			};
 
 			ethernet@70000 {
-				pinctrl-0 = <&pmx_ge0>;
+				pinctrl-0 = <&pmx_ge0_rgmii>;
 				pinctrl-names = "default";
 				status = "okay";
 				phy = <&phy0>;
 				phy-mode = "rgmii-id";
 			};
 			ethernet@74000 {
-				pinctrl-0 = <&pmx_ge1>;
+				pinctrl-0 = <&pmx_ge1_rgmii>;
 				pinctrl-names = "default";
 				status = "okay";
 				phy = <&phy1>;
@@ -133,20 +133,6 @@
 	pinctrl-0 = <&pmx_phy_int>;
 	pinctrl-names = "default";
 
-	pmx_ge0: pmx-ge0 {
-		marvell,pins = "mpp0", "mpp1", "mpp2", "mpp3",
-			       "mpp4", "mpp5", "mpp6", "mpp7",
-			       "mpp8", "mpp9", "mpp10", "mpp11";
-		marvell,function = "ge0";
-	};
-
-	pmx_ge1: pmx-ge1 {
-		marvell,pins = "mpp12", "mpp13", "mpp14", "mpp15",
-			       "mpp16", "mpp17", "mpp18", "mpp19",
-			       "mpp20", "mpp21", "mpp22", "mpp23";
-		marvell,function = "ge1";
-	};
-
 	pmx_keys: pmx-keys {
 		marvell,pins = "mpp33";
 		marvell,function = "gpio";
diff --git a/arch/arm/boot/dts/armada-xp.dtsi b/arch/arm/boot/dts/armada-xp.dtsi
index b5fd8c69dfff..dfbcb10ad0db 100644
--- a/arch/arm/boot/dts/armada-xp.dtsi
+++ b/arch/arm/boot/dts/armada-xp.dtsi
@@ -74,6 +74,22 @@
 			pinctrl: pin-ctrl@18000 {
 				reg = <0x18000 0x38>;
 
+				pmx_ge0_rgmii: pmx-ge0-rgmii {
+					marvell,pins =
+					     "mpp0", "mpp1", "mpp2", "mpp3",
+					     "mpp4", "mpp5", "mpp6", "mpp7",
+					     "mpp8", "mpp9", "mpp10", "mpp11";
+					marvell,function = "ge0";
+				};
+
+				pmx_ge1_rgmii: pmx-ge1-rgmii {
+					marvell,pins =
+					     "mpp12", "mpp13", "mpp14", "mpp15",
+					     "mpp16", "mpp17", "mpp18", "mpp19",
+					     "mpp20", "mpp21", "mpp22", "mpp23";
+					marvell,function = "ge1";
+				};
+
 				sdio_pins: sdio-pins {
 					marvell,pins = "mpp30", "mpp31", "mpp32",
 						       "mpp33", "mpp34", "mpp35";
-- 
2.0.0

