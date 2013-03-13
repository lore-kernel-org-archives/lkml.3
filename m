Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934276Ab3CMUk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 16:40:59 -0400
Received: from mail-ve0-f202.google.com ([209.85.128.202]:57795 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510Ab3CMUkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 16:40:15 -0400
From: Doug Anderson <dianders@chromium.org>
To: Jonathan Cameron <jic23@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Olof Johansson <olof@lixom.net>, Guenter Roeck <linux@roeck-us.net>,
        Doug Anderson <dianders@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] ARM: dts: Add adc and thermistors for exynos5250-snow
Date: Wed, 13 Mar 2013 13:40:02 -0700
Message-Id: <1363207202-10858-5-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363207202-10858-1-git-send-email-dianders@chromium.org>
References: <1363129994-10438-1-git-send-email-dianders@chromium.org>
 <1363207202-10858-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hook up the exynos5250-snow thermistors via the device tree now that
there's a driver available to use them.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v2:
- Match 'uV' -> 'uv' change in Naveen's bindings.

 arch/arm/boot/dts/cros5250-common.dtsi |  4 ++++
 arch/arm/boot/dts/exynos5250-snow.dts  | 31 +++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/arch/arm/boot/dts/cros5250-common.dtsi b/arch/arm/boot/dts/cros5250-common.dtsi
index 46c0980..f7cc835 100644
--- a/arch/arm/boot/dts/cros5250-common.dtsi
+++ b/arch/arm/boot/dts/cros5250-common.dtsi
@@ -167,6 +167,10 @@
 		status = "disabled";
 	};
 
+	adc@12D10000 {
+		vdd-supply = <&buck5_reg>;
+	};
+
 	hdmi {
 		hpd-gpio = <&gpx3 7 0xf 1 3>;
 	};
diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index 17dd951..b78da7c 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -40,4 +40,35 @@
 				<&gpc4 5 2 3 0>, <&gpc4 6 2 3 0>;
 		};
 	};
+
+	adc@12D10000 {
+		ncp15wb473@3 {
+			compatible = "ntc,ncp15wb473";
+			pullup-uv = <1800000>;
+			pullup-ohm = <47000>;
+			pulldown-ohm = <0>;
+			io-channels = <&adc 3>;
+		};
+		ncp15wb473@4 {
+			compatible = "ntc,ncp15wb473";
+			pullup-uv = <1800000>;
+			pullup-ohm = <47000>;
+			pulldown-ohm = <0>;
+			io-channels = <&adc 4>;
+		};
+		ncp15wb473@5 {
+			compatible = "ntc,ncp15wb473";
+			pullup-uv = <1800000>;
+			pullup-ohm = <47000>;
+			pulldown-ohm = <0>;
+			io-channels = <&adc 5>;
+		};
+		ncp15wb473@6 {
+			compatible = "ntc,ncp15wb473";
+			pullup-uv = <1800000>;
+			pullup-ohm = <47000>;
+			pulldown-ohm = <0>;
+			io-channels = <&adc 6>;
+		};
+	};
 };
-- 
1.8.1.3

