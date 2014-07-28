Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaG1MSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:18:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51209 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbaG1MSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:18:31 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: linux-samsung-soc@vger.kernel.org, Hakjoo Kim <ruppi.kim@hardkernel.com>
Cc: Tarek Dakhran <t.dakhran@samsung.com>, Kevin Hilman <khilman@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...)
Subject: [RFC 5/5] ARM: dts: exynos5410: Add ODROID-XU LEDs
Date: Mon, 28 Jul 2014 14:18:12 +0200
Message-Id: <1406549892-5558-6-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406549892-5558-1-git-send-email-afaerber@suse.de>
References: <1406549892-5558-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 arch/arm/boot/dts/exynos5410-odroidxu.dts | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5410-odroidxu.dts b/arch/arm/boot/dts/exynos5410-odroidxu.dts
index b67112bf062a..f6e7555feeff 100644
--- a/arch/arm/boot/dts/exynos5410-odroidxu.dts
+++ b/arch/arm/boot/dts/exynos5410-odroidxu.dts
@@ -15,6 +15,7 @@
 
 /dts-v1/;
 #include "exynos5410.dtsi"
+#include <dt-bindings/gpio/gpio.h>
 / {
 	model = "ODROID-XU based on EXYNOS5410";
 	compatible = "hardkernel,odroid-xu", "samsung,exynos5410", "samsung,exynos5";
@@ -39,6 +40,30 @@
 		reg = <0x02037000 0x1000>;
 	};
 
+	leds {
+		compatible = "gpio-leds";
+
+		blue {
+			label = "blue:heartbeat";
+			gpios = <&gpb2 2 GPIO_ACTIVE_HIGH>;
+			default-state = "off";
+			linux,default-trigger = "heartbeat";
+		};
+
+		green {
+			label = "green:activity";
+			gpios = <&gpb2 1 GPIO_ACTIVE_HIGH>;
+			default-state = "off";
+			linux,default-trigger = "mmc0";
+		};
+
+		red {
+			label = "red:activity";
+			gpios = <&gpx2 3 GPIO_ACTIVE_HIGH>;
+			default-state = "off";
+			linux,default-trigger = "mmc1";
+		};
+	};
 };
 
 &mmc_0 {
-- 
1.9.3

