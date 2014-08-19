Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaHSPJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:09:27 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:42455 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbaHSPIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:08:53 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 5/6] ARM: dts: Add vmmc and vqmmc supplies for Peach Pit and Pi boards
Date: Tue, 19 Aug 2014 17:08:32 +0200
Message-Id: <1408460913-13863-6-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1408460913-13863-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1408460913-13863-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VCC/VDD and VCCQ/VDD_IO power supplies for the MMC are
provided by the tps65090 fet4 and max77802 ldo4 regulators
respectively. Add the phandle to the regulators tree nodes
for the the dw_mmc device device.

These DTS snippets were taken from the downstream ChromeOS
3.8 kernel Device Tree for Peach Pit and Pi boards.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 arch/arm/boot/dts/exynos5420-peach-pit.dts | 2 ++
 arch/arm/boot/dts/exynos5800-peach-pi.dts  | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index 8e50042..5b9dbb9 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -547,6 +547,8 @@
 };
 
 &mmc_2 {
+	vmmc-supply = <&tps65090_fet4>;
+	vqmmc-supply = <&vqmmc_sdcard>;
 	status = "okay";
 	num-slots = <1>;
 	supports-highspeed;
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index 939f91c..dcac443 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -545,6 +545,8 @@
 };
 
 &mmc_2 {
+	vmmc-supply = <&tps65090_fet4>;
+	vqmmc-supply = <&vqmmc_sdcard>;
 	status = "okay";
 	num-slots = <1>;
 	supports-highspeed;
-- 
2.0.1

