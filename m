Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaLQSul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 13:50:41 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:41121 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaLQStZ (ORCPT
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
Subject: [PATCH 6/8] ARM: shmobile: kzm9g dts: Move Ethernet node to BSC
Date: Wed, 17 Dec 2014 19:49:11 +0100
Message-Id: <1418842153-17113-7-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418842153-17113-1-git-send-email-geert+renesas@glider.be>
References: <1418842153-17113-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the Ethernet node from the root of the device tree to the BSC node,
as its connected to the Bus State Controller.  This allows the system to
know the right position of the Ethernet node in the clock and PM domain
hierarchy, and manage the clock and PM domain appropriately.

Also rename the node's name from "lan9220" to "ethernet", to conform to
ePAPR generic name recomendations.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v2:
  - s/confirm/conform/
  - Moved from kzm9g-reference to kzm9g
---
 arch/arm/boot/dts/sh73a0-kzm9g.dts | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/arm/boot/dts/sh73a0-kzm9g.dts b/arch/arm/boot/dts/sh73a0-kzm9g.dts
index fce37b96394d0ee3..3e8aacb6ca1f2d06 100644
--- a/arch/arm/boot/dts/sh73a0-kzm9g.dts
+++ b/arch/arm/boot/dts/sh73a0-kzm9g.dts
@@ -84,19 +84,6 @@
 		enable-active-high;
 	};
 
-	lan9220@10000000 {
-		compatible = "smsc,lan9220", "smsc,lan9115";
-		reg = <0x10000000 0x100>;
-		phy-mode = "mii";
-		interrupt-parent = <&irqpin0>;
-		interrupts = <3 IRQ_TYPE_EDGE_FALLING>;
-		reg-io-width = <4>;
-		smsc,irq-push-pull;
-		smsc,save-mac-address;
-		vddvario-supply = <&reg_1p8v>;
-		vdd33a-supply = <&reg_3p3v>;
-	};
-
 	leds {
 		compatible = "gpio-leds";
 		led1 {
@@ -178,6 +165,21 @@
 	};
 };
 
+&bsc {
+	ethernet@10000000 {
+		compatible = "smsc,lan9220", "smsc,lan9115";
+		reg = <0x10000000 0x100>;
+		phy-mode = "mii";
+		interrupt-parent = <&irqpin0>;
+		interrupts = <3 IRQ_TYPE_EDGE_FALLING>;
+		reg-io-width = <4>;
+		smsc,irq-push-pull;
+		smsc,save-mac-address;
+		vddvario-supply = <&reg_1p8v>;
+		vdd33a-supply = <&reg_3p3v>;
+	};
+};
+
 &cmt1 {
 	status = "okay";
 };
-- 
1.9.1

