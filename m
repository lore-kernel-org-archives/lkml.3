Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaACN3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 08:29:06 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53454 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbaACN2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 08:28:25 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/11] ASoC: twl4030: Parameter alignment fixes (for code consistency)
Date: Fri, 3 Jan 2014 15:27:54 +0200
Message-ID: <1388755676-16036-10-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
References: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Over time the multi line alignment got messed up. Correct them in one go
so the code will look consistent.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl4030.c | 93 ++++++++++++++++++++++------------------------
 1 file changed, 45 insertions(+), 48 deletions(-)

diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index dda53e8c51e5..7a5b91e70f98 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -171,8 +171,8 @@ static bool twl4030_can_write_to_chip(struct snd_soc_codec *codec,
 	return write_to_reg;
 }
 
-static int twl4030_write(struct snd_soc_codec *codec,
-			 unsigned int reg, unsigned int value)
+static int twl4030_write(struct snd_soc_codec *codec, unsigned int reg,
+			 unsigned int value)
 {
 	twl4030_update_ctl_cache(codec, reg, value);
 	if (twl4030_can_write_to_chip(codec, reg))
@@ -298,11 +298,11 @@ static void twl4030_init_chip(struct snd_soc_codec *codec)
 	/* anti-pop when changing analog gain */
 	reg = twl4030_read(codec, TWL4030_REG_MISC_SET_1);
 	twl4030_write(codec, TWL4030_REG_MISC_SET_1,
-		reg | TWL4030_SMOOTH_ANAVOL_EN);
+		      reg | TWL4030_SMOOTH_ANAVOL_EN);
 
 	twl4030_write(codec, TWL4030_REG_OPTION,
-		TWL4030_ATXL1_EN | TWL4030_ATXR1_EN |
-		TWL4030_ARXL2_EN | TWL4030_ARXR2_EN);
+		      TWL4030_ATXL1_EN | TWL4030_ATXR1_EN |
+		      TWL4030_ARXL2_EN | TWL4030_ARXR2_EN);
 
 	/* REG_ARXR2_APGA_CTL reset according to the TRM: 0dB, DA_EN */
 	twl4030_write(codec, TWL4030_REG_ARXR2_APGA_CTL, 0x32);
@@ -325,7 +325,7 @@ static void twl4030_init_chip(struct snd_soc_codec *codec)
 	reg &= ~TWL4030_OFFSET_CNCL_SEL;
 	reg |= pdata->offset_cncl_path;
 	twl4030_write(codec, TWL4030_REG_ANAMICL,
-		reg | TWL4030_CNCL_OFFSET_START);
+		      reg | TWL4030_CNCL_OFFSET_START);
 
 	/*
 	 * Wait for offset cancellation to complete.
@@ -337,7 +337,7 @@ static void twl4030_init_chip(struct snd_soc_codec *codec)
 		usleep_range(1000, 2000);
 		twl_set_regcache_bypass(TWL4030_MODULE_AUDIO_VOICE, true);
 		twl_i2c_read_u8(TWL4030_MODULE_AUDIO_VOICE, &byte,
-				    TWL4030_REG_ANAMICL);
+				TWL4030_REG_ANAMICL);
 		twl_set_regcache_bypass(TWL4030_MODULE_AUDIO_VOICE, false);
 	} while ((i++ < 100) &&
 		 ((byte & TWL4030_CNCL_OFFSET_START) ==
@@ -577,7 +577,7 @@ static const struct snd_kcontrol_new twl4030_dapm_dbypassv_control =
  */
 #define TWL4030_OUTPUT_PGA(pin_name, reg, mask)				\
 static int pin_name##pga_event(struct snd_soc_dapm_widget *w,		\
-		struct snd_kcontrol *kcontrol, int event)		\
+			       struct snd_kcontrol *kcontrol, int event) \
 {									\
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(w->codec); \
 									\
@@ -588,8 +588,7 @@ static int pin_name##pga_event(struct snd_soc_dapm_widget *w,		\
 		break;							\
 	case SND_SOC_DAPM_POST_PMD:					\
 		twl4030->pin_name##_enabled = 0;			\
-		twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,		\
-					0, reg);			\
+		twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE, 0, reg);	\
 		break;							\
 	}								\
 	return 0;							\
