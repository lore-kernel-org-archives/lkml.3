Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbaKYNQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:16:58 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44921 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093AbaKYNQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:16:54 -0500
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
Subject: [PATCH 15/19] arm: dts: am4372: Add named interrupt property for dwc3
Date: Tue, 25 Nov 2014 18:41:51 +0530
Message-ID: <1416921115-10467-16-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1416921115-10467-1-git-send-email-george.cherian@ti.com>
References: <1416921115-10467-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <balbi@ti.com>

Add interrupt names so that the same can be used for OTG easily.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: George Cherian <george.cherian@ti.com>
---
 arch/arm/boot/dts/am4372.dtsi | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index e19068d..3dda4c8 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -810,8 +810,13 @@
 
 			usb1: usb@48390000 {
 				compatible = "synopsys,dwc3";
-				reg = <0x48390000 0x10000>;
-				interrupts = <GIC_SPI 168 IRQ_TYPE_LEVEL_HIGH>;
+				reg = <0x48390000 0x17000>;
+				interrupts = <GIC_SPI 168 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 168 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 172 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "peripheral",
+						  "host",
+						  "otg";
 				phys = <&usb2_phy1>;
 				phy-names = "usb2-phy";
 				maximum-speed = "high-speed";
@@ -834,8 +839,13 @@
 
 			usb2: usb@483d0000 {
 				compatible = "synopsys,dwc3";
-				reg = <0x483d0000 0x10000>;
-				interrupts = <GIC_SPI 174 IRQ_TYPE_LEVEL_HIGH>;
+				reg = <0x483d0000 0x17000>;
+				interrupts = <GIC_SPI 174 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 174 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 178 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "peripheral",
+						  "host",
+						  "otg";
 				phys = <&usb2_phy2>;
 				phy-names = "usb2-phy";
 				maximum-speed = "high-speed";
-- 
1.8.3.1

