Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbaFEA1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:27:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbaFDXWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.14 105/228] ARM: dts: kirkwood: fix mislocated pcie-controller nodes
Date: Wed,  4 Jun 2014 16:22:14 -0700
Message-Id: <20140604232351.410856568@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts |   18 ++++++++++--------
 arch/arm/boot/dts/kirkwood-nsa310-common.dtsi  |   18 ++++++++++--------
 2 files changed, 20 insertions(+), 16 deletions(-)

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


