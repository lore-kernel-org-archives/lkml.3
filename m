Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbaDYOKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:10:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47362 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754184AbaDYOHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:07:50 -0400
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
Subject: [PATCH v2 16/18] ARM: mvebu: add USB3 controller Device Tree details for Armada 375
Date: Fri, 25 Apr 2014 16:07:14 +0200
Message-Id: <1398434836-18908-17-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1398434836-18908-1-git-send-email-gregory.clement@free-electrons.com>
References: <1398434836-18908-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds the support for the USB3 controller in the Armada 375
SoC. The following things have been taken in consideration:

 - The usb3-controller node has to be *outside* of the internal-regs{}
   node, because this device needs to access special windows.

 - The usb3-controller node has one ranges to describe the special
   window to be created but it must be done at the board level in the
   dts.

 - The usb3-controller node has two entries in the reg property, the
   first for XHCI, the second for the internal registers

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/boot/dts/armada-375.dtsi | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/armada-375.dtsi b/arch/arm/boot/dts/armada-375.dtsi
index 0e0036800071..cbe64ba9eb65 100644
--- a/arch/arm/boot/dts/armada-375.dtsi
+++ b/arch/arm/boot/dts/armada-375.dtsi
@@ -465,5 +465,23 @@
 			};
 
 		};
+
+		/*
+		 * On Armada 375, USB2 host controller and USB3 host
+		 * controller are incompatible. That means that in the
+		 * dts of your board, you can either select the USB2
+		 * controller: marvell,orion-ehci or the USB3
+		 * controller: marvell,armada-375-xhci, but not
+		 * both. If both controllers are selected, then the
+		 * kernel will select the USB3 by default.
+		 */
+		usb3-controller {
+			compatible = "marvell,armada-375-xhci";
+			reg = <MBUS_ID(0x05, 0x00) 0 0x20000>,
+				<MBUS_ID(0xf0, 0x01) 0x5ff80 0x80>;
+			interrupts = <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&gateclk 16>;
+			status = "disabled";
+		};
 	};
 };
-- 
1.8.1.2

