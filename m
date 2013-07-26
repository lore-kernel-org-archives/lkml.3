Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab3GZWqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 18:46:16 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:59906 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757933Ab3GZWpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 18:45:47 -0400
From: "Felipe F. Tonello" <eu@felipetonello.com>
To: alsa-devel@alsa-project.org
Cc: "Felipe F. Tonello" <eu@felipetonello.com>, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        David Henningsson <david.henningsson@canonical.com>,
        Wang Xingchao <xingchao.wang@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH v2 3/3] ALSA: SoC: Updating jack implementation according new ALSA Jacks
Date: Fri, 26 Jul 2013 15:45:13 -0700
Message-Id: <1374878713-11922-4-git-send-email-eu@felipetonello.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374878713-11922-1-git-send-email-eu@felipetonello.com>
References: <1374878713-11922-1-git-send-email-eu@felipetonello.com>
In-Reply-To: <1374863133-6745-1-git-send-email-eu@felipetonello.com>
References: <1374863133-6745-1-git-send-email-eu@felipetonello.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Felipe F. Tonello" <eu@felipetonello.com>

Updating the ASoC jack support to add the ability to specify a
jack index when creating it.

Signed-off-by: Felipe F. Tonello <eu@felipetonello.com>
---
 include/sound/soc.h                |  2 +-
 sound/soc/fsl/wm1133-ev1.c         |  4 ++--
 sound/soc/mid-x86/mfld_machine.c   |  6 +++---
 sound/soc/omap/ams-delta.c         |  2 +-
 sound/soc/omap/omap-abe-twl6040.c  |  4 ++--
 sound/soc/omap/omap-twl4030.c      |  4 ++--
 sound/soc/omap/rx51.c              |  6 +++---
 sound/soc/pxa/hx4700.c             |  4 ++--
 sound/soc/pxa/palm27x.c            |  4 ++--
 sound/soc/pxa/ttc-dkb.c            |  8 ++++----
 sound/soc/pxa/z2.c                 |  4 ++--
 sound/soc/samsung/goni_wm8994.c    |  4 ++--
 sound/soc/samsung/h1940_uda1380.c  |  4 ++--
 sound/soc/samsung/littlemill.c     | 10 +++++-----
 sound/soc/samsung/lowland.c        |  6 +++---
 sound/soc/samsung/rx1950_uda1380.c |  4 ++--
 sound/soc/samsung/smartq_wm8987.c  |  4 ++--
 sound/soc/samsung/speyside.c       |  6 +++---
 sound/soc/samsung/tobermory.c      |  4 ++--
 sound/soc/soc-jack.c               |  4 ++--
 sound/soc/tegra/tegra_alc5632.c    |  4 ++--
 sound/soc/tegra/tegra_rt5640.c     |  2 +-
 sound/soc/tegra/tegra_wm8903.c     |  8 ++++----
 23 files changed, 54 insertions(+), 54 deletions(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 6eabee7..31bea52 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -436,7 +436,7 @@ int snd_soc_platform_trigger(struct snd_pcm_substream *substream,
 
 /* Jack reporting */
 int snd_soc_jack_new(struct snd_soc_codec *codec, const char *id, int type,
-		     struct snd_soc_jack *jack);
+                     int idx, struct snd_soc_jack *jack);
 void snd_soc_jack_report(struct snd_soc_jack *jack, int status, int mask);
 int snd_soc_jack_add_pins(struct snd_soc_jack *jack, int count,
 			  struct snd_soc_jack_pin *pins);
diff --git a/sound/soc/fsl/wm1133-ev1.c b/sound/soc/fsl/wm1133-ev1.c
index fce6325..50f96d4 100644
--- a/sound/soc/fsl/wm1133-ev1.c
+++ b/sound/soc/fsl/wm1133-ev1.c
@@ -221,14 +221,14 @@ static int wm1133_ev1_init(struct snd_soc_pcm_runtime *rtd)
 				ARRAY_SIZE(wm1133_ev1_map));
 
 	/* Headphone jack detection */
