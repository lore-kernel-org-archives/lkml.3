Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985AbaD3M5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:57:05 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:63370 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758864AbaD3M5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:57:01 -0400
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
Subject: [PATCH 12/15] ARM: dts: kirkwood: set default pinctrl for I2C0
Date: Wed, 30 Apr 2014 14:56:39 +0200
Message-Id: <1398862602-29595-13-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is only one valid pinctrl setting for I2C0 on Kirkwood. Now that we
have the setting in the common SoC pinctrl, move it to the I2C0 controller
node directly and remove it from the individual boards.

While at it, also fix up status = "okay" to "ok" on one board's I2C0 node.

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
 arch/arm/boot/dts/kirkwood-laplug.dts      | 2 --
 arch/arm/boot/dts/kirkwood-ns2-common.dtsi | 2 --
 arch/arm/boot/dts/kirkwood-synology.dtsi   | 2 --
 arch/arm/boot/dts/kirkwood-topkick.dts     | 4 +---
 arch/arm/boot/dts/kirkwood-ts219.dtsi      | 2 --
 arch/arm/boot/dts/kirkwood.dtsi            | 2 ++
 6 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/arm/boot/dts/kirkwood-laplug.dts b/arch/arm/boot/dts/kirkwood-laplug.dts
index 642755acf2fe..92c2d3c16546 100644
--- a/arch/arm/boot/dts/kirkwood-laplug.dts
+++ b/arch/arm/boot/dts/kirkwood-laplug.dts
@@ -42,8 +42,6 @@
 		};
 
 		i2c@11000 {
-			pinctrl-0 = <&pmx_twsi0>;
-			pinctrl-names = "default";
 			status = "okay";
 
 			eeprom@50 {
diff --git a/arch/arm/boot/dts/kirkwood-ns2-common.dtsi b/arch/arm/boot/dts/kirkwood-ns2-common.dtsi
index c10ff0f5290b..e6863ed87d76 100644
--- a/arch/arm/boot/dts/kirkwood-ns2-common.dtsi
+++ b/arch/arm/boot/dts/kirkwood-ns2-common.dtsi
@@ -42,8 +42,6 @@
 		};
 
 		i2c@11000 {
-			pinctrl-0 = <&pmx_twsi0>;
-			pinctrl-names = "default";
 			status = "okay";
 
 			eeprom@50 {
diff --git a/arch/arm/boot/dts/kirkwood-synology.dtsi b/arch/arm/boot/dts/kirkwood-synology.dtsi
index a21419f78bee..811e0971fc58 100644
--- a/arch/arm/boot/dts/kirkwood-synology.dtsi
+++ b/arch/arm/boot/dts/kirkwood-synology.dtsi
@@ -257,8 +257,6 @@
 		i2c@11000 {
 			status = "okay";
 			clock-frequency = <400000>;
-			pinctrl-0 = <&pmx_twsi0>;
-			pinctrl-names = "default";
 
 			rs5c372: rs5c372@32 {
 				status = "disabled";
diff --git a/arch/arm/boot/dts/kirkwood-topkick.dts b/arch/arm/boot/dts/kirkwood-topkick.dts
index a4dd47acf98a..f5c8c0dd41dc 100644
--- a/arch/arm/boot/dts/kirkwood-topkick.dts
+++ b/arch/arm/boot/dts/kirkwood-topkick.dts
@@ -95,9 +95,7 @@
 		};
 
 		i2c@11000 {
-			status = "ok";
-			pinctrl-0 = <&pmx_twsi0>;
-			pinctrl-names = "default";
+			status = "okay";
 		};
 
 		mvsdio@90000 {
diff --git a/arch/arm/boot/dts/kirkwood-ts219.dtsi b/arch/arm/boot/dts/kirkwood-ts219.dtsi
index 539a2f80a3ad..df7f15276575 100644
--- a/arch/arm/boot/dts/kirkwood-ts219.dtsi
+++ b/arch/arm/boot/dts/kirkwood-ts219.dtsi
@@ -26,8 +26,6 @@
 		i2c@11000 {
 			status = "okay";
 			clock-frequency = <400000>;
-			pinctrl-0 = <&pmx_twsi0>;
-			pinctrl-names = "default";
 
 			s35390a: s35390a@30 {
 				compatible = "s35390a";
diff --git a/arch/arm/boot/dts/kirkwood.dtsi b/arch/arm/boot/dts/kirkwood.dtsi
index caafcde88f67..0399a096e324 100644
--- a/arch/arm/boot/dts/kirkwood.dtsi
+++ b/arch/arm/boot/dts/kirkwood.dtsi
@@ -170,6 +170,8 @@
 			interrupts = <29>;
 			clock-frequency = <100000>;
 			clocks = <&gate_clk 7>;
+			pinctrl-0 = <&pmx_twsi0>;
+			pinctrl-names = "default";
 			status = "disabled";
 		};
 
-- 
1.9.1

