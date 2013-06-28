Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab3F1Gpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 02:45:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48946 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab3F1Gpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 02:45:33 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>
CC: <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>, <a-kishore@ti.com>,
        <afzal@ti.com>, <linux-kernel@vger.kernel.org>, <balbi@ti.com>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH] arm: dts: AM43x: Add usb_otg_hs node
Date: Fri, 28 Jun 2013 12:14:47 +0530
Message-ID: <1372401887-19422-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds device node for HS USB Host module for AM437x

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 This patch is on top of 
 git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt.git for_3.11/dts

 arch/arm/boot/dts/am4372.dtsi | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index ddc1df7..e4f5eb8 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -64,5 +64,24 @@
 			compatible = "ti,am4372-counter32k","ti,omap-counter32k";
 			reg = <0x44e86000 0x40>;
 		};
+
+		usb_otg_hs1: am4372_dwc3@48380000 {
+			compatible = "ti,am437x-dwc3";
+			reg = <0x48380000 0x1ff>;
+			interrupts = <GIC_SPI 172 IRQ_TYPE_LEVEL_HIGH>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			utmi-mode = <1>;
+			ranges;
+
+			dwc3@48390000 {
+				compatible = "synopsys,dwc3";
+				reg = <0x48390000 0xcfff>;
+				interrupts = <GIC_SPI  168 IRQ_TYPE_LEVEL_HIGH>;
+				tx-fifo-resize;
+			};
+
+		};
+
 	};
 };
-- 
1.8.1.4

