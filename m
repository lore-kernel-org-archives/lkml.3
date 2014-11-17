Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaKQRnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 12:43:46 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:57218 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbaKQRnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 12:43:43 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Simon Glass <sjg@chromium.org>,
        Olof Johansson <olof@lixom.net>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 2/3] ARM: dts: Add spidev registration to exynos5250-snow
Date: Mon, 17 Nov 2014 18:43:03 +0100
Message-Id: <1416246184-29071-3-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416246184-29071-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1416246184-29071-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Anderson <dianders@chromium.org>

Exynos5250 Snow machine has a SPI flash memory that is used to store
firmware data and different system parameters.

Add a spidev node so the flash chip can be accessed by user-space tools.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Olof Johansson <olofj@chromium.org>
[javier.martinez: Extend commit message]
Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 arch/arm/boot/dts/exynos5250-snow.dts | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index f9bc04b..bb0e04e 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -554,6 +554,13 @@
 		samsung,pin-drv = <0>;
 	};
 
+	spi_cs: spi-cs {
+		samsung,pins = "gpa2-5";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <3>;
+	};
+
 	tps65090_irq: tps65090-irq {
 		samsung,pins = "gpx2-6";
 		samsung,pin-function = <0>;
@@ -622,6 +629,19 @@
 	status = "okay";
 	samsung,spi-src-clk = <0>;
 	num-cs = <1>;
+	cs-gpios = <&gpa2 5 0>;
+
+	spidev@0 {
+		compatible = "spidev";
+		reg = <0>;
+		spi-max-frequency = <10000000>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&spi_cs>;
+
+		controller-data {
+			samsung,spi-feedback-delay = <2>;
+		};
+	};
 };
 
 &usbdrd_phy {
-- 
2.1.0

