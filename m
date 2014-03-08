Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaCHJcB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 04:32:01 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:61274 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbaCHJbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 04:31:46 -0500
From: Max Filippov <jcmvbkbc@gmail.com>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH] ASoC: tlv320aic23: add missing EXPORT_SYMBOLs
Date: Sat,  8 Mar 2014 13:31:06 +0400
Message-Id: <1394271066-25380-1-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following build errors when aic23 is configured as
module:

>> ERROR: "tlv320aic23_probe"
>> [sound/soc/codecs/snd-soc-tlv320aic23-i2c.ko] undefined!
>> ERROR: "tlv320aic23_regmap"
>> [sound/soc/codecs/snd-soc-tlv320aic23-i2c.ko] undefined!

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 sound/soc/codecs/tlv320aic23.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/tlv320aic23.c b/sound/soc/codecs/tlv320aic23.c
index 455250f..a934add 100644
--- a/sound/soc/codecs/tlv320aic23.c
+++ b/sound/soc/codecs/tlv320aic23.c
@@ -59,6 +59,7 @@ const struct regmap_config tlv320aic23_regmap = {
 	.num_reg_defaults = ARRAY_SIZE(tlv320aic23_reg),
 	.cache_type = REGCACHE_RBTREE,
 };
+EXPORT_SYMBOL(tlv320aic23_regmap);
 
 static const char *rec_src_text[] = { "Line", "Mic" };
 static const char *deemph_text[] = {"None", "32Khz", "44.1Khz", "48Khz"};
@@ -634,6 +635,7 @@ int tlv320aic23_probe(struct device *dev, struct regmap *regmap)
 	return snd_soc_register_codec(dev, &soc_codec_dev_tlv320aic23,
 				      &tlv320aic23_dai, 1);
 }
+EXPORT_SYMBOL(tlv320aic23_probe);
 
 MODULE_DESCRIPTION("ASoC TLV320AIC23 codec driver");
 MODULE_AUTHOR("Arun KS <arunks@mistralsolutions.com>");
-- 
1.8.1.4

