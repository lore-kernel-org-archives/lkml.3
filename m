Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbaKYNRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:17:13 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50918 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754340AbaKYNRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:17:07 -0500
From: George Cherian <george.cherian@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
CC: <peter.chen@freescale.com>, <sojka@merica.cz>, <mathias.nyman@intel.com>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>, <kgene.kim@samsung.com>,
        <ben-linux@fluff.org>, <linux@arm.linux.org.uk>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 17/19] arm: dts: dra7: Add named interrupt property for dwc3
Date: Tue, 25 Nov 2014 18:41:53 +0530
Message-ID: <1416921115-10467-18-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1416921115-10467-1-git-send-email-george.cherian@ti.com>
References: <1416921115-10467-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add interrupt names so that the same can be used for OTG easily.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 9cc9843..78f1761 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -1153,7 +1153,12 @@
 			usb1: usb@48890000 {
 				compatible = "snps,dwc3";
 				reg = <0x48890000 0x17000>;
-				interrupts = <GIC_SPI 71 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_SPI 71 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 71 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "peripheral",
+						  "host",
+						  "otg";
 				phys = <&usb2_phy1>, <&usb3_phy1>;
 				phy-names = "usb2-phy", "usb3-phy";
 				tx-fifo-resize;
@@ -1174,7 +1179,12 @@
 			usb2: usb@488d0000 {
 				compatible = "snps,dwc3";
 				reg = <0x488d0000 0x17000>;
-				interrupts = <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 87 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "peripheral",
+						  "host",
+						  "otg";
 				phys = <&usb2_phy2>;
 				phy-names = "usb2-phy";
 				tx-fifo-resize;
@@ -1197,7 +1207,12 @@
 			usb3: usb@48910000 {
 				compatible = "snps,dwc3";
 				reg = <0x48910000 0x17000>;
-				interrupts = <GIC_SPI 88 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_SPI 88 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 88 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 344 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "peripheral",
+						  "host",
+						  "otg";
 				tx-fifo-resize;
 				maximum-speed = "high-speed";
 				dr_mode = "otg";
@@ -1217,7 +1232,12 @@
 			usb4: usb@48950000 {
 				compatible = "snps,dwc3";
 				reg = <0x48950000 0x17000>;
-				interrupts = <GIC_SPI 345 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_SPI 345 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 345 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 346 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "peripheral",
+						  "host",
+						  "otg";
 				tx-fifo-resize;
 				maximum-speed = "high-speed";
 				dr_mode = "otg";
-- 
1.8.3.1

