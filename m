Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaLQSt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 13:49:29 -0500
Received: from laurent.telenet-ops.be ([195.130.137.89]:40697 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaLQStZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 13:49:25 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        linux-pm@vger.kernel.org
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@kernel.org>,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 8/8] ARM: shmobile: ape6evm dts: Move Ethernet node to BSC
Date: Wed, 17 Dec 2014 19:49:13 +0100
Message-Id: <1418842153-17113-9-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418842153-17113-1-git-send-email-geert+renesas@glider.be>
References: <1418842153-17113-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the Ethernet node from the ad-hoc lbsc node to the BSC node,
as its connected to the Bus State Controller.  This allows the system to
know the right position of the Ethernet node in the clock and PM domain
hierarchy, and manage the clock and PM domain appropriately.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Untested

v2:
  - New
---
 arch/arm/boot/dts/r8a73a4-ape6evm.dts | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/arch/arm/boot/dts/r8a73a4-ape6evm.dts b/arch/arm/boot/dts/r8a73a4-ape6evm.dts
index 0d50bef0123449f5..44c4cac1820a4dfe 100644
--- a/arch/arm/boot/dts/r8a73a4-ape6evm.dts
+++ b/arch/arm/boot/dts/r8a73a4-ape6evm.dts
@@ -72,26 +72,6 @@
 		regulator-always-on;
 	};
 
-	lbsc {
-		compatible = "simple-bus";
-		#address-cells = <1>;
-		#size-cells = <1>;
-		ranges = <0 0 0 0x20000000>;
-
-		ethernet@8000000 {
-			compatible = "smsc,lan9220", "smsc,lan9115";
-			reg = <0x08000000 0x1000>;
-			interrupt-parent = <&irqc1>;
-			interrupts = <8 IRQ_TYPE_LEVEL_HIGH>;
-			phy-mode = "mii";
-			reg-io-width = <4>;
-			smsc,irq-active-high;
-			smsc,irq-push-pull;
-			vdd33a-supply = <&ape6evm_fixed_3v3>;
-			vddvario-supply = <&ape6evm_fixed_1v8>;
-		};
-	};
-
 	leds {
 		compatible = "gpio-leds";
 		led1 {
@@ -184,6 +164,21 @@
 	voltage-tolerance = <1>; /* 1% */
 };
 
+&bsc {
+	ethernet@8000000 {
+		compatible = "smsc,lan9220", "smsc,lan9115";
+		reg = <0x08000000 0x1000>;
+		interrupt-parent = <&irqc1>;
+		interrupts = <8 IRQ_TYPE_LEVEL_HIGH>;
+		phy-mode = "mii";
+		reg-io-width = <4>;
+		smsc,irq-active-high;
+		smsc,irq-push-pull;
+		vdd33a-supply = <&ape6evm_fixed_3v3>;
+		vddvario-supply = <&ape6evm_fixed_1v8>;
+	};
+};
+
 &cmt1 {
 	status = "okay";
 };
-- 
1.9.1

