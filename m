Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaB0Cpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 21:45:55 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:20977 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752649AbaB0Cpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 21:45:52 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zze0eahd799hzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <vinod.koul@intel.com>, <brian.austin@cirrus.com>,
        <Paul.Handrigan@cirrus.com>, <timur@tabi.org>, <mr.swami.reddy@ti.com>,
        <vishwas.a.deshpande@ti.com>, <fabio.estevam@freescale.com>,
        <kuninori.morimoto.gx@renesas.com>, <sachin.kamat@linaro.org>,
        <Adam.Thomson.Opensource@diasemi.com>, <dgreid@chromium.org>,
        <abrestic@chromium.org>, <swarren@nvidia.com>, <shc_work@mail.ru>,
        <s.trumtrar@pengutronix.de>, <bardliao@realtek.com>,
        <shawn.guo@linaro.org>, <LW@KARO-electronics.de>, <mpa@pengutronix.de>,
        <peter.ujfalusi@ti.com>, <Andreas.Irestal@axis.com>,
        <ckeepax@opensource.wolfsonmicro.com>,
        <rf@opensource.wolfsonmicro.com>, <viresh.kumar@linaro.org>,
        <axel.lin@ingics.com>, <alban.bedel@avionic-design.de>,
        <voice.shen@atmel.com>, <jic23@kernel.org>, <mahaijuns@gmail.com>,
        <mike.dyer@md-soft.co.uk>, <b42378@freescale.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] ASoC: io: Clean up snd_soc_codec_set_cache_io()
Date: Thu, 27 Feb 2014 09:37:45 +0800
Message-ID: <1393465065-9512-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all users have been converted to regmap and the config.reg_bits
and config.val_bits can be setted by each user through regmap core API.
So these two params are redundant here.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---

@Mark and All

I'm also thinking could we just discard snd_soc_codec_set_cache_io()
calling from each individual driver to simply the code? And just bind
it to devm_regmap_init_i2c() and devm_regmap_init_spi()...

