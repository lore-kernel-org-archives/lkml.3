Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934252Ab3CMUkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 16:40:19 -0400
Received: from mail-gg0-f201.google.com ([209.85.161.201]:56353 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499Ab3CMUkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 16:40:14 -0400
From: Doug Anderson <dianders@chromium.org>
To: Jonathan Cameron <jic23@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Olof Johansson <olof@lixom.net>, Guenter Roeck <linux@roeck-us.net>,
        Doug Anderson <dianders@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] ARM: dts: Add adc to exynos5250 device tree file
Date: Wed, 13 Mar 2013 13:40:01 -0700
Message-Id: <1363207202-10858-4-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363207202-10858-1-git-send-email-dianders@chromium.org>
References: <1363129994-10438-1-git-send-email-dianders@chromium.org>
 <1363207202-10858-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the device tree entry for the device-tree enabled ADC driver that
recently landed in the iio tree.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v2: None

 arch/arm/boot/dts/exynos5250.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 3acf594..1642062 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -69,6 +69,17 @@
 			     <0 28 0>, <0 29 0>, <0 30 0>, <0 31 0>;
 	};
 
+	adc: adc@12D10000 {
+		compatible = "samsung,exynos-adc-v1";
+		reg = <0x12D10000 0x100>, <0x10040718 0x4>;
+		interrupts = <0 106 0>;
+		#io-channel-cells = <1>;
+		io-channel-ranges;
+
+		clocks = <&clock 303>;
+		clock-names = "adc";
+	};
+
 	watchdog {
 		compatible = "samsung,s3c2410-wdt";
 		reg = <0x101D0000 0x100>;
-- 
1.8.1.3

