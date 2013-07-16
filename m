Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab3GPMvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:51:33 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41291 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932358Ab3GPMva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:51:30 -0400
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v2 1/5] arm: omap5: dts: fix reg property size
Date: Tue, 16 Jul 2013 15:50:33 +0300
Message-ID: <1373979037-27587-2-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.3.3.754.g9c3c367
In-Reply-To: <1373979037-27587-1-git-send-email-balbi@ti.com>
References: <1373979037-27587-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB3 block has a 64KiB space, another 64KiB is
used for the wrapper.

Without this change, resource_size() will get
confused and driver won't probe because size
will be negative.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index e643620..5c99f19 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -637,7 +637,7 @@
 		omap_dwc3@4a020000 {
 			compatible = "ti,dwc3";
 			ti,hwmods = "usb_otg_ss";
-			reg = <0x4a020000 0x1000>;
+			reg = <0x4a020000 0x10000>;
 			interrupts = <GIC_SPI 93 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <1>;
@@ -645,7 +645,7 @@
 			ranges;
 			dwc3@4a030000 {
 				compatible = "synopsys,dwc3";
-				reg = <0x4a030000 0x1000>;
+				reg = <0x4a030000 0x10000>;
 				interrupts = <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
 				usb-phy = <&usb2_phy>, <&usb3_phy>;
 				tx-fifo-resize;
-- 
1.8.3.3.754.g9c3c367

