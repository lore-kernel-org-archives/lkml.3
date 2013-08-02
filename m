Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab3HBIAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 04:00:00 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:34996 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab3HBH7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 03:59:42 -0400
From: "Felipe F. Tonello" <eu@felipetonello.com>
To: alsa-devel@alsa-project.org
Cc: "Felipe F. Tonello" <eu@felipetonello.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] ALSA: SoC: Fix jack names according new API
Date: Fri,  2 Aug 2013 00:59:25 -0700
Message-Id: <1375430365-13232-3-git-send-email-eu@felipetonello.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375430365-13232-1-git-send-email-eu@felipetonello.com>
References: <1375430365-13232-1-git-send-email-eu@felipetonello.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Felipe F. Tonello" <eu@felipetonello.com>

The new ALSA jack API ensures that " Jack" is appended by default.

It's also good practice that all codecs name jacks based on its type.

Signed-off-by: Felipe F. Tonello <eu@felipetonello.com>
---
 sound/soc/mid-x86/mfld_machine.c   | 2 +-
 sound/soc/omap/omap-abe-twl6040.c  | 2 +-
 sound/soc/omap/omap-twl4030.c      | 2 +-
 sound/soc/omap/rx51.c              | 2 +-
 sound/soc/pxa/hx4700.c             | 2 +-
 sound/soc/pxa/palm27x.c            | 2 +-
 sound/soc/pxa/ttc-dkb.c            | 4 ++--
 sound/soc/pxa/z2.c                 | 2 +-
 sound/soc/samsung/goni_wm8994.c    | 2 +-
 sound/soc/samsung/h1940_uda1380.c  | 2 +-
 sound/soc/samsung/rx1950_uda1380.c | 2 +-
 sound/soc/samsung/smartq_wm8987.c  | 2 +-
 sound/soc/tegra/tegra_alc5632.c    | 2 +-
 sound/soc/tegra/tegra_rt5640.c     | 2 +-
 sound/soc/tegra/tegra_wm8903.c     | 4 ++--
 15 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/sound/soc/mid-x86/mfld_machine.c b/sound/soc/mid-x86/mfld_machine.c
index e52c836..e2c7978 100644
--- a/sound/soc/mid-x86/mfld_machine.c
+++ b/sound/soc/mid-x86/mfld_machine.c
@@ -253,7 +253,7 @@ static int mfld_init(struct snd_soc_pcm_runtime *runtime)
 	snd_soc_dapm_disable_pin(dapm, "LINEINR");
 
 	/* Headset and button jack detection */
