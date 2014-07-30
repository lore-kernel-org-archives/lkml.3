Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbaG3DIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 23:08:23 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:51835
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754777AbaG3DIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 23:08:14 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>
CC: <alsa-devel@alsa-project.org>, <lgirdwood@gmail.com>, <tiwai@suse.de>,
        <perex@perex.cz>, <linux-kernel@vger.kernel.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <b42378@freescale.com>, <b02247@freescale.com>
Subject: [PATCH 2/4] ASoC: fsl_sai: Add stream names for DPCM usage
Date: Wed, 30 Jul 2014 11:10:27 +0800
Message-ID: <da605dc6ca36c124a24c12d2dbc0bfa1a4837037.1406688049.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1406688048.git.nicoleotsuka@gmail.com>
References: <cover.1406688048.git.nicoleotsuka@gmail.com>
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130511632923816700;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(55446002)(4396001)(47776003)(74662001)(44976005)(86362001)(19580395003)(73972005)(77982001)(6806004)(36756003)(74502001)(20776003)(82202001)(93916002)(31966008)(50466002)(81342001)(81542001)(83072002)(19580405001)(62966002)(77156001)(88136002)(102836001)(73392001)(21056001)(26826002)(68736004)(87936001)(87286001)(87572001)(84676001)(104166001)(61266001)(105596002)(85852003)(95666004)(229853001)(2351001)(99396002)(46102001)(48376002)(107046002)(76176999)(50226001)(81442001)(50986999)(85306003)(104016003)(92726001)(97736001)(92566001)(80022001)(110136001)(79102001)(33646002)(106466001)(89996001)(64706001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB356;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0288CD37D9
Authentication-Results: spf=softfail (sender IP is 192.88.168.50)
 smtp.mailfrom=nicoleotsuka@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DPCM needs extra dapm routes in the machine driver to route audio
between Front-End and Back-End. In order to differ the stream names
in the route map from CODECs, we here add specific stream names to
SAI driver so that we can implement ASRC via DPCM to it.

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 sound/soc/fsl/fsl_sai.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 364410b..faa0497 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -455,12 +455,14 @@ static int fsl_sai_dai_probe(struct snd_soc_dai *cpu_dai)
 static struct snd_soc_dai_driver fsl_sai_dai = {
 	.probe = fsl_sai_dai_probe,
 	.playback = {
+		.stream_name = "CPU-Playback",
 		.channels_min = 1,
 		.channels_max = 2,
 		.rates = SNDRV_PCM_RATE_8000_96000,
 		.formats = FSL_SAI_FORMATS,
 	},
 	.capture = {
+		.stream_name = "CPU-Capture",
 		.channels_min = 1,
 		.channels_max = 2,
 		.rates = SNDRV_PCM_RATE_8000_96000,
-- 
1.8.4

