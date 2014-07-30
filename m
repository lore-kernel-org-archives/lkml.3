Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbaG3DIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 23:08:21 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:4776
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753918AbaG3DIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 23:08:18 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>
CC: <alsa-devel@alsa-project.org>, <lgirdwood@gmail.com>, <tiwai@suse.de>,
        <perex@perex.cz>, <linux-kernel@vger.kernel.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <b42378@freescale.com>, <b02247@freescale.com>
Subject: [PATCH 3/4] ASoC: fsl_spdif: Add stream names for DPCM usage
Date: Wed, 30 Jul 2014 11:10:28 +0800
Message-ID: <d8b80d9f84e923104ccc714d1c2e7d480596db92.1406688049.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1406688048.git.nicoleotsuka@gmail.com>
References: <cover.1406688048.git.nicoleotsuka@gmail.com>
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130511632959816132;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(73972005)(64706001)(20776003)(55446002)(88136002)(19580405001)(4396001)(92726001)(107046002)(81542001)(86362001)(92566001)(89996001)(62966002)(47776003)(95666004)(50466002)(6806004)(81442001)(229853001)(85306003)(102836001)(81342001)(105596002)(106466001)(19580395003)(48376002)(26826002)(87936001)(44976005)(83072002)(50226001)(68736004)(46102001)(79102001)(104166001)(61266001)(21056001)(77982001)(76176999)(73392001)(97736001)(80022001)(50986999)(104016003)(110136001)(33646002)(82202001)(74662001)(36756003)(93916002)(85852003)(2351001)(87286001)(31966008)(87572001)(99396002)(84676001)(77156001)(74502001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB361;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
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
SPDIF driver so that we can implement ASRC via DPCM to it.

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 sound/soc/fsl/fsl_spdif.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/fsl/fsl_spdif.c b/sound/soc/fsl/fsl_spdif.c
index 495b9f3..70acfe4 100644
--- a/sound/soc/fsl/fsl_spdif.c
+++ b/sound/soc/fsl/fsl_spdif.c
@@ -975,12 +975,14 @@ static int fsl_spdif_dai_probe(struct snd_soc_dai *dai)
 static struct snd_soc_dai_driver fsl_spdif_dai = {
 	.probe = &fsl_spdif_dai_probe,
 	.playback = {
+		.stream_name = "CPU-Playback",
 		.channels_min = 2,
 		.channels_max = 2,
 		.rates = FSL_SPDIF_RATES_PLAYBACK,
 		.formats = FSL_SPDIF_FORMATS_PLAYBACK,
 	},
 	.capture = {
+		.stream_name = "CPU-Capture",
 		.channels_min = 2,
 		.channels_max = 2,
 		.rates = FSL_SPDIF_RATES_CAPTURE,
-- 
1.8.4

