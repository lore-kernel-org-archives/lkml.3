Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926Ab3GPMwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:52:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49429 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932191Ab3GPMvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:51:32 -0400
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v2 3/5] arm: omap5: dts: add palmas-usb node
Date: Tue, 16 Jul 2013 15:50:35 +0300
Message-ID: <1373979037-27587-4-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.3.3.754.g9c3c367
In-Reply-To: <1373979037-27587-1-git-send-email-balbi@ti.com>
References: <1373979037-27587-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this node, there will be no palmas
driver to notify dwc3 that a cable has
been connected and, without that, dwc3
will never initialize.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/boot/dts/omap5-uevm.dts | 10 ++++++++++
 arch/arm/boot/dts/omap5.dtsi     |  2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap5-uevm.dts b/arch/arm/boot/dts/omap5-uevm.dts
index 08b7267..badceb8 100644
--- a/arch/arm/boot/dts/omap5-uevm.dts
+++ b/arch/arm/boot/dts/omap5-uevm.dts
@@ -272,6 +272,11 @@
 		interrupt-controller;
 		#interrupt-cells = <2>;
 
+		extcon_usb3: palmas_usb {
+			compatible = "ti,palmas-usb";
+			ti,wakeup;
+		};
+
 		palmas_pmic {
 			compatible = "ti,palmas-pmic";
 			interrupt-parent = <&palmas>;
@@ -450,6 +455,11 @@
 	phys = <0 &hsusb2_phy &hsusb3_phy>;
 };
 
+&usb3 {
+	extcon = <&extcon_usb3>;
+	vbus-supply = <&smps10_reg>;
+};
+
 &mcspi1 {
 
 };
diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 4e41409..1659246 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -634,7 +634,7 @@
 			ti,type = <2>;
 		};
 
-		omap_dwc3@4a020000 {
+		usb3: omap_dwc3@4a020000 {
 			compatible = "ti,dwc3";
 			ti,hwmods = "usb_otg_ss";
 			reg = <0x4a020000 0x10000>;
-- 
1.8.3.3.754.g9c3c367