@@ -632,7 +631,7 @@ static void handsfree_ramp(struct snd_soc_codec *codec, int reg, int ramp)
 }
 
 static int handsfreelpga_event(struct snd_soc_dapm_widget *w,
-		struct snd_kcontrol *kcontrol, int event)
+			       struct snd_kcontrol *kcontrol, int event)
 {
 	switch (event) {
 	case SND_SOC_DAPM_POST_PMU:
@@ -646,7 +645,7 @@ static int handsfreelpga_event(struct snd_soc_dapm_widget *w,
 }
 
 static int handsfreerpga_event(struct snd_soc_dapm_widget *w,
-		struct snd_kcontrol *kcontrol, int event)
+			       struct snd_kcontrol *kcontrol, int event)
 {
 	switch (event) {
 	case SND_SOC_DAPM_POST_PMU:
@@ -660,14 +659,14 @@ static int handsfreerpga_event(struct snd_soc_dapm_widget *w,
 }
 
 static int vibramux_event(struct snd_soc_dapm_widget *w,
-		struct snd_kcontrol *kcontrol, int event)
+			  struct snd_kcontrol *kcontrol, int event)
 {
 	twl4030_write(w->codec, TWL4030_REG_VIBRA_SET, 0xff);
 	return 0;
 }
 
 static int apll_event(struct snd_soc_dapm_widget *w,
-		struct snd_kcontrol *kcontrol, int event)
+		      struct snd_kcontrol *kcontrol, int event)
 {
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
@@ -681,7 +680,7 @@ static int apll_event(struct snd_soc_dapm_widget *w,
 }
 
 static int aif_event(struct snd_soc_dapm_widget *w,
-		struct snd_kcontrol *kcontrol, int event)
+		     struct snd_kcontrol *kcontrol, int event)
 {
 	u8 audio_if;
 
@@ -693,12 +692,12 @@ static int aif_event(struct snd_soc_dapm_widget *w,
 		twl4030_apll_enable(w->codec, 1);
 
 		twl4030_write(w->codec, TWL4030_REG_AUDIO_IF,
-						audio_if | TWL4030_AIF_EN);
+			      audio_if | TWL4030_AIF_EN);
 		break;
 	case SND_SOC_DAPM_POST_PMD:
 		/* disable the DAI before we stop it's source PLL */
 		twl4030_write(w->codec, TWL4030_REG_AUDIO_IF,
-						audio_if &  ~TWL4030_AIF_EN);
+			      audio_if &  ~TWL4030_AIF_EN);
 		twl4030_apll_enable(w->codec, 0);
 		break;
 	}
@@ -736,9 +735,8 @@ static void headset_ramp(struct snd_soc_codec *codec, int ramp)
 		hs_pop |= TWL4030_VMID_EN;
 		twl4030_write(codec, TWL4030_REG_HS_POPN_SET, hs_pop);
 		/* Actually write to the register */
-		twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
-					hs_gain,
-					TWL4030_REG_HS_GAIN_SET);
+		twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE, hs_gain,
+				 TWL4030_REG_HS_GAIN_SET);
 		hs_pop |= TWL4030_RAMP_EN;
 		twl4030_write(codec, TWL4030_REG_HS_POPN_SET, hs_pop);
 		/* Wait ramp delay time + 1, so the VMID can settle */
@@ -751,9 +749,8 @@ static void headset_ramp(struct snd_soc_codec *codec, int ramp)
 		/* Wait ramp delay time + 1, so the VMID can settle */
 		twl4030_wait_ms(delay);
 		/* Bypass the reg_cache to mute the headset */
-		twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
-					hs_gain & (~0x0f),
-					TWL4030_REG_HS_GAIN_SET);
+		twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE, hs_gain & (~0x0f),
+				 TWL4030_REG_HS_GAIN_SET);
 
 		hs_pop &= ~TWL4030_VMID_EN;
 		twl4030_write(codec, TWL4030_REG_HS_POPN_SET, hs_pop);
