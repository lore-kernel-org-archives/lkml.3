Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaACN2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 08:28:19 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:33609 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbaACN2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 08:28:15 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/11] ASoC: twl4030: Remove check defaults functionality
Date: Fri, 3 Jan 2014 15:27:50 +0200
Message-ID: <1388755676-16036-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
References: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to keep the check defaults functionality anymore.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 include/linux/i2c/twl.h    |  1 -
 sound/soc/codecs/twl4030.c | 23 -----------------------
 2 files changed, 24 deletions(-)

diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index a09da0910339..2937a9472b94 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -670,7 +670,6 @@ struct twl4030_codec_data {
 	unsigned int digimic_delay; /* in ms */
 	unsigned int ramp_delay_value;
 	unsigned int offset_cncl_path;
-	unsigned int check_defaults:1;
 	unsigned int reset_registers:1;
 	unsigned int hs_extmute:1;
 	int hs_extmute_gpio;
diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index 419108ae31de..7b732ab70d2c 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -268,25 +268,6 @@ static void twl4030_codec_enable(struct snd_soc_codec *codec, int enable)
 	udelay(10);
 }
 
-static inline void twl4030_check_defaults(struct snd_soc_codec *codec)
-{
-	int i, difference = 0;
-	u8 val;
-
-	dev_dbg(codec->dev, "Checking TWL audio default configuration\n");
-	for (i = 1; i <= TWL4030_REG_MISC_SET_2; i++) {
-		twl_i2c_read_u8(TWL4030_MODULE_AUDIO_VOICE, &val, i);
-		if (val != twl4030_reg[i]) {
-			difference++;
-			dev_dbg(codec->dev,
-				 "Reg 0x%02x: chip: 0x%02x driver: 0x%02x\n",
-				 i, val, twl4030_reg[i]);
-		}
-	}
-	dev_dbg(codec->dev, "Found %d non-matching registers. %s\n",
-		 difference, difference ? "Not OK" : "OK");
-}
-
 static inline void twl4030_reset_registers(struct snd_soc_codec *codec)
 {
 	int i;
@@ -378,10 +359,6 @@ static void twl4030_init_chip(struct snd_soc_codec *codec)
 		}
 	}
 
-	/* Check defaults, if instructed before anything else */
-	if (pdata && pdata->check_defaults)
-		twl4030_check_defaults(codec);
-
 	/* Reset registers, if no setup data or if instructed to do so */
 	if (!pdata || (pdata && pdata->reset_registers))
 		twl4030_reset_registers(codec);
-- 
1.8.5.2

