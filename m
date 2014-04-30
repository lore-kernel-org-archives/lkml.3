Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139AbaD3M6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:58:25 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:41793 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758956AbaD3M5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:57:02 -0400
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
Subject: [PATCH 13/15] ARM: dts: kirkwood: set default pinctrl for I2C1 on 6282
Date: Wed, 30 Apr 2014 14:56:40 +0200
Message-Id: <1398862602-29595-14-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the only 6282-based Kirkwood boards that use I2C1 are Openblocks
A6/A7. Both use the same default I2C1 pinctrl setting from kirkwood-6282.dtsi.
Move the pinctrl setting to the I2C1 node directly and put a note in front of
the corresponding pinctrl node to overwrite the setting on board level.

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
 arch/arm/boot/dts/kirkwood-6282.dtsi         | 6 ++++++
 arch/arm/boot/dts/kirkwood-openblocks_a6.dts | 2 --
 arch/arm/boot/dts/kirkwood-openblocks_a7.dts | 2 --
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/kirkwood-6282.dtsi b/arch/arm/boot/dts/kirkwood-6282.dtsi
index b869f48cac02..4680eec990f0 100644
--- a/arch/arm/boot/dts/kirkwood-6282.dtsi
+++ b/arch/arm/boot/dts/kirkwood-6282.dtsi
@@ -68,6 +68,10 @@
 				marvell,function = "sata1";
 			};
 
+			/*
+			 * Default I2C1 pinctrl setting on mpp36/mpp37,
+			 * overwrite marvell,pins on board level if required.
+			 */
 			pmx_twsi1: pmx-twsi1 {
 				marvell,pins = "mpp36", "mpp37";
 				marvell,function = "twsi1";
@@ -101,6 +105,8 @@
 			interrupts = <32>;
 			clock-frequency = <100000>;
 			clocks = <&gate_clk 7>;
+			pinctrl-0 = <&pmx_twsi1>;
+			pinctrl-names = "default";
 			status = "disabled";
 		};
 
diff --git a/arch/arm/boot/dts/kirkwood-openblocks_a6.dts b/arch/arm/boot/dts/kirkwood-openblocks_a6.dts
index 00c2e5a9d863..3dcb5c26b78b 100644
--- a/arch/arm/boot/dts/kirkwood-openblocks_a6.dts
+++ b/arch/arm/boot/dts/kirkwood-openblocks_a6.dts
@@ -33,8 +33,6 @@
 
 		i2c@11100 {
 			status = "okay";
-			pinctrl-0 = <&pmx_twsi1>;
-			pinctrl-names = "default";
 
 			s35390a: s35390a@30 {
 				compatible = "s35390a";
diff --git a/arch/arm/boot/dts/kirkwood-openblocks_a7.dts b/arch/arm/boot/dts/kirkwood-openblocks_a7.dts
index bc07aa5e6698..4e10e92b7822 100644
--- a/arch/arm/boot/dts/kirkwood-openblocks_a7.dts
+++ b/arch/arm/boot/dts/kirkwood-openblocks_a7.dts
@@ -45,8 +45,6 @@
 
 		i2c@11100 {
 			status = "okay";
-			pinctrl-0 = <&pmx_twsi1>;
-			pinctrl-names = "default";
 
 			s24c02: s24c02@50 {
 				compatible = "24c02";
-- 
1.9.1

