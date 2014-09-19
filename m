Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374AbaISUO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:14:56 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56308 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757658AbaISUOw (ORCPT
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
Subject: [PATCH 1/8] ARM: mvebu: armada-xp: Consolidate pinctrl node
Date: Fri, 19 Sep 2014 22:14:37 +0200
Message-Id: <1411157684-6991-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1411157684-6991-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1411157684-6991-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All current Armada XP SoCs have their pin controller at 0x18000/0x38.
Move the common properties of pinctrl nodes to armada-xp.dtsi to allow
to share pinctrl settings later.

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
 arch/arm/boot/dts/armada-xp-mv78230.dtsi |  7 -------
 arch/arm/boot/dts/armada-xp-mv78260.dtsi |  7 -------
 arch/arm/boot/dts/armada-xp-mv78460.dtsi |  7 -------
 arch/arm/boot/dts/armada-xp.dtsi         | 10 ++++++++++
 4 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/arch/arm/boot/dts/armada-xp-mv78230.dtsi b/arch/arm/boot/dts/armada-xp-mv78230.dtsi
index 2592e1c13560..b5933aa9ab50 100644
--- a/arch/arm/boot/dts/armada-xp-mv78230.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78230.dtsi
@@ -169,13 +169,6 @@
 		internal-regs {
 			pinctrl {
 				compatible = "marvell,mv78230-pinctrl";
-				reg = <0x18000 0x38>;
-
-				sdio_pins: sdio-pins {
-					marvell,pins = "mpp30", "mpp31", "mpp32",
-						       "mpp33", "mpp34", "mpp35";
-					marvell,function = "sd0";
-				};
 			};
 
 			gpio0: gpio@18100 {
diff --git a/arch/arm/boot/dts/armada-xp-mv78260.dtsi b/arch/arm/boot/dts/armada-xp-mv78260.dtsi
index 480e237a870f..5954b362180c 100644
--- a/arch/arm/boot/dts/armada-xp-mv78260.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78260.dtsi
@@ -253,13 +253,6 @@
 		internal-regs {
 			pinctrl {
 				compatible = "marvell,mv78260-pinctrl";
-				reg = <0x18000 0x38>;
-
-				sdio_pins: sdio-pins {
-					marvell,pins = "mpp30", "mpp31", "mpp32",
-						       "mpp33", "mpp34", "mpp35";
-					marvell,function = "sd0";
-				};
 			};
 
 			gpio0: gpio@18100 {
diff --git a/arch/arm/boot/dts/armada-xp-mv78460.dtsi b/arch/arm/boot/dts/armada-xp-mv78460.dtsi
index 2c7b1fef4703..735924d62e12 100644
--- a/arch/arm/boot/dts/armada-xp-mv78460.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78460.dtsi
@@ -291,13 +291,6 @@
 		internal-regs {
 			pinctrl {
 				compatible = "marvell,mv78460-pinctrl";
-				reg = <0x18000 0x38>;
-
-				sdio_pins: sdio-pins {
-					marvell,pins = "mpp30", "mpp31", "mpp32",
-						       "mpp33", "mpp34", "mpp35";
-					marvell,function = "sd0";
-				};
 			};
 
 			gpio0: gpio@18100 {
diff --git a/arch/arm/boot/dts/armada-xp.dtsi b/arch/arm/boot/dts/armada-xp.dtsi
index bff9f6c18db1..75653774342a 100644
--- a/arch/arm/boot/dts/armada-xp.dtsi
+++ b/arch/arm/boot/dts/armada-xp.dtsi
@@ -71,6 +71,16 @@
 				status = "disabled";
 			};
 
+			pinctrl {
+				reg = <0x18000 0x38>;
+
+				sdio_pins: sdio-pins {
+					marvell,pins = "mpp30", "mpp31", "mpp32",
+						       "mpp33", "mpp34", "mpp35";
+					marvell,function = "sd0";
+				};
+			};
+
 			system-controller@18200 {
 				compatible = "marvell,armada-370-xp-system-controller";
 				reg = <0x18200 0x500>;
-- 
2.0.0

