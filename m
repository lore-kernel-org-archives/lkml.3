Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbaGDJP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:15:58 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:52979 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372AbaGDJPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:15:54 -0400
From: Tushar Behera <tushar.b@samsung.com>
To: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Cc: tiwai@suse.de, perex@perex.cz, broonie@kernel.org, lgirdwood@gmail.com,
        trblinux@gmail.com
Subject: [PATCH 2/2] ASoC: max98090: Remove redundant max98090_handle_pdata()
Date: Fri,  4 Jul 2014 14:42:17 +0530
Message-Id: <1404465137-14295-2-git-send-email-tushar.b@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404465137-14295-1-git-send-email-tushar.b@samsung.com>
References: <1404465137-14295-1-git-send-email-tushar.b@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max98090_handle_pdata() is not doing anything other than printing
a message if pdata is not valid. This can be removed.

Signed-off-by: Tushar Behera <tushar.b@samsung.com>
---
 sound/soc/codecs/max98090.c |   13 -------------
 1 file changed, 13 deletions(-)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 1ed06d9..b2b3286 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -2200,17 +2200,6 @@ static struct snd_soc_dai_driver max98090_dai[] = {
 }
 };
 
-static void max98090_handle_pdata(struct snd_soc_codec *codec)
-{
-	struct max98090_priv *max98090 = snd_soc_codec_get_drvdata(codec);
-	struct max98090_pdata *pdata = max98090->pdata;
-
-	if (!pdata) {
-		dev_err(codec->dev, "No platform data\n");
-		return;
-	}
-}
-
 static int max98090_probe(struct snd_soc_codec *codec)
 {
 	struct max98090_priv *max98090 = snd_soc_codec_get_drvdata(codec);
@@ -2310,8 +2299,6 @@ static int max98090_probe(struct snd_soc_codec *codec)
 	snd_soc_update_bits(codec, M98090_REG_MIC_BIAS_VOLTAGE,
 		M98090_MBVSEL_MASK, M98090_MBVSEL_2V8);
 
-	max98090_handle_pdata(codec);
-
 	max98090_add_widgets(codec);
 
 err_access:
-- 
1.7.9.5

