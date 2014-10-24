Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbaJXPYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:24:40 -0400
Received: from down.free-electrons.com ([37.187.137.238]:40704 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756436AbaJXPYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:24:33 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: "Kishon Vijay Abraham I" <kishon@ti.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/6] ARM: mvebu: add PHY support to the dts for the USB controllers on Armada 375
Date: Fri, 24 Oct 2014 17:24:14 +0200
Message-Id: <1414164254-13053-7-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414164254-13053-1-git-send-email-gregory.clement@free-electrons.com>
References: <1414164254-13053-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the USB cluster node has been added, use it as a PHY provider
for the USB controller linked to it: the first EHCI and the xHCI.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/boot/dts/armada-375.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/armada-375.dtsi b/arch/arm/boot/dts/armada-375.dtsi
index 8f45cf5d2a50..39a3afbb293d 100644
--- a/arch/arm/boot/dts/armada-375.dtsi
+++ b/arch/arm/boot/dts/armada-375.dtsi
@@ -14,6 +14,7 @@
 #include "skeleton.dtsi"
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 #include <dt-bindings/interrupt-controller/irq.h>
+#include <dt-bindings/phy/armada-375-usb-cluster.h>
 
 #define MBUS_ID(target,attributes) (((target) << 24) | ((attributes) << 16))
 
@@ -396,6 +397,8 @@
 				reg = <0x50000 0x500>;
 				interrupts = <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&gateclk 18>;
+				phys = <&usbcluster PHY_USB2>;
+				phy-names = "usb";
 				status = "disabled";
 			};
 
@@ -412,6 +415,8 @@
 				reg = <0x58000 0x20000>,<0x5b880 0x80>;
 				interrupts = <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&gateclk 16>;
+				phys = <&usbcluster PHY_USB3>;
+				phy-names = "usb";
 				status = "disabled";
 			};
 
-- 
1.9.1

