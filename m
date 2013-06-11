Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab3FKHSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 03:18:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36587 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583Ab3FKHSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 03:18:10 -0400
From: Ravi Babu <ravibabu@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <balbi@ti.com>, Ravi Babu <ravibabu@ti.com>
Subject: [PATCH v2 6/7] usb: phy: dts: Adding usbphy DT bindings for am33xx
Date: Tue, 11 Jun 2013 12:47:51 +0530
Message-ID: <1370935072-21056-7-git-send-email-ravibabu@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1370935072-21056-1-git-send-email-ravibabu@ti.com>
References: <1370935072-21056-1-git-send-email-ravibabu@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The am33xx platforms suppors dual musb instance which need two instances
of usb-phy. Add dual instance usb-phy DT bindings for am333x platform.

Signed-off-by: Ravi Babu <ravibabu@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 0957645..b0b4deb 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -322,6 +322,22 @@
 			status = "disabled";
 		};
 
+		phy1: usbphy-gs70@44e10620 {
+			compatible = "ti,dsps-usbphy";
+			reg = <0x44e10620 0x8
+			       0x44e10648 0x4>;
+			reg-names = "phy_ctrl","phy_wkup";
+			id = <0>;
+		};
+
+		phy2: usbphy-gs70@44e10628 {
+			compatible = "ti,dsps-usbphy";
+			reg = <0x44e10628 0x8
+			       0x44e10648 0x4>;
+			reg-names = "phy_ctrl","phy_wkup";
+			id = <1>;
+		};
+
 		usb@47400000 {
 			compatible = "ti,musb-am33xx";
 			reg = <0x47400000 0x1000	/* usbss */
@@ -337,6 +353,7 @@
 			port1-mode = <3>;
 			power = <250>;
 			ti,hwmods = "usb_otg_hs";
+			usb-phy = <&phy1>, <&phy2>;
 		};
 
 		mac: ethernet@4a100000 {
-- 
1.7.0.4

