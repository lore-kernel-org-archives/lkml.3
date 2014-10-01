Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751119AbaJAFoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 01:44:16 -0400
Received: from smtp81.ord1c.emailsrvr.com ([108.166.43.81]:58914 "EHLO
	smtp81.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750883AbaJAFoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 01:44:14 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-gpio@vger.kernel.org
Subject: [PATCH] ASoC: remove use of gpiochip_remove() retval
Date: Wed,  1 Oct 2014 11:17:46 +0530
Message-Id: <1412142466-14932-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of using return value from gpiochip_remove() as it returns
void with a new change in kernel.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
CC: Liam Girdwood <lgirdwood@gmail.com>
CC: Mark Brown <broonie@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz> 
Cc: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org
Cc: linux-gpio@vger.kernel.org
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 sound/soc/codecs/wm5100.c |    5 +----
 sound/soc/codecs/wm8903.c |    6 +-----
 sound/soc/codecs/wm8962.c |    5 +----
 sound/soc/codecs/wm8996.c |    6 +-----
 4 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/sound/soc/codecs/wm5100.c b/sound/soc/codecs/wm5100.c
index 7bb0d36..a01ad62 100644
--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -2319,11 +2319,8 @@ static void wm5100_init_gpio(struct i2c_client *i2c)
 static void wm5100_free_gpio(struct i2c_client *i2c)
 {
 	struct wm5100_priv *wm5100 = i2c_get_clientdata(i2c);
-	int ret;
 
-	ret = gpiochip_remove(&wm5100->gpio_chip);
-	if (ret != 0)
-		dev_err(&i2c->dev, "Failed to remove GPIOs: %d\n", ret);
+	gpiochip_remove(&wm5100->gpio_chip);
 }
 #else
 static void wm5100_init_gpio(struct i2c_client *i2c)
diff --git a/sound/soc/codecs/wm8903.c b/sound/soc/codecs/wm8903.c
index aa09848..c038b3e 100644
--- a/sound/soc/codecs/wm8903.c
+++ b/sound/soc/codecs/wm8903.c
@@ -1877,11 +1877,7 @@ static void wm8903_init_gpio(struct wm8903_priv *wm8903)
 
 static void wm8903_free_gpio(struct wm8903_priv *wm8903)
 {
-	int ret;
-
-	ret = gpiochip_remove(&wm8903->gpio_chip);
-	if (ret != 0)
-		dev_err(wm8903->dev, "Failed to remove GPIOs: %d\n", ret);
+	gpiochip_remove(&wm8903->gpio_chip);
 }
 #else
 static void wm8903_init_gpio(struct wm8903_priv *wm8903)
diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index 1098ae3..9077411 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -3398,11 +3398,8 @@ static void wm8962_init_gpio(struct snd_soc_codec *codec)
 static void wm8962_free_gpio(struct snd_soc_codec *codec)
 {
 	struct wm8962_priv *wm8962 = snd_soc_codec_get_drvdata(codec);
-	int ret;
 
-	ret = gpiochip_remove(&wm8962->gpio_chip);
-	if (ret != 0)
-		dev_err(codec->dev, "Failed to remove GPIOs: %d\n", ret);
+	gpiochip_remove(&wm8962->gpio_chip);
 }
 #else
 static void wm8962_init_gpio(struct snd_soc_codec *codec)
diff --git a/sound/soc/codecs/wm8996.c b/sound/soc/codecs/wm8996.c
index f16ff4f..b1dcc11 100644
--- a/sound/soc/codecs/wm8996.c
+++ b/sound/soc/codecs/wm8996.c
@@ -2216,11 +2216,7 @@ static void wm8996_init_gpio(struct wm8996_priv *wm8996)
 
 static void wm8996_free_gpio(struct wm8996_priv *wm8996)
 {
-	int ret;
-
-	ret = gpiochip_remove(&wm8996->gpio_chip);
-	if (ret != 0)
-		dev_err(wm8996->dev, "Failed to remove GPIOs: %d\n", ret);
+	gpiochip_remove(&wm8996->gpio_chip);
 }
 #else
 static void wm8996_init_gpio(struct wm8996_priv *wm8996)
-- 
1.7.9.5

