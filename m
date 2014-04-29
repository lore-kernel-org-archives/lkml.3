Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbaD2LTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:19:23 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:55724 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757331AbaD2LTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:19:17 -0400
From: Xia Kaixu <kaixu.xia@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, arnd@arndb.de, kaixu.xia@linaro.org,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH 03/15] ASoC: SMDK_WM8580_PCM needs REGMAP_I2C
Date: Tue, 29 Apr 2014 19:18:24 +0800
Message-Id: <1398770316-19715-4-git-send-email-kaixu.xia@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

This adds a missing dependency for SND_SOC_SMDK_WM8580_PCM to
require REGMAP_I2C to be enabled, avoiding possible build
erorrs.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Xia Kaixu <kaixu.xia@linaro.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: alsa-devel@alsa-project.org
---
 sound/soc/samsung/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
index 14568be..0c5e9e2 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -64,6 +64,7 @@ config SND_SOC_SAMSUNG_JIVE_WM8750
 config SND_SOC_SAMSUNG_SMDK_WM8580
 	tristate "SoC I2S Audio support for WM8580 on SMDK"
 	depends on SND_SOC_SAMSUNG && (MACH_SMDK6410 || MACH_SMDKC100 || MACH_SMDK6440 || MACH_SMDK6450 || MACH_SMDKV210 || MACH_SMDKC110)
+	depends on REGMAP_I2C
 	select SND_SOC_WM8580
 	select SND_SAMSUNG_I2S
 	help
@@ -178,6 +179,7 @@ config SND_SOC_SAMSUNG_SMDK_SPDIF
 config SND_SOC_SMDK_WM8580_PCM
 	tristate "SoC PCM Audio support for WM8580 on SMDK"
 	depends on SND_SOC_SAMSUNG && (MACH_SMDK6450 || MACH_SMDKV210 || MACH_SMDKC110)
+	depends on REGMAP_I2C
 	select SND_SOC_WM8580
 	select SND_SAMSUNG_PCM
 	help
-- 
1.7.9.5

