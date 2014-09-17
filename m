Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbaIQLux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 07:50:53 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:40150 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313AbaIQLuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 07:50:50 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Daniel Drake <drake@endlessm.com>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 2/2] ARM: dts: Add rtc_src clk for s3c-rtc on exynos5250-snow
Date: Wed, 17 Sep 2014 13:50:33 +0200
Message-Id: <1410954633-27025-3-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410954633-27025-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1410954633-27025-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 546b117fdf17 ("rtc: s3c: add support for RTC of Exynos3250 SoC")
added an "rtc_src" DT property for the Samsung's S3C Real Time Clock
controller that specifies the 32.768 kHz clock that uses the RTC as its
source clock. In the case of the Exynos5250 based Snow board, the Maxim
77686 32kHz AP clock is used as the source clock.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 arch/arm/boot/dts/exynos5250-snow.dts | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index e51fcef..56eec56 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -10,6 +10,7 @@
 
 /dts-v1/;
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/clock/maxim,max77686.h>
 #include "exynos5250.dtsi"
 
 / {
@@ -29,6 +30,8 @@
 
 	rtc@101E0000 {
 		status = "okay";
+		clocks = <&clock CLK_RTC>, <&max77686 MAX77686_CLK_AP>;
+		clock-names = "rtc", "rtc_src";
 	};
 
 	pinctrl@11400000 {
@@ -350,7 +353,7 @@
 	samsung,i2c-sda-delay = <100>;
 	samsung,i2c-max-bus-freq = <378000>;
 
-	max77686@09 {
+	max77686: max77686@09 {
 		compatible = "maxim,max77686";
 		interrupt-parent = <&gpx3>;
 		interrupts = <2 0>;
-- 
2.1.0