-	ret_val = snd_soc_jack_new(codec, "Intel(R) MID Audio Jack",
+	ret_val = snd_soc_jack_new(codec, "Intel(R) MID Audio",
 	                           SND_JACK_HEADSET | SND_JACK_BTN_0 |
 	                           SND_JACK_BTN_1, 0, &mfld_jack);
 	if (ret_val) {
diff --git a/sound/soc/omap/omap-abe-twl6040.c b/sound/soc/omap/omap-abe-twl6040.c
index a63038b..45ff3bc 100644
--- a/sound/soc/omap/omap-abe-twl6040.c
+++ b/sound/soc/omap/omap-abe-twl6040.c
@@ -193,7 +193,7 @@ static int omap_abe_twl6040_init(struct snd_soc_pcm_runtime *rtd)
 
 	/* Headset jack detection only if it is supported */
 	if (priv->jack_detection) {
-		ret = snd_soc_jack_new(codec, "Headset Jack",
+		ret = snd_soc_jack_new(codec, "Headset",
 		                       SND_JACK_HEADSET, 0, &hs_jack);
 		if (ret)
 			return ret;
diff --git a/sound/soc/omap/omap-twl4030.c b/sound/soc/omap/omap-twl4030.c
index 07ba4d3..0619ecb 100644
--- a/sound/soc/omap/omap-twl4030.c
+++ b/sound/soc/omap/omap-twl4030.c
@@ -189,7 +189,7 @@ static int omap_twl4030_init(struct snd_soc_pcm_runtime *rtd)
 	if (priv->jack_detect > 0) {
 		hs_jack_gpios[0].gpio = priv->jack_detect;
 
-		ret = snd_soc_jack_new(codec, "Headset Jack", SND_JACK_HEADSET,
+		ret = snd_soc_jack_new(codec, "Headset", SND_JACK_HEADSET,
 		                       0, &priv->hs_jack);
 		if (ret)
 			return ret;
diff --git a/sound/soc/omap/rx51.c b/sound/soc/omap/rx51.c
index 2cec19a..46fe697 100644
--- a/sound/soc/omap/rx51.c
+++ b/sound/soc/omap/rx51.c
@@ -317,7 +317,7 @@ static int rx51_aic34_init(struct snd_soc_pcm_runtime *rtd)
 		return err;
 
 	/* AV jack detection */
-	err = snd_soc_jack_new(codec, "AV Jack",
+	err = snd_soc_jack_new(codec, "AV",
 	                       SND_JACK_HEADSET | SND_JACK_VIDEOOUT,
 	                       0, &rx51_av_jack);
 	if (err)
diff --git a/sound/soc/pxa/hx4700.c b/sound/soc/pxa/hx4700.c
index 82fd557..3ffe48b 100644
--- a/sound/soc/pxa/hx4700.c
+++ b/sound/soc/pxa/hx4700.c
@@ -137,7 +137,7 @@ static int hx4700_ak4641_init(struct snd_soc_pcm_runtime *rtd)
 	snd_soc_dapm_nc_pin(dapm, "AUX");
 
 	/* Jack detection API stuff */
-	err = snd_soc_jack_new(codec, "Headphone Jack",
+	err = snd_soc_jack_new(codec, "Headphone",
 	                       SND_JACK_HEADPHONE, 0, &hs_jack);
 	if (err)
 		return err;
diff --git a/sound/soc/pxa/palm27x.c b/sound/soc/pxa/palm27x.c
index 264be5e..7caba46 100644
--- a/sound/soc/pxa/palm27x.c
+++ b/sound/soc/pxa/palm27x.c
@@ -97,7 +97,7 @@ static int palm27x_ac97_init(struct snd_soc_pcm_runtime *rtd)
 	snd_soc_dapm_nc_pin(dapm, "MIC2");
 
 	/* Jack detection API stuff */
-	err = snd_soc_jack_new(codec, "Headphone Jack",
+	err = snd_soc_jack_new(codec, "Headphone",
 	                       SND_JACK_HEADPHONE, 0, &hs_jack);
 	if (err)
 		return err;
diff --git a/sound/soc/pxa/ttc-dkb.c b/sound/soc/pxa/ttc-dkb.c
index 1a462cb..880c01f 100644
--- a/sound/soc/pxa/ttc-dkb.c
+++ b/sound/soc/pxa/ttc-dkb.c
@@ -86,12 +86,12 @@ static int ttc_pm860x_init(struct snd_soc_pcm_runtime *rtd)
 	snd_soc_dapm_disable_pin(dapm, "Headset Stereophone");
 
 	/* Headset jack detection */
-	snd_soc_jack_new(codec, "Headphone Jack", SND_JACK_HEADPHONE
+	snd_soc_jack_new(codec, "Headphone", SND_JACK_HEADPHONE
 	                 | SND_JACK_BTN_0 | SND_JACK_BTN_1 | SND_JACK_BTN_2,
 	                 0, &hs_jack);
 	snd_soc_jack_add_pins(&hs_jack, ARRAY_SIZE(hs_jack_pins),
 			      hs_jack_pins);
-	snd_soc_jack_new(codec, "Microphone Jack", SND_JACK_MICROPHONE,
+	snd_soc_jack_new(codec, "Microphone", SND_JACK_MICROPHONE,
 	                 0, &mic_jack);
 	snd_soc_jack_add_pins(&mic_jack, ARRAY_SIZE(mic_jack_pins),
 			      mic_jack_pins);
diff --git a/sound/soc/pxa/z2.c b/sound/soc/pxa/z2.c
index 082fd24..2bbb2de 100644
--- a/sound/soc/pxa/z2.c
+++ b/sound/soc/pxa/z2.c
@@ -143,7 +143,7 @@ static int z2_wm8750_init(struct snd_soc_pcm_runtime *rtd)
 	snd_soc_dapm_disable_pin(dapm, "MONO1");
 
 	/* Jack detection API stuff */
-	ret = snd_soc_jack_new(codec, "Headset Jack", SND_JACK_HEADSET,
+	ret = snd_soc_jack_new(codec, "Headset", SND_JACK_HEADSET,
 	                       0, &hs_jack);
 	if (ret)
 		goto err;
diff --git a/sound/soc/samsung/goni_wm8994.c b/sound/soc/samsung/goni_wm8994.c
index bdd70a9..2bfa4c9 100644
--- a/sound/soc/samsung/goni_wm8994.c
+++ b/sound/soc/samsung/goni_wm8994.c
@@ -114,7 +114,7 @@ static int goni_wm8994_init(struct snd_soc_pcm_runtime *rtd)
 	}
 
 	/* Headset jack detection */
-	ret = snd_soc_jack_new(codec, "Headset Jack",
+	ret = snd_soc_jack_new(codec, "Headset",
 	                       SND_JACK_HEADSET | SND_JACK_MECHANICAL |
 	                       SND_JACK_AVOUT,
 	                       0, &jack);
diff --git a/sound/soc/samsung/h1940_uda1380.c b/sound/soc/samsung/h1940_uda1380.c
index 66b5a33..f8cf0cf 100644
--- a/sound/soc/samsung/h1940_uda1380.c
+++ b/sound/soc/samsung/h1940_uda1380.c
@@ -186,7 +186,7 @@ static int h1940_uda1380_init(struct snd_soc_pcm_runtime *rtd)
 	snd_soc_dapm_enable_pin(dapm, "Speaker");
 	snd_soc_dapm_enable_pin(dapm, "Mic Jack");
 
-	snd_soc_jack_new(codec, "Headphone Jack", SND_JACK_HEADPHONE,
+	snd_soc_jack_new(codec, "Headphone", SND_JACK_HEADPHONE,
 	                 0, &hp_jack);
 
 	snd_soc_jack_add_pins(&hp_jack, ARRAY_SIZE(hp_jack_pins),
diff --git a/sound/soc/samsung/rx1950_uda1380.c b/sound/soc/samsung/rx1950_uda1380.c
index 588ad72..f62b845 100644
--- a/sound/soc/samsung/rx1950_uda1380.c
+++ b/sound/soc/samsung/rx1950_uda1380.c
@@ -231,7 +231,7 @@ static int rx1950_uda1380_init(struct snd_soc_pcm_runtime *rtd)
 	snd_soc_dapm_enable_pin(dapm, "Speaker");
 	snd_soc_dapm_enable_pin(dapm, "Mic Jack");
 
-	snd_soc_jack_new(codec, "Headphone Jack", SND_JACK_HEADPHONE,
+	snd_soc_jack_new(codec, "Headphone", SND_JACK_HEADPHONE,
 	                 0, &hp_jack);
 
 	snd_soc_jack_add_pins(&hp_jack, ARRAY_SIZE(hp_jack_pins),
diff --git a/sound/soc/samsung/smartq_wm8987.c b/sound/soc/samsung/smartq_wm8987.c
index 71a17a5..053ceea 100644
--- a/sound/soc/samsung/smartq_wm8987.c
+++ b/sound/soc/samsung/smartq_wm8987.c
@@ -166,7 +166,7 @@ static int smartq_wm8987_init(struct snd_soc_pcm_runtime *rtd)
 	snd_soc_dapm_disable_pin(dapm, "Headphone Jack");
 
 	/* Headphone jack detection */
-	err = snd_soc_jack_new(codec, "Headphone Jack",
+	err = snd_soc_jack_new(codec, "Headphone",
 	                       SND_JACK_HEADPHONE, 0, &smartq_jack);
 	if (err)
 		return err;
diff --git a/sound/soc/tegra/tegra_alc5632.c b/sound/soc/tegra/tegra_alc5632.c
index 1a44af9..cfacc27 100644
--- a/sound/soc/tegra/tegra_alc5632.c
+++ b/sound/soc/tegra/tegra_alc5632.c
@@ -109,7 +109,7 @@ static int tegra_alc5632_asoc_init(struct snd_soc_pcm_runtime *rtd)
 	struct snd_soc_dapm_context *dapm = &codec->dapm;
 	struct tegra_alc5632 *machine = snd_soc_card_get_drvdata(codec->card);
 
-	snd_soc_jack_new(codec, "Headset Jack", SND_JACK_HEADSET,
+	snd_soc_jack_new(codec, "Headset", SND_JACK_HEADSET,
 	                 0, &tegra_alc5632_hs_jack);
 	snd_soc_jack_add_pins(&tegra_alc5632_hs_jack,
 			ARRAY_SIZE(tegra_alc5632_hs_jack_pins),
diff --git a/sound/soc/tegra/tegra_rt5640.c b/sound/soc/tegra/tegra_rt5640.c
index aad20f2..149b12c 100644
--- a/sound/soc/tegra/tegra_rt5640.c
+++ b/sound/soc/tegra/tegra_rt5640.c
@@ -111,7 +111,7 @@ static int tegra_rt5640_asoc_init(struct snd_soc_pcm_runtime *rtd)
 	struct snd_soc_codec *codec = codec_dai->codec;
 	struct tegra_rt5640 *machine = snd_soc_card_get_drvdata(codec->card);
 
-	snd_soc_jack_new(codec, "Headphones", SND_JACK_HEADPHONE,
+	snd_soc_jack_new(codec, "Headphone", SND_JACK_HEADPHONE,
 	                 0, &tegra_rt5640_hp_jack);
 	snd_soc_jack_add_pins(&tegra_rt5640_hp_jack,
 			ARRAY_SIZE(tegra_rt5640_hp_jack_pins),
diff --git a/sound/soc/tegra/tegra_wm8903.c b/sound/soc/tegra/tegra_wm8903.c
index 3f38d31..cd297f5 100644
--- a/sound/soc/tegra/tegra_wm8903.c
+++ b/sound/soc/tegra/tegra_wm8903.c
@@ -178,7 +178,7 @@ static int tegra_wm8903_init(struct snd_soc_pcm_runtime *rtd)
 
 	if (gpio_is_valid(machine->gpio_hp_det)) {
 		tegra_wm8903_hp_jack_gpio.gpio = machine->gpio_hp_det;
-		snd_soc_jack_new(codec, "Headphone Jack", SND_JACK_HEADPHONE,
+		snd_soc_jack_new(codec, "Headphone", SND_JACK_HEADPHONE,
 		                 0, &tegra_wm8903_hp_jack);
 		snd_soc_jack_add_pins(&tegra_wm8903_hp_jack,
 					ARRAY_SIZE(tegra_wm8903_hp_jack_pins),
@@ -188,7 +188,7 @@ static int tegra_wm8903_init(struct snd_soc_pcm_runtime *rtd)
 					&tegra_wm8903_hp_jack_gpio);
 	}
 
-	snd_soc_jack_new(codec, "Mic Jack", SND_JACK_MICROPHONE,
+	snd_soc_jack_new(codec, "Mic", SND_JACK_MICROPHONE,
 	                 0, &tegra_wm8903_mic_jack);
 	snd_soc_jack_add_pins(&tegra_wm8903_mic_jack,
 			      ARRAY_SIZE(tegra_wm8903_mic_jack_pins),
-- 
1.8.3.1

