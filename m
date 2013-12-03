Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab3LCK1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 05:27:33 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:35161 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab3LCK1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 05:27:16 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@kernel.org
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH 2/2] ASoC: ux500: Dynamically fill DAI driver data on probe
Date: Tue,  3 Dec 2013 10:27:07 +0000
Message-Id: <1386066427-6862-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386066427-6862-1-git-send-email-lee.jones@linaro.org>
References: <1386066427-6862-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We no longer have a means to differentiate between MSP devices at probe
time, mainly because we don't really have to. So rather than have an over-
sized static data structure in place, where the only difference between
devices is the ID and name (which are unused), we'll just create one
succinct, statically assigned and shared one instead.

Cc: alsa-devel@alsa-project.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/ux500_msp_dai.c | 96 ++++++-----------------------------------
 1 file changed, 14 insertions(+), 82 deletions(-)

diff --git a/sound/soc/ux500/ux500_msp_dai.c b/sound/soc/ux500/ux500_msp_dai.c
index 8d1b01f..8a7ae45 100644
--- a/sound/soc/ux500/ux500_msp_dai.c
+++ b/sound/soc/ux500/ux500_msp_dai.c
@@ -718,87 +718,19 @@ static struct snd_soc_dai_ops ux500_msp_dai_ops[] = {
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
+static struct snd_soc_dai_driver ux500_msp_dai_drv = {
+	.probe                 = ux500_msp_dai_probe,
+	.suspend               = NULL,
+	.resume                = NULL,
+	.playback.channels_min = UX500_MSP_MIN_CHANNELS,
+	.playback.channels_max = UX500_MSP_MAX_CHANNELS,
+	.playback.rates        = UX500_I2S_RATES,
+	.playback.formats      = UX500_I2S_FORMATS,
+	.capture.channels_min  = UX500_MSP_MIN_CHANNELS,
+	.capture.channels_max  = UX500_MSP_MAX_CHANNELS,
+	.capture.rates         = UX500_I2S_RATES,
+	.capture.formats       = UX500_I2S_FORMATS,
+	.ops                   = ux500_msp_dai_ops,
 };
 
 static const struct snd_soc_component_driver ux500_msp_component = {
@@ -864,7 +796,7 @@ static int ux500_msp_drv_probe(struct platform_device *pdev)
 	dev_set_drvdata(&pdev->dev, drvdata);
 
 	ret = snd_soc_register_component(&pdev->dev, &ux500_msp_component,
-					 &ux500_msp_dai_drv[drvdata->msp->id], 1);
+					 &ux500_msp_dai_drv, 1);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Error: %s: Failed to register MSP%d!\n",
 			__func__, drvdata->msp->id);
-- 
1.8.3.2

