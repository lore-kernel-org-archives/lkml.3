Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967485AbaFQWCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:02:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54829 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966018AbaFQVw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:52:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 086/212] ARM: dts: kirkwood: fix mislocated pcie-controller nodes
Date: Tue, 17 Jun 2014 14:43:00 -0700
Message-Id: <1403041506-13646-87-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts | 18 ++++++++++--------
 arch/arm/boot/dts/kirkwood-nsa310-common.dtsi  | 18 ++++++++++--------
 2 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts b/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
index 6317e1d..e650e35 100644
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
index e3f915d..5dff4cf 100644
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
 
@@ -26,14 +36,6 @@
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

