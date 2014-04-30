Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbaD3M44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:56:56 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:51604 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758846AbaD3M4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:56:52 -0400
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
Subject: [PATCH 01/15] ARM: dts: kirkwood: fix mislocated pcie-controller nodes
Date: Wed, 30 Apr 2014 14:56:28 +0200
Message-Id: <1398862602-29595-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 54397d85349f
 ("ARM: kirkwood: Relocate PCIe device tree nodes")

moved the pcie-controller nodes for the Kirkwood SoCs to the mbus
bus node. For some reason, two boards were not properly converted
and have their pci-controller nodes still in the ocp bus node.

As the corresponding SoC pcie-controller does not exist anymore,
it is likely that pcie is broken on those boards since above commit.
Fix it by moving the pcie related nodes to the correct location.

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
 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts | 18 ++++++++++--------
 arch/arm/boot/dts/kirkwood-nsa3x0-common.dtsi  | 18 ++++++++++--------
 2 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts b/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
index 2cb0dc529165..4bf358c28be2 100644
--- a/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
+++ b/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
@@ -30,6 +30,16 @@
 		bootargs = "console=ttyS0,115200n8 earlyprintk";
 	};
 
+	mbus {
+		pcie-controller {
+			status = "okay";
+
+			pcie@1,0 {
+				status = "okay";
+			};
+		};
+        };
+
 	ocp@f1000000 {
 		pinctrl@10000 {
 			pmx_usb_led: pmx-usb-led {
@@ -73,14 +83,6 @@
 		ehci@50000 {
 			status = "okay";
 		};
-
-		pcie-controller {
-			status = "okay";
-
-			pcie@1,0 {
-				status = "okay";
-			};
-		};
 	};
 
 	gpio-leds {
diff --git a/arch/arm/boot/dts/kirkwood-nsa3x0-common.dtsi b/arch/arm/boot/dts/kirkwood-nsa3x0-common.dtsi
index 843b8b561e5e..b88810df7ca2 100644
--- a/arch/arm/boot/dts/kirkwood-nsa3x0-common.dtsi
+++ b/arch/arm/boot/dts/kirkwood-nsa3x0-common.dtsi
@@ -4,6 +4,16 @@
 / {
 	model = "ZyXEL NSA310";
 
+	mbus {
+		pcie-controller {
+			status = "okay";
+
+			pcie@1,0 {
+				status = "okay";
+			};
+		};
+	};
+
 	ocp@f1000000 {
 		pinctrl: pinctrl@10000 {
 
@@ -51,14 +61,6 @@
 			status = "okay";
 			nr-ports = <2>;
 		};
-
-		pcie-controller {
-			status = "okay";
-
-			pcie@1,0 {
-				status = "okay";
-			};
-		};
 	};
 
 	gpio_poweroff {
-- 
1.9.1

