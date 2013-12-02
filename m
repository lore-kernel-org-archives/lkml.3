Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab3LBSAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 13:00:40 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:48731 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab3LBSAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 13:00:33 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, broonie@kernel.org,
        Lee Jones <lee.jones@linaro.org>, alsa-devel@alsa-project.org
Subject: [PATCH 3/3] ASoC: ux500: Dynamically fill DAI driver data on probe
Date: Mon,  2 Dec 2013 18:00:22 +0000
Message-Id: <1386007222-10081-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386007222-10081-1-git-send-email-lee.jones@linaro.org>
References: <1386007222-10081-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We no longer have a means to differentiate MSP devices at probe time,
mainline because we don't really have to. So rather than have an over-
sized static data structure in place, where the only difference between
devices is the ID and name (which are unused), we'll create them only
when required and omit the unnecessary information.

Cc: alsa-devel@alsa-project.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/ux500_msp_dai.c | 108 ++++++++++------------------------------
 1 file changed, 26 insertions(+), 82 deletions(-)

diff --git a/sound/soc/ux500/ux500_msp_dai.c b/sound/soc/ux500/ux500_msp_dai.c
index 8d1b01f..153fb3f 100644
--- a/sound/soc/ux500/ux500_msp_dai.c
+++ b/sound/soc/ux500/ux500_msp_dai.c
@@ -718,87 +718,20 @@ static struct snd_soc_dai_ops ux500_msp_dai_ops[] = {
 	}
 };
 
-static struct snd_soc_dai_driver ux500_msp_dai_drv[UX500_NBR_OF_DAI] = {
-	{
-		.name = "ux500-msp-i2s.0",
-		.probe = ux500_msp_dai_probe,
-		.id = 0,
-		.suspend = NULL,
-		.resume = NULL,
-		.playback = {
-			.channels_min = UX500_MSP_MIN_CHANNELS,
-			.channels_max = UX500_MSP_MAX_CHANNELS,
-			.rates = UX500_I2S_RATES,
-			.formats = UX500_I2S_FORMATS,
-		},
-		.capture = {
-			.channels_min = UX500_MSP_MIN_CHANNELS,
-			.channels_max = UX500_MSP_MAX_CHANNELS,
-			.rates = UX500_I2S_RATES,
-			.formats = UX500_I2S_FORMATS,
-		},
-		.ops = ux500_msp_dai_ops,
-	},
-	{
-		.name = "ux500-msp-i2s.1",
-		.probe = ux500_msp_dai_probe,
-		.id = 1,
-		.suspend = NULL,
-		.resume = NULL,
-		.playback = {
-			.channels_min = UX500_MSP_MIN_CHANNELS,
-			.channels_max = UX500_MSP_MAX_CHANNELS,
-			.rates = UX500_I2S_RATES,
-			.formats = UX500_I2S_FORMATS,
-		},
-		.capture = {
-			.channels_min = UX500_MSP_MIN_CHANNELS,
-			.channels_max = UX500_MSP_MAX_CHANNELS,
-			.rates = UX500_I2S_RATES,
-			.formats = UX500_I2S_FORMATS,
-		},
-		.ops = ux500_msp_dai_ops,
-	},
-	{
-		.name = "ux500-msp-i2s.2",
-		.id = 2,
-		.probe = ux500_msp_dai_probe,
-		.suspend = NULL,
-		.resume = NULL,
-		.playback = {
-			.channels_min = UX500_MSP_MIN_CHANNELS,
-			.channels_max = UX500_MSP_MAX_CHANNELS,
-			.rates = UX500_I2S_RATES,
-			.formats = UX500_I2S_FORMATS,
-		},
-		.capture = {
-			.channels_min = UX500_MSP_MIN_CHANNELS,
-			.channels_max = UX500_MSP_MAX_CHANNELS,
-			.rates = UX500_I2S_RATES,
-			.formats = UX500_I2S_FORMATS,
-		},
-		.ops = ux500_msp_dai_ops,
-	},
-	{
-		.name = "ux500-msp-i2s.3",
-		.probe = ux500_msp_dai_probe,
-		.id = 3,
-		.suspend = NULL,
-		.resume = NULL,
-		.playback = {
-			.channels_min = UX500_MSP_MIN_CHANNELS,
-			.channels_max = UX500_MSP_MAX_CHANNELS,
-			.rates = UX500_I2S_RATES,
-			.formats = UX500_I2S_FORMATS,
-		},
-		.capture = {
-			.channels_min = UX500_MSP_MIN_CHANNELS,
-			.channels_max = UX500_MSP_MAX_CHANNELS,
-			.rates = UX500_I2S_RATES,
-			.formats = UX500_I2S_FORMATS,
-		},
-		.ops = ux500_msp_dai_ops,
-	},
+void ux500_msp_populate_dai_drv(struct snd_soc_dai_driver *ux500_msp_dai_drv)
+{
+	ux500_msp_dai_drv->probe                 = ux500_msp_dai_probe;
+	ux500_msp_dai_drv->suspend               = NULL;
+	ux500_msp_dai_drv->resume                = NULL;
+	ux500_msp_dai_drv->playback.channels_min = UX500_MSP_MIN_CHANNELS;
+	ux500_msp_dai_drv->playback.channels_max = UX500_MSP_MAX_CHANNELS;
+	ux500_msp_dai_drv->playback.rates        = UX500_I2S_RATES;
+	ux500_msp_dai_drv->playback.formats      = UX500_I2S_FORMATS;
+	ux500_msp_dai_drv->capture.channels_min  = UX500_MSP_MIN_CHANNELS;
+	ux500_msp_dai_drv->capture.channels_max  = UX500_MSP_MAX_CHANNELS;
+	ux500_msp_dai_drv->capture.rates         = UX500_I2S_RATES;
+	ux500_msp_dai_drv->capture.formats       = UX500_I2S_FORMATS;
+	ux500_msp_dai_drv->ops                   = ux500_msp_dai_ops;
 };
 
 static const struct snd_soc_component_driver ux500_msp_component = {
@@ -809,6 +742,7 @@ static const struct snd_soc_component_driver ux500_msp_component = {
 static int ux500_msp_drv_probe(struct platform_device *pdev)
 {
 	struct ux500_msp_i2s_drvdata *drvdata;
+	struct snd_soc_dai_driver *ux500_msp_dai_drv;
 	int ret = 0;
 
 	dev_dbg(&pdev->dev, "%s: Enter (pdev->name = %s).\n", __func__,
@@ -863,8 +797,18 @@ static int ux500_msp_drv_probe(struct platform_device *pdev)
 	}
 	dev_set_drvdata(&pdev->dev, drvdata);
 
+	ux500_msp_dai_drv = devm_kzalloc(&pdev->dev,
+					 sizeof(*ux500_msp_dai_drv),
+					 GFP_KERNEL);
+	if (!ux500_msp_dai_drv) {
+		ret = -ENOMEM;
+		goto err_init_msp;
+	}
+
+	ux500_msp_populate_dai_drv(ux500_msp_dai_drv);
+
 	ret = snd_soc_register_component(&pdev->dev, &ux500_msp_component,
-					 &ux500_msp_dai_drv[drvdata->msp->id], 1);
+					 ux500_msp_dai_drv, 1);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Error: %s: Failed to register MSP%d!\n",
 			__func__, drvdata->msp->id);
-- 
1.8.3.2

