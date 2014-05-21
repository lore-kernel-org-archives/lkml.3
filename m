Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbaEUDYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 23:24:35 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:56077 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbaEUDYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 23:24:31 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-samsung-soc@vger.kernel.org
Cc: tiwai@suse.de, perex@perex.cz, broonie@kernel.org, lgirdwood@gmail.com,
        sbkim73@samsung.com, kgene.kim@samsung.com
Subject: [PATCH 1/4] ASoC: samsung: Use devm_snd_soc_register_card
Date: Wed, 21 May 2014 08:52:17 +0530
Message-Id: <1400642540-24375-2-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400642540-24375-1-git-send-email-tushar.behera@linaro.org>
References: <1400642540-24375-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace snd_soc_register_card with devm_snd_soc_register_card.
With this change, we can delete the empty remove functions.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 sound/soc/samsung/bells.c          |   16 +++-------------
 sound/soc/samsung/littlemill.c     |   18 +++---------------
 sound/soc/samsung/lowland.c        |   18 +++---------------
 sound/soc/samsung/smdk_wm8580pcm.c |   15 +++------------
 sound/soc/samsung/smdk_wm8994pcm.c |   15 +++------------
 sound/soc/samsung/speyside.c       |   18 +++---------------
 sound/soc/samsung/tobermory.c      |   18 +++---------------
 7 files changed, 21 insertions(+), 97 deletions(-)

diff --git a/sound/soc/samsung/bells.c b/sound/soc/samsung/bells.c
index 84f5d8b..5b21207 100644
--- a/sound/soc/samsung/bells.c
+++ b/sound/soc/samsung/bells.c
@@ -433,22 +433,13 @@ static int bells_probe(struct platform_device *pdev)
 
 	bells_cards[pdev->id].dev = &pdev->dev;
 
-	ret = snd_soc_register_card(&bells_cards[pdev->id]);
-	if (ret) {
+	ret = devm_snd_soc_register_card(&pdev->dev, &bells_cards[pdev->id]);
+	if (ret)
 		dev_err(&pdev->dev,
 			"snd_soc_register_card(%s) failed: %d\n",
 			bells_cards[pdev->id].name, ret);
-		return ret;
-	}
-
-	return 0;
-}
-
-static int bells_remove(struct platform_device *pdev)
-{
-	snd_soc_unregister_card(&bells_cards[pdev->id]);
 
-	return 0;
+	return ret;
 }
 
 static struct platform_driver bells_driver = {
@@ -458,7 +449,6 @@ static struct platform_driver bells_driver = {
 		.pm = &snd_soc_pm_ops,
 	},
 	.probe = bells_probe,
-	.remove = bells_remove,
 };
 
 module_platform_driver(bells_driver);
diff --git a/sound/soc/samsung/littlemill.c b/sound/soc/samsung/littlemill.c
index bfb91f3..840787e 100644
--- a/sound/soc/samsung/littlemill.c
+++ b/sound/soc/samsung/littlemill.c
@@ -304,23 +304,12 @@ static int littlemill_probe(struct platform_device *pdev)
 
 	card->dev = &pdev->dev;
 
-	ret = snd_soc_register_card(card);
-	if (ret) {
+	ret = devm_snd_soc_register_card(&pdev->dev, card);
+	if (ret)
 		dev_err(&pdev->dev, "snd_soc_register_card() failed: %d\n",
 			ret);
-		return ret;
-	}
-
-	return 0;
-}
-
-static int littlemill_remove(struct platform_device *pdev)
-{
-	struct snd_soc_card *card = platform_get_drvdata(pdev);
 
-	snd_soc_unregister_card(card);
-
-	return 0;
+	return ret;
 }
 
 static struct platform_driver littlemill_driver = {
@@ -330,7 +319,6 @@ static struct platform_driver littlemill_driver = {
 		.pm = &snd_soc_pm_ops,
 	},
 	.probe = littlemill_probe,
-	.remove = littlemill_remove,
 };
 
 module_platform_driver(littlemill_driver);
diff --git a/sound/soc/samsung/lowland.c b/sound/soc/samsung/lowland.c
index 570cf52..bd5f0d6 100644
--- a/sound/soc/samsung/lowland.c
+++ b/sound/soc/samsung/lowland.c
@@ -187,23 +187,12 @@ static int lowland_probe(struct platform_device *pdev)
 
 	card->dev = &pdev->dev;
 
-	ret = snd_soc_register_card(card);
-	if (ret) {
+	ret = devm_snd_soc_register_card(&pdev->dev, card);
+	if (ret)
 		dev_err(&pdev->dev, "snd_soc_register_card() failed: %d\n",
 			ret);
-		return ret;
-	}
-
-	return 0;
-}
-
-static int lowland_remove(struct platform_device *pdev)
-{
-	struct snd_soc_card *card = platform_get_drvdata(pdev);
 
-	snd_soc_unregister_card(card);
-
-	return 0;
+	return ret;
 }
 
 static struct platform_driver lowland_driver = {
@@ -213,7 +202,6 @@ static struct platform_driver lowland_driver = {
 		.pm = &snd_soc_pm_ops,
 	},
 	.probe = lowland_probe,
-	.remove = lowland_remove,
 };
 
 module_platform_driver(lowland_driver);
