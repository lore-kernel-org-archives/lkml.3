Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000AbaD3M5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:57:06 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:52387 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758931AbaD3M5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:57:00 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/15] ARM: dts: kirkwood: set default pinctrl for SPI0
Date: Wed, 30 Apr 2014 14:56:37 +0200
Message-Id: <1398862602-29595-11-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most Kirkwood boards use the default SPI0 pinctrl setting anyway. Add a
default pinctrl setting to the toplevel SoC SPI0 node and put a note
in front of the corresponding pinctrl node to overwrite the setting
on board level.

Currently, only T5325 is using a different setting and already
overwrites the corresponding pinctrl node.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/kirkwood-b3.dts              | 2 --
 arch/arm/boot/dts/kirkwood-cloudbox.dts        | 2 --
 arch/arm/boot/dts/kirkwood-dreamplug.dts       | 2 --
 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts | 2 --
 arch/arm/boot/dts/kirkwood-ns2-common.dtsi     | 2 --
 arch/arm/boot/dts/kirkwood-rd88f6192.dts       | 2 --
 arch/arm/boot/dts/kirkwood-synology.dtsi       | 2 --
 arch/arm/boot/dts/kirkwood-t5325.dts           | 6 ------
 arch/arm/boot/dts/kirkwood-ts219.dtsi          | 2 --
 arch/arm/boot/dts/kirkwood.dtsi                | 6 ++++++
 10 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/arch/arm/boot/dts/kirkwood-b3.dts b/arch/arm/boot/dts/kirkwood-b3.dts
