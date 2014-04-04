Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbaDDLoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 07:44:39 -0400
Received: from smtprelay01.ispgateway.de ([80.67.31.24]:54044 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbaDDLog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 07:44:36 -0400
From: Christoph Jaeger <christophjaeger@linux.com>
To: tiwai@suse.de, perex@perex.cz, broonie@kernel.org, lgirdwood@gmail.com
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <christophjaeger@linux.com>
Subject: [PATCH] ASoC: alc56(23|32): fix undefined return value of probing code
Date: Fri,  4 Apr 2014 13:44:19 +0200
Message-Id: <1396611859-719-1-git-send-email-christophjaeger@linux.com>
X-Mailer: git-send-email 1.9.0
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5d6be5aa ("ASoC: codec: Simplify ASoC probe code.") left variable
'ret', whose value is returned, uninitialized. Since it is not used
otherwise, remove it.

Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
---
 sound/soc/codecs/alc5623.c | 3 +--
 sound/soc/codecs/alc5632.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/alc5623.c b/sound/soc/codecs/alc5623.c
index 09f7e77..f500905 100644
--- a/sound/soc/codecs/alc5623.c
+++ b/sound/soc/codecs/alc5623.c
@@ -902,7 +902,6 @@ static int alc5623_probe(struct snd_soc_codec *codec)
 {
 	struct alc5623_priv *alc5623 = snd_soc_codec_get_drvdata(codec);
 	struct snd_soc_dapm_context *dapm = &codec->dapm;
-	int ret;
 
 	alc5623_reset(codec);
 
@@ -961,7 +960,7 @@ static int alc5623_probe(struct snd_soc_codec *codec)
 		return -EINVAL;
 	}
 
-	return ret;
+	return 0;
 }
 
 /* power down chip */
diff --git a/sound/soc/codecs/alc5632.c b/sound/soc/codecs/alc5632.c
index ec071a6..3ee8d4e 100644
--- a/sound/soc/codecs/alc5632.c
+++ b/sound/soc/codecs/alc5632.c
@@ -1061,7 +1061,6 @@ static int alc5632_resume(struct snd_soc_codec *codec)
 static int alc5632_probe(struct snd_soc_codec *codec)
 {
 	struct alc5632_priv *alc5632 = snd_soc_codec_get_drvdata(codec);
-	int ret;
 
 	/* power on device  */
 	alc5632_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
@@ -1075,7 +1074,7 @@ static int alc5632_probe(struct snd_soc_codec *codec)
 		return -EINVAL;
 	}
 
-	return ret;
+	return 0;
 }
 
 /* power down chip */
-- 
1.9.0