diff --git a/sound/soc/samsung/smdk_wm8580pcm.c b/sound/soc/samsung/smdk_wm8580pcm.c
index 23a9204..e119aaa 100644
--- a/sound/soc/samsung/smdk_wm8580pcm.c
+++ b/sound/soc/samsung/smdk_wm8580pcm.c
@@ -164,19 +164,11 @@ static int snd_smdk_probe(struct platform_device *pdev)
 		xtal_freq = mclk_freq = SMDK_WM8580_EXT_VOICE;
 
 	smdk_pcm.dev = &pdev->dev;
-	ret = snd_soc_register_card(&smdk_pcm);
-	if (ret) {
+	ret = devm_snd_soc_register_card(&pdev->dev, &smdk_pcm);
+	if (ret)
 		dev_err(&pdev->dev, "snd_soc_register_card failed %d\n", ret);
-		return ret;
-	}
 
-	return 0;
-}
-
-static int snd_smdk_remove(struct platform_device *pdev)
-{
-	snd_soc_unregister_card(&smdk_pcm);
-	return 0;
+	return ret;
 }
 
 static struct platform_driver snd_smdk_driver = {
@@ -185,7 +177,6 @@ static struct platform_driver snd_smdk_driver = {
 		.name = "samsung-smdk-pcm",
 	},
 	.probe = snd_smdk_probe,
-	.remove = snd_smdk_remove,
 };
 
 module_platform_driver(snd_smdk_driver);
diff --git a/sound/soc/samsung/smdk_wm8994pcm.c b/sound/soc/samsung/smdk_wm8994pcm.c
index 0c84ca0..b6c0997 100644
--- a/sound/soc/samsung/smdk_wm8994pcm.c
+++ b/sound/soc/samsung/smdk_wm8994pcm.c
@@ -134,19 +134,11 @@ static int snd_smdk_probe(struct platform_device *pdev)
 	int ret = 0;
 
 	smdk_pcm.dev = &pdev->dev;
-	ret = snd_soc_register_card(&smdk_pcm);
-	if (ret) {
+	ret = devm_snd_soc_register_card(&pdev->dev, &smdk_pcm);
+	if (ret)
 		dev_err(&pdev->dev, "snd_soc_register_card failed %d\n", ret);
-		return ret;
-	}
 
-	return 0;
-}
-
-static int snd_smdk_remove(struct platform_device *pdev)
-{
-	snd_soc_unregister_card(&smdk_pcm);
-	return 0;
+	return ret;
 }
 
 static struct platform_driver snd_smdk_driver = {
@@ -155,7 +147,6 @@ static struct platform_driver snd_smdk_driver = {
 		.name = "samsung-smdk-pcm",
 	},
 	.probe = snd_smdk_probe,
-	.remove = snd_smdk_remove,
 };
 
 module_platform_driver(snd_smdk_driver);
diff --git a/sound/soc/samsung/speyside.c b/sound/soc/samsung/speyside.c
index 57df90d..9902efc 100644
--- a/sound/soc/samsung/speyside.c
+++ b/sound/soc/samsung/speyside.c
@@ -327,23 +327,12 @@ static int speyside_probe(struct platform_device *pdev)
 
 	card->dev = &pdev->dev;
 
-	ret = snd_soc_register_card(card);
-	if (ret) {
+	ret = devm_snd_soc_register_card(&pdev->dev, card);
+	if (ret)
 		dev_err(&pdev->dev, "snd_soc_register_card() failed: %d\n",
 			ret);
-		return ret;
-	}
-
-	return 0;
-}
-
-static int speyside_remove(struct platform_device *pdev)
-{
-	struct snd_soc_card *card = platform_get_drvdata(pdev);
 
-	snd_soc_unregister_card(card);
-
-	return 0;
+	return ret;
 }
 
 static struct platform_driver speyside_driver = {
@@ -353,7 +342,6 @@ static struct platform_driver speyside_driver = {
 		.pm = &snd_soc_pm_ops,
 	},
 	.probe = speyside_probe,
-	.remove = speyside_remove,
 };
 
 module_platform_driver(speyside_driver);
diff --git a/sound/soc/samsung/tobermory.c b/sound/soc/samsung/tobermory.c
index 1807b75..6a2b9f1 100644
--- a/sound/soc/samsung/tobermory.c
+++ b/sound/soc/samsung/tobermory.c
@@ -223,23 +223,12 @@ static int tobermory_probe(struct platform_device *pdev)
 
 	card->dev = &pdev->dev;
 
-	ret = snd_soc_register_card(card);
-	if (ret) {
+	ret = devm_snd_soc_register_card(&pdev->dev, card);
+	if (ret)
 		dev_err(&pdev->dev, "snd_soc_register_card() failed: %d\n",
 			ret);
-		return ret;
-	}
-
-	return 0;
-}
-
-static int tobermory_remove(struct platform_device *pdev)
-{
-	struct snd_soc_card *card = platform_get_drvdata(pdev);
 
-	snd_soc_unregister_card(card);
-
-	return 0;
+	return ret;
 }
 
 static struct platform_driver tobermory_driver = {
@@ -249,7 +238,6 @@ static struct platform_driver tobermory_driver = {
 		.pm = &snd_soc_pm_ops,
 	},
 	.probe = tobermory_probe,
-	.remove = tobermory_remove,
 };
 
 module_platform_driver(tobermory_driver);
-- 
1.7.9.5

