Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbaGaEFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 00:05:11 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:13339
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750766AbaGaEFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 00:05:10 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>,
        <b42378@freescale.com>
Subject: [PATCH] ASoC: fsl_asrc: Fix sparse warnings in FSL_ASRC_FORMATS due to typo
Date: Thu, 31 Jul 2014 12:07:40 +0800
Message-ID: <1406779660-17177-1-git-send-email-nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130512531068775113;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(77156001)(50226001)(48376002)(82202001)(50466002)(74502001)(62966002)(77982001)(87286001)(73972005)(73392001)(81442001)(87936001)(81342001)(81542001)(19580405001)(64706001)(85852003)(97736001)(36756003)(89996001)(46102001)(83072002)(92566001)(88136002)(47776003)(87572001)(93916002)(107046002)(229853001)(104166001)(6806004)(80022001)(44976005)(2351001)(19580395003)(92726001)(104016003)(85306003)(84676001)(68736004)(55446002)(106466001)(74662001)(50986999)(99396002)(20776003)(61266001)(105596002)(21056001)(95666004)(102836001)(110136001)(31966008)(33646002)(79102001)(86362001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB367;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0289B6431E
Authentication-Results: spf=softfail (sender IP is 192.88.168.50)
 smtp.mailfrom=nicoleotsuka@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reproduce: make C=1 CF=-D__CHECK_ENDIAN__

sparse warnings: (new ones prefixed by >>)

>> sound/soc/fsl/fsl_asrc.c:563:28: sparse: restricted snd_pcm_format_t degrades to integer
>> sound/soc/fsl/fsl_asrc.c:570:28: sparse: restricted snd_pcm_format_t degrades to integer

vim +563 sound/soc/fsl/fsl_asrc.c

  557          .probe = fsl_asrc_dai_probe,
  558          .playback = {
  559                  .stream_name = "ASRC-Playback",
  560                  .channels_min = 1,
  561                  .channels_max = 10,
  562                  .rates = FSL_ASRC_RATES,
> 563                  .formats = FSL_ASRC_FORMATS,
  564          },
  565          .capture = {
  566                  .stream_name = "ASRC-Capture",
  567                  .channels_min = 1,
  568                  .channels_max = 10,
  569                  .rates = FSL_ASRC_RATES,
> 570                  .formats = FSL_ASRC_FORMATS,
  571          },
  572          .ops = &fsl_asrc_dai_ops,
  573  };

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 sound/soc/fsl/fsl_asrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_asrc.c b/sound/soc/fsl/fsl_asrc.c
index 41699f7..cdb5779 100644
--- a/sound/soc/fsl/fsl_asrc.c
+++ b/sound/soc/fsl/fsl_asrc.c
@@ -551,7 +551,7 @@ static int fsl_asrc_dai_probe(struct snd_soc_dai *dai)
 #define FSL_ASRC_RATES		 SNDRV_PCM_RATE_8000_192000
 #define FSL_ASRC_FORMATS	(SNDRV_PCM_FMTBIT_S24_LE | \
 				 SNDRV_PCM_FMTBIT_S16_LE | \
-				 SNDRV_PCM_FORMAT_S20_3LE)
+				 SNDRV_PCM_FMTBIT_S20_3LE)
 
 static struct snd_soc_dai_driver fsl_asrc_dai = {
 	.probe = fsl_asrc_dai_probe,
-- 
1.8.4

