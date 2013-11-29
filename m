Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab3K2OEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 09:04:10 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44385 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756535Ab3K2OED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 09:04:03 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 4/5] ASoC: twl6040: Remove register restore functionality
Date: Fri, 29 Nov 2013 16:03:46 +0200
Message-ID: <1385733827-19831-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385733827-19831-1-git-send-email-peter.ujfalusi@ti.com>
References: <1385733827-19831-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MFD core takes care of the restore via standard regmap API, no need to
do this anymore here.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl6040.c | 29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index fb8c65b..b07839b 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -133,22 +133,6 @@ static const u8 twl6040_reg[TWL6040_CACHEREGNUM] = {
 	0x00, /* REG_STATUS	0x2E (ro) */
 };
 
-/* List of registers to be restored after power up */
-static const int twl6040_restore_list[] = {
-	TWL6040_REG_MICLCTL,
-	TWL6040_REG_MICRCTL,
-	TWL6040_REG_MICGAIN,
-	TWL6040_REG_LINEGAIN,
-	TWL6040_REG_HSLCTL,
-	TWL6040_REG_HSRCTL,
-	TWL6040_REG_HSGAIN,
-	TWL6040_REG_EARCTL,
-	TWL6040_REG_HFLCTL,
-	TWL6040_REG_HFLGAIN,
-	TWL6040_REG_HFRCTL,
-	TWL6040_REG_HFRGAIN,
-};
-
 /* set of rates for each pll: low-power and high-performance */
 static unsigned int lp_rates[] = {
 	8000,
@@ -335,17 +319,6 @@ static void twl6040_init_chip(struct snd_soc_codec *codec)
 	twl6040_write_reg_cache(codec, TWL6040_REG_LINEGAIN, 0);
 }
 
-static void twl6040_restore_regs(struct snd_soc_codec *codec)
-{
-	u8 *cache = codec->reg_cache;
-	int reg, i;
-
-	for (i = 0; i < ARRAY_SIZE(twl6040_restore_list); i++) {
-		reg = twl6040_restore_list[i];
-		twl6040_write(codec, reg, cache[reg]);
-	}
-}
-
 /* set headset dac and driver power mode */
 static int headset_power_mode(struct snd_soc_codec *codec, int high_perf)
 {
@@ -978,8 +951,6 @@ static int twl6040_set_bias_level(struct snd_soc_codec *codec,
 
 		priv->codec_powered = 1;
 
-		twl6040_restore_regs(codec);
-
 		/* Set external boost GPO */
 		twl6040_write(codec, TWL6040_REG_GPOCTL, 0x02);
 		break;
-- 
1.8.4.2

