Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbaIAAs2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 20:48:28 -0400
Received: from m12-18.163.com ([220.181.12.18]:47773 "EHLO m12-18.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbaIAAs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 20:48:26 -0400
X-Coremail-DSSMTP: 117.88.144.180
From: weiyj_lk@163.com
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Sean Cross <xobs@kosagi.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH -next] ASoC: es8328: fix error return code in es8328_codec_probe()
Date: Mon,  1 Sep 2014 08:47:50 +0800
Message-Id: <1409532470-32364-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: EsCowEC5MlI4wgNU1xFBBQ--.1245S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7WryUGw4xuw1kCFW5ZFy7Wrg_yoW3Xwc_G3
	yUW3yqvrWj9FZrtrWjgFWay393XF15uFWF9rnIy3W7tryDtwn8C34jqw13uF4IqF4v9FyY
	qF1Sqr4xZF1xJjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnDxhJUUUUU==
X-Originating-IP: [117.88.144.180]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/1tbioxr51lD+WG5XnQAAsE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/soc/codecs/es8328.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/es8328.c b/sound/soc/codecs/es8328.c
index 7a9f65a..3ff7870 100644
--- a/sound/soc/codecs/es8328.c
+++ b/sound/soc/codecs/es8328.c
@@ -665,6 +665,7 @@ static int es8328_codec_probe(struct snd_soc_codec *codec)
 	es8328->clk = devm_clk_get(codec->dev, NULL);
 	if (IS_ERR(es8328->clk)) {
 		dev_err(codec->dev, "codec clock missing or invalid\n");
+		ret = PTR_ERR(es8328->clk);
 		goto clk_fail;
 	}
 

