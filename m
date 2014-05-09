Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaEIGeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 02:34:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42668 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbaEIGeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 02:34:16 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <linux@arm.linux.org.uk>, <galak@codeaurora.org>,
        <ijc+devicetree@hellion.org.uk>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <robh+dt@kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>, <ezequiel@vanguardiasur.com.ar>,
        <bigeasy@linutronix.de>, <yegorslists@googlemail.com>, <balbi@ti.com>,
        George Cherian <george.cherian@ti.com>
Subject: [RFC PATCH] ARM: dts: am33xx: Re-arrange the USB dt to reflect the h/w configuration
Date: Fri, 9 May 2014 12:01:08 +0530
Message-ID: <1399617068-19826-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re arrange the USB dt for AM33xx to take it a bit closer
to the hardware configuration.

The USBSS is designed as follows

USB control Module	0x44e10_0620

USBSS			0x4740_0000

USB0			0x4740_1000
USB0_PHY		0x4740_1300
USB0_CORE		0x4740_1400

USB1			0x4740_1800
USB1_PHY		0x4740_1b00
USB1_CORE		0x4740_1c00

CPPI DMA Controller	0x4740_2000
CPPI DMA Scheduler	0x4740_3000
Queue Manager		0x4740_4000

So model the DT as follows
USBSS {
    usb_ctrl_mod: {
        0x44e10_0620
    }
    usb0: {
    0x4740_1000
    0x4740_1400
    }
    usb0_phy:{
    0x4740_1300
    }
    usb1:{
    0x4740_1800
    0x4740_1c00
    }
    usb1_phy: {
    0x4740_1b00
    }
    cppi41dma: {
    0x4740_2000
    0x4740_3000
    0x4740_4000
    }
}

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index cb6811e..d33a1e7 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -461,14 +461,6 @@
 				status = "disabled";
 			};
 
-			usb0_phy: usb-phy@47401300 {
-				compatible = "ti,am335x-usb-phy";
-				reg = <0x47401300 0x100>;
-				reg-names = "phy";
-				status = "disabled";
-				ti,ctrl_mod = <&usb_ctrl_mod>;
-			};
-
 			usb0: usb@47401000 {
 				compatible = "ti,musb-am33xx";
 				status = "disabled";
@@ -509,9 +501,9 @@
 					"tx14", "tx15";
 			};
 
-			usb1_phy: usb-phy@47401b00 {
+			usb0_phy: usb-phy@47401300 {
 				compatible = "ti,am335x-usb-phy";
-				reg = <0x47401b00 0x100>;
+				reg = <0x47401300 0x100>;
 				reg-names = "phy";
 				status = "disabled";
 				ti,ctrl_mod = <&usb_ctrl_mod>;
@@ -556,6 +548,14 @@
 					"tx14", "tx15";
 			};
 
+			usb1_phy: usb-phy@47401b00 {
+				compatible = "ti,am335x-usb-phy";
+				reg = <0x47401b00 0x100>;
+				reg-names = "phy";
+				status = "disabled";
+				ti,ctrl_mod = <&usb_ctrl_mod>;
+			};
+
 			cppi41dma: dma-controller@47402000 {
 				compatible = "ti,am3359-cppi41";
 				reg =  <0x47400000 0x1000
-- 
1.8.3.1

