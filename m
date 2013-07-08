Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab3GHKn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 06:43:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48133 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3GHKn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 06:43:56 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-omap@vger.kernel.org>,
        <kishon@ti.com>, <bigeasy@linutronix.de>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 4/5] arm: dts: Add USB phy nodes for AM33XX
Date: Mon, 8 Jul 2013 16:13:20 +0530
Message-ID: <1373280201-31785-5-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1373280201-31785-1-git-send-email-george.cherian@ti.com>
References: <1373280201-31785-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT bindings of phy nodes for AM33XX platform.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 8e1248f..4f3cca0 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -326,6 +326,25 @@
 			status = "disabled";
 		};
 
+		phy1: usbphy-gs70@44e10620 {
+			compatible = "ti,am335x-usb2";
+			#phy-cells = <0>;
+			id = <0>;
+		};
+
+		phy2: usbphy-gs71@44e10628 {
+			compatible = "ti,am335x-usb2";
+			#phy-cells = <0>;
+			id = <1>;
+		};
+
+		omap_control_usb: omap-control-usb@44e10620 {
+			compatible = "ti,omap-control-usb";
+			reg = <0x44e10620 0x10>;
+			reg-names = "control_dev_conf";
+			ti,type = <3>;
+		};
+
 		usb@47400000 {
 			compatible = "ti,musb-am33xx";
 			reg = <0x47400000 0x1000	/* usbss */
@@ -341,6 +360,9 @@
 			port1-mode = <3>;
 			power = <250>;
 			ti,hwmods = "usb_otg_hs";
+			phy-names = "am335x-usb0", "am335x-usb1";
+			phys	= <&phy1>, <&phy2>;
+
 		};
 
 		mac: ethernet@4a100000 {
-- 
1.8.1.4

