Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaHSPIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:08:54 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:42450 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbaHSPIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:08:51 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 4/6] ARM: dts: Add thermistor dts fragment used by exynos based Peach boards
Date: Tue, 19 Aug 2014 17:08:31 +0200
Message-Id: <1408460913-13863-5-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1408460913-13863-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1408460913-13863-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>

This patch creates a thermistor fragment carrying the NTC Thermistor
nodes as children of the IIO based ADC.

This fragment is included in exynos5420-peach-pit.dts and
exynos5800-peach-pi.dts.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 arch/arm/boot/dts/cros-adc-thermistors.dtsi | 44 +++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos5420-peach-pit.dts  |  6 ++++
 arch/arm/boot/dts/exynos5800-peach-pi.dts   |  6 ++++
 3 files changed, 56 insertions(+)
 create mode 100644 arch/arm/boot/dts/cros-adc-thermistors.dtsi

diff --git a/arch/arm/boot/dts/cros-adc-thermistors.dtsi b/arch/arm/boot/dts/cros-adc-thermistors.dtsi
new file mode 100644
index 0000000..acd4fe1
--- /dev/null
+++ b/arch/arm/boot/dts/cros-adc-thermistors.dtsi
@@ -0,0 +1,44 @@
+/*
+ * Thermistor dts fragment for devices that use Thermistors as
+ * children of the IIO based ADC.
+ *
+ * Currently, used by Exynos5420 based Peach PIT and
+ * Exynos5800 based Peach PI.
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+&adc {
+	ncp15wb473@3 {
+		compatible = "murata,ncp15wb473";
+		pullup-uv = <1800000>;
+		pullup-ohm = <47000>;
+		pulldown-ohm = <0>;
+		io-channels = <&adc 3>;
+	};
+	ncp15wb473@4 {
+		compatible = "murata,ncp15wb473";
+		pullup-uv = <1800000>;
+		pullup-ohm = <47000>;
+		pulldown-ohm = <0>;
+		io-channels = <&adc 4>;
+	};
+	ncp15wb473@5 {
+		compatible = "murata,ncp15wb473";
+		pullup-uv = <1800000>;
+		pullup-ohm = <47000>;
+		pulldown-ohm = <0>;
+		io-channels = <&adc 5>;
+	};
+	ncp15wb473@6 {
+		compatible = "murata,ncp15wb473";
+		pullup-uv = <1800000>;
+		pullup-ohm = <47000>;
+		pulldown-ohm = <0>;
+		io-channels = <&adc 6>;
+	};
+};
diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index 9cf53b1..8e50042 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -102,6 +102,11 @@
 	};
 };
 
+&adc {
+	status = "okay";
+	vdd-supply = <&ldo9_reg>;
+};
+
 &dp {
 	status = "okay";
 	pinctrl-names = "default";
@@ -821,3 +826,4 @@
 };
 
 #include "cros-ec-keyboard.dtsi"
+#include "cros-adc-thermistors.dtsi"
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index e613827..939f91c 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -100,6 +100,11 @@
 	};
 };
 
+&adc {
+	status = "okay";
+	vdd-supply = <&ldo9_reg>;
+};
+
 &dp {
 	status = "okay";
 	pinctrl-names = "default";
@@ -819,3 +824,4 @@
 };
 
 #include "cros-ec-keyboard.dtsi"
+#include "cros-adc-thermistors.dtsi"
-- 
2.0.1