-	snd_soc_jack_new(codec, "Headphone", SND_JACK_HEADPHONE, &hp_jack);
+	snd_soc_jack_new(codec, "Headphone", SND_JACK_HEADPHONE, 0, &hp_jack);
 	snd_soc_jack_add_pins(&hp_jack, ARRAY_SIZE(hp_jack_pins),
 			      hp_jack_pins);
 	wm8350_hp_jack_detect(codec, WM8350_JDR, &hp_jack, SND_JACK_HEADPHONE);
 
 	/* Microphone jack detection */
 	snd_soc_jack_new(codec, "Microphone",
-			 SND_JACK_MICROPHONE | SND_JACK_BTN_0, &mic_jack);
+	                 SND_JACK_MICROPHONE | SND_JACK_BTN_0, 0, &mic_jack);
 	snd_soc_jack_add_pins(&mic_jack, ARRAY_SIZE(mic_jack_pins),
 			      mic_jack_pins);
 	wm8350_mic_jack_detect(codec, &mic_jack, SND_JACK_MICROPHONE,
diff --git a/sound/soc/mid-x86/mfld_machine.c b/sound/soc/mid-x86/mfld_machine.c
index ee36384..e2c7978 100644
--- a/sound/soc/mid-x86/mfld_machine.c
+++ b/sound/soc/mid-x86/mfld_machine.c
@@ -253,9 +253,9 @@ static int mfld_init(struct snd_soc_pcm_runtime *runtime)
 	snd_soc_dapm_disable_pin(dapm, "LINEINR");
 
 	/* Headset and button jack detection */
-	ret_val = snd_soc_jack_new(codec, "Intel(R) MID Audio Jack",
-			SND_JACK_HEADSET | SND_JACK_BTN_0 |
-			SND_JACK_BTN_1, &mfld_jack);
+	ret_val = snd_soc_jack_new(codec, "Intel(R) MID Audio",
+	                           SND_JACK_HEADSET | SND_JACK_BTN_0 |
+	                           SND_JACK_BTN_1, 0, &mfld_jack);
 	if (ret_val) {
 		pr_err("jack creation failed\n");
 		return ret_val;
diff --git a/sound/soc/omap/ams-delta.c b/sound/soc/omap/ams-delta.c
index 6294464..4ffa38e 100644
--- a/sound/soc/omap/ams-delta.c
+++ b/sound/soc/omap/ams-delta.c
@@ -491,7 +491,7 @@ static int ams_delta_cx20442_init(struct snd_soc_pcm_runtime *rtd)
 	/* Add hook switch - can be used to control the codec from userspace
 	 * even if line discipline fails */
 	ret = snd_soc_jack_new(rtd->codec, "hook_switch",
-				SND_JACK_HEADSET, &ams_delta_hook_switch);
+	                       SND_JACK_HEADSET, 0, &ams_delta_hook_switch);
 	if (ret)
 		dev_warn(card->dev,
 				"Failed to allocate resources for hook switch, "
diff --git a/sound/soc/omap/omap-abe-twl6040.c b/sound/soc/omap/omap-abe-twl6040.c
index 70cd5c7..45ff3bc 100644
--- a/sound/soc/omap/omap-abe-twl6040.c
+++ b/sound/soc/omap/omap-abe-twl6040.c
@@ -193,8 +193,8 @@ static int omap_abe_twl6040_init(struct snd_soc_pcm_runtime *rtd)
 
 	/* Headset jack detection only if it is supported */
 	if (priv->jack_detection) {
-		ret = snd_soc_jack_new(codec, "Headset Jack",
-					SND_JACK_HEADSET, &hs_jack);
+		ret = snd_soc_jack_new(codec, "Headset",
+		                       SND_JACK_HEADSET, 0, &hs_jack);
 		if (ret)
 			return ret;
 
diff --git a/sound/soc/omap/omap-twl4030.c b/sound/soc/omap/omap-twl4030.c
index 2a9324f..0619ecb 100644
--- a/sound/soc/omap/omap-twl4030.c
+++ b/sound/soc/omap/omap-twl4030.c
@@ -189,8 +189,8 @@ static int omap_twl4030_init(struct snd_soc_pcm_runtime *rtd)
 	if (priv->jack_detect > 0) {
 		hs_jack_gpios[0].gpio = priv->jack_detect;
 
-		ret = snd_soc_jack_new(codec, "Headset Jack", SND_JACK_HEADSET,
-				       &priv->hs_jack);
+		ret = snd_soc_jack_new(codec, "Headset", SND_JACK_HEADSET,
+		                       0, &priv->hs_jack);
 		if (ret)
 			return ret;
 
diff --git a/sound/soc/omap/rx51.c b/sound/soc/omap/rx51.c
index 611179c..46fe697 100644
--- a/sound/soc/omap/rx51.c
+++ b/sound/soc/omap/rx51.c
@@ -317,9 +317,9 @@ static int rx51_aic34_init(struct snd_soc_pcm_runtime *rtd)
 		return err;
 
 	/* AV jack detection */
-	err = snd_soc_jack_new(codec, "AV Jack",
-			       SND_JACK_HEADSET | SND_JACK_VIDEOOUT,
-			       &rx51_av_jack);
+	err = snd_soc_jack_new(codec, "AV",
+	                       SND_JACK_HEADSET | SND_JACK_VIDEOOUT,
+	                       0, &rx51_av_jack);
 	if (err)
 		return err;
 	err = snd_soc_jack_add_gpios(&rx51_av_jack,
diff --git a/sound/soc/pxa/hx4700.c b/sound/soc/pxa/hx4700.c
index dcc9b04..3ffe48b 100644
--- a/sound/soc/pxa/hx4700.c
+++ b/sound/soc/pxa/hx4700.c
@@ -137,8 +137,8 @@ static int hx4700_ak4641_init(struct snd_soc_pcm_runtime *rtd)
 	snd_soc_dapm_nc_pin(dapm, "AUX");
 
 	/* Jack detection API stuff */
-	err = snd_soc_jack_new(codec, "Headphone Jack",
-				SND_JACK_HEADPHONE, &hs_jack);
+	err = snd_soc_jack_new(codec, "Headphone",
+	                       SND_JACK_HEADPHONE, 0, &hs_jack);
 	if (err)
 		return err;
 
diff --git a/sound/soc/pxa/palm27x.c b/sound/soc/pxa/palm27x.c
index e1ffcdd..7caba46 100644
--- a/sound/soc/pxa/palm27x.c
+++ b/sound/soc/pxa/palm27x.c
@@ -97,8 +97,8 @@ static int palm27x_ac97_init(struct snd_soc_pcm_runtime *rtd)
 	snd_soc_dapm_nc_pin(dapm, "MIC2");
 
 	/* Jack detection API stuff */
-	err = snd_soc_jack_new(codec, "Headphone Jack",
-				SND_JACK_HEADPHONE, &hs_jack);
+	err = snd_soc_jack_new(codec, "Headphone",
+	                       SND_JACK_HEADPHONE, 0, &hs_jack);
 	if (err)
 		return err;
 
diff --git a/sound/soc/pxa/ttc-dkb.c b/sound/soc/pxa/ttc-dkb.c
index f4ea4f6..1220a51 100644
--- a/sound/soc/pxa/ttc-dkb.c
+++ b/sound/soc/pxa/ttc-dkb.c
@@ -86,13 +86,13 @@ static int ttc_pm860x_init(struct snd_soc_pcm_runtime *rtd)
 	snd_soc_dapm_disable_pin(dapm, "Headset Stereophone");
 
 	/* Headset jack detection */
-	snd_soc_jack_new(codec, "Headphone Jack", SND_JACK_HEADPHONE
+	snd_soc_jack_new(codec, "Headphone", SND_JACK_HEADPHONE
 			| SND_JACK_BTN_0 | SND_JACK_BTN_1 | SND_JACK_BTN_2,
-			&hs_jack);
+	                 0, &hs_jack);
 	snd_soc_jack_add_pins(&hs_jack, ARRAY_SIZE(hs_jack_pins),
 			      hs_jack_pins);
-	snd_soc_jack_new(codec, "Microphone Jack", SND_JACK_MICROPHONE,
-			 &mic_jack);
+	snd_soc_jack_new(codec, "Microphone", SND_JACK_MICROPHONE,
+	                 0, &mic_jack);
 	snd_soc_jack_add_pins(&mic_jack, ARRAY_SIZE(mic_jack_pins),
 			      mic_jack_pins);
 
diff --git a/sound/soc/pxa/z2.c b/sound/soc/pxa/z2.c
index 76ccb17..2bbb2de 100644
--- a/sound/soc/pxa/z2.c
+++ b/sound/soc/pxa/z2.c
@@ -143,8 +143,8 @@ static int z2_wm8750_init(struct snd_soc_pcm_runtime *rtd)
 	snd_soc_dapm_disable_pin(dapm, "MONO1");
 
 	/* Jack detection API stuff */
-	ret = snd_soc_jack_new(codec, "Headset Jack", SND_JACK_HEADSET,
-				&hs_jack);
+	ret = snd_soc_jack_new(codec, "Headset", SND_JACK_HEADSET,
+	                       0, &hs_jack);
 	if (ret)
 		goto err;
 
diff --git a/sound/soc/samsung/goni_wm8994.c b/sound/soc/samsung/goni_wm8994.c
index 415ad81..d76072d 100644
--- a/sound/soc/samsung/goni_wm8994.c
+++ b/sound/soc/samsung/goni_wm8994.c
@@ -115,8 +115,8 @@ static int goni_wm8994_init(struct snd_soc_pcm_runtime *rtd)
 
 	/* Headset jack detection */
 	ret = snd_soc_jack_new(codec, "Headset Jack",
-			SND_JACK_HEADSET | SND_JACK_MECHANICAL | SND_JACK_AVOUT,
-			&jack);
+	                       SND_JACK_HEADSET | SND_JACK_MECHANICAL | SND_JACK_AVOUT,
+	                       0, &jack);
 	if (ret)
 		return ret;
 
diff --git a/sound/soc/samsung/h1940_uda1380.c b/sound/soc/samsung/h1940_uda1380.c
index fa91376..f8cf0cf 100644
--- a/sound/soc/samsung/h1940_uda1380.c
+++ b/sound/soc/samsung/h1940_uda1380.c
@@ -186,8 +186,8 @@ static int h1940_uda1380_init(struct snd_soc_pcm_runtime *rtd)
 	snd_soc_dapm_enable_pin(dapm, "Speaker");
 	snd_soc_dapm_enable_pin(dapm, "Mic Jack");
 
-	snd_soc_jack_new(codec, "Headphone Jack", SND_JACK_HEADPHONE,
-		&hp_jack);
+	snd_soc_jack_new(codec, "Headphone", SND_JACK_HEADPHONE,
+	                 0, &hp_jack);
 
 	snd_soc_jack_add_pins(&hp_jack, ARRAY_SIZE(hp_jack_pins),
 		hp_jack_pins);
diff --git a/sound/soc/samsung/littlemill.c b/sound/soc/samsung/littlemill.c
index bfb91f3..46344f3 100644
--- a/sound/soc/samsung/littlemill.c
+++ b/sound/soc/samsung/littlemill.c
@@ -261,11 +261,11 @@ static int littlemill_late_probe(struct snd_soc_card *card)
 		return ret;
 
 	ret = snd_soc_jack_new(codec, "Headset",
-			       SND_JACK_HEADSET | SND_JACK_MECHANICAL |
-			       SND_JACK_BTN_0 | SND_JACK_BTN_1 |
-			       SND_JACK_BTN_2 | SND_JACK_BTN_3 |
-			       SND_JACK_BTN_4 | SND_JACK_BTN_5,
-			       &littlemill_headset);
+	                       SND_JACK_HEADSET | SND_JACK_MECHANICAL |
+	                       SND_JACK_BTN_0 | SND_JACK_BTN_1 |
+	                       SND_JACK_BTN_2 | SND_JACK_BTN_3 |
+	                       SND_JACK_BTN_4 | SND_JACK_BTN_5,
+	                       0, &littlemill_headset);
 	if (ret)
 		return ret;
 
diff --git a/sound/soc/samsung/lowland.c b/sound/soc/samsung/lowland.c
index 570cf52..1e6a3df 100644
--- a/sound/soc/samsung/lowland.c
+++ b/sound/soc/samsung/lowland.c
@@ -57,9 +57,9 @@ static int lowland_wm5100_init(struct snd_soc_pcm_runtime *rtd)
 	}
 
 	ret = snd_soc_jack_new(codec, "Headset",
-			       SND_JACK_LINEOUT | SND_JACK_HEADSET |
-			       SND_JACK_BTN_0,
-			       &lowland_headset);
+	                       SND_JACK_LINEOUT | SND_JACK_HEADSET |
+	                       SND_JACK_BTN_0,
+	                       0, &lowland_headset);
 	if (ret)
 		return ret;
 
diff --git a/sound/soc/samsung/rx1950_uda1380.c b/sound/soc/samsung/rx1950_uda1380.c
index 704460a..f62b845 100644
--- a/sound/soc/samsung/rx1950_uda1380.c
+++ b/sound/soc/samsung/rx1950_uda1380.c
@@ -231,8 +231,8 @@ static int rx1950_uda1380_init(struct snd_soc_pcm_runtime *rtd)
 	snd_soc_dapm_enable_pin(dapm, "Speaker");
 	snd_soc_dapm_enable_pin(dapm, "Mic Jack");
 
-	snd_soc_jack_new(codec, "Headphone Jack", SND_JACK_HEADPHONE,
-		&hp_jack);
+	snd_soc_jack_new(codec, "Headphone", SND_JACK_HEADPHONE,
+	                 0, &hp_jack);
 
 	snd_soc_jack_add_pins(&hp_jack, ARRAY_SIZE(hp_jack_pins),
 		hp_jack_pins);
diff --git a/sound/soc/samsung/smartq_wm8987.c b/sound/soc/samsung/smartq_wm8987.c
index 58ae323..053ceea 100644
--- a/sound/soc/samsung/smartq_wm8987.c
+++ b/sound/soc/samsung/smartq_wm8987.c
@@ -166,8 +166,8 @@ static int smartq_wm8987_init(struct snd_soc_pcm_runtime *rtd)
 	snd_soc_dapm_disable_pin(dapm, "Headphone Jack");
 
 	/* Headphone jack detection */
-	err = snd_soc_jack_new(codec, "Headphone Jack",
-			       SND_JACK_HEADPHONE, &smartq_jack);
+	err = snd_soc_jack_new(codec, "Headphone",
+	                       SND_JACK_HEADPHONE, 0, &smartq_jack);
 	if (err)
 		return err;
 
diff --git a/sound/soc/samsung/speyside.c b/sound/soc/samsung/speyside.c
index 57df90d..feff3fb 100644
--- a/sound/soc/samsung/speyside.c
+++ b/sound/soc/samsung/speyside.c
@@ -154,9 +154,9 @@ static int speyside_wm8996_init(struct snd_soc_pcm_runtime *rtd)
 	gpio_direction_output(WM8996_HPSEL_GPIO, speyside_jack_polarity);
 
 	ret = snd_soc_jack_new(codec, "Headset",
-			       SND_JACK_LINEOUT | SND_JACK_HEADSET |
-			       SND_JACK_BTN_0,
-			       &speyside_headset);
+	                       SND_JACK_LINEOUT | SND_JACK_HEADSET |
+	                       SND_JACK_BTN_0,
+	                       0, &speyside_headset);
 	if (ret)
 		return ret;
 
