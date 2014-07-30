Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaG3DIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 23:08:15 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:56186
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753918AbaG3DIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 23:08:12 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>
CC: <alsa-devel@alsa-project.org>, <lgirdwood@gmail.com>, <tiwai@suse.de>,
        <perex@perex.cz>, <linux-kernel@vger.kernel.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <b42378@freescale.com>, <b02247@freescale.com>
Subject: [PATCH 1/4] ASoC: fsl_esai: Add stream names for DPCM usage
Date: Wed, 30 Jul 2014 11:10:26 +0800
Message-ID: <fb152c2ad8460daea68b0ccf00e787579483b7ab.1406688049.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1406688048.git.nicoleotsuka@gmail.com>
References: <cover.1406688048.git.nicoleotsuka@gmail.com>
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130511632887931838;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(50466002)(79102001)(229853001)(2351001)(55446002)(106466001)(76176999)(84676001)(104166001)(48376002)(107046002)(86362001)(93916002)(87572001)(50986999)(4396001)(81542001)(77982001)(80022001)(77156001)(36756003)(87936001)(81342001)(31966008)(82202001)(46102001)(50226001)(81442001)(19580405001)(74502001)(99396002)(88136002)(74662001)(19580395003)(33646002)(44976005)(21056001)(85852003)(20776003)(92726001)(62966002)(105596002)(47776003)(85306003)(73392001)(64706001)(87286001)(102836001)(95666004)(92566001)(26826002)(110136001)(104016003)(97736001)(6806004)(73972005)(61266001)(83072002)(68736004)(89996001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB360;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
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
ESAI driver so that we can implement ASRC via DPCM to it.

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 sound/soc/fsl/fsl_esai.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/fsl/fsl_esai.c b/sound/soc/fsl/fsl_esai.c
index d719caf..72d154e 100644
--- a/sound/soc/fsl/fsl_esai.c
+++ b/sound/soc/fsl/fsl_esai.c
@@ -624,12 +624,14 @@ static int fsl_esai_dai_probe(struct snd_soc_dai *dai)
 static struct snd_soc_dai_driver fsl_esai_dai = {
 	.probe = fsl_esai_dai_probe,
 	.playback = {
+		.stream_name = "CPU-Playback",
 		.channels_min = 1,
 		.channels_max = 12,
 		.rates = FSL_ESAI_RATES,
 		.formats = FSL_ESAI_FORMATS,
 	},
 	.capture = {
+		.stream_name = "CPU-Capture",
 		.channels_min = 1,
 		.channels_max = 8,
 		.rates = FSL_ESAI_RATES,
-- 
1.8.4

