Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab3JJW0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 18:26:50 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:40789 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711Ab3JJW0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 18:26:42 -0400
From: Sean Paul <seanpaul@chromium.org>
To: kgene.kim@samsung.com, dri-devel@lists.freedesktop.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        inki.dae@samsung.com
Cc: airlied@linux.ie, Sean Paul <seanpaul@chromium.org>
Subject: [PATCH v3 5/5] ARM: dts: Add ptn3460 to exynos5250-snow
Date: Thu, 10 Oct 2013 18:26:18 -0400
Message-Id: <1381443978-5654-6-git-send-email-seanpaul@chromium.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381443978-5654-1-git-send-email-seanpaul@chromium.org>
References: <1380839303-4834-1-git-send-email-seanpaul@chromium.org>
 <1381443978-5654-1-git-send-email-seanpaul@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a node for the ptn3460 DP-LVDS chip in the
exynos5250-snow board dts file.

Signed-off-by: Sean Paul <seanpaul@chromium.org>
---

v2: Changed node name to lvds-bridge
v3: No changes

 arch/arm/boot/dts/exynos5250-snow.dts | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index f813644..8c92df8 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -33,6 +33,13 @@
 		sd3_bus4: sd3-bus-width4 {
 			samsung,pin-drv = <0>;
 		};
+
+		ptn3460_gpios: ptn3460-gpios {
+			samsung,pins = "gpy2-5", "gpx1-5";
+			samsung,pin-function = <1>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
 	};
 
 	gpio-keys {
@@ -186,6 +193,18 @@
 		samsung,vbus-gpio = <&gpx1 1 0>;
 	};
 
+	i2c@12CD0000 {
+		lvds-bridge@20 {
+			compatible = "nxp,ptn3460";
+			reg = <0x20>;
+			powerdown-gpio = <&gpy2 5 0>;
+			reset-gpio = <&gpx1 5 0>;
+			edid-emulation = <5>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&ptn3460_gpios>;
+		};
+	};
+
 	dp-controller@145B0000 {
 		samsung,color-space = <0>;
 		samsung,dynamic-range = <0>;
-- 
1.8.4

