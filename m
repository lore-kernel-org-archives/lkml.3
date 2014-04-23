Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbaDWP3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:29:50 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:65265 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbaDWP3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:29:45 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgene.kim@samsung.com, stern@rowland.harvard.edu, balbi@ti.com,
        jg1.han@samsung.com, av.tikhomirov@samsung.com
Subject: [PATCH 2/3] dts: exynos5250-snow: Add required VDD regulator supplies for usb
Date: Wed, 23 Apr 2014 20:59:28 +0530
Message-Id: <1398266969-26000-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398266969-26000-1-git-send-email-gautam.vivek@samsung.com>
References: <1398266969-26000-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add required VDD 3.3V and VDD 1.0V regulator supplies to usb nodes.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/boot/dts/exynos5250-snow.dts |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index fd9b3b3..21d1f31 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -214,12 +214,24 @@
 		enable-active-high;
 	};
 
+	usb@12000000 {
+		vdd33-supply = <&ldo12_reg>;
+		vdd10-supply = <&ldo15_reg>;
+	};
+
 	phy@12100000 {
 		vbus-supply = <&usb3_vbus_reg>;
 	};
 
 	usb@12110000 {
 		samsung,vbus-gpio = <&gpx1 1 0>;
+		vdd33-supply = <&ldo12_reg>;
+		vdd10-supply = <&ldo15_reg>;
+	};
+
+	usb@12120000 {
+		vdd33-supply = <&ldo12_reg>;
+		vdd10-supply = <&ldo15_reg>;
 	};
 
 	fixed-rate-clocks {
-- 
1.7.10.4