diff --git a/sound/soc/samsung/tobermory.c b/sound/soc/samsung/tobermory.c
index f21ff60..e498e7c 100644
--- a/sound/soc/samsung/tobermory.c
+++ b/sound/soc/samsung/tobermory.c
@@ -178,8 +178,8 @@ static int tobermory_late_probe(struct snd_soc_card *card)
 		return ret;
 
 	ret = snd_soc_jack_new(codec, "Headset",
-			       SND_JACK_HEADSET | SND_JACK_BTN_0,
-			       &tobermory_headset);
+	                       SND_JACK_HEADSET | SND_JACK_BTN_0,
+	                       0, &tobermory_headset);
 	if (ret)
 		return ret;
 
diff --git a/sound/soc/soc-jack.c b/sound/soc/soc-jack.c
index 0bb5ccc..ecd1601 100644
--- a/sound/soc/soc-jack.c
+++ b/sound/soc/soc-jack.c
@@ -34,7 +34,7 @@
  * On success jack will be initialised.
  */
 int snd_soc_jack_new(struct snd_soc_codec *codec, const char *id, int type,
-		     struct snd_soc_jack *jack)
+                     int idx, struct snd_soc_jack *jack)
 {
 	mutex_init(&jack->mutex);
 	jack->codec = codec;
@@ -42,7 +42,7 @@ int snd_soc_jack_new(struct snd_soc_codec *codec, const char *id, int type,
 	INIT_LIST_HEAD(&jack->jack_zones);
 	BLOCKING_INIT_NOTIFIER_HEAD(&jack->notifier);
 
-	return snd_jack_new(codec->card->snd_card, id, type, &jack->jack);
+	return snd_jack_new(codec->card->snd_card, id, type, idx, &jack->jack);
 }
 EXPORT_SYMBOL_GPL(snd_soc_jack_new);
 
diff --git a/sound/soc/tegra/tegra_alc5632.c b/sound/soc/tegra/tegra_alc5632.c
index 48d05d9..cfacc27 100644
--- a/sound/soc/tegra/tegra_alc5632.c
+++ b/sound/soc/tegra/tegra_alc5632.c
@@ -109,8 +109,8 @@ static int tegra_alc5632_asoc_init(struct snd_soc_pcm_runtime *rtd)
 	struct snd_soc_dapm_context *dapm = &codec->dapm;
 	struct tegra_alc5632 *machine = snd_soc_card_get_drvdata(codec->card);
 
-	snd_soc_jack_new(codec, "Headset Jack", SND_JACK_HEADSET,
-			 &tegra_alc5632_hs_jack);
+	snd_soc_jack_new(codec, "Headset", SND_JACK_HEADSET,
+	                 0, &tegra_alc5632_hs_jack);
 	snd_soc_jack_add_pins(&tegra_alc5632_hs_jack,
 			ARRAY_SIZE(tegra_alc5632_hs_jack_pins),
 			tegra_alc5632_hs_jack_pins);
diff --git a/sound/soc/tegra/tegra_rt5640.c b/sound/soc/tegra/tegra_rt5640.c
index 08794f9..aad20f2 100644
--- a/sound/soc/tegra/tegra_rt5640.c
+++ b/sound/soc/tegra/tegra_rt5640.c
@@ -112,7 +112,7 @@ static int tegra_rt5640_asoc_init(struct snd_soc_pcm_runtime *rtd)
 	struct tegra_rt5640 *machine = snd_soc_card_get_drvdata(codec->card);
 
 	snd_soc_jack_new(codec, "Headphones", SND_JACK_HEADPHONE,
-			 &tegra_rt5640_hp_jack);
+	                 0, &tegra_rt5640_hp_jack);
 	snd_soc_jack_add_pins(&tegra_rt5640_hp_jack,
 			ARRAY_SIZE(tegra_rt5640_hp_jack_pins),
 			tegra_rt5640_hp_jack_pins);
