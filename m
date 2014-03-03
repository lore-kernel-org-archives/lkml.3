Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbaCCDta (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 22:49:30 -0500
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:21974
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753163AbaCCDtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 22:49:06 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zze0eahd799hzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lars@metafoo.de>, <alsa-devel@alsa-project.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv3 1/3] ASoC: codec: Simplify ASoC probe code.
Date: Mon, 3 Mar 2014 10:42:22 +0800
Message-ID: <1393814545-15002-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1393814545-15002-1-git-send-email-Li.Xiubo@freescale.com>
References: <1393814545-15002-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some CODEC drivers like who act as the MFDs children are ignored
by this patch.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/codecs/ad193x.c        | 10 +---------
 sound/soc/codecs/adau1373.c      |  7 -------
 sound/soc/codecs/adav80x.c       |  7 -------
 sound/soc/codecs/ak4535.c        |  9 ---------
 sound/soc/codecs/ak4641.c        |  8 --------
 sound/soc/codecs/ak4642.c        |  8 --------
 sound/soc/codecs/ak4671.c        | 12 +-----------
 sound/soc/codecs/alc5623.c       |  7 -------
 sound/soc/codecs/alc5632.c       |  8 --------
 sound/soc/codecs/cs4270.c        |  9 ---------
 sound/soc/codecs/cs42l51.c       |  6 ------
 sound/soc/codecs/cs42l52.c       |  9 +--------
 sound/soc/codecs/cs42l73.c       | 11 +----------
 sound/soc/codecs/da7210.c        |  8 --------
 sound/soc/codecs/da7213.c        |  8 --------
 sound/soc/codecs/da732x.c        | 13 ++-----------
 sound/soc/codecs/da9055.c        |  8 --------
 sound/soc/codecs/isabelle.c      | 16 ----------------
 sound/soc/codecs/lm49453.c       | 17 -----------------
 sound/soc/codecs/max9768.c       |  5 -----
 sound/soc/codecs/max98088.c      |  6 ------
 sound/soc/codecs/max98090.c      |  8 --------
 sound/soc/codecs/max98095.c      |  6 ------
 sound/soc/codecs/max9850.c       |  8 --------
 sound/soc/codecs/ml26124.c       | 10 ----------
 sound/soc/codecs/rt5631.c        |  9 ---------
 sound/soc/codecs/rt5640.c        |  8 --------
 sound/soc/codecs/sn95031.c       |  2 --
 sound/soc/codecs/ssm2518.c       | 10 ----------
 sound/soc/codecs/ssm2602.c       |  7 -------
 sound/soc/codecs/sta32x.c        | 14 --------------
 sound/soc/codecs/sta529.c        | 10 ----------
 sound/soc/codecs/tlv320aic23.c   |  8 --------
 sound/soc/codecs/tlv320aic26.c   |  2 --
 sound/soc/codecs/tlv320aic32x4.c |  2 --
 sound/soc/codecs/tlv320aic3x.c   |  6 ------
 sound/soc/codecs/wm2000.c        |  2 --
 sound/soc/codecs/wm2200.c        |  7 -------
 sound/soc/codecs/wm5100.c        |  7 -------
 sound/soc/codecs/wm8510.c        | 10 +---------
 sound/soc/codecs/wm8523.c        |  7 -------
 sound/soc/codecs/wm8580.c        |  6 ------
 sound/soc/codecs/wm8711.c        |  6 ------
 sound/soc/codecs/wm8728.c        | 11 +----------
 sound/soc/codecs/wm8731.c        |  7 -------
 sound/soc/codecs/wm8737.c        |  6 ------
 sound/soc/codecs/wm8741.c        |  6 ------
 sound/soc/codecs/wm8750.c        |  6 ------
 sound/soc/codecs/wm8753.c        |  7 -------
 sound/soc/codecs/wm8770.c        |  6 ------
 sound/soc/codecs/wm8776.c        |  6 ------
 sound/soc/codecs/wm8804.c        |  8 --------
 sound/soc/codecs/wm8900.c        |  8 +-------
 sound/soc/codecs/wm8903.c        | 10 +---------
 sound/soc/codecs/wm8904.c        |  9 ---------
 sound/soc/codecs/wm8940.c        |  6 ------
 sound/soc/codecs/wm8955.c        |  8 --------
 sound/soc/codecs/wm8960.c        |  6 ------
 sound/soc/codecs/wm8961.c        |  7 -------
 sound/soc/codecs/wm8962.c        |  7 -------
 sound/soc/codecs/wm8971.c        |  6 ------
 sound/soc/codecs/wm8974.c        |  6 ------
 sound/soc/codecs/wm8978.c        |  8 +-------
 sound/soc/codecs/wm8983.c        |  6 ------
 sound/soc/codecs/wm8985.c        |  7 -------
 sound/soc/codecs/wm8988.c        |  8 --------
 sound/soc/codecs/wm8990.c        |  8 --------
 sound/soc/codecs/wm8991.c        |  8 --------
 sound/soc/codecs/wm8993.c        |  7 -------
 sound/soc/codecs/wm8995.c        |  7 -------
 sound/soc/codecs/wm8996.c        | 12 +-----------
 sound/soc/codecs/wm9081.c        | 11 +----------
 sound/soc/codecs/wm9090.c        | 10 ----------
 73 files changed, 13 insertions(+), 562 deletions(-)

