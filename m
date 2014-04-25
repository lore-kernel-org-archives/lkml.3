Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbaDYOIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:08:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47362 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754196AbaDYOHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:07:52 -0400
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
Subject: [PATCH v2 18/18] ARM: mvebu: Add Device Tree description of EHCI hosts on Armada 375
Date: Fri, 25 Apr 2014 16:07:16 +0200
Message-Id: <1398434836-18908-19-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1398434836-18908-1-git-send-email-gregory.clement@free-electrons.com>
References: <1398434836-18908-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Marvell Armada 375 SoC contains one EHCI host. This commit adds
the Device Tree description of this interface at the SoC level.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/boot/dts/armada-375.dtsi | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/armada-375.dtsi b/arch/arm/boot/dts/armada-375.dtsi
index cbe64ba9eb65..349b9635bf3a 100644
--- a/arch/arm/boot/dts/armada-375.dtsi
+++ b/arch/arm/boot/dts/armada-375.dtsi
@@ -320,6 +320,24 @@
 				clocks = <&coreclk 0>;
 			};
 
+			/*
+			 * On Armada 375, USB2 host controller and
+			 * USB3 host controller are incompatible. That
+			 * means that in the dts of your board, you
+			 * can either select the USB2 controller:
+			 * marvell,orion-ehci or the USB3 controller:
+			 * marvell,armada-375-xhci, but not both. If
+			 * both controllers are selected, then the
+			 * kernel will select the USB3 by default.
+			 */
+			usb@50000 {
+				compatible = "marvell,orion-ehci";
+				reg = <0x50000 0x500>;
+				interrupts = <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&gateclk 18>;
+				status = "disabled";
+			};
+
 			usb-cluster@18400 {
 				compatible = "marvell,armada-375-usb-cluster";
 				reg = <0x18400 0x4>;
-- 
1.8.1.2