@@ -771,7 +768,7 @@ static void headset_ramp(struct snd_soc_codec *codec, int ramp)
 }
 
 static int headsetlpga_event(struct snd_soc_dapm_widget *w,
-		struct snd_kcontrol *kcontrol, int event)
+			     struct snd_kcontrol *kcontrol, int event)
 {
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(w->codec);
 
@@ -795,7 +792,7 @@ static int headsetlpga_event(struct snd_soc_dapm_widget *w,
 }
 
 static int headsetrpga_event(struct snd_soc_dapm_widget *w,
-		struct snd_kcontrol *kcontrol, int event)
+			     struct snd_kcontrol *kcontrol, int event)
 {
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(w->codec);
 
@@ -819,7 +816,7 @@ static int headsetrpga_event(struct snd_soc_dapm_widget *w,
 }
 
 static int digimic_event(struct snd_soc_dapm_widget *w,
-		struct snd_kcontrol *kcontrol, int event)
+			 struct snd_kcontrol *kcontrol, int event)
 {
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(w->codec);
 	struct twl4030_codec_data *pdata = twl4030->pdata;
@@ -840,7 +837,7 @@ static int digimic_event(struct snd_soc_dapm_widget *w,
  * Custom volsw and volsw_2r get/put functions to handle these gain bits.
  */
 static int snd_soc_get_volsw_twl4030(struct snd_kcontrol *kcontrol,
-	struct snd_ctl_elem_value *ucontrol)
+				     struct snd_ctl_elem_value *ucontrol)
 {
 	struct soc_mixer_control *mc =
 		(struct soc_mixer_control *)kcontrol->private_value;
@@ -869,7 +866,7 @@ static int snd_soc_get_volsw_twl4030(struct snd_kcontrol *kcontrol,
 }
 
 static int snd_soc_put_volsw_twl4030(struct snd_kcontrol *kcontrol,
-	struct snd_ctl_elem_value *ucontrol)
+				     struct snd_ctl_elem_value *ucontrol)
 {
 	struct soc_mixer_control *mc =
 		(struct soc_mixer_control *)kcontrol->private_value;
@@ -898,7 +895,7 @@ static int snd_soc_put_volsw_twl4030(struct snd_kcontrol *kcontrol,
 }
 
 static int snd_soc_get_volsw_r2_twl4030(struct snd_kcontrol *kcontrol,
-	struct snd_ctl_elem_value *ucontrol)
+					struct snd_ctl_elem_value *ucontrol)
 {
 	struct soc_mixer_control *mc =
 		(struct soc_mixer_control *)kcontrol->private_value;
@@ -925,7 +922,7 @@ static int snd_soc_get_volsw_r2_twl4030(struct snd_kcontrol *kcontrol,
 }
 
 static int snd_soc_put_volsw_r2_twl4030(struct snd_kcontrol *kcontrol,
-	struct snd_ctl_elem_value *ucontrol)
+					struct snd_ctl_elem_value *ucontrol)
 {
 	struct soc_mixer_control *mc =
 		(struct soc_mixer_control *)kcontrol->private_value;
@@ -1656,7 +1653,7 @@ static void twl4030_constraints(struct twl4030_priv *twl4030,
 /* In case of 4 channel mode, the RX1 L/R for playback and the TX2 L/R for
  * capture has to be enabled/disabled. */
 static void twl4030_tdm_enable(struct snd_soc_codec *codec, int direction,
-				int enable)
+			       int enable)
 {
 	u8 reg, mask;
 
@@ -1695,8 +1692,8 @@ static int twl4030_startup(struct snd_pcm_substream *substream,
 			 * constraint for the first stream for channels, the
 			 * second stream will 'inherit' this cosntraint */
 			snd_pcm_hw_constraint_minmax(substream->runtime,
-						SNDRV_PCM_HW_PARAM_CHANNELS,
-						2, 2);
+						     SNDRV_PCM_HW_PARAM_CHANNELS,
+						     2, 2);
 		}
 		twl4030->master_substream = substream;
 	}
@@ -1728,8 +1725,8 @@ static void twl4030_shutdown(struct snd_pcm_substream *substream,
 }
 
 static int twl4030_hw_params(struct snd_pcm_substream *substream,
-			   struct snd_pcm_hw_params *params,
-			   struct snd_soc_dai *dai)
+			     struct snd_pcm_hw_params *params,
+			     struct snd_soc_dai *dai)
 {
 	struct snd_soc_codec *codec = dai->codec;
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
@@ -1845,8 +1842,8 @@ static int twl4030_hw_params(struct snd_pcm_substream *substream,
 	return 0;
 }
 
-static int twl4030_set_dai_sysclk(struct snd_soc_dai *codec_dai,
-		int clk_id, unsigned int freq, int dir)
+static int twl4030_set_dai_sysclk(struct snd_soc_dai *codec_dai, int clk_id,
+				  unsigned int freq, int dir)
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
@@ -1871,8 +1868,7 @@ static int twl4030_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 	return 0;
 }
 