Is there any other limitations for snd_soc_codec_set_cache_io() usage?





 include/sound/soc.h              | 1 -
 sound/soc/codecs/ad193x.c        | 2 +-
 sound/soc/codecs/adau1373.c      | 2 +-
 sound/soc/codecs/adav80x.c       | 2 +-
 sound/soc/codecs/ak4535.c        | 2 +-
 sound/soc/codecs/ak4641.c        | 2 +-
 sound/soc/codecs/ak4642.c        | 2 +-
 sound/soc/codecs/ak4671.c        | 2 +-
 sound/soc/codecs/alc5623.c       | 2 +-
 sound/soc/codecs/alc5632.c       | 2 +-
 sound/soc/codecs/cq93vc.c        | 2 +-
 sound/soc/codecs/cs4270.c        | 2 +-
 sound/soc/codecs/cs42l51.c       | 2 +-
 sound/soc/codecs/cs42l52.c       | 2 +-
 sound/soc/codecs/cs42l73.c       | 2 +-
 sound/soc/codecs/da7210.c        | 2 +-
 sound/soc/codecs/da7213.c        | 2 +-
 sound/soc/codecs/da732x.c        | 2 +-
 sound/soc/codecs/da9055.c        | 2 +-
 sound/soc/codecs/isabelle.c      | 2 +-
 sound/soc/codecs/lm49453.c       | 2 +-
 sound/soc/codecs/max9768.c       | 2 +-
 sound/soc/codecs/max98088.c      | 2 +-
 sound/soc/codecs/max98090.c      | 2 +-
 sound/soc/codecs/max98095.c      | 2 +-
 sound/soc/codecs/max9850.c       | 2 +-
 sound/soc/codecs/mc13783.c       | 2 +-
 sound/soc/codecs/ml26124.c       | 2 +-
 sound/soc/codecs/rt5631.c        | 2 +-
 sound/soc/codecs/rt5640.c        | 2 +-
 sound/soc/codecs/sgtl5000.c      | 2 +-
 sound/soc/codecs/sn95031.c       | 2 +-
 sound/soc/codecs/ssm2518.c       | 2 +-
 sound/soc/codecs/ssm2602.c       | 2 +-
 sound/soc/codecs/sta32x.c        | 2 +-
 sound/soc/codecs/sta529.c        | 2 +-
 sound/soc/codecs/tlv320aic23.c   | 2 +-
 sound/soc/codecs/tlv320aic26.c   | 2 +-
 sound/soc/codecs/tlv320aic32x4.c | 2 +-
 sound/soc/codecs/tlv320aic3x.c   | 2 +-
 sound/soc/codecs/wm2000.c        | 2 +-
 sound/soc/codecs/wm2200.c        | 2 +-
 sound/soc/codecs/wm5100.c        | 2 +-
 sound/soc/codecs/wm5102.c        | 2 +-
 sound/soc/codecs/wm5110.c        | 2 +-
 sound/soc/codecs/wm8350.c        | 2 +-
 sound/soc/codecs/wm8400.c        | 2 +-
 sound/soc/codecs/wm8510.c        | 2 +-
 sound/soc/codecs/wm8523.c        | 2 +-
 sound/soc/codecs/wm8580.c        | 2 +-
 sound/soc/codecs/wm8711.c        | 2 +-
 sound/soc/codecs/wm8728.c        | 2 +-
 sound/soc/codecs/wm8731.c        | 2 +-
 sound/soc/codecs/wm8737.c        | 2 +-
 sound/soc/codecs/wm8741.c        | 2 +-
 sound/soc/codecs/wm8750.c        | 2 +-
 sound/soc/codecs/wm8753.c        | 2 +-
 sound/soc/codecs/wm8770.c        | 2 +-
 sound/soc/codecs/wm8776.c        | 2 +-
 sound/soc/codecs/wm8804.c        | 2 +-
 sound/soc/codecs/wm8900.c        | 2 +-
 sound/soc/codecs/wm8903.c        | 2 +-
 sound/soc/codecs/wm8904.c        | 2 +-
 sound/soc/codecs/wm8940.c        | 2 +-
 sound/soc/codecs/wm8955.c        | 2 +-
 sound/soc/codecs/wm8960.c        | 2 +-
 sound/soc/codecs/wm8961.c        | 2 +-
 sound/soc/codecs/wm8962.c        | 2 +-
 sound/soc/codecs/wm8971.c        | 2 +-
 sound/soc/codecs/wm8974.c        | 2 +-
 sound/soc/codecs/wm8978.c        | 2 +-
 sound/soc/codecs/wm8983.c        | 2 +-
 sound/soc/codecs/wm8985.c        | 2 +-
 sound/soc/codecs/wm8988.c        | 2 +-
 sound/soc/codecs/wm8990.c        | 2 +-
 sound/soc/codecs/wm8991.c        | 2 +-
 sound/soc/codecs/wm8993.c        | 2 +-
 sound/soc/codecs/wm8994.c        | 2 +-
 sound/soc/codecs/wm8995.c        | 2 +-
 sound/soc/codecs/wm8996.c        | 2 +-
 sound/soc/codecs/wm8997.c        | 2 +-
 sound/soc/codecs/wm9081.c        | 2 +-
 sound/soc/codecs/wm9090.c        | 2 +-
 sound/soc/soc-core.c             | 2 +-
 sound/soc/soc-io.c               | 9 ---------
 85 files changed, 83 insertions(+), 93 deletions(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index ecfb334..0a1d732 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -404,7 +404,6 @@ int snd_soc_codec_readable_register(struct snd_soc_codec *codec,
 int snd_soc_codec_writable_register(struct snd_soc_codec *codec,
 				    unsigned int reg);
 int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
-			       int addr_bits, int data_bits,
 			       enum snd_soc_control_type control);
 int snd_soc_cache_sync(struct snd_soc_codec *codec);
 int snd_soc_cache_init(struct snd_soc_codec *codec);
diff --git a/sound/soc/codecs/ad193x.c b/sound/soc/codecs/ad193x.c
index 9381a76..052495f 100644
--- a/sound/soc/codecs/ad193x.c
+++ b/sound/soc/codecs/ad193x.c
@@ -325,7 +325,7 @@ static int ad193x_codec_probe(struct snd_soc_codec *codec)
 	int ret;
 
 	codec->control_data = ad193x->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 0, 0, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/adau1373.c b/sound/soc/codecs/adau1373.c
index 5765c22..69b434c 100644
--- a/sound/soc/codecs/adau1373.c
+++ b/sound/soc/codecs/adau1373.c
@@ -1379,7 +1379,7 @@ static int adau1373_probe(struct snd_soc_codec *codec)
 	int ret;
 	int i;
 
-	ret = snd_soc_codec_set_cache_io(codec, 0, 0, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret) {
 		dev_err(codec->dev, "failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/adav80x.c b/sound/soc/codecs/adav80x.c
index 9eb53c8..0066feb 100644
--- a/sound/soc/codecs/adav80x.c
+++ b/sound/soc/codecs/adav80x.c
@@ -804,7 +804,7 @@ static int adav80x_probe(struct snd_soc_codec *codec)
 	int ret;
 	struct adav80x *adav80x = snd_soc_codec_get_drvdata(codec);
 
-	ret = snd_soc_codec_set_cache_io(codec, 0, 0, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret) {
 		dev_err(codec->dev, "failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/ak4535.c b/sound/soc/codecs/ak4535.c
index 684fe91..9d4f878 100644
--- a/sound/soc/codecs/ak4535.c
+++ b/sound/soc/codecs/ak4535.c
@@ -392,7 +392,7 @@ static int ak4535_probe(struct snd_soc_codec *codec)
 	int ret;
 
 	codec->control_data = ak4535->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/ak4641.c b/sound/soc/codecs/ak4641.c
index 684b56f..5d81cbd 100644
--- a/sound/soc/codecs/ak4641.c
+++ b/sound/soc/codecs/ak4641.c
@@ -521,7 +521,7 @@ static int ak4641_probe(struct snd_soc_codec *codec)
 {
 	int ret;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/ak4642.c b/sound/soc/codecs/ak4642.c
index 1f646c6..7e7621a 100644
--- a/sound/soc/codecs/ak4642.c
+++ b/sound/soc/codecs/ak4642.c
@@ -467,7 +467,7 @@ static int ak4642_probe(struct snd_soc_codec *codec)
 {
 	int ret;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/ak4671.c b/sound/soc/codecs/ak4671.c
index deb2b44..46fd465 100644
--- a/sound/soc/codecs/ak4671.c
+++ b/sound/soc/codecs/ak4671.c
@@ -615,7 +615,7 @@ static int ak4671_probe(struct snd_soc_codec *codec)
 {
 	int ret;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/alc5623.c b/sound/soc/codecs/alc5623.c
index ed50625..030dcda 100644
--- a/sound/soc/codecs/alc5623.c
+++ b/sound/soc/codecs/alc5623.c
@@ -905,7 +905,7 @@ static int alc5623_probe(struct snd_soc_codec *codec)
 	int ret;
 
 	codec->control_data = alc5623->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/alc5632.c b/sound/soc/codecs/alc5632.c
index d885056..2cd5d27 100644
--- a/sound/soc/codecs/alc5632.c
+++ b/sound/soc/codecs/alc5632.c
@@ -1065,7 +1065,7 @@ static int alc5632_probe(struct snd_soc_codec *codec)
 
 	codec->control_data = alc5632->regmap;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/cq93vc.c b/sound/soc/codecs/cq93vc.c
index 43737a27..d4f8714 100644
--- a/sound/soc/codecs/cq93vc.c
+++ b/sound/soc/codecs/cq93vc.c
@@ -140,7 +140,7 @@ static int cq93vc_probe(struct snd_soc_codec *codec)
 	davinci_vc->cq93vc.codec = codec;
 	codec->control_data = davinci_vc->regmap;
 
-	snd_soc_codec_set_cache_io(codec, 32, 32, SND_SOC_REGMAP);
+	snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 
 	/* Off, with power on */
 	cq93vc_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
diff --git a/sound/soc/codecs/cs4270.c b/sound/soc/codecs/cs4270.c
index 83c835d..988a00a 100644
--- a/sound/soc/codecs/cs4270.c
+++ b/sound/soc/codecs/cs4270.c
@@ -509,7 +509,7 @@ static int cs4270_probe(struct snd_soc_codec *codec)
 	/* Tell ASoC what kind of I/O to use to read the registers.  ASoC will
 	 * then do the I2C transactions itself.
 	 */
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "failed to set cache I/O (ret=%i)\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/cs42l51.c b/sound/soc/codecs/cs42l51.c
index 5caf75b..42564fb 100644
--- a/sound/soc/codecs/cs42l51.c
+++ b/sound/soc/codecs/cs42l51.c
@@ -488,7 +488,7 @@ static int cs42l51_probe(struct snd_soc_codec *codec)
 {
 	int ret, reg;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c
index be455ea..d7a5967 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -1112,7 +1112,7 @@ static int cs42l52_probe(struct snd_soc_codec *codec)
 	int ret;
 
 	codec->control_data = cs42l52->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/cs42l73.c b/sound/soc/codecs/cs42l73.c
index 06f4291..efa3b20 100644
--- a/sound/soc/codecs/cs42l73.c
+++ b/sound/soc/codecs/cs42l73.c
@@ -1350,7 +1350,7 @@ static int cs42l73_probe(struct snd_soc_codec *codec)
 
 	codec->control_data = cs42l73->regmap;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/da7210.c b/sound/soc/codecs/da7210.c
index 01e55fc..3cfbab6 100644
--- a/sound/soc/codecs/da7210.c
+++ b/sound/soc/codecs/da7210.c
@@ -1076,7 +1076,7 @@ static int da7210_probe(struct snd_soc_codec *codec)
 	dev_info(codec->dev, "DA7210 Audio Codec %s\n", DA7210_VERSION);
 
 	codec->control_data = da7210->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/da7213.c b/sound/soc/codecs/da7213.c
index 439d103..bf6b840 100644
--- a/sound/soc/codecs/da7213.c
+++ b/sound/soc/codecs/da7213.c
@@ -1398,7 +1398,7 @@ static int da7213_probe(struct snd_soc_codec *codec)
 	struct da7213_platform_data *pdata = da7213->pdata;
 
 	codec->control_data = da7213->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/da732x.c b/sound/soc/codecs/da732x.c
index 05f07fb..f32f219 100644
--- a/sound/soc/codecs/da732x.c
+++ b/sound/soc/codecs/da732x.c
@@ -1508,7 +1508,7 @@ static int da732x_probe(struct snd_soc_codec *codec)
 
 	codec->control_data = da732x->regmap;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to register codec.\n");
 		goto err;
diff --git a/sound/soc/codecs/da9055.c b/sound/soc/codecs/da9055.c
index f118daa..187d8ce 100644
--- a/sound/soc/codecs/da9055.c
+++ b/sound/soc/codecs/da9055.c
@@ -1387,7 +1387,7 @@ static int da9055_probe(struct snd_soc_codec *codec)
 	struct da9055_priv *da9055 = snd_soc_codec_get_drvdata(codec);
 
 	codec->control_data = da9055->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/isabelle.c b/sound/soc/codecs/isabelle.c
index cb736dd..54ea3cf 100644
--- a/sound/soc/codecs/isabelle.c
+++ b/sound/soc/codecs/isabelle.c
@@ -1096,7 +1096,7 @@ static int isabelle_probe(struct snd_soc_codec *codec)
 
 	codec->control_data = dev_get_regmap(codec->dev, NULL);
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/lm49453.c b/sound/soc/codecs/lm49453.c
index e533594..8061103 100644
--- a/sound/soc/codecs/lm49453.c
+++ b/sound/soc/codecs/lm49453.c
@@ -1414,7 +1414,7 @@ static int lm49453_probe(struct snd_soc_codec *codec)
 
 	codec->control_data = lm49453->regmap;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/max9768.c b/sound/soc/codecs/max9768.c
index 31f9156..896ae28 100644
--- a/sound/soc/codecs/max9768.c
+++ b/sound/soc/codecs/max9768.c
@@ -136,7 +136,7 @@ static int max9768_probe(struct snd_soc_codec *codec)
 	int ret;
 
 	codec->control_data = max9768->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 2, 6, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret)
 		return ret;
 
diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
index 4b9274d..5355e1a 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -1914,7 +1914,7 @@ static int max98088_probe(struct snd_soc_codec *codec)
 
        regcache_mark_dirty(max98088->regmap);
 
-       ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
+       ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
        if (ret != 0) {
                dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
                return ret;
diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index a75752f..d01ac5d 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -2220,7 +2220,7 @@ static int max98090_probe(struct snd_soc_codec *codec)
 
 	codec->control_data = max98090->regmap;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/max98095.c b/sound/soc/codecs/max98095.c
index 4c22582..02666ce 100644
--- a/sound/soc/codecs/max98095.c
+++ b/sound/soc/codecs/max98095.c
@@ -2238,7 +2238,7 @@ static int max98095_probe(struct snd_soc_codec *codec)
 	struct i2c_client *client;
 	int ret = 0;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/max9850.c b/sound/soc/codecs/max9850.c
index 82757eb..b7951b3 100644
--- a/sound/soc/codecs/max9850.c
+++ b/sound/soc/codecs/max9850.c
@@ -314,7 +314,7 @@ static int max9850_probe(struct snd_soc_codec *codec)
 {
 	int ret;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/mc13783.c b/sound/soc/codecs/mc13783.c
index c605036..16725e9 100644
--- a/sound/soc/codecs/mc13783.c
+++ b/sound/soc/codecs/mc13783.c
@@ -615,7 +615,7 @@ static int mc13783_probe(struct snd_soc_codec *codec)
 	int ret;
 
 	codec->control_data = dev_get_regmap(codec->dev->parent, NULL);
-	ret = snd_soc_codec_set_cache_io(codec, 8, 24, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/ml26124.c b/sound/soc/codecs/ml26124.c
index 577fb87..3202eee 100644
--- a/sound/soc/codecs/ml26124.c
+++ b/sound/soc/codecs/ml26124.c
@@ -590,7 +590,7 @@ static int ml26124_probe(struct snd_soc_codec *codec)
 	struct ml26124_priv *priv = snd_soc_codec_get_drvdata(codec);
 	codec->control_data = priv->regmap;
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/rt5631.c b/sound/soc/codecs/rt5631.c
index ce199d3..3287fe7 100644
--- a/sound/soc/codecs/rt5631.c
+++ b/sound/soc/codecs/rt5631.c
@@ -1574,7 +1574,7 @@ static int rt5631_probe(struct snd_soc_codec *codec)
 
 	codec->control_data = rt5631->regmap;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/rt5640.c b/sound/soc/codecs/rt5640.c
index 1a1e115..26b9988 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -1941,7 +1941,7 @@ static int rt5640_probe(struct snd_soc_codec *codec)
 	rt5640->codec = codec;
 	codec->control_data = rt5640->regmap;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index ab4754a..8758c3b 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -1354,7 +1354,7 @@ static int sgtl5000_probe(struct snd_soc_codec *codec)
 
 	/* setup i2c data ops */
 	codec->control_data = sgtl5000->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 16, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/sn95031.c b/sound/soc/codecs/sn95031.c
index bca7d02..671c45b 100644
--- a/sound/soc/codecs/sn95031.c
+++ b/sound/soc/codecs/sn95031.c
@@ -825,7 +825,7 @@ static int sn95031_codec_probe(struct snd_soc_codec *codec)
 {
 	pr_debug("codec_probe called\n");
 
-	snd_soc_codec_set_cache_io(codec, 0, 0, SND_SOC_REGMAP);
+	snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 
 	/* PCM interface config
 	 * This sets the pcm rx slot conguration to max 6 slots
diff --git a/sound/soc/codecs/ssm2518.c b/sound/soc/codecs/ssm2518.c
index 806f3d8..ce4f890 100644
--- a/sound/soc/codecs/ssm2518.c
+++ b/sound/soc/codecs/ssm2518.c
@@ -652,7 +652,7 @@ static int ssm2518_probe(struct snd_soc_codec *codec)
 	int ret;
 
 	codec->control_data = ssm2518->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 0, 0, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/ssm2602.c b/sound/soc/codecs/ssm2602.c
index 1294709..912fa5d 100644
--- a/sound/soc/codecs/ssm2602.c
+++ b/sound/soc/codecs/ssm2602.c
@@ -563,7 +563,7 @@ static int ssm260x_codec_probe(struct snd_soc_codec *codec)
 	int ret;
 
 	codec->control_data = ssm2602->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 0, 0, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/sta32x.c b/sound/soc/codecs/sta32x.c
index ea78c17..93e67c8 100644
--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -876,7 +876,7 @@ static int sta32x_probe(struct snd_soc_codec *codec)
 	 * then do the I2C transactions itself.
 	 */
 	codec->control_data = sta32x->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "failed to set cache I/O (ret=%i)\n", ret);
 		goto err;
diff --git a/sound/soc/codecs/sta529.c b/sound/soc/codecs/sta529.c
index f15b0e3..9530e079 100644
--- a/sound/soc/codecs/sta529.c
+++ b/sound/soc/codecs/sta529.c
@@ -326,7 +326,7 @@ static int sta529_probe(struct snd_soc_codec *codec)
 	int ret;
 
 	codec->control_data = sta529->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
diff --git a/sound/soc/codecs/tlv320aic23.c b/sound/soc/codecs/tlv320aic23.c
index 139f11f..70cb324 100644
--- a/sound/soc/codecs/tlv320aic23.c
+++ b/sound/soc/codecs/tlv320aic23.c
@@ -561,7 +561,7 @@ static int tlv320aic23_probe(struct snd_soc_codec *codec)
 {
 	int ret;
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/tlv320aic26.c b/sound/soc/codecs/tlv320aic26.c
index ff5f23d..41186ef 100644
--- a/sound/soc/codecs/tlv320aic26.c
+++ b/sound/soc/codecs/tlv320aic26.c
@@ -296,7 +296,7 @@ static int aic26_probe(struct snd_soc_codec *codec)
 	struct aic26 *aic26 = dev_get_drvdata(codec->dev);
 	int ret, reg;
 
-	snd_soc_codec_set_cache_io(codec, 16, 16, SND_SOC_REGMAP);
+	snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 
 	aic26->codec = codec;
 
diff --git a/sound/soc/codecs/tlv320aic32x4.c b/sound/soc/codecs/tlv320aic32x4.c
index c6bd7e7..d79a9ec 100644
--- a/sound/soc/codecs/tlv320aic32x4.c
+++ b/sound/soc/codecs/tlv320aic32x4.c
@@ -614,7 +614,7 @@ static int aic32x4_probe(struct snd_soc_codec *codec)
 	struct aic32x4_priv *aic32x4 = snd_soc_codec_get_drvdata(codec);
 	u32 tmp_reg;
 
-	snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
+	snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 
 	if (gpio_is_valid(aic32x4->rstn_gpio)) {
 		ndelay(10);
diff --git a/sound/soc/codecs/tlv320aic3x.c b/sound/soc/codecs/tlv320aic3x.c
index 470fbfb..598625b 100644
--- a/sound/soc/codecs/tlv320aic3x.c
+++ b/sound/soc/codecs/tlv320aic3x.c
@@ -1344,7 +1344,7 @@ static int aic3x_probe(struct snd_soc_codec *codec)
 	INIT_LIST_HEAD(&aic3x->list);
 	aic3x->codec = codec;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm2000.c b/sound/soc/codecs/wm2000.c
index 8ae5027..a8dde7b 100644
--- a/sound/soc/codecs/wm2000.c
+++ b/sound/soc/codecs/wm2000.c
@@ -786,7 +786,7 @@ static int wm2000_probe(struct snd_soc_codec *codec)
 {
 	struct wm2000_priv *wm2000 = dev_get_drvdata(codec->dev);
 
-	snd_soc_codec_set_cache_io(codec, 16, 8, SND_SOC_REGMAP);
+	snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 
 	/* This will trigger a transition to standby mode by default */
 	wm2000_anc_set_mode(wm2000);
diff --git a/sound/soc/codecs/wm2200.c b/sound/soc/codecs/wm2200.c
index 1e0a083..58b9fb0 100644
--- a/sound/soc/codecs/wm2200.c
+++ b/sound/soc/codecs/wm2200.c
@@ -1557,7 +1557,7 @@ static int wm2200_probe(struct snd_soc_codec *codec)
 	codec->control_data = wm2200->regmap;
 	codec->dapm.bias_level = SND_SOC_BIAS_OFF;
 
-	ret = snd_soc_codec_set_cache_io(codec, 16, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm5100.c b/sound/soc/codecs/wm5100.c
index d3fa65f..5874238 100644
--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -2345,7 +2345,7 @@ static int wm5100_probe(struct snd_soc_codec *codec)
 	wm5100->codec = codec;
 	codec->control_data = wm5100->regmap;
 
-	ret = snd_soc_codec_set_cache_io(codec, 16, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm5102.c b/sound/soc/codecs/wm5102.c
index 293dffc..50593bb 100644
--- a/sound/soc/codecs/wm5102.c
+++ b/sound/soc/codecs/wm5102.c
@@ -1762,7 +1762,7 @@ static int wm5102_codec_probe(struct snd_soc_codec *codec)
 
 	codec->control_data = priv->core.arizona->regmap;
 
-	ret = snd_soc_codec_set_cache_io(codec, 32, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0)
 		return ret;
 
diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index 4de2bf1..9cb4257 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -1590,7 +1590,7 @@ static int wm5110_codec_probe(struct snd_soc_codec *codec)
 	codec->control_data = priv->core.arizona->regmap;
 	priv->core.arizona->dapm = &codec->dapm;
 
-	ret = snd_soc_codec_set_cache_io(codec, 32, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0)
 		return ret;
 
diff --git a/sound/soc/codecs/wm8350.c b/sound/soc/codecs/wm8350.c
index a183dcf..35c30a9 100644
--- a/sound/soc/codecs/wm8350.c
+++ b/sound/soc/codecs/wm8350.c
@@ -1507,7 +1507,7 @@ static  int wm8350_codec_probe(struct snd_soc_codec *codec)
 
 	codec->control_data = wm8350->regmap;
 
-	snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
+	snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 
 	/* Put the codec into reset if it wasn't already */
 	wm8350_clear_bits(wm8350, WM8350_POWER_MGMT_5, WM8350_CODEC_ENA);
diff --git a/sound/soc/codecs/wm8400.c b/sound/soc/codecs/wm8400.c
index 6d684d9..10b1172 100644
--- a/sound/soc/codecs/wm8400.c
+++ b/sound/soc/codecs/wm8400.c
@@ -1319,7 +1319,7 @@ static int wm8400_codec_probe(struct snd_soc_codec *codec)
 	codec->control_data = wm8400->regmap;
 	priv->codec = codec;
 
-	snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
+	snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 
 	ret = devm_regulator_bulk_get(wm8400->dev,
 				 ARRAY_SIZE(power), &power[0]);
diff --git a/sound/soc/codecs/wm8510.c b/sound/soc/codecs/wm8510.c
index 7df7d45..e531b9d 100644
--- a/sound/soc/codecs/wm8510.c
+++ b/sound/soc/codecs/wm8510.c
@@ -591,7 +591,7 @@ static int wm8510_probe(struct snd_soc_codec *codec)
 {
 	int ret;
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		printk(KERN_ERR "wm8510: failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8523.c b/sound/soc/codecs/wm8523.c
index 5dfd571..f5c17a0 100644
--- a/sound/soc/codecs/wm8523.c
+++ b/sound/soc/codecs/wm8523.c
@@ -398,7 +398,7 @@ static int wm8523_probe(struct snd_soc_codec *codec)
 	wm8523->rate_constraint.count =
 		ARRAY_SIZE(wm8523->rate_constraint_list);
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8580.c b/sound/soc/codecs/wm8580.c
index 318989a..249961b 100644
--- a/sound/soc/codecs/wm8580.c
+++ b/sound/soc/codecs/wm8580.c
@@ -869,7 +869,7 @@ static int wm8580_probe(struct snd_soc_codec *codec)
 	struct wm8580_priv *wm8580 = snd_soc_codec_get_drvdata(codec);
 	int ret = 0;
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8711.c b/sound/soc/codecs/wm8711.c
index d99f948..3673b90 100644
--- a/sound/soc/codecs/wm8711.c
+++ b/sound/soc/codecs/wm8711.c
@@ -367,7 +367,7 @@ static int wm8711_probe(struct snd_soc_codec *codec)
 {
 	int ret;
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8728.c b/sound/soc/codecs/wm8728.c
index cd89033..c2d2835 100644
--- a/sound/soc/codecs/wm8728.c
+++ b/sound/soc/codecs/wm8728.c
@@ -230,7 +230,7 @@ static int wm8728_probe(struct snd_soc_codec *codec)
 {
 	int ret;
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		printk(KERN_ERR "wm8728: failed to configure cache I/O: %d\n",
 		       ret);
diff --git a/sound/soc/codecs/wm8731.c b/sound/soc/codecs/wm8731.c
index d9655f9..3f877d2 100644
--- a/sound/soc/codecs/wm8731.c
+++ b/sound/soc/codecs/wm8731.c
@@ -584,7 +584,7 @@ static int wm8731_probe(struct snd_soc_codec *codec)
 	int ret = 0, i;
 
 	codec->control_data = wm8731->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8737.c b/sound/soc/codecs/wm8737.c
index ecc4e87..8f14ed8 100644
--- a/sound/soc/codecs/wm8737.c
+++ b/sound/soc/codecs/wm8737.c
@@ -570,7 +570,7 @@ static int wm8737_probe(struct snd_soc_codec *codec)
 	struct wm8737_priv *wm8737 = snd_soc_codec_get_drvdata(codec);
 	int ret;
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8741.c b/sound/soc/codecs/wm8741.c
index dd02ebf..6a40489 100644
--- a/sound/soc/codecs/wm8741.c
+++ b/sound/soc/codecs/wm8741.c
@@ -429,7 +429,7 @@ static int wm8741_probe(struct snd_soc_codec *codec)
 		goto err_get;
 	}
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		goto err_enable;
diff --git a/sound/soc/codecs/wm8750.c b/sound/soc/codecs/wm8750.c
index 78616a6..886d618 100644
--- a/sound/soc/codecs/wm8750.c
+++ b/sound/soc/codecs/wm8750.c
@@ -702,7 +702,7 @@ static int wm8750_probe(struct snd_soc_codec *codec)
 {
 	int ret;
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		printk(KERN_ERR "wm8750: failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8753.c b/sound/soc/codecs/wm8753.c
index be85da9..f5e4d1a 100644
--- a/sound/soc/codecs/wm8753.c
+++ b/sound/soc/codecs/wm8753.c
@@ -1472,7 +1472,7 @@ static int wm8753_probe(struct snd_soc_codec *codec)
 	INIT_DELAYED_WORK(&codec->dapm.delayed_work, wm8753_work);
 
 	codec->control_data = wm8753->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8770.c b/sound/soc/codecs/wm8770.c
index 5bce210..ff2e087 100644
--- a/sound/soc/codecs/wm8770.c
+++ b/sound/soc/codecs/wm8770.c
@@ -580,7 +580,7 @@ static int wm8770_probe(struct snd_soc_codec *codec)
 	wm8770 = snd_soc_codec_get_drvdata(codec);
 	wm8770->codec = codec;
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8776.c b/sound/soc/codecs/wm8776.c
index ef82467..70276d7 100644
--- a/sound/soc/codecs/wm8776.c
+++ b/sound/soc/codecs/wm8776.c
@@ -430,7 +430,7 @@ static int wm8776_probe(struct snd_soc_codec *codec)
 {
 	int ret = 0;
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8804.c b/sound/soc/codecs/wm8804.c
index 72d12bb..ae7f031 100644
--- a/sound/soc/codecs/wm8804.c
+++ b/sound/soc/codecs/wm8804.c
@@ -548,7 +548,7 @@ static int wm8804_probe(struct snd_soc_codec *codec)
 
 	codec->control_data = wm8804->regmap;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache i/o: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8900.c b/sound/soc/codecs/wm8900.c
index 43c2201..651908f 100644
--- a/sound/soc/codecs/wm8900.c
+++ b/sound/soc/codecs/wm8900.c
@@ -1180,7 +1180,7 @@ static int wm8900_probe(struct snd_soc_codec *codec)
 {
 	int ret = 0, reg;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8903.c b/sound/soc/codecs/wm8903.c
index b82b70a..0a92e99 100644
--- a/sound/soc/codecs/wm8903.c
+++ b/sound/soc/codecs/wm8903.c
@@ -1902,7 +1902,7 @@ static int wm8903_probe(struct snd_soc_codec *codec)
 	wm8903->codec = codec;
 	codec->control_data = wm8903->regmap;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8904.c b/sound/soc/codecs/wm8904.c
index 27299cd..f524481 100644
--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -2064,7 +2064,7 @@ static int wm8904_probe(struct snd_soc_codec *codec)
 		return -EINVAL;
 	}
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8940.c b/sound/soc/codecs/wm8940.c
index 87f032d..f53033b 100644
--- a/sound/soc/codecs/wm8940.c
+++ b/sound/soc/codecs/wm8940.c
@@ -712,7 +712,7 @@ static int wm8940_probe(struct snd_soc_codec *codec)
 	int ret;
 	u16 reg;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8955.c b/sound/soc/codecs/wm8955.c
index d4dcaec..5762e3c 100644
--- a/sound/soc/codecs/wm8955.c
+++ b/sound/soc/codecs/wm8955.c
@@ -897,7 +897,7 @@ static int wm8955_probe(struct snd_soc_codec *codec)
 
 	codec->control_data = wm8955->regmap;
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index f156010..1b90049 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -976,7 +976,7 @@ static int wm8960_probe(struct snd_soc_codec *codec)
 			wm8960->set_bias_level = wm8960_set_bias_level_capless;
 	}
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8961.c b/sound/soc/codecs/wm8961.c
index ce8fa6e..f18950c 100644
--- a/sound/soc/codecs/wm8961.c
+++ b/sound/soc/codecs/wm8961.c
@@ -839,7 +839,7 @@ static int wm8961_probe(struct snd_soc_codec *codec)
 	int ret = 0;
 	u16 reg;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index 62af9dc..4199e0e 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -3426,7 +3426,7 @@ static int wm8962_probe(struct snd_soc_codec *codec)
 	wm8962->codec = codec;
 	codec->control_data = wm8962->regmap;
 
-	ret = snd_soc_codec_set_cache_io(codec, 16, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8971.c b/sound/soc/codecs/wm8971.c
index 67aba78..7dfee38 100644
--- a/sound/soc/codecs/wm8971.c
+++ b/sound/soc/codecs/wm8971.c
@@ -648,7 +648,7 @@ static int wm8971_probe(struct snd_soc_codec *codec)
 	int ret = 0;
 	u16 reg;
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		printk(KERN_ERR "wm8971: failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8974.c b/sound/soc/codecs/wm8974.c
index 6e16c43..3aa5821 100644
--- a/sound/soc/codecs/wm8974.c
+++ b/sound/soc/codecs/wm8974.c
@@ -593,7 +593,7 @@ static int wm8974_probe(struct snd_soc_codec *codec)
 {
 	int ret = 0;
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8978.c b/sound/soc/codecs/wm8978.c
index a9e2f46..4564695 100644
--- a/sound/soc/codecs/wm8978.c
+++ b/sound/soc/codecs/wm8978.c
@@ -983,7 +983,7 @@ static int wm8978_probe(struct snd_soc_codec *codec)
 	 */
 	wm8978->sysclk = WM8978_PLL;
 	codec->control_data = wm8978->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8983.c b/sound/soc/codecs/wm8983.c
index 58f0551..ff0f005 100644
--- a/sound/soc/codecs/wm8983.c
+++ b/sound/soc/codecs/wm8983.c
@@ -995,7 +995,7 @@ static int wm8983_probe(struct snd_soc_codec *codec)
 	int ret;
 	int i;
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache i/o: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8985.c b/sound/soc/codecs/wm8985.c
index d786f2b..677253c 100644
--- a/sound/soc/codecs/wm8985.c
+++ b/sound/soc/codecs/wm8985.c
@@ -997,7 +997,7 @@ static int wm8985_probe(struct snd_soc_codec *codec)
 	wm8985 = snd_soc_codec_get_drvdata(codec);
 	codec->control_data = wm8985->regmap;
 
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache i/o: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8988.c b/sound/soc/codecs/wm8988.c
index 0277a76..88fec3c 100644
--- a/sound/soc/codecs/wm8988.c
+++ b/sound/soc/codecs/wm8988.c
@@ -814,7 +814,7 @@ static int wm8988_probe(struct snd_soc_codec *codec)
 	int ret = 0;
 
 	codec->control_data = wm8988->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 7, 9, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8990.c b/sound/soc/codecs/wm8990.c
index 33f53ab..8acfa9a 100644
--- a/sound/soc/codecs/wm8990.c
+++ b/sound/soc/codecs/wm8990.c
@@ -1291,7 +1291,7 @@ static int wm8990_probe(struct snd_soc_codec *codec)
 {
 	int ret;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		printk(KERN_ERR "wm8990: failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8991.c b/sound/soc/codecs/wm8991.c
index 32d2195..d288976 100644
--- a/sound/soc/codecs/wm8991.c
+++ b/sound/soc/codecs/wm8991.c
@@ -1250,7 +1250,7 @@ static int wm8991_probe(struct snd_soc_codec *codec)
 {
 	int ret;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache i/o: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8993.c b/sound/soc/codecs/wm8993.c
index 7b0630a..abc78d2 100644
--- a/sound/soc/codecs/wm8993.c
+++ b/sound/soc/codecs/wm8993.c
@@ -1494,7 +1494,7 @@ static int wm8993_probe(struct snd_soc_codec *codec)
 	wm8993->hubs_data.series_startup = 1;
 
 	codec->control_data = wm8993->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 699b527..cef8fdc 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -4001,7 +4001,7 @@ static int wm8994_codec_probe(struct snd_soc_codec *codec)
 	wm8994->hubs.codec = codec;
 	codec->control_data = control->regmap;
 
-	snd_soc_codec_set_cache_io(codec, 16, 16, SND_SOC_REGMAP);
+	snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 
 	mutex_init(&wm8994->accdet_lock);
 	INIT_DELAYED_WORK(&wm8994->jackdet_bootstrap,
diff --git a/sound/soc/codecs/wm8995.c b/sound/soc/codecs/wm8995.c
index 33ff361..f50b937 100644
--- a/sound/soc/codecs/wm8995.c
+++ b/sound/soc/codecs/wm8995.c
@@ -2043,7 +2043,7 @@ static int wm8995_probe(struct snd_soc_codec *codec)
 	wm8995->codec = codec;
 
 	codec->control_data = wm8995->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 16, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache i/o: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm8996.c b/sound/soc/codecs/wm8996.c
index c8244af..14f27f25 100644
--- a/sound/soc/codecs/wm8996.c
+++ b/sound/soc/codecs/wm8996.c
@@ -2635,7 +2635,7 @@ static int wm8996_probe(struct snd_soc_codec *codec)
 
 	codec->control_data = wm8996->regmap;
 
-	ret = snd_soc_codec_set_cache_io(codec, 16, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		goto err;
diff --git a/sound/soc/codecs/wm8997.c b/sound/soc/codecs/wm8997.c
index 4e6442c..4a36d1a 100644
--- a/sound/soc/codecs/wm8997.c
+++ b/sound/soc/codecs/wm8997.c
@@ -1055,7 +1055,7 @@ static int wm8997_codec_probe(struct snd_soc_codec *codec)
 
 	codec->control_data = priv->core.arizona->regmap;
 
-	ret = snd_soc_codec_set_cache_io(codec, 32, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0)
 		return ret;
 
diff --git a/sound/soc/codecs/wm9081.c b/sound/soc/codecs/wm9081.c
index 721cee7..d4b8a0c 100644
--- a/sound/soc/codecs/wm9081.c
+++ b/sound/soc/codecs/wm9081.c
@@ -1264,7 +1264,7 @@ static int wm9081_probe(struct snd_soc_codec *codec)
 
 	codec->control_data = wm9081->regmap;
 
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/wm9090.c b/sound/soc/codecs/wm9090.c
index a07fe16..19285b0 100644
--- a/sound/soc/codecs/wm9090.c
+++ b/sound/soc/codecs/wm9090.c
@@ -526,7 +526,7 @@ static int wm9090_probe(struct snd_soc_codec *codec)
 	int ret;
 
 	codec->control_data = wm9090->regmap;
-	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index e5a535b..86c5733 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1152,7 +1152,7 @@ static int soc_probe_codec(struct snd_soc_card *card,
 
 	/* If the driver didn't set I/O up try regmap */
 	if (!codec->write && dev_get_regmap(codec->dev, NULL))
-		snd_soc_codec_set_cache_io(codec, 0, 0, SND_SOC_REGMAP);
+		snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 
 	if (driver->controls)
 		snd_soc_add_codec_controls(codec, driver->controls,
diff --git a/sound/soc/soc-io.c b/sound/soc/soc-io.c
index add99e2..4b4f3d9 100644
--- a/sound/soc/soc-io.c
+++ b/sound/soc/soc-io.c
@@ -69,8 +69,6 @@ static unsigned int hw_read(struct snd_soc_codec *codec, unsigned int reg)
  * snd_soc_codec_set_cache_io: Set up standard I/O functions.
  *
  * @codec: CODEC to configure.
- * @addr_bits: Number of bits of register address data.
- * @data_bits: Number of bits of data per register.
  * @control: Control bus used.
  *
  * Register formats are frequently shared between many I2C and SPI
@@ -85,19 +83,13 @@ static unsigned int hw_read(struct snd_soc_codec *codec, unsigned int reg)
  * volatile registers.
  */
 int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
-			       int addr_bits, int data_bits,
 			       enum snd_soc_control_type control)
 {
-	struct regmap_config config;
 	int ret;
 
-	memset(&config, 0, sizeof(config));
 	codec->write = hw_write;
 	codec->read = hw_read;
 
-	config.reg_bits = addr_bits;
-	config.val_bits = data_bits;
-
 	switch (control) {
 	case SND_SOC_REGMAP:
 		/* Device has made its own regmap arrangements */
@@ -123,7 +115,6 @@ int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
 EXPORT_SYMBOL_GPL(snd_soc_codec_set_cache_io);
 #else
 int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
-			       int addr_bits, int data_bits,
 			       enum snd_soc_control_type control)
 {
 	return -ENOTSUPP;
-- 
1.8.4


