Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476AbaGODrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:47:19 -0400
Received: from [207.46.163.240] ([207.46.163.240]:54149 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757485AbaGODrB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:47:01 -0400
From: "shengjiu.wang@freescale.com" <shengjiu.wang@freescale.com>
To: "brian.austin@cirrus.com" <brian.austin@cirrus.com>,
        "Paul.Handrigan@cirrus.com" <Paul.Handrigan@cirrus.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [alsa-devel] [PATCH] ASoC: cs42xx8: Add SND_SOC_DAIFMT_DSP_A
 support
Thread-Topic: [alsa-devel] [PATCH] ASoC: cs42xx8: Add SND_SOC_DAIFMT_DSP_A
 support
Thread-Index: AQHPn1MV25eVw/h/Y0aOsDsvw9pmKJugfFQQ
Date: Tue, 15 Jul 2014 03:46:48 +0000
Message-ID: <415792f55c1340179171516ba0c25242@BY2PR03MB332.namprd03.prod.outlook.com>
References: <1405334371-4248-1-git-send-email-shengjiu.wang@freescale.com>
In-Reply-To: <1405334371-4248-1-git-send-email-shengjiu.wang@freescale.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 027367F73D
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(13464003)(189002)(53754006)(377454003)(199002)(105586002)(76176999)(81542001)(80022001)(95666004)(101416001)(19580405001)(106356001)(66066001)(19580395003)(87936001)(74662001)(83322001)(4396001)(15975445006)(21056001)(107046002)(74502001)(77982001)(31966008)(64706001)(85852003)(106116001)(81342001)(46102001)(15202345003)(76576001)(83072002)(92566001)(20776003)(50986999)(74316001)(2201001)(2656002)(54356999)(85306003)(575784001)(86362001)(99396002)(76482001)(99286002)(33646002)(79102001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB330;H:BY2PR03MB332.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

    Sorry, add more maintainers.

Best regards
Wang shengjiu

-----Original Message-----
From: alsa-devel-bounces@alsa-project.org [mailto:alsa-devel-bounces@alsa-project.org] On Behalf Of Shengjiu Wang
Sent: Monday, July 14, 2014 6:40 PM
To: broonie@linaro.org
Cc: alsa-devel@alsa-project.org
Subject: [alsa-devel] [PATCH] ASoC: cs42xx8: Add SND_SOC_DAIFMT_DSP_A support

According to the spec, the definition of TDM and ONELINE_24 for CS42XX8_INTF_DAC and CS42XX8_INTF_ADC is wrong. correct them and enable SND_SOC_DAIFMT_DSP_A support.

Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
---
 sound/soc/codecs/cs42xx8.c | 3 +++
 sound/soc/codecs/cs42xx8.h | 8 ++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/cs42xx8.c b/sound/soc/codecs/cs42xx8.c index ec53ffc..02b1520 100644
--- a/sound/soc/codecs/cs42xx8.c
+++ b/sound/soc/codecs/cs42xx8.c
@@ -219,6 +219,9 @@ static int cs42xx8_set_dai_fmt(struct snd_soc_dai *codec_dai,
 	case SND_SOC_DAIFMT_RIGHT_J:
 		val = CS42XX8_INTF_DAC_DIF_RIGHTJ | CS42XX8_INTF_ADC_DIF_RIGHTJ;
 		break;
+	case SND_SOC_DAIFMT_DSP_A:
+		val = CS42XX8_INTF_DAC_DIF_TDM | CS42XX8_INTF_ADC_DIF_TDM;
+		break;
 	default:
 		dev_err(codec->dev, "unsupported dai format\n");
 		return -EINVAL;
diff --git a/sound/soc/codecs/cs42xx8.h b/sound/soc/codecs/cs42xx8.h index da0b94a..b2c10e5 100644
--- a/sound/soc/codecs/cs42xx8.h
+++ b/sound/soc/codecs/cs42xx8.h
@@ -128,8 +128,8 @@ int cs42xx8_probe(struct device *dev, struct regmap *regmap);
 #define CS42XX8_INTF_DAC_DIF_RIGHTJ		(2 << CS42XX8_INTF_DAC_DIF_SHIFT)
 #define CS42XX8_INTF_DAC_DIF_RIGHTJ_16		(3 << CS42XX8_INTF_DAC_DIF_SHIFT)
 #define CS42XX8_INTF_DAC_DIF_ONELINE_20		(4 << CS42XX8_INTF_DAC_DIF_SHIFT)
-#define CS42XX8_INTF_DAC_DIF_ONELINE_24		(6 << CS42XX8_INTF_DAC_DIF_SHIFT)
-#define CS42XX8_INTF_DAC_DIF_TDM		(7 << CS42XX8_INTF_DAC_DIF_SHIFT)
+#define CS42XX8_INTF_DAC_DIF_ONELINE_24		(5 << CS42XX8_INTF_DAC_DIF_SHIFT)
+#define CS42XX8_INTF_DAC_DIF_TDM		(6 << CS42XX8_INTF_DAC_DIF_SHIFT)
 #define CS42XX8_INTF_ADC_DIF_SHIFT		0
 #define CS42XX8_INTF_ADC_DIF_WIDTH		3
 #define CS42XX8_INTF_ADC_DIF_MASK		(((1 << CS42XX8_INTF_ADC_DIF_WIDTH) - 1) << CS42XX8_INTF_ADC_DIF_SHIFT)
@@ -138,8 +138,8 @@ int cs42xx8_probe(struct device *dev, struct regmap *regmap);
 #define CS42XX8_INTF_ADC_DIF_RIGHTJ		(2 << CS42XX8_INTF_ADC_DIF_SHIFT)
 #define CS42XX8_INTF_ADC_DIF_RIGHTJ_16		(3 << CS42XX8_INTF_ADC_DIF_SHIFT)
 #define CS42XX8_INTF_ADC_DIF_ONELINE_20		(4 << CS42XX8_INTF_ADC_DIF_SHIFT)
-#define CS42XX8_INTF_ADC_DIF_ONELINE_24		(6 << CS42XX8_INTF_ADC_DIF_SHIFT)
-#define CS42XX8_INTF_ADC_DIF_TDM		(7 << CS42XX8_INTF_ADC_DIF_SHIFT)
+#define CS42XX8_INTF_ADC_DIF_ONELINE_24		(5 << CS42XX8_INTF_ADC_DIF_SHIFT)
+#define CS42XX8_INTF_ADC_DIF_TDM		(6 << CS42XX8_INTF_ADC_DIF_SHIFT)
 
 /* ADC Control & DAC De-Emphasis (Address 05h) */
 #define CS42XX8_ADCCTL_ADC_HPF_FREEZE_SHIFT	7
--
1.8.0

_______________________________________________
Alsa-devel mailing list
Alsa-devel@alsa-project.org
http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
