Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbaHSPI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:08:57 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:42458 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbaHSPIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:08:55 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 6/6] ARM: dts: Add Peach Pit and Pi dts entry for ISL29018 sensor
Date: Tue, 19 Aug 2014 17:08:33 +0200
Message-Id: <1408460913-13863-7-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1408460913-13863-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1408460913-13863-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Exynos5420 based Peach Pit and the Exynos5800 based Peach Pi
machines have an i2c ISL29018 light sensor. This patch adds the
device nodes needed to support this device.

These DTS snippets were taken from the downstream Chrome OS 3.8
kernel Device Tree for Peach Pit and Pi boards.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 arch/arm/boot/dts/exynos5420-peach-pit.dts | 6 ++++++
 arch/arm/boot/dts/exynos5800-peach-pi.dts  | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index 5b9dbb9..b835953 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -498,6 +498,12 @@
 		pinctrl-names = "default";
 		pinctrl-0 = <&max98090_irq>;
 	};
+
+	light-sensor@44 {
+		compatible = "isil,isl29018";
+		reg = <0x44>;
+		vcc-supply = <&tps65090_fet5>;
+	};
 };
 
 &hsi2c_9 {
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index dcac443..c3c51c0 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -496,6 +496,12 @@
 		pinctrl-names = "default";
 		pinctrl-0 = <&max98091_irq>;
 	};
+
+	light-sensor@44 {
+		compatible = "isil,isl29018";
+		reg = <0x44>;
+		vcc-supply = <&tps65090_fet5>;
+	};
 };
 
 &hsi2c_9 {
-- 
2.0.1

