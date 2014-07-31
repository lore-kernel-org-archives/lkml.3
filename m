Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374AbaGaL4C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:56:02 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:59614 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaGaLz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:55:59 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 2/2] ARM: dts: Add tps65090 FET constraints on Peach Pit and Pi
Date: Thu, 31 Jul 2014 13:55:11 +0200
Message-Id: <1406807711-19955-3-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406807711-19955-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1406807711-19955-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both Exynos5420 Peach Pit and Exynos5800 Peach Pi boards
have a tps65090 PMU that has a number of switches (FETs)
that are just on/off devices but they do have a current
limit and the output voltage of the switch is ramped up
within a controlled slope.

After the switch is turned on, a safety timer is started
and before this timer times out the output voltage must
have reached the input voltage. Otherwise the switch is
turned off expecting an overload condition.

So using the maximum output voltage slew rate and the timer
minimum and maximum timeouts, a voltage constraints can be
expressed as bounded limits for the timeout. That is what
is used in the board schematics and should be in the DT too.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 arch/arm/boot/dts/exynos5420-peach-pit.dts | 14 ++++++++++++++
 arch/arm/boot/dts/exynos5800-peach-pi.dts  | 14 ++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index d8710c1..eefafe6 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -386,27 +386,41 @@
 					};
 					tps65090_fet1: fet1 {
 						regulator-name = "vcd_led";
+						regulator-min-microvolt = <5000000>;
+						regulator-max-microvolt = <1700000>;
 					};
 					tps65090_fet2: fet2 {
 						regulator-name = "video_mid";
+						regulator-min-microvolt = <4500000>;
+						regulator-max-microvolt = <5500000>;
 						regulator-always-on;
 					};
 					tps65090_fet3: fet3 {
 						regulator-name = "wwan_r";
+						regulator-min-microvolt = <3000000>;
+						regulator-max-microvolt = <5500000>;
 						regulator-always-on;
 					};
 					tps65090_fet4: fet4 {
 						regulator-name = "sdcard";
+						regulator-min-microvolt = <3000000>;
+						regulator-max-microvolt = <5500000>;
 						regulator-always-on;
 					};
 					tps65090_fet5: fet5 {
 						regulator-name = "camout";
+						regulator-min-microvolt = <3000000>;
+						regulator-max-microvolt = <5500000>;
 					};
 					tps65090_fet6: fet6 {
 						regulator-name = "lcd_vdd";
+						regulator-min-microvolt = <3000000>;
+						regulator-max-microvolt = <5500000>;
 					};
 					tps65090_fet7: fet7 {
 						regulator-name = "video_mid_1a";
+						regulator-min-microvolt = <3000000>;
+						regulator-max-microvolt = <5500000>;
 						regulator-always-on;
 					};
 					tps65090_ldo1: ldo1 {
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index 07b29b7..5c38bc0 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -384,27 +384,41 @@
 					};
 					tps65090_fet1: fet1 {
 						regulator-name = "vcd_led";
+						regulator-min-microvolt = <5000000>;
+						regulator-max-microvolt = <1700000>;
 					};
 					tps65090_fet2: fet2 {
 						regulator-name = "video_mid";
+						regulator-min-microvolt = <4500000>;
+						regulator-max-microvolt = <5500000>;
 						regulator-always-on;
 					};
 					tps65090_fet3: fet3 {
 						regulator-name = "wwan_r";
+						regulator-min-microvolt = <3000000>;
+						regulator-max-microvolt = <5500000>;
 						regulator-always-on;
 					};
 					tps65090_fet4: fet4 {
 						regulator-name = "sdcard";
+						regulator-min-microvolt = <3000000>;
+						regulator-max-microvolt = <5500000>;
 						regulator-always-on;
 					};
 					tps65090_fet5: fet5 {
 						regulator-name = "camout";
+						regulator-min-microvolt = <3000000>;
+						regulator-max-microvolt = <5500000>;
 					};
 					tps65090_fet6: fet6 {
 						regulator-name = "lcd_vdd";
+						regulator-min-microvolt = <3000000>;
+						regulator-max-microvolt = <5500000>;
 					};
 					tps65090_fet7: fet7 {
 						regulator-name = "video_mid_1a";
+						regulator-min-microvolt = <3000000>;
+						regulator-max-microvolt = <5500000>;
 						regulator-always-on;
 					};
 					tps65090_ldo1: ldo1 {
-- 
2.0.0.rc2

