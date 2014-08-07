Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbaHGLyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 07:54:04 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:16336
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754519AbaHGLyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 07:54:03 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>
CC: <patches@opensource.wolfsonmicro.com>, <alsa-devel@alsa-project.org>,
        <rf@opensource.wolfsonmicro.com>, <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>, <tiwai@suse.de>, <perex@perex.cz>,
        <ckeepax@opensource.wolfsonmicro.com>, <B18700@freescale.com>,
        <b02247@freescale.com>
Subject: [PATCH] ASoC: wm8962: Correct the bit offset to enable mono speaker output
Date: Thu, 7 Aug 2014 19:55:49 +0800
Message-ID: <1407412549-14983-1-git-send-email-nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130518860393085916;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009003)(6009001)(199002)(189002)(99396002)(62966002)(21056001)(92726001)(46102001)(81542001)(2351001)(31966008)(73392001)(74662001)(48376002)(81442001)(26826002)(229853001)(61266001)(104016003)(74502001)(19580395003)(44976005)(50986999)(6806004)(19580405001)(110136001)(104166001)(86362001)(97736001)(93916002)(107046002)(77156001)(64706001)(87572001)(47776003)(82202001)(73972005)(36756003)(80022001)(89996001)(20776003)(102836001)(33646002)(81342001)(88136002)(4396001)(68736004)(84676001)(106466001)(105596002)(50466002)(79102001)(87286001)(92566001)(95666004)(85306004)(87936001)(85852003)(50226001)(55446002)(83072002)(77982001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB356;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 029651C7A1
Authentication-Results: spf=softfail (sender IP is 192.88.168.50)
 smtp.mailfrom=nicoleotsuka@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As WM8962 datasheet describes for SPK_MONO bit of R51: When SPK_MONO
is set to '1', both speakers output the signal from the left channel.

So for mono speaker widget, we shall enable Left Channel whose enable
bit is 6 instead of 7 (Right Channel).

This patches just simply corrects the bit offset.

Signed-off-by: Peter Chan <B18700@freescale.com>
Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---

@Peter
I cced you just to let you know that I'm merging your fix to upstream.
And because you patch can't be applied to the upstream tree directly,
I used my own commit with your signed-off. Thank you for the fix.

 sound/soc/codecs/wm8962.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index 1098ae3..105deec 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -2185,7 +2185,7 @@ SND_SOC_DAPM_MIXER("Speaker Mixer", WM8962_MIXER_ENABLES, 1, 0,
 		   spkmixl, ARRAY_SIZE(spkmixl)),
 SND_SOC_DAPM_MUX_E("Speaker PGA", WM8962_PWR_MGMT_2, 4, 0, &spkoutl_mux,
 		   out_pga_event, SND_SOC_DAPM_POST_PMU),
-SND_SOC_DAPM_PGA("Speaker Output", WM8962_CLASS_D_CONTROL_1, 7, 0, NULL, 0),
+SND_SOC_DAPM_PGA("Speaker Output", WM8962_CLASS_D_CONTROL_1, 6, 0, NULL, 0),
 SND_SOC_DAPM_OUTPUT("SPKOUT"),
 };
 
-- 
1.8.4

