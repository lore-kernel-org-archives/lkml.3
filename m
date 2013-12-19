Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab3LSP5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:57:30 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:64245 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab3LSPzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:55:52 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, broonie@kernel.org, alsa-devel@alsa-project.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 11/11] ASoC: ux500: Dramatically reduce the size of the DAI driver data struct
Date: Thu, 19 Dec 2013 15:55:08 +0000
Message-Id: <1387468508-12286-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
References: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We no longer have a means to differentiate between MSP devices at probe
time, mainly because we don't really have to. So rather than have an over-
sized static data structure in place, where the only difference between
devices is the ID and name (which are unused), we'll just create one
succinct, statically assigned and shared one instead.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/ux500_msp_dai.c | 96 ++++++-----------------------------------
 1 file changed, 14 insertions(+), 82 deletions(-)

diff --git a/sound/soc/ux500/ux500_msp_dai.c b/sound/soc/ux500/ux500_msp_dai.c
index f4d607a..5f4807b 100644
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
@@ -868,7 +800,7 @@ static int ux500_msp_drv_probe(struct platform_device *pdev)
 	dev_set_drvdata(&pdev->dev, drvdata);
 
 	ret = snd_soc_register_component(&pdev->dev, &ux500_msp_component,
-					 &ux500_msp_dai_drv[drvdata->msp->id], 1);
+					 &ux500_msp_dai_drv, 1);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Error: %s: Failed to register MSP%d!\n",
 			__func__, drvdata->msp->id);
-- 
1.8.3.2

