Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaFMRUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:20:35 -0400
Received: from mout.gmx.net ([212.227.17.20]:63530 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794AbaFMRUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:20:33 -0400
From: Christian Engelmayer <cengelma@gmx.at>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Xiubo Li <Li.Xiubo@freescale.com>, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Christian Engelmayer <cengelma@gmx.at>
Subject: [PATCH] ASoC: wm8985: Remove unused pointer in wm8985_remove()
Date: Fri, 13 Jun 2014 19:19:28 +0200
Message-Id: <1402679968-5925-1-git-send-email-cengelma@gmx.at>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K0:uK3boCuhSbyaMSNjsvmE69CL+I6PdMdEasdHgc0iau0fPb7eeJU
 sG36W+15AFB86FR5plcLH3P/gwOLobe4d0DR3HwOR557JYp2+fWA8DWfsOlnV145LkkZ/gg
 yUhkLK667rinW0bv3pkfx/aw10EDMXjOPasSVj6El5THfUEeOjKi3pv3guBLoRbfTSJc95I
 6GA8ezZGrN6GwnoEO14Cw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a0b148b4 (ASoC: wm8985: Use devm_regulator_bulk_get()) removed the last
user of pointer wm8985 to struct wm8985_priv. Thus remove it. Detected by
Coverity CID 1222150.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Compile tested. Applies against branch for-next in tree
git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git
---
 sound/soc/codecs/wm8985.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/sound/soc/codecs/wm8985.c b/sound/soc/codecs/wm8985.c
index 0f5780c..cbbdfbb 100644
--- a/sound/soc/codecs/wm8985.c
+++ b/sound/soc/codecs/wm8985.c
@@ -980,9 +980,6 @@ static int wm8985_resume(struct snd_soc_codec *codec)
 
 static int wm8985_remove(struct snd_soc_codec *codec)
 {
-	struct wm8985_priv *wm8985;
-
-	wm8985 = snd_soc_codec_get_drvdata(codec);
 	wm8985_set_bias_level(codec, SND_SOC_BIAS_OFF);
 	return 0;
 }
-- 
1.9.1

