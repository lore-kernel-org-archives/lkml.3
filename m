Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbbASKmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 05:42:49 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:64249 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752014AbbASKms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 05:42:48 -0500
Message-ID: <1421664165.9655.54.camel@x220>
Subject: [PATCH 3/4] ASoC: samsung: MACH_SMDKC100 isn't supported anymore
From: Paul Bolle <pebolle@tiscali.nl>
To: Kukjin Kim <kgene@kernel.org>, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2015 11:42:45 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jan 2015 10:42:46.0464 (UTC) FILETIME=[A9906400:01D033D4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b8529ec1c1b0 ("ARM: S5PC100: no more support S5PC100 SoC")
removed Kconfig symbol MACH_SMDKC100. But there are still two references
to that symbol left. These are now pointless. Remove them too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Apparently Kukjin had a fixup queued (see
http://mailman.alsa-project.org/pipermail/alsa-devel/2014-September/081482.html ). But that fixup never entered the tree, so let's try again.

 sound/soc/samsung/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
index 3be649098b30..5f983d064920 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -53,7 +53,7 @@ config SND_SOC_SAMSUNG_JIVE_WM8750
 
 config SND_SOC_SAMSUNG_SMDK_WM8580
 	tristate "SoC I2S Audio support for WM8580 on SMDK"
-	depends on SND_SOC_SAMSUNG && (MACH_SMDK6410 || MACH_SMDKC100 || MACH_SMDKV210 || MACH_SMDKC110)
+	depends on SND_SOC_SAMSUNG && (MACH_SMDK6410 || MACH_SMDKV210 || MACH_SMDKC110)
 	depends on REGMAP_I2C
 	select SND_SOC_WM8580
 	select SND_SAMSUNG_I2S
@@ -134,7 +134,7 @@ config SND_SOC_SAMSUNG_RX1950_UDA1380
 
 config SND_SOC_SAMSUNG_SMDK_WM9713
 	tristate "SoC AC97 Audio support for SMDK with WM9713"
-	depends on SND_SOC_SAMSUNG && (MACH_SMDK6410 || MACH_SMDKC100 || MACH_SMDKV210 || MACH_SMDKC110)
+	depends on SND_SOC_SAMSUNG && (MACH_SMDK6410 || MACH_SMDKV210 || MACH_SMDKC110)
 	select SND_SOC_WM9713
 	select SND_SAMSUNG_AC97
 	help
-- 
1.9.3

