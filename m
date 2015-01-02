Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbbABPYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 10:24:54 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60151 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbbABPYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 10:24:34 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Kevin Hilman <khilman@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH RESEND 3/4] ARM: dts: Set Peach boards USB WebCam regulators to always on
Date: Fri,  2 Jan 2015 16:24:16 +0100
Message-Id: <1420212257-22443-4-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1420212257-22443-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1420212257-22443-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Exynos5420 Peach Pit and Exynos5800 Peach Pi boards have a built-in
Silicon Motion USB UVC WebCam whose power supply is the tps65090 fet5
regulator. Since the camera uses the generic USB Video Class driver and
this does not grab a regulator, mark the regulator as always on so the
USB device is enumerated and usable.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 arch/arm/boot/dts/exynos5420-peach-pit.dts | 1 +
 arch/arm/boot/dts/exynos5800-peach-pi.dts  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index fa74a73..a4c5152 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -831,6 +831,7 @@
 					};
 					tps65090_fet5: fet5 {
 						regulator-name = "camout";
+						regulator-always-on;
 					};
 					tps65090_fet6: fet6 {
 						regulator-name = "lcd_vdd";
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index d603e73..1367276 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -820,6 +820,7 @@
 					};
 					tps65090_fet5: fet5 {
 						regulator-name = "camout";
+						regulator-always-on;
 					};
 					tps65090_fet6: fet6 {
 						regulator-name = "lcd_vdd";
-- 
2.1.3

