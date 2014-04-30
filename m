Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225AbaD3M7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:59:31 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:41395 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758846AbaD3M45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:56:57 -0400
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
Subject: [PATCH 06/15] ARM: dts: kirkwood: add pinctrl node to common SoC include
Date: Wed, 30 Apr 2014 14:56:33 +0200
Message-Id: <1398862602-29595-7-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All Kirkwood SoCs have their pinctrl registers at the same address.
Instead of replaying the same reg property on each SoC, have the
reg property set in the common SoC file already. This also allows
us to move common pinctrl settings to this node later on.

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
 arch/arm/boot/dts/kirkwood-6192.dtsi     | 1 -
 arch/arm/boot/dts/kirkwood-6281.dtsi     | 1 -
 arch/arm/boot/dts/kirkwood-6282.dtsi     | 1 -
 arch/arm/boot/dts/kirkwood-98dx4122.dtsi | 1 -
 arch/arm/boot/dts/kirkwood.dtsi          | 5 +++++
 5 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/kirkwood-6192.dtsi b/arch/arm/boot/dts/kirkwood-6192.dtsi
index 4f1eef36a7ac..c008e9a877d5 100644
--- a/arch/arm/boot/dts/kirkwood-6192.dtsi
+++ b/arch/arm/boot/dts/kirkwood-6192.dtsi
@@ -37,7 +37,6 @@
 	ocp@f1000000 {
 		pinctrl: pin-controller@10000 {
 			compatible = "marvell,88f6192-pinctrl";
-			reg = <0x10000 0x20>;
 
 			pmx_nand: pmx-nand {
 				marvell,pins = "mpp0", "mpp1", "mpp2", "mpp3",
diff --git a/arch/arm/boot/dts/kirkwood-6281.dtsi b/arch/arm/boot/dts/kirkwood-6281.dtsi
index d95a7a9cfd1e..3674a9b9552e 100644
--- a/arch/arm/boot/dts/kirkwood-6281.dtsi
+++ b/arch/arm/boot/dts/kirkwood-6281.dtsi
@@ -37,7 +37,6 @@
 	ocp@f1000000 {
 		pinctrl: pin-controller@10000 {
 			compatible = "marvell,88f6281-pinctrl";
-			reg = <0x10000 0x20>;
 
 			pmx_nand: pmx-nand {
 				marvell,pins = "mpp0", "mpp1", "mpp2", "mpp3",
diff --git a/arch/arm/boot/dts/kirkwood-6282.dtsi b/arch/arm/boot/dts/kirkwood-6282.dtsi
index 523d6feeaf19..89a6ba149ec2 100644
--- a/arch/arm/boot/dts/kirkwood-6282.dtsi
+++ b/arch/arm/boot/dts/kirkwood-6282.dtsi
@@ -58,7 +58,6 @@
 
 		pinctrl: pin-controller@10000 {
 			compatible = "marvell,88f6282-pinctrl";
-			reg = <0x10000 0x20>;
 
 			pmx_nand: pmx-nand {
 				marvell,pins = "mpp0", "mpp1", "mpp2", "mpp3",
diff --git a/arch/arm/boot/dts/kirkwood-98dx4122.dtsi b/arch/arm/boot/dts/kirkwood-98dx4122.dtsi
index c59e7b75b169..4a2d1b12d1ca 100644
--- a/arch/arm/boot/dts/kirkwood-98dx4122.dtsi
+++ b/arch/arm/boot/dts/kirkwood-98dx4122.dtsi
@@ -2,7 +2,6 @@
 	ocp@f1000000 {
 		pinctrl: pin-controller@10000 {
 			compatible = "marvell,98dx4122-pinctrl";
-			reg = <0x10000 0x20>;
 
 			pmx_nand: pmx-nand {
 				marvell,pins = "mpp0", "mpp1", "mpp2", "mpp3",
diff --git a/arch/arm/boot/dts/kirkwood.dtsi b/arch/arm/boot/dts/kirkwood.dtsi
index 2570e0f1673f..028003e12111 100644
--- a/arch/arm/boot/dts/kirkwood.dtsi
+++ b/arch/arm/boot/dts/kirkwood.dtsi
@@ -71,6 +71,11 @@
 		#address-cells = <1>;
 		#size-cells = <1>;
 
+		pinctrl: pin-controller@10000 {
+			/* set compatible property in SoC file */
+			reg = <0x10000 0x20>;
+		};
+
 		core_clk: core-clocks@10030 {
 			compatible = "marvell,kirkwood-core-clock";
 			reg = <0x10030 0x4>;
-- 
1.9.1

