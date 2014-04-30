Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbaD3NAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 09:00:13 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:48269 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758901AbaD3M4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:56:55 -0400
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
Subject: [PATCH 04/15] ARM: dts: kirkwood: remove clock-frequency properties from UART nodes
Date: Wed, 30 Apr 2014 14:56:31 +0200
Message-Id: <1398862602-29595-5-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UART devices found on Kirkwood SoCs derive their baudrate from TCLK.
With proper clocks property in the SoCs serial node, boards do not
need to overwrite it anymore.

Remove the remaining clock-frequency property from all Kirkwood boards.

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
 arch/arm/boot/dts/kirkwood-cloudbox.dts             | 1 -
 arch/arm/boot/dts/kirkwood-db.dtsi                  | 1 -
 arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts | 1 -
 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts      | 1 -
 arch/arm/boot/dts/kirkwood-ts219.dtsi               | 2 --
 5 files changed, 6 deletions(-)

diff --git a/arch/arm/boot/dts/kirkwood-cloudbox.dts b/arch/arm/boot/dts/kirkwood-cloudbox.dts
index 61212692740e..65ae6471d553 100644
--- a/arch/arm/boot/dts/kirkwood-cloudbox.dts
+++ b/arch/arm/boot/dts/kirkwood-cloudbox.dts
@@ -28,7 +28,6 @@
 		serial@12000 {
 			pinctrl-0 = <&pmx_uart0>;
 			pinctrl-names = "default";
-			clock-frequency = <166666667>;
 			status = "okay";
 		};
 
diff --git a/arch/arm/boot/dts/kirkwood-db.dtsi b/arch/arm/boot/dts/kirkwood-db.dtsi
index 22df970df2a1..68dfb3ad57dd 100644
--- a/arch/arm/boot/dts/kirkwood-db.dtsi
+++ b/arch/arm/boot/dts/kirkwood-db.dtsi
@@ -36,7 +36,6 @@
 		serial@12000 {
 			pinctrl-0 = <&pmx_uart0>;
 			pinctrl-names = "default";
-			clock-frequency = <200000000>;
 			status = "ok";
 		};
 
diff --git a/arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts b/arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts
index db183455ff34..3994a86f989e 100644
--- a/arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts
+++ b/arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts
@@ -37,7 +37,6 @@
 			};
 		};
 		serial@12000 {
-			clock-frequency = <200000000>;
 			status = "ok";
 		};
 
diff --git a/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts b/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
index 9c48e827e34e..444257c08a0c 100644
--- a/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
+++ b/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
@@ -77,7 +77,6 @@
 		serial@12000 {
 			pinctrl-0 = <&pmx_uart0>;
 			pinctrl-names = "default";
-			clock-frequency = <200000000>;
 			status = "ok";
 		};
 
diff --git a/arch/arm/boot/dts/kirkwood-ts219.dtsi b/arch/arm/boot/dts/kirkwood-ts219.dtsi
index 8f2226b8bd3d..414d2246b37c 100644
--- a/arch/arm/boot/dts/kirkwood-ts219.dtsi
+++ b/arch/arm/boot/dts/kirkwood-ts219.dtsi
@@ -35,13 +35,11 @@
 			};
 		};
 		serial@12000 {
-			clock-frequency = <200000000>;
 			status = "okay";
 			pinctrl-0 = <&pmx_uart0>;
 			pinctrl-names = "default";
 		};
 		serial@12100 {
-			clock-frequency = <200000000>;
 			status = "okay";
 			pinctrl-0 = <&pmx_uart1>;
 			pinctrl-names = "default";
-- 
1.9.1

