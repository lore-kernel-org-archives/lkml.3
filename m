Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbaELMnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 08:43:37 -0400
Received: from mail-bn1bon0060.outbound.protection.outlook.com ([157.56.111.60]:51427
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751925AbaELMnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 08:43:35 -0400
X-Greylist: delayed 1115 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 May 2014 08:43:35 EDT
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        <tiwai@suse.de>, <perex@perex.cz>
Subject: [PATCH] ASoC: Fix incorrect condition check for case SNDRV_PCM_TRIGGER_SUSPEND
Date: Mon, 12 May 2014 20:12:05 +0800
Message-ID: <1399896725-28083-1-git-send-email-Guangyu.Chen@freescale.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(189002)(199002)(50986999)(92566001)(50226001)(77982001)(36756003)(83072002)(92726001)(85852003)(77156001)(46102001)(21056001)(77096999)(76482001)(62966002)(4396001)(6806004)(31966008)(84676001)(99396002)(47776003)(20776003)(81542001)(68736004)(19580405001)(87286001)(93916002)(81342001)(80022001)(86362001)(64706001)(74502001)(87936001)(48376002)(19580395003)(83322001)(81156002)(44976005)(2009001)(74662001)(69596002)(88136002)(97736001)(50466002)(89996001)(79102001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB019;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0209425D0A
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=guangyu.chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regular state before we execute SNDRV_PCM_TRIGGER_SUSPEND should be
SNDRV_PCM_TRIGGER_START, not SNDRV_PCM_TRIGGER_STOP. Thus fix it.

Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
---
 sound/soc/soc-pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 88230ea..49930bd 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1666,7 +1666,7 @@ int dpcm_be_dai_trigger(struct snd_soc_pcm_runtime *fe, int stream,
 			be->dpcm[stream].state = SND_SOC_DPCM_STATE_STOP;
 			break;
 		case SNDRV_PCM_TRIGGER_SUSPEND:
-			if (be->dpcm[stream].state != SND_SOC_DPCM_STATE_STOP)
+			if (be->dpcm[stream].state != SND_SOC_DPCM_STATE_START)
 				continue;
 
 			if (!snd_soc_dpcm_can_be_free_stop(fe, be, stream))
-- 
1.8.4