index 38972b221089..6678e0b318d5 100644
--- a/arch/arm/boot/dts/kirkwood-b3.dts
+++ b/arch/arm/boot/dts/kirkwood-b3.dts
@@ -70,8 +70,6 @@
 
 		spi@10600 {
 			status = "okay";
-			pinctrl-0 = <&pmx_spi>;
-			pinctrl-names = "default";
 
 			m25p16@0 {
 				#address-cells = <1>;
diff --git a/arch/arm/boot/dts/kirkwood-cloudbox.dts b/arch/arm/boot/dts/kirkwood-cloudbox.dts
index 1ac6bd9f54de..e7a232eb28b0 100644
--- a/arch/arm/boot/dts/kirkwood-cloudbox.dts
+++ b/arch/arm/boot/dts/kirkwood-cloudbox.dts
@@ -37,8 +37,6 @@
 		};
 
 		spi@10600 {
-			pinctrl-0 = <&pmx_spi>;
-			pinctrl-names = "default";
 			status = "okay";
 
 			flash@0 {
diff --git a/arch/arm/boot/dts/kirkwood-dreamplug.dts b/arch/arm/boot/dts/kirkwood-dreamplug.dts
index dd8d1a4611a8..af56cecc6c73 100644
--- a/arch/arm/boot/dts/kirkwood-dreamplug.dts
+++ b/arch/arm/boot/dts/kirkwood-dreamplug.dts
@@ -38,8 +38,6 @@
 
 		spi@10600 {
 			status = "okay";
-			pinctrl-0 = <&pmx_spi>;
-			pinctrl-names = "default";
 
 			m25p40@0 {
 				#address-cells = <1>;
diff --git a/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts b/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
index acbebc6dc169..b318d5d82d67 100644
--- a/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
+++ b/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
@@ -60,8 +60,6 @@
 		};
 
 		spi@10600 {
-			pinctrl-0 = <&pmx_spi>;
-			pinctrl-names = "default";
 			status = "okay";
 
 			flash@0 {
diff --git a/arch/arm/boot/dts/kirkwood-ns2-common.dtsi b/arch/arm/boot/dts/kirkwood-ns2-common.dtsi
index 696b208b676f..c10ff0f5290b 100644
--- a/arch/arm/boot/dts/kirkwood-ns2-common.dtsi
+++ b/arch/arm/boot/dts/kirkwood-ns2-common.dtsi
@@ -24,8 +24,6 @@
 		};
 
 		spi@10600 {
-			pinctrl-0 = <&pmx_spi>;
-			pinctrl-names = "default";
 			status = "okay";
 
 			flash@0 {
diff --git a/arch/arm/boot/dts/kirkwood-rd88f6192.dts b/arch/arm/boot/dts/kirkwood-rd88f6192.dts
index 30087b19efae..35a29dee8dd8 100644
--- a/arch/arm/boot/dts/kirkwood-rd88f6192.dts
+++ b/arch/arm/boot/dts/kirkwood-rd88f6192.dts
@@ -57,8 +57,6 @@
 
 		spi@10600 {
 			status = "okay";
-			pinctrl-0 = <&pmx_spi>;
-			pinctrl-names = "default";
 
 			m25p128@0 {
 				#address-cells = <1>;
diff --git a/arch/arm/boot/dts/kirkwood-synology.dtsi b/arch/arm/boot/dts/kirkwood-synology.dtsi
index 370af7f69319..a21419f78bee 100644
--- a/arch/arm/boot/dts/kirkwood-synology.dtsi
+++ b/arch/arm/boot/dts/kirkwood-synology.dtsi
@@ -213,8 +213,6 @@
 
 		spi@10600 {
 			status = "okay";
-			pinctrl-0 = <&pmx_spi>;
-			pinctrl-names = "default";
 
 			m25p80@0 {
 				#address-cells = <1>;
diff --git a/arch/arm/boot/dts/kirkwood-t5325.dts b/arch/arm/boot/dts/kirkwood-t5325.dts
index ae102abcab04..289fc9e2afc2 100644
--- a/arch/arm/boot/dts/kirkwood-t5325.dts
+++ b/arch/arm/boot/dts/kirkwood-t5325.dts
@@ -65,10 +65,6 @@
 				marvell,function = "gpio";
 			};
 
-			/*
-			 * Redefined from kirkwood-6281.dtsi, because
-			 * we don't use SPI CS on MPP0, but on MPP7.
-			 */
 			pmx_spi: pmx-spi {
 				marvell,pins = "mpp1", "mpp2", "mpp3", "mpp7";
 				marvell,function = "spi";
@@ -87,8 +83,6 @@
 		};
 
 		spi@10600 {
-			pinctrl-0 = <&pmx_spi>;
-			pinctrl-names = "default";
 			status = "okay";
 
 			flash@0 {
diff --git a/arch/arm/boot/dts/kirkwood-ts219.dtsi b/arch/arm/boot/dts/kirkwood-ts219.dtsi
index 21cb9aeb2455..539a2f80a3ad 100644
--- a/arch/arm/boot/dts/kirkwood-ts219.dtsi
+++ b/arch/arm/boot/dts/kirkwood-ts219.dtsi
@@ -47,8 +47,6 @@
 		};
 		spi@10600 {
 			status = "okay";
-			pinctrl-0 = <&pmx_spi>;
-			pinctrl-names = "default";
 
 			m25p128@0 {
 				#address-cells = <1>;
diff --git a/arch/arm/boot/dts/kirkwood.dtsi b/arch/arm/boot/dts/kirkwood.dtsi
index f92c8c4e3908..0c8d8fa29926 100644
--- a/arch/arm/boot/dts/kirkwood.dtsi
+++ b/arch/arm/boot/dts/kirkwood.dtsi
@@ -88,6 +88,10 @@
 				marvell,function = "nand";
 			};
 
+			/*
+			 * Default SPI0 pinctrl setting with CSn on mpp0,
+			 * overwrite marvell,pins on board level if required.
+			 */
 			pmx_spi: pmx-spi {
 				marvell,pins = "mpp0", "mpp1", "mpp2", "mpp3";
 				marvell,function = "spi";
@@ -127,6 +131,8 @@
 			interrupts = <23>;
 			reg = <0x10600 0x28>;
 			clocks = <&gate_clk 7>;
+			pinctrl-0 = <&pmx_spi>;
+			pinctrl-names = "default";
 			status = "disabled";
 		};
 
-- 
1.9.1

