Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab3I0IWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:22:52 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:56791 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab3I0IWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:22:50 -0400
MIME-Version: 1.0
Date: Fri, 27 Sep 2013 16:22:49 +0800
Message-ID: <CAPgLHd_-3McKfmk9fE0R386_RjMS-kKKrJN=dBt2gWC7tUPLxQ@mail.gmail.com>
Subject: [PATCH] ASoC: wm8993: drop regulator_bulk_free of devm_ allocated data
From: Wei Yongjun <weiyj.lk@gmail.com>
To: lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        sachin.kamat@linaro.org, wfp5p@virginia.edu
Cc: yongjun_wei@trendmicro.com.cn, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

It's not necessary to free regulator consumers allocated with
devm_regulator_bulk_get.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/soc/codecs/wm8993.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/codecs/wm8993.c b/sound/soc/codecs/wm8993.c
index 433d59a..2ee23a3 100644
--- a/sound/soc/codecs/wm8993.c
+++ b/sound/soc/codecs/wm8993.c
@@ -1562,7 +1562,6 @@ static int wm8993_remove(struct snd_soc_codec *codec)
 	struct wm8993_priv *wm8993 = snd_soc_codec_get_drvdata(codec);
 
 	wm8993_set_bias_level(codec, SND_SOC_BIAS_OFF);
-	regulator_bulk_free(ARRAY_SIZE(wm8993->supplies), wm8993->supplies);
 	return 0;
 }
 

