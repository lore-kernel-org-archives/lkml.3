Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbaFIJFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:05:31 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58476 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755077AbaFIIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 070/146] ARM: dts: kirkwood: fix mislocated pcie-controller nodes
Date: Mon,  9 Jun 2014 10:50:05 +0200
Message-Id: <1df20d356228c49f021f1d3e17a150e2c1294db2.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 788296b2d19d16ec33aba0a5ad1544d50bb58601 upstream.

Commit 54397d85349f
 ("ARM: kirkwood: Relocate PCIe device tree nodes")

moved the pcie-controller nodes for the Kirkwood SoCs to the mbus
bus node. For some reason, two boards were not properly converted
and have their pci-controller nodes still in the ocp bus node.

As the corresponding SoC pcie-controller does not exist anymore,
it is likely that pcie is broken on those boards since above commit.
Fix it by moving the pcie related nodes to the correct location.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Fixes: 54397d85349f ("ARM: kirkwood: Relocate PCIe device tree nodes")
Acked-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lkml.kernel.org/r/1398862602-29595-2-git-send-email-sebastian.hesselbarth@gmail.com
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts | 18 ++++++++++--------
 arch/arm/boot/dts/kirkwood-nsa310-common.dtsi  | 18 ++++++++++--------
 2 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts b/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
index 6317e1d088b3..e650e35d120c 100644
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
diff --git a/arch/arm/boot/dts/kirkwood-nsa310-common.dtsi b/arch/arm/boot/dts/kirkwood-nsa310-common.dtsi
index 06267a91de38..7c3f4bc4b7e4 100644
--- a/arch/arm/boot/dts/kirkwood-nsa310-common.dtsi
+++ b/arch/arm/boot/dts/kirkwood-nsa310-common.dtsi
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
 
@@ -69,14 +79,6 @@
 				reg = <0x5040000 0x2fc0000>;
 			};
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
1.9.3

