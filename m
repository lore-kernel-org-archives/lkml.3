Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbbASKnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 05:43:07 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:51987 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751839AbbASKnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 05:43:04 -0500
Message-ID: <1421664182.9655.55.camel@x220>
Subject: [PATCH 4/4] ASoC: samsung: remove outdated Kconfig references
From: Paul Bolle <pebolle@tiscali.nl>
To: Kukjin Kim <kgene@kernel.org>, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2015 11:43:02 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jan 2015 10:43:02.0638 (UTC) FILETIME=[B33458E0:01D033D4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbols MACH_SMDKC110 and MACH_SMDKV210 were removed in
v3.17. But the Kconfig entries for SND_SOC_SAMSUNG_SMDK_WM8580 and
SND_SOC_SAMSUNG_SMDK_WM9713 still reference them.

Perhaps these references to those removed symbols should be changed into
references to an existing symbol (such as MACH_S5PV210_DT). But
apparently no one noticed that these references were pointless ever
since v3.17. So it seems they can simply be removed. Let's do that now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 sound/soc/samsung/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
index 5f983d064920..01980bb2c6e7 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -53,7 +53,7 @@ config SND_SOC_SAMSUNG_JIVE_WM8750
 
 config SND_SOC_SAMSUNG_SMDK_WM8580
 	tristate "SoC I2S Audio support for WM8580 on SMDK"
-	depends on SND_SOC_SAMSUNG && (MACH_SMDK6410 || MACH_SMDKV210 || MACH_SMDKC110)
+	depends on SND_SOC_SAMSUNG && MACH_SMDK6410
 	depends on REGMAP_I2C
 	select SND_SOC_WM8580
 	select SND_SAMSUNG_I2S
@@ -134,7 +134,7 @@ config SND_SOC_SAMSUNG_RX1950_UDA1380
 
 config SND_SOC_SAMSUNG_SMDK_WM9713
 	tristate "SoC AC97 Audio support for SMDK with WM9713"
-	depends on SND_SOC_SAMSUNG && (MACH_SMDK6410 || MACH_SMDKV210 || MACH_SMDKC110)
+	depends on SND_SOC_SAMSUNG && MACH_SMDK6410
 	select SND_SOC_WM9713
 	select SND_SAMSUNG_AC97
 	help
-- 
1.9.3

