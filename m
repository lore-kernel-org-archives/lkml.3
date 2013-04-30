Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab3D3OKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 10:10:51 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:51146 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240Ab3D3OKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 10:10:48 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 3/3] ASoC: ux500: register controls to card instead of codec
Date: Tue, 30 Apr 2013 16:09:54 +0200
Message-Id: <1367330994-7259-4-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1367330994-7259-1-git-send-email-fabio.baltieri@linaro.org>
References: <1367330994-7259-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update mop500_ab8500_machine_init to register mop500_ab8500_ctrls as
card control instead of codec control, as it only contains
SOC_DAPM_PIN_SWITCH definitions.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 sound/soc/ux500/mop500_ab8500.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/ux500/mop500_ab8500.c b/sound/soc/ux500/mop500_ab8500.c
index 1a5c6b9..4606194 100644
--- a/sound/soc/ux500/mop500_ab8500.c
+++ b/sound/soc/ux500/mop500_ab8500.c
@@ -127,9 +127,9 @@ static int mop500_ab8500_set_mclk(struct device *dev,
 static int mclk_input_control_get(struct snd_kcontrol *kcontrol,
 				struct snd_ctl_elem_value *ucontrol)
 {
-	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct snd_soc_card *card = snd_kcontrol_chip(kcontrol);
 	struct mop500_ab8500_drvdata *drvdata =
-				snd_soc_card_get_drvdata(codec->card);
+				snd_soc_card_get_drvdata(card);
 
 	ucontrol->value.enumerated.item[0] = drvdata->mclk_sel;
 
@@ -139,9 +139,9 @@ static int mclk_input_control_get(struct snd_kcontrol *kcontrol,
 static int mclk_input_control_put(struct snd_kcontrol *kcontrol,
 				struct snd_ctl_elem_value *ucontrol)
 {
-	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct snd_soc_card *card = snd_kcontrol_chip(kcontrol);
 	struct mop500_ab8500_drvdata *drvdata =
-				snd_soc_card_get_drvdata(codec->card);
+				snd_soc_card_get_drvdata(card);
 	unsigned int val = ucontrol->value.enumerated.item[0];
 
 	if (val > (unsigned int)MCLK_ULPCLK)
@@ -377,7 +377,7 @@ int mop500_ab8500_machine_init(struct snd_soc_pcm_runtime *rtd)
 	drvdata->mclk_sel = MCLK_ULPCLK;
 
 	/* Add controls */
-	ret = snd_soc_add_codec_controls(codec, mop500_ab8500_ctrls,
+	ret = snd_soc_add_card_controls(codec->card, mop500_ab8500_ctrls,
 			ARRAY_SIZE(mop500_ab8500_ctrls));
 	if (ret < 0) {
 		pr_err("%s: Failed to add machine-controls (%d)!\n",
-- 
1.8.2

