Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbaG2LBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:01:46 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:38571
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752841AbaG2LBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:01:44 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <alsa-devel@alsa-project.org>, <brian.austin@cirrus.com>,
        <Paul.Handrigan@cirrus.com>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <perex@perex.cz>, <tiwai@suse.de>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V2] ASoC: cs42xx8: Add SND_SOC_DAIFMT_DSP_A support
Date: Tue, 29 Jul 2014 18:39:37 +0800
Message-ID: <d30e88a9fa8c0e52acb48755a1b6dbd2b9e4bacf.1406629932.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(54534003)(199002)(189002)(33646002)(62966002)(76482001)(106466001)(104016003)(46102001)(77982001)(105606002)(95666004)(44976005)(88136002)(6806004)(47776003)(79102001)(85306003)(107886001)(64706001)(84676001)(26826002)(87286001)(50466002)(50986999)(4396001)(81542001)(50226001)(81342001)(68736004)(83322001)(92566001)(77156001)(31966008)(87936001)(83072002)(229853001)(107046002)(19580395003)(36756003)(102836001)(19580405001)(97736001)(575784001)(48376002)(21056001)(80022001)(93916002)(74502001)(2201001)(74662001)(86362001)(92726001)(20776003)(85852003)(89996001)(104166001)(99396002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB576;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0287BBA78D
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the spec, the definition of TDM and ONELINE_24 for
CS42XX8_INTF_DAC and CS42XX8_INTF_ADC is wrong. correct them and enable
SND_SOC_DAIFMT_DSP_A support.

Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
Acked-by: Brian Austin <brian.austin@cirrus.com>
Acked-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
Changelog:

v2
 * Resend this patch, v1 missed some maintainers.
 * Add Acked info.

 sound/soc/codecs/cs42xx8.c | 3 +++
 sound/soc/codecs/cs42xx8.h | 8 ++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/cs42xx8.c b/sound/soc/codecs/cs42xx8.c
index ec53ffc..02b1520 100644
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
diff --git a/sound/soc/codecs/cs42xx8.h b/sound/soc/codecs/cs42xx8.h
index da0b94a..b2c10e5 100644
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