diff --git a/sound/soc/tegra/tegra_wm8903.c b/sound/soc/tegra/tegra_wm8903.c
index 4ac7373..cd297f5 100644
--- a/sound/soc/tegra/tegra_wm8903.c
+++ b/sound/soc/tegra/tegra_wm8903.c
@@ -178,8 +178,8 @@ static int tegra_wm8903_init(struct snd_soc_pcm_runtime *rtd)
 
 	if (gpio_is_valid(machine->gpio_hp_det)) {
 		tegra_wm8903_hp_jack_gpio.gpio = machine->gpio_hp_det;
-		snd_soc_jack_new(codec, "Headphone Jack", SND_JACK_HEADPHONE,
-				&tegra_wm8903_hp_jack);
+		snd_soc_jack_new(codec, "Headphone", SND_JACK_HEADPHONE,
+		                 0, &tegra_wm8903_hp_jack);
 		snd_soc_jack_add_pins(&tegra_wm8903_hp_jack,
 					ARRAY_SIZE(tegra_wm8903_hp_jack_pins),
 					tegra_wm8903_hp_jack_pins);
@@ -188,8 +188,8 @@ static int tegra_wm8903_init(struct snd_soc_pcm_runtime *rtd)
 					&tegra_wm8903_hp_jack_gpio);
 	}
 
-	snd_soc_jack_new(codec, "Mic Jack", SND_JACK_MICROPHONE,
-			 &tegra_wm8903_mic_jack);
+	snd_soc_jack_new(codec, "Mic", SND_JACK_MICROPHONE,
+	                 0, &tegra_wm8903_mic_jack);
 	snd_soc_jack_add_pins(&tegra_wm8903_mic_jack,
 			      ARRAY_SIZE(tegra_wm8903_mic_jack_pins),
 			      tegra_wm8903_mic_jack_pins);
-- 
1.8.1.4