-static int twl4030_set_dai_fmt(struct snd_soc_dai *codec_dai,
-			     unsigned int fmt)
+static int twl4030_set_dai_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
@@ -1942,7 +1938,7 @@ static int twl4030_set_tristate(struct snd_soc_dai *dai, int tristate)
 /* In case of voice mode, the RX1 L(VRX) for downlink and the TX2 L/R
  * (VTXL, VTXR) for uplink has to be enabled/disabled. */
 static void twl4030_voice_enable(struct snd_soc_codec *codec, int direction,
-				int enable)
+				 int enable)
 {
 	u8 reg, mask;
 
@@ -1962,7 +1958,7 @@ static void twl4030_voice_enable(struct snd_soc_codec *codec, int direction,
 }
 
 static int twl4030_voice_startup(struct snd_pcm_substream *substream,
-		struct snd_soc_dai *dai)
+				 struct snd_soc_dai *dai)
 {
 	struct snd_soc_codec *codec = dai->codec;
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
@@ -1994,7 +1990,7 @@ static int twl4030_voice_startup(struct snd_pcm_substream *substream,
 }
 
 static void twl4030_voice_shutdown(struct snd_pcm_substream *substream,
-				struct snd_soc_dai *dai)
+				   struct snd_soc_dai *dai)
 {
 	struct snd_soc_codec *codec = dai->codec;
 
@@ -2003,7 +1999,8 @@ static void twl4030_voice_shutdown(struct snd_pcm_substream *substream,
 }
 
 static int twl4030_voice_hw_params(struct snd_pcm_substream *substream,
-		struct snd_pcm_hw_params *params, struct snd_soc_dai *dai)
+				   struct snd_pcm_hw_params *params,
+				   struct snd_soc_dai *dai)
 {
 	struct snd_soc_codec *codec = dai->codec;
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
@@ -2013,8 +2010,8 @@ static int twl4030_voice_hw_params(struct snd_pcm_substream *substream,
 	twl4030_voice_enable(codec, substream->stream, 1);
 
 	/* bit rate */
-	old_mode = twl4030_read(codec, TWL4030_REG_CODEC_MODE)
-		& ~(TWL4030_CODECPDZ);
+	old_mode = twl4030_read(codec,
+				TWL4030_REG_CODEC_MODE) & ~TWL4030_CODECPDZ;
 	mode = old_mode;
 
 	switch (params_rate(params)) {
@@ -2048,7 +2045,7 @@ static int twl4030_voice_hw_params(struct snd_pcm_substream *substream,
 }
 
 static int twl4030_voice_set_dai_sysclk(struct snd_soc_dai *codec_dai,
-		int clk_id, unsigned int freq, int dir)
+					int clk_id, unsigned int freq, int dir)
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
@@ -2069,7 +2066,7 @@ static int twl4030_voice_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 }
 
 static int twl4030_voice_set_dai_fmt(struct snd_soc_dai *codec_dai,
-		unsigned int fmt)
+				     unsigned int fmt)
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
@@ -2242,7 +2239,7 @@ static struct snd_soc_codec_driver soc_codec_dev_twl4030 = {
 static int twl4030_codec_probe(struct platform_device *pdev)
 {
 	return snd_soc_register_codec(&pdev->dev, &soc_codec_dev_twl4030,
-			twl4030_dai, ARRAY_SIZE(twl4030_dai));
+				      twl4030_dai, ARRAY_SIZE(twl4030_dai));
 }
 
 static int twl4030_codec_remove(struct platform_device *pdev)
-- 
1.8.5.2

