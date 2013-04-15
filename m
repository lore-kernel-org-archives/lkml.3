Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934736Ab3DOCtb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:49:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719Ab3DOCng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:43:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nigel Roberts <nigel@nobiscuit.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [ 06/27] ARM: Kirkwood: Fix typo in the definition of ix2-200 rebuild LED
Date: Sun, 14 Apr 2013 19:43:05 -0700
Message-Id: <20130415024231.836417139@linuxfoundation.org>
X-Mailer: git-send-email 1.8.2.1.368.g99c2266
In-Reply-To: <20130415024231.351969241@linuxfoundation.org>
References: <20130415024231.351969241@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nigel Roberts <nigel@nobiscuit.com>

commit 8f08d6667287241f6818d35e02b223fb5df97cf1 upstream.

In the conversion to pinctrl, an error in the pins for the rebuild
LED was introduced. This patch assigns the correct pins and includes
the correct name for the LED in kirkwood-iomega_ix2_200.dts.

Signed-off-by: Nigel Roberts <nigel@nobiscuit.com>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts
+++ b/arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts
@@ -96,11 +96,11 @@
 				marvell,function = "gpio";
 			};
 			pmx_led_rebuild_brt_ctrl_1: pmx-led-rebuild-brt-ctrl-1 {
-				marvell,pins = "mpp44";
+				marvell,pins = "mpp46";
 				marvell,function = "gpio";
 			};
 			pmx_led_rebuild_brt_ctrl_2: pmx-led-rebuild-brt-ctrl-2 {
-				marvell,pins = "mpp45";
+				marvell,pins = "mpp47";
 				marvell,function = "gpio";
 			};
 
@@ -157,14 +157,14 @@
 			gpios = <&gpio0 16 0>;
 			linux,default-trigger = "default-on";
 		};
-		health_led1 {
+		rebuild_led {
+			label = "status:white:rebuild_led";
+			gpios = <&gpio1 4 0>;
+		};
+		health_led {
 			label = "status:red:health_led";
 			gpios = <&gpio1 5 0>;
 		};
-		health_led2 {
-			label = "status:white:health_led";
-			gpios = <&gpio1 4 0>;
-		};
 		backup_led {
 			label = "status:blue:backup_led";
 			gpios = <&gpio0 15 0>;


