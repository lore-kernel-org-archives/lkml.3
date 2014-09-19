Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519AbaISUQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:16:55 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:35037 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757686AbaISUOw (ORCPT
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
Subject: [PATCH 2/8] ARM: mvebu: armada-xp: Add node alias to pinctrl and add base address
Date: Fri, 19 Sep 2014 22:14:38 +0200
Message-Id: <1411157684-6991-3-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1411157684-6991-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1411157684-6991-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In other MVEBU SoCs, the pin controller node is called pin-ctrl with
its base address added. Also, we have a node alias to access the pinctrl
node easily. Fix this for Armada XP pinctrl nodes to be consistent with
other SoCs.

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
 arch/arm/boot/dts/armada-xp-axpwifiap.dts        | 2 +-
 arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts  | 2 +-
 arch/arm/boot/dts/armada-xp-mv78230.dtsi         | 2 +-
 arch/arm/boot/dts/armada-xp-mv78260.dtsi         | 2 +-
 arch/arm/boot/dts/armada-xp-mv78460.dtsi         | 2 +-
 arch/arm/boot/dts/armada-xp-netgear-rn2120.dts   | 2 +-
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts | 2 +-
 arch/arm/boot/dts/armada-xp.dtsi                 | 2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/armada-xp-axpwifiap.dts b/arch/arm/boot/dts/armada-xp-axpwifiap.dts
index a55a97a70505..546016148283 100644
--- a/arch/arm/boot/dts/armada-xp-axpwifiap.dts
+++ b/arch/arm/boot/dts/armada-xp-axpwifiap.dts
@@ -60,7 +60,7 @@
 		};
 
 		internal-regs {
-			pinctrl {
+			pinctrl: pin-ctrl@18000 {
 				pinctrl-0 = <&pmx_phy_int>;
 				pinctrl-names = "default";
 
diff --git a/arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts b/arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts
index 469cf7137595..baa43a004299 100644
--- a/arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts
+++ b/arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts
@@ -51,7 +51,7 @@
 		};
 
 		internal-regs {
-			pinctrl {
+			pinctrl: pin-ctrl@18000 {
 				poweroff_pin: poweroff-pin {
 					marvell,pins = "mpp24";
 					marvell,function = "gpio";
diff --git a/arch/arm/boot/dts/armada-xp-mv78230.dtsi b/arch/arm/boot/dts/armada-xp-mv78230.dtsi
index b5933aa9ab50..e24ef072b8cb 100644
--- a/arch/arm/boot/dts/armada-xp-mv78230.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78230.dtsi
@@ -167,7 +167,7 @@
 		};
 
 		internal-regs {
-			pinctrl {
+			pinctrl: pin-ctrl@18000 {
 				compatible = "marvell,mv78230-pinctrl";
 			};
 
diff --git a/arch/arm/boot/dts/armada-xp-mv78260.dtsi b/arch/arm/boot/dts/armada-xp-mv78260.dtsi
index 5954b362180c..53dfb157b91a 100644
--- a/arch/arm/boot/dts/armada-xp-mv78260.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78260.dtsi
@@ -251,7 +251,7 @@
 		};
 
 		internal-regs {
-			pinctrl {
+			pinctrl: pin-ctrl@18000 {
 				compatible = "marvell,mv78260-pinctrl";
 			};
 
diff --git a/arch/arm/boot/dts/armada-xp-mv78460.dtsi b/arch/arm/boot/dts/armada-xp-mv78460.dtsi
index 735924d62e12..8b4ab0a5d620 100644
--- a/arch/arm/boot/dts/armada-xp-mv78460.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78460.dtsi
@@ -289,7 +289,7 @@
 		};
 
 		internal-regs {
-			pinctrl {
+			pinctrl: pin-ctrl@18000 {
 				compatible = "marvell,mv78460-pinctrl";
 			};
 
diff --git a/arch/arm/boot/dts/armada-xp-netgear-rn2120.dts b/arch/arm/boot/dts/armada-xp-netgear-rn2120.dts
index 0cf999abc4ed..b3951c39c5da 100644
--- a/arch/arm/boot/dts/armada-xp-netgear-rn2120.dts
+++ b/arch/arm/boot/dts/armada-xp-netgear-rn2120.dts
@@ -55,7 +55,7 @@
 		};
 
 		internal-regs {
-			pinctrl {
+			pinctrl: pin-ctrl@18000 {
 				poweroff: poweroff {
 					marvell,pins = "mpp42";
 					marvell,function = "gpio";
diff --git a/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts b/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
index 4e5a59ee1501..394f085751be 100644
--- a/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
+++ b/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
@@ -77,7 +77,7 @@
 			serial@12100 {
 				status = "okay";
 			};
-			pinctrl {
+			pinctrl: pin-ctrl@18000 {
 				led_pins: led-pins-0 {
 					marvell,pins = "mpp49", "mpp51", "mpp53";
 					marvell,function = "gpio";
diff --git a/arch/arm/boot/dts/armada-xp.dtsi b/arch/arm/boot/dts/armada-xp.dtsi
index 75653774342a..b5fd8c69dfff 100644
--- a/arch/arm/boot/dts/armada-xp.dtsi
+++ b/arch/arm/boot/dts/armada-xp.dtsi
@@ -71,7 +71,7 @@
 				status = "disabled";
 			};
 
-			pinctrl {
+			pinctrl: pin-ctrl@18000 {
 				reg = <0x18000 0x38>;
 
 				sdio_pins: sdio-pins {
-- 
2.0.0

