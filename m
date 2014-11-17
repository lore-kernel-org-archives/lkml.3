Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaKQRnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 12:43:41 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:57217 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaKQRnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 12:43:39 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Simon Glass <sjg@chromium.org>,
        Olof Johansson <olof@lixom.net>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 1/3] ARM: dts: Add SPI flash node for Peach boards
Date: Mon, 17 Nov 2014 18:43:02 +0100
Message-Id: <1416246184-29071-2-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416246184-29071-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1416246184-29071-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Glass <sjg@chromium.org>

Peach Pit and Pi machines have a SPI flash memory that is used to store
firmware data and different system parameters.

Add a spidev node so the flash chip can be accessed by user-space tools.

Signed-off-by: Simon Glass <sjg@chromium.org>
Reviewed-by: Doug Anderson <dianders@chromium.org>
[javier.martinez: Extend commit message]
Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 arch/arm/boot/dts/exynos5420-peach-pit.dts | 26 ++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos5800-peach-pi.dts  | 26 ++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index 9a050e1..e7c2a9f 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -703,6 +703,13 @@
 		samsung,pin-drv = <2>;
 	};
 
+	spi_flash_cs: spi-flash-cs {
+		samsung,pins = "gpa2-5";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <3>;
+	};
+
 	usb300_vbus_en: usb300-vbus-en {
 		samsung,pins = "gph0-0";
 		samsung,pin-function = <1>;
@@ -732,6 +739,25 @@
 	clock-names = "rtc", "rtc_src";
 };
 
+&spi_1 {
+	status = "okay";
+	samsung,spi-src-clk = <0>;
+	num-cs = <1>;
+	cs-gpios = <&gpa2 5 0>;
+
+	spidev@0 {
+		compatible = "spidev";
+		reg = <0>;
+		spi-max-frequency = <50000000>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&spi_flash_cs>;
+
+		controller-data {
+			samsung,spi-feedback-delay = <2>;
+		};
+	};
+};
+
 &spi_2 {
 	status = "okay";
 	num-cs = <1>;
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index e8fdda8..7a0a2a6 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -691,6 +691,13 @@
 		samsung,pin-drv = <2>;
 	};
 
+	spi_flash_cs: spi-flash-cs {
+		samsung,pins = "gpa2-5";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <3>;
+	};
+
 	usb300_vbus_en: usb300-vbus-en {
 		samsung,pins = "gph0-0";
 		samsung,pin-function = <1>;
@@ -720,6 +727,25 @@
 	clock-names = "rtc", "rtc_src";
 };
 
+&spi_1 {
+	status = "okay";
+	samsung,spi-src-clk = <0>;
+	num-cs = <1>;
+	cs-gpios = <&gpa2 5 0>;
+
+	spidev@0 {
+		compatible = "spidev";
+		reg = <0>;
+		spi-max-frequency = <50000000>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&spi_flash_cs>;
+
+		controller-data {
+			samsung,spi-feedback-delay = <2>;
+		};
+	};
+};
+
 &spi_2 {
 	status = "okay";
 	num-cs = <1>;
-- 
2.1.0

