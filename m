Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417AbaEFAOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 20:14:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41626 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933394AbaEFAOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 20:14:52 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v3 19/20] ARM: mvebu: Add Device Tree description of the xHCI host on Armada 375
Date: Tue,  6 May 2014 02:14:14 +0200
Message-Id: <1399335255-589-20-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Marvell Armada 375 SoCs contain a xHCI host. This commit adds the
Device Tree description of this interfaces at the SoC level, and also
enables the USB3 port on the Armada 375 DB platform.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/boot/dts/armada-375-db.dts |  4 ++++
 arch/arm/boot/dts/armada-375.dtsi   | 10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/armada-375-db.dts b/arch/arm/boot/dts/armada-375-db.dts
index 9378d3136b41..0453d69e6433 100644
--- a/arch/arm/boot/dts/armada-375-db.dts
+++ b/arch/arm/boot/dts/armada-375-db.dts
@@ -102,6 +102,10 @@
 				};
 			};
 
+			usb3@58000 {
+				status = "okay";
+			};
+
 			mvsdio@d4000 {
 				pinctrl-0 = <&sdio_pins &sdio_st_pins>;
 				pinctrl-names = "default";
diff --git a/arch/arm/boot/dts/armada-375.dtsi b/arch/arm/boot/dts/armada-375.dtsi
index 6724c10a8862..1b81d1e33510 100644
--- a/arch/arm/boot/dts/armada-375.dtsi
+++ b/arch/arm/boot/dts/armada-375.dtsi
@@ -320,6 +320,16 @@
 				clocks = <&coreclk 0>;
 			};
 
+			usb3@58000 {
+				compatible = "marvell,armada-375-xhci";
+				reg = <0x58000 0x20000>,<0x5b880 0x80>;
+				interrupts = <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&gateclk 16>;
+				phys = <&usbcluster 1>;
+				phy-names="usb";
+				status = "disabled";
+			};
+
 			usbcluster: usb-cluster@18400 {
 				compatible = "marvell,armada-375-usb-cluster";
 				reg = <0x18400 0x4>;
-- 
1.8.1.2