diff --git a/sound/soc/codecs/ad193x.c b/sound/soc/codecs/ad193x.c
index 9381a76..6844d0b 100644
--- a/sound/soc/codecs/ad193x.c
+++ b/sound/soc/codecs/ad193x.c
@@ -322,14 +322,6 @@ static struct snd_soc_dai_driver ad193x_dai = {
 static int ad193x_codec_probe(struct snd_soc_codec *codec)
 {
 	struct ad193x_priv *ad193x = snd_soc_codec_get_drvdata(codec);
-	int ret;
-
-	codec->control_data = ad193x->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 0, 0, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
 
 	/* default setting for ad193x */
 
@@ -347,7 +339,7 @@ static int ad193x_codec_probe(struct snd_soc_codec *codec)
 	regmap_write(ad193x->regmap, AD193X_PLL_CLK_CTRL0, 0x99); /* mclk=24.576Mhz: 0x9D; mclk=12.288Mhz: 0x99 */
 	regmap_write(ad193x->regmap, AD193X_PLL_CLK_CTRL1, 0x04);
 
-	return ret;
+	return 0;
 }
 
 static struct snd_soc_codec_driver soc_codec_dev_ad193x = {
diff --git a/sound/soc/codecs/adau1373.c b/sound/soc/codecs/adau1373.c
index 5765c22..97f610a 100644
--- a/sound/soc/codecs/adau1373.c
+++ b/sound/soc/codecs/adau1373.c
@@ -1376,15 +1376,8 @@ static int adau1373_probe(struct snd_soc_codec *codec)
 	struct adau1373_platform_data *pdata = codec->dev->platform_data;
 	bool lineout_differential = false;
 	unsigned int val;
-	int ret;
 	int i;
 
-	ret = snd_soc_codec_set_cache_io(codec, 0, 0, SND_SOC_REGMAP);
-	if (ret) {
-		dev_err(codec->dev, "failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	if (pdata) {
 		if (pdata->num_drc > ARRAY_SIZE(pdata->drc_setting))
 			return -EINVAL;
diff --git a/sound/soc/codecs/adav80x.c b/sound/soc/codecs/adav80x.c
index 9eb53c8..3f0b0e2 100644
--- a/sound/soc/codecs/adav80x.c
+++ b/sound/soc/codecs/adav80x.c
@@ -801,15 +801,8 @@ static struct snd_soc_dai_driver adav80x_dais[] = {
 
 static int adav80x_probe(struct snd_soc_codec *codec)
 {
-	int ret;
 	struct adav80x *adav80x = snd_soc_codec_get_drvdata(codec);
 
-	ret = snd_soc_codec_set_cache_io(codec, 0, 0, SND_SOC_REGMAP);
-	if (ret) {
-		dev_err(codec->dev, "failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	/* Force PLLs on for SYSCLK output */
 	snd_soc_dapm_force_enable_pin(&codec->dapm, "PLL1");
 	snd_soc_dapm_force_enable_pin(&codec->dapm, "PLL2");
diff --git a/sound/soc/codecs/ak4535.c b/sound/soc/codecs/ak4535.c
index 684fe91..30e2978 100644
--- a/sound/soc/codecs/ak4535.c
+++ b/sound/soc/codecs/ak4535.c
@@ -388,15 +388,6 @@ static int ak4535_resume(struct snd_soc_codec *codec)
 
 static int ak4535_probe(struct snd_soc_codec *codec)
 {
-	struct ak4535_priv *ak4535 = snd_soc_codec_get_drvdata(codec);
-	int ret;
-
-	codec->control_data = ak4535->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
 	/* power on device */
 	ak4535_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
diff --git a/sound/soc/codecs/ak4641.c b/sound/soc/codecs/ak4641.c
index 684b56f..868c0e2 100644
--- a/sound/soc/codecs/ak4641.c
+++ b/sound/soc/codecs/ak4641.c
@@ -519,14 +519,6 @@ static int ak4641_resume(struct snd_soc_codec *codec)
 
 static int ak4641_probe(struct snd_soc_codec *codec)
 {
-	int ret;
-
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
-	if (ret != 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	/* power on device */
 	ak4641_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
diff --git a/sound/soc/codecs/ak4642.c b/sound/soc/codecs/ak4642.c
index 1f646c6..92655cc 100644
--- a/sound/soc/codecs/ak4642.c
+++ b/sound/soc/codecs/ak4642.c
@@ -465,14 +465,6 @@ static int ak4642_resume(struct snd_soc_codec *codec)
 
 static int ak4642_probe(struct snd_soc_codec *codec)
 {
-	int ret;
-
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	ak4642_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
 	return 0;
diff --git a/sound/soc/codecs/ak4671.c b/sound/soc/codecs/ak4671.c
index deb2b44..998fa0c 100644
--- a/sound/soc/codecs/ak4671.c
+++ b/sound/soc/codecs/ak4671.c
@@ -613,17 +613,7 @@ static struct snd_soc_dai_driver ak4671_dai = {
 
 static int ak4671_probe(struct snd_soc_codec *codec)
 {
-	int ret;
-
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
-	ak4671_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
-
-	return ret;
+	return ak4671_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 }
 
 static int ak4671_remove(struct snd_soc_codec *codec)
diff --git a/sound/soc/codecs/alc5623.c b/sound/soc/codecs/alc5623.c
index ed50625..09f7e77 100644
--- a/sound/soc/codecs/alc5623.c
+++ b/sound/soc/codecs/alc5623.c
@@ -904,13 +904,6 @@ static int alc5623_probe(struct snd_soc_codec *codec)
 	struct snd_soc_dapm_context *dapm = &codec->dapm;
 	int ret;
 
-	codec->control_data = alc5623->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	alc5623_reset(codec);
 
 	/* power on device */
diff --git a/sound/soc/codecs/alc5632.c b/sound/soc/codecs/alc5632.c
index d885056..ec071a6 100644
--- a/sound/soc/codecs/alc5632.c
+++ b/sound/soc/codecs/alc5632.c
@@ -1063,14 +1063,6 @@ static int alc5632_probe(struct snd_soc_codec *codec)
 	struct alc5632_priv *alc5632 = snd_soc_codec_get_drvdata(codec);
 	int ret;
 
-	codec->control_data = alc5632->regmap;
-
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
-	if (ret != 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	/* power on device  */
 	alc5632_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
diff --git a/sound/soc/codecs/cs4270.c b/sound/soc/codecs/cs4270.c
index 83c835d..3920e62 100644
--- a/sound/soc/codecs/cs4270.c
+++ b/sound/soc/codecs/cs4270.c
@@ -506,15 +506,6 @@ static int cs4270_probe(struct snd_soc_codec *codec)
 	struct cs4270_private *cs4270 = snd_soc_codec_get_drvdata(codec);
 	int ret;
 
-	/* Tell ASoC what kind of I/O to use to read the registers.  ASoC will
-	 * then do the I2C transactions itself.
-	 */
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "failed to set cache I/O (ret=%i)\n", ret);
-		return ret;
-	}
-
 	/* Disable auto-mute.  This feature appears to be buggy.  In some
 	 * situations, auto-mute will not deactivate when it should, so we want
 	 * this feature disabled by default.  An application (e.g. alsactl) can
diff --git a/sound/soc/codecs/cs42l51.c b/sound/soc/codecs/cs42l51.c
index 5caf75b..1870620 100644
--- a/sound/soc/codecs/cs42l51.c
+++ b/sound/soc/codecs/cs42l51.c
@@ -488,12 +488,6 @@ static int cs42l51_probe(struct snd_soc_codec *codec)
 {
 	int ret, reg;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	/*
 	 * DAC configuration
 	 * - Use signal processor
diff --git a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c
index be455ea..ff45400 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -1109,14 +1109,7 @@ static void cs42l52_free_beep(struct snd_soc_codec *codec)
 static int cs42l52_probe(struct snd_soc_codec *codec)
 {
 	struct cs42l52_private *cs42l52 = snd_soc_codec_get_drvdata(codec);
-	int ret;
 
-	codec->control_data = cs42l52->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
 	regcache_cache_only(cs42l52->regmap, true);
 
 	cs42l52_add_mic_controls(codec);
@@ -1128,7 +1121,7 @@ static int cs42l52_probe(struct snd_soc_codec *codec)
 	cs42l52->sysclk = CS42L52_DEFAULT_CLK;
 	cs42l52->config.format = CS42L52_DEFAULT_FORMAT;
 
-	return ret;
+	return 0;
 }
 
 static int cs42l52_remove(struct snd_soc_codec *codec)
diff --git a/sound/soc/codecs/cs42l73.c b/sound/soc/codecs/cs42l73.c
index 06f4291..b2906c6 100644
--- a/sound/soc/codecs/cs42l73.c
+++ b/sound/soc/codecs/cs42l73.c
@@ -1345,17 +1345,8 @@ static int cs42l73_resume(struct snd_soc_codec *codec)
 
 static int cs42l73_probe(struct snd_soc_codec *codec)
 {
-	int ret;
 	struct cs42l73_private *cs42l73 = snd_soc_codec_get_drvdata(codec);
 
-	codec->control_data = cs42l73->regmap;
-
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	cs42l73_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
 	/* Set Charge Pump Frequency */
@@ -1368,7 +1359,7 @@ static int cs42l73_probe(struct snd_soc_codec *codec)
 	cs42l73->mclksel = CS42L73_CLKID_MCLK1;
 	cs42l73->mclk = 0;
 
-	return ret;
+	return 0;
 }
 
 static int cs42l73_remove(struct snd_soc_codec *codec)
diff --git a/sound/soc/codecs/da7210.c b/sound/soc/codecs/da7210.c
index 01e55fc..137e8eb 100644
--- a/sound/soc/codecs/da7210.c
+++ b/sound/soc/codecs/da7210.c
@@ -1071,17 +1071,9 @@ static struct snd_soc_dai_driver da7210_dai = {
 static int da7210_probe(struct snd_soc_codec *codec)
 {
 	struct da7210_priv *da7210 = snd_soc_codec_get_drvdata(codec);
-	int ret;
 
 	dev_info(codec->dev, "DA7210 Audio Codec %s\n", DA7210_VERSION);
 
-	codec->control_data = da7210->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	da7210->mclk_rate       = 0;    /* This will be set from set_sysclk() */
 	da7210->master          = 0;    /* This will be set from set_fmt() */
 
diff --git a/sound/soc/codecs/da7213.c b/sound/soc/codecs/da7213.c
index 439d103..738fa18 100644
--- a/sound/soc/codecs/da7213.c
+++ b/sound/soc/codecs/da7213.c
@@ -1393,17 +1393,9 @@ static int da7213_set_bias_level(struct snd_soc_codec *codec,
 
 static int da7213_probe(struct snd_soc_codec *codec)
 {
-	int ret;
 	struct da7213_priv *da7213 = snd_soc_codec_get_drvdata(codec);
 	struct da7213_platform_data *pdata = da7213->pdata;
 
-	codec->control_data = da7213->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	/* Default to using ALC auto offset calibration mode. */
 	snd_soc_update_bits(codec, DA7213_ALC_CTRL1,
 			    DA7213_ALC_CALIB_MODE_MAN, 0);
diff --git a/sound/soc/codecs/da732x.c b/sound/soc/codecs/da732x.c
index 4d1c302..d6a1f3a 100644
--- a/sound/soc/codecs/da732x.c
+++ b/sound/soc/codecs/da732x.c
@@ -1512,23 +1512,14 @@ static int da732x_probe(struct snd_soc_codec *codec)
 {
 	struct da732x_priv *da732x = snd_soc_codec_get_drvdata(codec);
 	struct snd_soc_dapm_context *dapm = &codec->dapm;
-	int ret = 0;
 
 	da732x->codec = codec;
 
 	dapm->idle_bias_off = false;
 
-	codec->control_data = da732x->regmap;
-
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
-	if (ret != 0) {
-		dev_err(codec->dev, "Failed to register codec.\n");
-		goto err;
-	}
-
 	da732x_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
-err:
-	return ret;
+
+	return 0;
 }
 
 static int da732x_remove(struct snd_soc_codec *codec)
diff --git a/sound/soc/codecs/da9055.c b/sound/soc/codecs/da9055.c
index f118daa..4ff06b5 100644
--- a/sound/soc/codecs/da9055.c
+++ b/sound/soc/codecs/da9055.c
@@ -1383,16 +1383,8 @@ static int da9055_set_bias_level(struct snd_soc_codec *codec,
 
 static int da9055_probe(struct snd_soc_codec *codec)
 {
-	int ret;
 	struct da9055_priv *da9055 = snd_soc_codec_get_drvdata(codec);
 
-	codec->control_data = da9055->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	/* Enable all Gain Ramps */
 	snd_soc_update_bits(codec, DA9055_AUX_L_CTRL,
 			    DA9055_GAIN_RAMPING_EN, DA9055_GAIN_RAMPING_EN);
diff --git a/sound/soc/codecs/isabelle.c b/sound/soc/codecs/isabelle.c
index cb736dd..3e264a7 100644
--- a/sound/soc/codecs/isabelle.c
+++ b/sound/soc/codecs/isabelle.c
@@ -1090,23 +1090,7 @@ static struct snd_soc_dai_driver isabelle_dai[] = {
 	},
 };
 
-static int isabelle_probe(struct snd_soc_codec *codec)
-{
-	int ret = 0;
-
-	codec->control_data = dev_get_regmap(codec->dev, NULL);
-
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
-	return 0;
-}
-
 static struct snd_soc_codec_driver soc_codec_dev_isabelle = {
-	.probe = isabelle_probe,
 	.set_bias_level = isabelle_set_bias_level,
 	.controls = isabelle_snd_controls,
 	.num_controls = ARRAY_SIZE(isabelle_snd_controls),
diff --git a/sound/soc/codecs/lm49453.c b/sound/soc/codecs/lm49453.c
index e533594..275b3f7 100644
--- a/sound/soc/codecs/lm49453.c
+++ b/sound/soc/codecs/lm49453.c
@@ -1407,22 +1407,6 @@ static int lm49453_resume(struct snd_soc_codec *codec)
 	return 0;
 }
 
-static int lm49453_probe(struct snd_soc_codec *codec)
-{
-	struct lm49453_priv *lm49453 = snd_soc_codec_get_drvdata(codec);
-	int ret = 0;
-
-	codec->control_data = lm49453->regmap;
-
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
-	return 0;
-}
-
 /* power down chip */
 static int lm49453_remove(struct snd_soc_codec *codec)
 {
@@ -1431,7 +1415,6 @@ static int lm49453_remove(struct snd_soc_codec *codec)
 }
 
 static struct snd_soc_codec_driver soc_codec_dev_lm49453 = {
-	.probe = lm49453_probe,
 	.remove = lm49453_remove,
 	.suspend = lm49453_suspend,
 	.resume = lm49453_resume,
diff --git a/sound/soc/codecs/max9768.c b/sound/soc/codecs/max9768.c
index 31f9156..ec481fc 100644
--- a/sound/soc/codecs/max9768.c
+++ b/sound/soc/codecs/max9768.c
@@ -135,11 +135,6 @@ static int max9768_probe(struct snd_soc_codec *codec)
 	struct max9768 *max9768 = snd_soc_codec_get_drvdata(codec);
 	int ret;
 
-	codec->control_data = max9768->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 2, 6, SND_SOC_REGMAP);
-	if (ret)
-		return ret;
-
 	if (max9768->flags & MAX9768_FLAG_CLASSIC_PWM) {
 		ret = snd_soc_write(codec, MAX9768_CTRL, MAX9768_CTRL_PWM);
 		if (ret)
diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
index 4b9274d..ef7cf89 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -1914,12 +1914,6 @@ static int max98088_probe(struct snd_soc_codec *codec)
 
        regcache_mark_dirty(max98088->regmap);
 
-       ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
-       if (ret != 0) {
-               dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-               return ret;
-       }
-
        /* initialize private data */
 
        max98088->sysclk = (unsigned)-1;
diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index a75752f..90b301e 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -2218,14 +2218,6 @@ static int max98090_probe(struct snd_soc_codec *codec)
 
 	max98090->codec = codec;
 
-	codec->control_data = max98090->regmap;
-
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
-	if (ret != 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	/* Reset the codec, the DSP core, and disable all interrupts */
 	max98090_reset(max98090);
 
diff --git a/sound/soc/codecs/max98095.c b/sound/soc/codecs/max98095.c
index 4c22582..03f0536 100644
--- a/sound/soc/codecs/max98095.c
+++ b/sound/soc/codecs/max98095.c
@@ -2238,12 +2238,6 @@ static int max98095_probe(struct snd_soc_codec *codec)
 	struct i2c_client *client;
 	int ret = 0;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
-	if (ret != 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	/* reset the codec, the DSP core, and disable all interrupts */
 	max98095_reset(codec);
 
diff --git a/sound/soc/codecs/max9850.c b/sound/soc/codecs/max9850.c
index 82757eb..4fdf5aa 100644
--- a/sound/soc/codecs/max9850.c
+++ b/sound/soc/codecs/max9850.c
@@ -312,14 +312,6 @@ static int max9850_resume(struct snd_soc_codec *codec)
 
 static int max9850_probe(struct snd_soc_codec *codec)
 {
-	int ret;
-
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	/* enable zero-detect */
 	snd_soc_update_bits(codec, MAX9850_GENERAL_PURPOSE, 1, 1);
 	/* enable slew-rate control */
diff --git a/sound/soc/codecs/ml26124.c b/sound/soc/codecs/ml26124.c
index 577fb87..e661e84 100644
--- a/sound/soc/codecs/ml26124.c
+++ b/sound/soc/codecs/ml26124.c
@@ -586,16 +586,6 @@ static int ml26124_resume(struct snd_soc_codec *codec)
 
 static int ml26124_probe(struct snd_soc_codec *codec)
 {
-	int ret;
-	struct ml26124_priv *priv = snd_soc_codec_get_drvdata(codec);
-	codec->control_data = priv->regmap;
-
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	/* Software Reset */
 	snd_soc_update_bits(codec, ML26124_SW_RST, 0x01, 1);
 	snd_soc_update_bits(codec, ML26124_SW_RST, 0x01, 0);
diff --git a/sound/soc/codecs/rt5631.c b/sound/soc/codecs/rt5631.c
index ce199d3..d4c229f 100644
--- a/sound/soc/codecs/rt5631.c
+++ b/sound/soc/codecs/rt5631.c
@@ -1570,15 +1570,6 @@ static int rt5631_probe(struct snd_soc_codec *codec)
 {
 	struct rt5631_priv *rt5631 = snd_soc_codec_get_drvdata(codec);
 	unsigned int val;
-	int ret;
-
-	codec->control_data = rt5631->regmap;
-
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
-	if (ret != 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
 
 	val = rt5631_read_index(codec, RT5631_ADDA_MIXER_INTL_REG3);
 	if (val & 0x0002)
diff --git a/sound/soc/codecs/rt5640.c b/sound/soc/codecs/rt5640.c
index 1a1e115..13ccee4 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -1936,16 +1936,8 @@ static int rt5640_set_bias_level(struct snd_soc_codec *codec,
 static int rt5640_probe(struct snd_soc_codec *codec)
 {
 	struct rt5640_priv *rt5640 = snd_soc_codec_get_drvdata(codec);
-	int ret;
 
 	rt5640->codec = codec;
-	codec->control_data = rt5640->regmap;
-
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
-	if (ret != 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
 
 	codec->dapm.idle_bias_off = 1;
 	rt5640_set_bias_level(codec, SND_SOC_BIAS_OFF);
diff --git a/sound/soc/codecs/sn95031.c b/sound/soc/codecs/sn95031.c
index bca7d02..42dff26 100644
--- a/sound/soc/codecs/sn95031.c
+++ b/sound/soc/codecs/sn95031.c
@@ -825,8 +825,6 @@ static int sn95031_codec_probe(struct snd_soc_codec *codec)
 {
 	pr_debug("codec_probe called\n");
 
-	snd_soc_codec_set_cache_io(codec, 0, 0, SND_SOC_REGMAP);
-
 	/* PCM interface config
 	 * This sets the pcm rx slot conguration to max 6 slots
 	 * for max 4 dais (2 stereo and 2 mono)
diff --git a/sound/soc/codecs/ssm2518.c b/sound/soc/codecs/ssm2518.c
index 806f3d8..56adb3e 100644
--- a/sound/soc/codecs/ssm2518.c
+++ b/sound/soc/codecs/ssm2518.c
@@ -648,16 +648,6 @@ static struct snd_soc_dai_driver ssm2518_dai = {
 
 static int ssm2518_probe(struct snd_soc_codec *codec)
 {
-	struct ssm2518 *ssm2518 = snd_soc_codec_get_drvdata(codec);
-	int ret;
-
-	codec->control_data = ssm2518->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 0, 0, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	return ssm2518_set_bias_level(codec, SND_SOC_BIAS_OFF);
 }
 
diff --git a/sound/soc/codecs/ssm2602.c b/sound/soc/codecs/ssm2602.c
index 1294709..97b0454 100644
--- a/sound/soc/codecs/ssm2602.c
+++ b/sound/soc/codecs/ssm2602.c
@@ -562,13 +562,6 @@ static int ssm260x_codec_probe(struct snd_soc_codec *codec)
 	struct ssm2602_priv *ssm2602 = snd_soc_codec_get_drvdata(codec);
 	int ret;
 
-	codec->control_data = ssm2602->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 0, 0, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	ret = regmap_write(ssm2602->regmap, SSM2602_RESET, 0);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to issue reset: %d\n", ret);
diff --git a/sound/soc/codecs/sta32x.c b/sound/soc/codecs/sta32x.c
index 2735361..1257774 100644
--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -872,16 +872,6 @@ static int sta32x_probe(struct snd_soc_codec *codec)
 		return ret;
 	}
 
-	/* Tell ASoC what kind of I/O to use to read the registers.  ASoC will
-	 * then do the I2C transactions itself.
-	 */
-	codec->control_data = sta32x->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "failed to set cache I/O (ret=%i)\n", ret);
-		goto err;
-	}
-
 	/* Chip documentation explicitly requires that the reset values
 	 * of reserved register bits are left untouched.
 	 * Write the register default value to cache for reserved registers,
@@ -946,10 +936,6 @@ static int sta32x_probe(struct snd_soc_codec *codec)
 	regulator_bulk_disable(ARRAY_SIZE(sta32x->supplies), sta32x->supplies);
 
 	return 0;
-
-err:
-	regulator_bulk_disable(ARRAY_SIZE(sta32x->supplies), sta32x->supplies);
-	return ret;
 }
 
 static int sta32x_remove(struct snd_soc_codec *codec)
diff --git a/sound/soc/codecs/sta529.c b/sound/soc/codecs/sta529.c
index f15b0e3..a3c61d3 100644
--- a/sound/soc/codecs/sta529.c
+++ b/sound/soc/codecs/sta529.c
@@ -322,16 +322,6 @@ static struct snd_soc_dai_driver sta529_dai = {
 
 static int sta529_probe(struct snd_soc_codec *codec)
 {
-	struct sta529 *sta529 = snd_soc_codec_get_drvdata(codec);
-	int ret;
-
-	codec->control_data = sta529->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
-
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
 	sta529_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
 	return 0;
diff --git a/sound/soc/codecs/tlv320aic23.c b/sound/soc/codecs/tlv320aic23.c
index 139f11f..49c95c4 100644
--- a/sound/soc/codecs/tlv320aic23.c
+++ b/sound/soc/codecs/tlv320aic23.c
@@ -559,14 +559,6 @@ static int tlv320aic23_resume(struct snd_soc_codec *codec)
 
 static int tlv320aic23_probe(struct snd_soc_codec *codec)
 {
-	int ret;
-
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	/* Reset codec */
 	snd_soc_write(codec, TLV320AIC23_RESET, 0);
 
diff --git a/sound/soc/codecs/tlv320aic26.c b/sound/soc/codecs/tlv320aic26.c
index ff5f23d..43069de 100644
--- a/sound/soc/codecs/tlv320aic26.c
+++ b/sound/soc/codecs/tlv320aic26.c
@@ -296,8 +296,6 @@ static int aic26_probe(struct snd_soc_codec *codec)
 	struct aic26 *aic26 = dev_get_drvdata(codec->dev);
 	int ret, reg;
 
-	snd_soc_codec_set_cache_io(codec, 16, 16, SND_SOC_REGMAP);
-
 	aic26->codec = codec;
 
 	/* Reset the codec to power on defaults */
diff --git a/sound/soc/codecs/tlv320aic32x4.c b/sound/soc/codecs/tlv320aic32x4.c
index c6bd7e7..1d9b117 100644
--- a/sound/soc/codecs/tlv320aic32x4.c
+++ b/sound/soc/codecs/tlv320aic32x4.c
@@ -614,8 +614,6 @@ static int aic32x4_probe(struct snd_soc_codec *codec)
 	struct aic32x4_priv *aic32x4 = snd_soc_codec_get_drvdata(codec);
 	u32 tmp_reg;
 
-	snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
-
 	if (gpio_is_valid(aic32x4->rstn_gpio)) {
 		ndelay(10);
 		gpio_set_value(aic32x4->rstn_gpio, 1);
diff --git a/sound/soc/codecs/tlv320aic3x.c b/sound/soc/codecs/tlv320aic3x.c
index 470fbfb..b183510 100644
--- a/sound/soc/codecs/tlv320aic3x.c
+++ b/sound/soc/codecs/tlv320aic3x.c
@@ -1344,12 +1344,6 @@ static int aic3x_probe(struct snd_soc_codec *codec)
 	INIT_LIST_HEAD(&aic3x->list);
 	aic3x->codec = codec;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
-	if (ret != 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	for (i = 0; i < ARRAY_SIZE(aic3x->supplies); i++) {
 		aic3x->disable_nb[i].nb.notifier_call = aic3x_regulator_event;
 		aic3x->disable_nb[i].aic3x = aic3x;
diff --git a/sound/soc/codecs/wm2000.c b/sound/soc/codecs/wm2000.c
index 8ae5027..83a2c87 100644
--- a/sound/soc/codecs/wm2000.c
+++ b/sound/soc/codecs/wm2000.c
@@ -786,8 +786,6 @@ static int wm2000_probe(struct snd_soc_codec *codec)
 {
 	struct wm2000_priv *wm2000 = dev_get_drvdata(codec->dev);
 
-	snd_soc_codec_set_cache_io(codec, 16, 8, SND_SOC_REGMAP);
-
 	/* This will trigger a transition to standby mode by default */
 	wm2000_anc_set_mode(wm2000);
 
diff --git a/sound/soc/codecs/wm2200.c b/sound/soc/codecs/wm2200.c
index 1e0a083..2e721e0 100644
--- a/sound/soc/codecs/wm2200.c
+++ b/sound/soc/codecs/wm2200.c
@@ -1554,15 +1554,8 @@ static int wm2200_probe(struct snd_soc_codec *codec)
 	int ret;
 
 	wm2200->codec = codec;
-	codec->control_data = wm2200->regmap;
 	codec->dapm.bias_level = SND_SOC_BIAS_OFF;
 
-	ret = snd_soc_codec_set_cache_io(codec, 16, 16, SND_SOC_REGMAP);
-	if (ret != 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	ret = snd_soc_add_codec_controls(codec, wm_adsp1_fw_controls, 2);
 	if (ret != 0)
 		return ret;
diff --git a/sound/soc/codecs/wm5100.c b/sound/soc/codecs/wm5100.c
index d3fa65f..eca983f 100644
--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -2343,13 +2343,6 @@ static int wm5100_probe(struct snd_soc_codec *codec)
 	int ret, i;
 
 	wm5100->codec = codec;
-	codec->control_data = wm5100->regmap;
-
-	ret = snd_soc_codec_set_cache_io(codec, 16, 16, SND_SOC_REGMAP);
-	if (ret != 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
 
 	for (i = 0; i < ARRAY_SIZE(wm5100_dig_vu); i++)
 		snd_soc_update_bits(codec, wm5100_dig_vu[i], WM5100_OUT_VU,
diff --git a/sound/soc/codecs/wm8510.c b/sound/soc/codecs/wm8510.c
index 7df7d45..1c1e328 100644
--- a/sound/soc/codecs/wm8510.c
+++ b/sound/soc/codecs/wm8510.c
@@ -589,20 +589,12 @@ static int wm8510_resume(struct snd_soc_codec *codec)
 
 static int wm8510_probe(struct snd_soc_codec *codec)
 {
-	int ret;
-
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
-	if (ret < 0) {
-		printk(KERN_ERR "wm8510: failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	wm8510_reset(codec);
 
 	/* power on device */
 	wm8510_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
-	return ret;
+	return 0;
 }
 
 /* power down chip */
diff --git a/sound/soc/codecs/wm8523.c b/sound/soc/codecs/wm8523.c
index 5dfd571..601ee81 100644
--- a/sound/soc/codecs/wm8523.c
+++ b/sound/soc/codecs/wm8523.c
@@ -392,18 +392,11 @@ static int wm8523_resume(struct snd_soc_codec *codec)
 static int wm8523_probe(struct snd_soc_codec *codec)
 {
 	struct wm8523_priv *wm8523 = snd_soc_codec_get_drvdata(codec);
-	int ret;
 
 	wm8523->rate_constraint.list = &wm8523->rate_constraint_list[0];
 	wm8523->rate_constraint.count =
 		ARRAY_SIZE(wm8523->rate_constraint_list);
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
-	if (ret != 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	/* Change some default settings - latch VU and enable ZC */
 	snd_soc_update_bits(codec, WM8523_DAC_GAINR,
 			    WM8523_DACR_VU, WM8523_DACR_VU);
diff --git a/sound/soc/codecs/wm8580.c b/sound/soc/codecs/wm8580.c
index 318989a..7558c83 100644
--- a/sound/soc/codecs/wm8580.c
+++ b/sound/soc/codecs/wm8580.c
@@ -869,12 +869,6 @@ static int wm8580_probe(struct snd_soc_codec *codec)
 	struct wm8580_priv *wm8580 = snd_soc_codec_get_drvdata(codec);
 	int ret = 0;
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	ret = regulator_bulk_enable(ARRAY_SIZE(wm8580->supplies),
 				    wm8580->supplies);
 	if (ret != 0) {
diff --git a/sound/soc/codecs/wm8711.c b/sound/soc/codecs/wm8711.c
index d99f948..ef6cbc7 100644
--- a/sound/soc/codecs/wm8711.c
+++ b/sound/soc/codecs/wm8711.c
@@ -367,12 +367,6 @@ static int wm8711_probe(struct snd_soc_codec *codec)
 {
 	int ret;
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	ret = wm8711_reset(codec);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to issue reset\n");
diff --git a/sound/soc/codecs/wm8728.c b/sound/soc/codecs/wm8728.c
index cd89033..bac7fc2 100644
--- a/sound/soc/codecs/wm8728.c
+++ b/sound/soc/codecs/wm8728.c
@@ -228,19 +228,10 @@ static int wm8728_resume(struct snd_soc_codec *codec)
 
 static int wm8728_probe(struct snd_soc_codec *codec)
 {
-	int ret;
-
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
-	if (ret < 0) {
-		printk(KERN_ERR "wm8728: failed to configure cache I/O: %d\n",
-		       ret);
-		return ret;
-	}
-
 	/* power on device */
 	wm8728_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
-	return ret;
+	return 0;
 }
 
 static int wm8728_remove(struct snd_soc_codec *codec)
diff --git a/sound/soc/codecs/wm8731.c b/sound/soc/codecs/wm8731.c
index d9655f9..d74f439 100644
--- a/sound/soc/codecs/wm8731.c
+++ b/sound/soc/codecs/wm8731.c
@@ -583,13 +583,6 @@ static int wm8731_probe(struct snd_soc_codec *codec)
 	struct wm8731_priv *wm8731 = snd_soc_codec_get_drvdata(codec);
 	int ret = 0, i;
 
-	codec->control_data = wm8731->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	for (i = 0; i < ARRAY_SIZE(wm8731->supplies); i++)
 		wm8731->supplies[i].supply = wm8731_supply_names[i];
 
diff --git a/sound/soc/codecs/wm8737.c b/sound/soc/codecs/wm8737.c
index ecc4e87..b27f26c 100644
--- a/sound/soc/codecs/wm8737.c
+++ b/sound/soc/codecs/wm8737.c
@@ -570,12 +570,6 @@ static int wm8737_probe(struct snd_soc_codec *codec)
 	struct wm8737_priv *wm8737 = snd_soc_codec_get_drvdata(codec);
 	int ret;
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
-	if (ret != 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	ret = regulator_bulk_enable(ARRAY_SIZE(wm8737->supplies),
 				    wm8737->supplies);
 	if (ret != 0) {
diff --git a/sound/soc/codecs/wm8741.c b/sound/soc/codecs/wm8741.c
index dd02ebf..b33542a 100644
--- a/sound/soc/codecs/wm8741.c
+++ b/sound/soc/codecs/wm8741.c
@@ -429,12 +429,6 @@ static int wm8741_probe(struct snd_soc_codec *codec)
 		goto err_get;
 	}
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
-	if (ret != 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		goto err_enable;
-	}
-
 	ret = wm8741_reset(codec);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to issue reset\n");
diff --git a/sound/soc/codecs/wm8750.c b/sound/soc/codecs/wm8750.c
index 78616a6..33990b6 100644
--- a/sound/soc/codecs/wm8750.c
+++ b/sound/soc/codecs/wm8750.c
@@ -702,12 +702,6 @@ static int wm8750_probe(struct snd_soc_codec *codec)
 {
 	int ret;
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
-	if (ret < 0) {
-		printk(KERN_ERR "wm8750: failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	ret = wm8750_reset(codec);
 	if (ret < 0) {
 		printk(KERN_ERR "wm8750: failed to reset: %d\n", ret);
diff --git a/sound/soc/codecs/wm8753.c b/sound/soc/codecs/wm8753.c
index be85da9..0d1670b 100644
--- a/sound/soc/codecs/wm8753.c
+++ b/sound/soc/codecs/wm8753.c
@@ -1471,13 +1471,6 @@ static int wm8753_probe(struct snd_soc_codec *codec)
 
 	INIT_DELAYED_WORK(&codec->dapm.delayed_work, wm8753_work);
 
-	codec->control_data = wm8753->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	ret = wm8753_reset(codec);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to issue reset: %d\n", ret);
diff --git a/sound/soc/codecs/wm8770.c b/sound/soc/codecs/wm8770.c
index 5bce210..c61aeb3 100644
--- a/sound/soc/codecs/wm8770.c
+++ b/sound/soc/codecs/wm8770.c
@@ -580,12 +580,6 @@ static int wm8770_probe(struct snd_soc_codec *codec)
 	wm8770 = snd_soc_codec_get_drvdata(codec);
 	wm8770->codec = codec;
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	ret = regulator_bulk_enable(ARRAY_SIZE(wm8770->supplies),
 				    wm8770->supplies);
 	if (ret) {
diff --git a/sound/soc/codecs/wm8776.c b/sound/soc/codecs/wm8776.c
index ef82467..70952ce 100644
--- a/sound/soc/codecs/wm8776.c
+++ b/sound/soc/codecs/wm8776.c
@@ -430,12 +430,6 @@ static int wm8776_probe(struct snd_soc_codec *codec)
 {
 	int ret = 0;
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	ret = wm8776_reset(codec);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to issue reset: %d\n", ret);
diff --git a/sound/soc/codecs/wm8804.c b/sound/soc/codecs/wm8804.c
index 72d12bb..ee76f0f 100644
--- a/sound/soc/codecs/wm8804.c
+++ b/sound/soc/codecs/wm8804.c
@@ -546,14 +546,6 @@ static int wm8804_probe(struct snd_soc_codec *codec)
 
 	wm8804 = snd_soc_codec_get_drvdata(codec);
 
-	codec->control_data = wm8804->regmap;
-
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache i/o: %d\n", ret);
-		return ret;
-	}
-
 	for (i = 0; i < ARRAY_SIZE(wm8804->supplies); i++)
 		wm8804->supplies[i].supply = wm8804_supply_names[i];
 
diff --git a/sound/soc/codecs/wm8900.c b/sound/soc/codecs/wm8900.c
index 43c2201..d09fdce 100644
--- a/sound/soc/codecs/wm8900.c
+++ b/sound/soc/codecs/wm8900.c
@@ -1178,13 +1178,7 @@ static int wm8900_resume(struct snd_soc_codec *codec)
 
 static int wm8900_probe(struct snd_soc_codec *codec)
 {
-	int ret = 0, reg;
-
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
-	if (ret != 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
+	int reg;
 
 	reg = snd_soc_read(codec, WM8900_REG_ID);
 	if (reg != 0x8900) {
diff --git a/sound/soc/codecs/wm8903.c b/sound/soc/codecs/wm8903.c
index b82b70a..b0084a1 100644
--- a/sound/soc/codecs/wm8903.c
+++ b/sound/soc/codecs/wm8903.c
@@ -1897,21 +1897,13 @@ static void wm8903_free_gpio(struct wm8903_priv *wm8903)
 static int wm8903_probe(struct snd_soc_codec *codec)
 {
 	struct wm8903_priv *wm8903 = snd_soc_codec_get_drvdata(codec);
-	int ret;
 
 	wm8903->codec = codec;
-	codec->control_data = wm8903->regmap;
-
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
-	if (ret != 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
 
 	/* power on device */
 	wm8903_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
-	return ret;
+	return 0;
 }
 
 /* power down chip */
diff --git a/sound/soc/codecs/wm8904.c b/sound/soc/codecs/wm8904.c
index 27299cd..49c35c3 100644
--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -2048,9 +2048,6 @@ static void wm8904_handle_pdata(struct snd_soc_codec *codec)
 static int wm8904_probe(struct snd_soc_codec *codec)
 {
 	struct wm8904_priv *wm8904 = snd_soc_codec_get_drvdata(codec);
-	int ret;
-
-	codec->control_data = wm8904->regmap;
 
 	switch (wm8904->devtype) {
 	case WM8904:
@@ -2064,12 +2061,6 @@ static int wm8904_probe(struct snd_soc_codec *codec)
 		return -EINVAL;
 	}
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
-	if (ret != 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	wm8904_handle_pdata(codec);
 
 	wm8904_add_widgets(codec);
diff --git a/sound/soc/codecs/wm8940.c b/sound/soc/codecs/wm8940.c
index 87f032d..fc6eec9 100644
--- a/sound/soc/codecs/wm8940.c
+++ b/sound/soc/codecs/wm8940.c
@@ -712,12 +712,6 @@ static int wm8940_probe(struct snd_soc_codec *codec)
 	int ret;
 	u16 reg;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	ret = wm8940_reset(codec);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to issue reset\n");
diff --git a/sound/soc/codecs/wm8955.c b/sound/soc/codecs/wm8955.c
index d4dcaec..fecd4e4 100644
--- a/sound/soc/codecs/wm8955.c
+++ b/sound/soc/codecs/wm8955.c
@@ -895,14 +895,6 @@ static int wm8955_probe(struct snd_soc_codec *codec)
 	struct wm8955_pdata *pdata = dev_get_platdata(codec->dev);
 	int ret, i;
 
-	codec->control_data = wm8955->regmap;
-
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
-	if (ret != 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	for (i = 0; i < ARRAY_SIZE(wm8955->supplies); i++)
 		wm8955->supplies[i].supply = wm8955_supply_names[i];
 
diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index f156010..d04e9ca 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -976,12 +976,6 @@ static int wm8960_probe(struct snd_soc_codec *codec)
 			wm8960->set_bias_level = wm8960_set_bias_level_capless;
 	}
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	ret = wm8960_reset(codec);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to issue reset\n");
diff --git a/sound/soc/codecs/wm8961.c b/sound/soc/codecs/wm8961.c
index ce8fa6e..9c88f04 100644
--- a/sound/soc/codecs/wm8961.c
+++ b/sound/soc/codecs/wm8961.c
@@ -836,15 +836,8 @@ static struct snd_soc_dai_driver wm8961_dai = {
 static int wm8961_probe(struct snd_soc_codec *codec)
 {
 	struct snd_soc_dapm_context *dapm = &codec->dapm;
-	int ret = 0;
 	u16 reg;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
-	if (ret != 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	/* Enable class W */
 	reg = snd_soc_read(codec, WM8961_CHARGE_PUMP_B);
 	reg |= WM8961_CP_DYN_PWR_MASK;
diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index 62af9dc..5522d25 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -3424,13 +3424,6 @@ static int wm8962_probe(struct snd_soc_codec *codec)
 	bool dmicclk, dmicdat;
 
 	wm8962->codec = codec;
-	codec->control_data = wm8962->regmap;
-
-	ret = snd_soc_codec_set_cache_io(codec, 16, 16, SND_SOC_REGMAP);
-	if (ret != 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
 
 	wm8962->disable_nb[0].notifier_call = wm8962_regulator_event_0;
 	wm8962->disable_nb[1].notifier_call = wm8962_regulator_event_1;
diff --git a/sound/soc/codecs/wm8971.c b/sound/soc/codecs/wm8971.c
index 67aba78..09b7b42 100644
--- a/sound/soc/codecs/wm8971.c
+++ b/sound/soc/codecs/wm8971.c
@@ -648,12 +648,6 @@ static int wm8971_probe(struct snd_soc_codec *codec)
 	int ret = 0;
 	u16 reg;
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
-	if (ret < 0) {
-		printk(KERN_ERR "wm8971: failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	INIT_DELAYED_WORK(&codec->dapm.delayed_work, wm8971_work);
 	wm8971_workq = create_workqueue("wm8971");
 	if (wm8971_workq == NULL)
diff --git a/sound/soc/codecs/wm8974.c b/sound/soc/codecs/wm8974.c
index 6e16c43..0627c56 100644
--- a/sound/soc/codecs/wm8974.c
+++ b/sound/soc/codecs/wm8974.c
@@ -593,12 +593,6 @@ static int wm8974_probe(struct snd_soc_codec *codec)
 {
 	int ret = 0;
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	ret = wm8974_reset(codec);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to issue reset\n");
diff --git a/sound/soc/codecs/wm8978.c b/sound/soc/codecs/wm8978.c
index a9e2f46..28ef46c 100644
--- a/sound/soc/codecs/wm8978.c
+++ b/sound/soc/codecs/wm8978.c
@@ -975,19 +975,13 @@ static const int update_reg[] = {
 static int wm8978_probe(struct snd_soc_codec *codec)
 {
 	struct wm8978_priv *wm8978 = snd_soc_codec_get_drvdata(codec);
-	int ret = 0, i;
+	int i;
 
 	/*
 	 * Set default system clock to PLL, it is more precise, this is also the
 	 * default hardware setting
 	 */
 	wm8978->sysclk = WM8978_PLL;
-	codec->control_data = wm8978->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
 
 	/*
 	 * Set the update bit in all registers, that have one. This way all
diff --git a/sound/soc/codecs/wm8983.c b/sound/soc/codecs/wm8983.c
index 58f0551..2b9bfa5 100644
--- a/sound/soc/codecs/wm8983.c
+++ b/sound/soc/codecs/wm8983.c
@@ -995,12 +995,6 @@ static int wm8983_probe(struct snd_soc_codec *codec)
 	int ret;
 	int i;
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache i/o: %d\n", ret);
-		return ret;
-	}
-
 	ret = snd_soc_write(codec, WM8983_SOFTWARE_RESET, 0);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to issue reset: %d\n", ret);
diff --git a/sound/soc/codecs/wm8985.c b/sound/soc/codecs/wm8985.c
index d786f2b..5473dc9 100644
--- a/sound/soc/codecs/wm8985.c
+++ b/sound/soc/codecs/wm8985.c
@@ -995,13 +995,6 @@ static int wm8985_probe(struct snd_soc_codec *codec)
 	int ret;
 
 	wm8985 = snd_soc_codec_get_drvdata(codec);
-	codec->control_data = wm8985->regmap;
-
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache i/o: %d\n", ret);
-		return ret;
-	}
 
 	for (i = 0; i < ARRAY_SIZE(wm8985->supplies); i++)
 		wm8985->supplies[i].supply = wm8985_supply_names[i];
diff --git a/sound/soc/codecs/wm8988.c b/sound/soc/codecs/wm8988.c
index 0277a76..3a1ae4f5 100644
--- a/sound/soc/codecs/wm8988.c
+++ b/sound/soc/codecs/wm8988.c
@@ -810,16 +810,8 @@ static int wm8988_resume(struct snd_soc_codec *codec)
 
 static int wm8988_probe(struct snd_soc_codec *codec)
 {
-	struct wm8988_priv *wm8988 = snd_soc_codec_get_drvdata(codec);
 	int ret = 0;
 
-	codec->control_data = wm8988->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	ret = wm8988_reset(codec);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to issue reset\n");
diff --git a/sound/soc/codecs/wm8990.c b/sound/soc/codecs/wm8990.c
index 33f53ab..c413c19 100644
--- a/sound/soc/codecs/wm8990.c
+++ b/sound/soc/codecs/wm8990.c
@@ -1289,14 +1289,6 @@ static int wm8990_resume(struct snd_soc_codec *codec)
  */
 static int wm8990_probe(struct snd_soc_codec *codec)
 {
-	int ret;
-
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
-	if (ret < 0) {
-		printk(KERN_ERR "wm8990: failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	wm8990_reset(codec);
 
 	/* charge output caps */
diff --git a/sound/soc/codecs/wm8991.c b/sound/soc/codecs/wm8991.c
index 32d2195..844cc4a 100644
--- a/sound/soc/codecs/wm8991.c
+++ b/sound/soc/codecs/wm8991.c
@@ -1248,14 +1248,6 @@ static int wm8991_remove(struct snd_soc_codec *codec)
 
 static int wm8991_probe(struct snd_soc_codec *codec)
 {
-	int ret;
-
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache i/o: %d\n", ret);
-		return ret;
-	}
-
 	wm8991_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
 	return 0;
diff --git a/sound/soc/codecs/wm8993.c b/sound/soc/codecs/wm8993.c
index 7b0630a..f825dc0 100644
--- a/sound/soc/codecs/wm8993.c
+++ b/sound/soc/codecs/wm8993.c
@@ -1493,13 +1493,6 @@ static int wm8993_probe(struct snd_soc_codec *codec)
 	wm8993->hubs_data.dcs_codes_r = -2;
 	wm8993->hubs_data.series_startup = 1;
 
-	codec->control_data = wm8993->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
-	if (ret != 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	/* Latch volume update bits and default ZC on */
 	snd_soc_update_bits(codec, WM8993_RIGHT_DAC_DIGITAL_VOLUME,
 			    WM8993_DAC_VU, WM8993_DAC_VU);
diff --git a/sound/soc/codecs/wm8995.c b/sound/soc/codecs/wm8995.c
index 33ff361..e8f331d 100644
--- a/sound/soc/codecs/wm8995.c
+++ b/sound/soc/codecs/wm8995.c
@@ -2042,13 +2042,6 @@ static int wm8995_probe(struct snd_soc_codec *codec)
 	wm8995 = snd_soc_codec_get_drvdata(codec);
 	wm8995->codec = codec;
 
-	codec->control_data = wm8995->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 16, 16, SND_SOC_REGMAP);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to set cache i/o: %d\n", ret);
-		return ret;
-	}
-
 	for (i = 0; i < ARRAY_SIZE(wm8995->supplies); i++)
 		wm8995->supplies[i].supply = wm8995_supply_names[i];
 
diff --git a/sound/soc/codecs/wm8996.c b/sound/soc/codecs/wm8996.c
index c8244af..c6cbb3b 100644
--- a/sound/soc/codecs/wm8996.c
+++ b/sound/soc/codecs/wm8996.c
@@ -2633,14 +2633,6 @@ static int wm8996_probe(struct snd_soc_codec *codec)
 	init_completion(&wm8996->dcs_done);
 	init_completion(&wm8996->fll_lock);
 
-	codec->control_data = wm8996->regmap;
-
-	ret = snd_soc_codec_set_cache_io(codec, 16, 16, SND_SOC_REGMAP);
-	if (ret != 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		goto err;
-	}
-
 	if (wm8996->pdata.num_retune_mobile_cfgs)
 		wm8996_retune_mobile_pdata(codec);
 	else
@@ -2679,13 +2671,11 @@ static int wm8996_probe(struct snd_soc_codec *codec)
 		} else {
 			dev_err(codec->dev, "Failed to request IRQ: %d\n",
 				ret);
+			return ret;
 		}
 	}
 
 	return 0;
-
-err:
-	return ret;
 }
 
 static int wm8996_remove(struct snd_soc_codec *codec)
diff --git a/sound/soc/codecs/wm9081.c b/sound/soc/codecs/wm9081.c
index 721cee7..d18eff3 100644
--- a/sound/soc/codecs/wm9081.c
+++ b/sound/soc/codecs/wm9081.c
@@ -1260,15 +1260,6 @@ static struct snd_soc_dai_driver wm9081_dai = {
 static int wm9081_probe(struct snd_soc_codec *codec)
 {
 	struct wm9081_priv *wm9081 = snd_soc_codec_get_drvdata(codec);
-	int ret;
-
-	codec->control_data = wm9081->regmap;
-
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
-	if (ret != 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
 
 	/* Enable zero cross by default */
 	snd_soc_update_bits(codec, WM9081_ANALOGUE_LINEOUT,
@@ -1283,7 +1274,7 @@ static int wm9081_probe(struct snd_soc_codec *codec)
 				     ARRAY_SIZE(wm9081_eq_controls));
 	}
 
-	return ret;
+	return 0;
 }
 
 static int wm9081_remove(struct snd_soc_codec *codec)
diff --git a/sound/soc/codecs/wm9090.c b/sound/soc/codecs/wm9090.c
index a07fe16..8793417 100644
--- a/sound/soc/codecs/wm9090.c
+++ b/sound/soc/codecs/wm9090.c
@@ -522,16 +522,6 @@ static int wm9090_set_bias_level(struct snd_soc_codec *codec,
 
 static int wm9090_probe(struct snd_soc_codec *codec)
 {
-	struct wm9090_priv *wm9090 = dev_get_drvdata(codec->dev);
-	int ret;
-
-	codec->control_data = wm9090->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
-	if (ret != 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
-	}
-
 	/* Configure some defaults; they will be written out when we
 	 * bring the bias up.
 	 */
-- 
1.8.4


