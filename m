Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaAND22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 22:28:28 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:50760 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbaAND2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 22:28:20 -0500
From: Bo Shen <voice.shen@atmel.com>
To: broonie@kernel.org
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        linux-sound@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, Bo Shen <voice.shen@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ASoC: atmel_wm8904: make it available to choose clock
Date: Tue, 14 Jan 2014 11:25:55 +0800
Message-Id: <1389669956-2304-3-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389669956-2304-1-git-send-email-voice.shen@atmel.com>
References: <1389669956-2304-1-git-send-email-voice.shen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it available to choose the clock from TK pin or RK pin. This
is hardware design decided.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---

 sound/soc/atmel/atmel_wm8904.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/soc/atmel/atmel_wm8904.c b/sound/soc/atmel/atmel_wm8904.c
index b4e3690..b85088d 100644
--- a/sound/soc/atmel/atmel_wm8904.c
+++ b/sound/soc/atmel/atmel_wm8904.c
@@ -108,6 +108,7 @@ static int atmel_asoc_wm8904_dt_init(struct platform_device *pdev)
 	struct device_node *codec_np, *cpu_np;
 	struct snd_soc_card *card = &atmel_asoc_wm8904_card;
 	struct snd_soc_dai_link *dailink = &atmel_asoc_wm8904_dailink;
+	struct atmel_ssc_info *ssc_info;
 	int ret;
 
 	if (!np) {
@@ -115,6 +116,15 @@ static int atmel_asoc_wm8904_dt_init(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	ssc_info = devm_kzalloc(&pdev->dev, sizeof(*ssc_info), GFP_KERNEL);
+	if (!ssc_info)
+		return -ENOMEM;
+
+	ssc_info->clk_from_rk_pin =
+		of_property_read_bool(np, "clk_from_rk_pin");
+
+	card->drvdata = (void *)ssc_info;
+
 	ret = snd_soc_of_parse_card_name(card, "atmel,model");
 	if (ret) {
 		dev_err(&pdev->dev, "failed to parse card name\n");
-- 
1.8.5.2

