Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964826Ab3CLXNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:13:46 -0400
Received: from mail-qe0-f73.google.com ([209.85.128.73]:45711 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933993Ab3CLXNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 19:13:40 -0400
From: Doug Anderson <dianders@chromium.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Olof Johansson <olof@lixom.net>, Doug Anderson <dianders@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] ARM: dts: Add adc and thermistors for exynos5250-snow
Date: Tue, 12 Mar 2013 16:13:14 -0700
Message-Id: <1363129994-10438-5-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363129994-10438-1-git-send-email-dianders@chromium.org>
References: <1363129994-10438-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hook up the exynos5250-snow thermistors via the device tree now that
there's a driver available to use them.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/boot/dts/cros5250-common.dtsi |  4 ++++
 arch/arm/boot/dts/exynos5250-snow.dts  | 31 +++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/arch/arm/boot/dts/cros5250-common.dtsi b/arch/arm/boot/dts/cros5250-common.dtsi
index 62eceb4..cb48981 100644
--- a/arch/arm/boot/dts/cros5250-common.dtsi
+++ b/arch/arm/boot/dts/cros5250-common.dtsi
@@ -305,6 +305,10 @@
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
index babd9f9..1cab5fd 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -51,4 +51,35 @@
 			clock-frequency = <24000000>;
 		};
 	};
+
+	adc@12D10000 {
+		ncp15wb473@3 {
+			compatible = "ntc,ncp15wb473";
+			pullup-uV = <1800000>;
+			pullup-ohm = <47000>;
+			pulldown-ohm = <0>;
+			io-channels = <&adc 3>;
+		};
+		ncp15wb473@4 {
+			compatible = "ntc,ncp15wb473";
+			pullup-uV = <1800000>;
+			pullup-ohm = <47000>;
+			pulldown-ohm = <0>;
+			io-channels = <&adc 4>;
+		};
+		ncp15wb473@5 {
+			compatible = "ntc,ncp15wb473";
+			pullup-uV = <1800000>;
+			pullup-ohm = <47000>;
+			pulldown-ohm = <0>;
+			io-channels = <&adc 5>;
+		};
+		ncp15wb473@6 {
+			compatible = "ntc,ncp15wb473";
+			pullup-uV = <1800000>;
+			pullup-ohm = <47000>;
+			pulldown-ohm = <0>;
+			io-channels = <&adc 6>;
+		};
+	};
 };
-- 
1.8.1.3

