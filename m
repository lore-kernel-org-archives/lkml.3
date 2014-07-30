Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbaG3DIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 23:08:34 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:4660
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753918AbaG3DIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 23:08:22 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>
CC: <alsa-devel@alsa-project.org>, <lgirdwood@gmail.com>, <tiwai@suse.de>,
        <perex@perex.cz>, <linux-kernel@vger.kernel.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <b42378@freescale.com>, <b02247@freescale.com>
Subject: [PATCH 4/4] ASoC: fsl_ssi: Add stream names for DPCM usage
Date: Wed, 30 Jul 2014 11:10:29 +0800
Message-ID: <891b9f4edbba81a03c2b8350abc5ccf923db9260.1406688049.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1406688048.git.nicoleotsuka@gmail.com>
References: <cover.1406688048.git.nicoleotsuka@gmail.com>
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130511632993351268;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(80022001)(85306003)(79102001)(82202001)(87936001)(81442001)(36756003)(76176999)(83072002)(46102001)(26826002)(99396002)(61266001)(105596002)(50986999)(104016003)(21056001)(229853001)(93916002)(89996001)(81542001)(104166001)(55446002)(110136001)(106466001)(77156001)(81342001)(85852003)(92566001)(33646002)(87572001)(107046002)(86362001)(20776003)(2351001)(88136002)(19580405001)(6806004)(44976005)(87286001)(50466002)(74662001)(19580395003)(74502001)(73972005)(102836001)(50226001)(95666004)(84676001)(47776003)(77982001)(92726001)(48376002)(31966008)(68736004)(97736001)(73392001)(64706001)(4396001)(62966002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB364;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
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
SSI driver so that we can implement ASRC via DPCM to it.

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 sound/soc/fsl/fsl_ssi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
index 3043d57..87eb577 100644
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -1032,12 +1032,14 @@ static const struct snd_soc_dai_ops fsl_ssi_dai_ops = {
 static struct snd_soc_dai_driver fsl_ssi_dai_template = {
 	.probe = fsl_ssi_dai_probe,
 	.playback = {
+		.stream_name = "CPU-Playback",
 		.channels_min = 1,
 		.channels_max = 2,
 		.rates = FSLSSI_I2S_RATES,
 		.formats = FSLSSI_I2S_FORMATS,
 	},
 	.capture = {
+		.stream_name = "CPU-Capture",
 		.channels_min = 1,
 		.channels_max = 2,
 		.rates = FSLSSI_I2S_RATES,
-- 
1.8.4

