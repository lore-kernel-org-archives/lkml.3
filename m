Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbaB1GNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 01:13:55 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:55390
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751715AbaB1GNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 01:13:52 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch1155h)
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
Subject: [PATCH 2/2] ASoC: io: Remove reduntant params of snd_soc_codec_set_cache_io()
Date: Fri, 28 Feb 2014 13:06:49 +0800
Message-ID: <1393564009-15968-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1393564009-15968-1-git-send-email-Li.Xiubo@freescale.com>
References: <1393564009-15968-1-git-send-email-Li.Xiubo@freescale.com>
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
 include/sound/soc.h       | 1 -
 sound/soc/codecs/wm5110.c | 2 +-
 sound/soc/codecs/wm8997.c | 2 +-
 sound/soc/soc-core.c      | 2 +-
 sound/soc/soc-io.c        | 4 ----
 5 files changed, 3 insertions(+), 8 deletions(-)

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
 
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index c159a34..e7aa681 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1139,7 +1139,7 @@ static int soc_probe_codec(struct snd_soc_card *card,
 
 	/* Set the default I/O up try regmap */
 	if (dev_get_regmap(codec->dev, NULL))
-		snd_soc_codec_set_cache_io(codec, 0, 0, SND_SOC_REGMAP);
+		snd_soc_codec_set_cache_io(codec, SND_SOC_REGMAP);
 
 	if (driver->probe) {
 		ret = driver->probe(codec);
diff --git a/sound/soc/soc-io.c b/sound/soc/soc-io.c
index 18353f1..4b4f3d9 100644
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
@@ -85,7 +83,6 @@ static unsigned int hw_read(struct snd_soc_codec *codec, unsigned int reg)
  * volatile registers.
  */
 int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
-			       int addr_bits, int data_bits,
 			       enum snd_soc_control_type control)
 {
 	int ret;
@@ -118,7 +115,6 @@ int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
 EXPORT_SYMBOL_GPL(snd_soc_codec_set_cache_io);
 #else
 int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
-			       int addr_bits, int data_bits,
 			       enum snd_soc_control_type control)
 {
 	return -ENOTSUPP;
-- 
1.8.4


