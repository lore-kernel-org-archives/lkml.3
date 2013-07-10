Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab3GJIPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 04:15:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34399 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab3GJIP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 04:15:29 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>
CC: <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>, <a-kishore@ti.com>,
        <afzal@ti.com>, <linux-kernel@vger.kernel.org>, <balbi@ti.com>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH v3] arm: dts: AM43x: Add usb DT nodes for AM4372
Date: Wed, 10 Jul 2013 13:44:42 +0530
Message-ID: <1373444082-4169-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds
	- HS USB nodes
	- phy nodes
	- usb control module nodes.

Signed-off-by: George Cherian <george.cherian@ti.com>
---

changes from v2
change synopsis to snps 
use simple node names
add both USB and PHY instances
add usbctrl node 

changes from v1
renamed synopsis to snps
removed flag tx-fifo-resize

 arch/arm/boot/dts/am4372.dtsi | 58 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index ddc1df7..37f196f 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -64,5 +64,63 @@
 			compatible = "ti,am4372-counter32k","ti,omap-counter32k";
 			reg = <0x44e86000 0x40>;
 		};
+
+		phy1: usbphy1 {
+			compatible = "ti,am4372-usb2";
+			#phy-cells = <0>;
+			id = <0>;
+			status = "disabled";
+		};
+
+		phy2: usbphy2 {
+			compatible = "ti,am4372-usb2";
+			#phy-cells = <0>;
+			id = <1>;
+			status = "disabled";
+		};
+
+		usbctrl: omap-control-usb@44e10620 {
+			compatible = "ti,omap-control-usb";
+			reg = <0x44e10620 0x10>;
+			reg-names = "control_dev_conf";
+			ti,type = <3>;
+			status = "disabled";
+		};
+
+		usb1: am4372_dwc3@48380000 {
+			status = "disabled";
+			compatible = "ti,am4372-dwc3";
+			reg = <0x48380000 0x200>;
+			interrupts = <GIC_SPI 172 IRQ_TYPE_LEVEL_HIGH>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			utmi-mode = <1>;
+			ranges;
+			dwc3@48390000 {
+				compatible = "snps,dwc3";
+				reg = <0x48390000 0xd000>;
+				interrupts = <GIC_SPI  168 IRQ_TYPE_LEVEL_HIGH>;
+				phys = <&phy1>;
+				phy-names = "am4372-usb1";
+			};
+		};
+
+		usb2: am4372_dwc3@483c0000 {
+			status = "disabled";
+			compatible = "ti,am4372-dwc3";
+			reg = <0x483c0000 0x200>;
+			interrupts = <GIC_SPI 178 IRQ_TYPE_LEVEL_HIGH>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			utmi-mode = <1>;
+			ranges;
+			dwc3@483d0000 {
+				compatible = "snps,dwc3";
+				reg = <0x483d0000 0xd000>;
+				interrupts = <GIC_SPI  174 IRQ_TYPE_LEVEL_HIGH>;
+				phys = <&phy2>;
+				phy-names = "am4372-usb2";
+			};
+		};
 	};
 };
-- 
1.8.1.4

