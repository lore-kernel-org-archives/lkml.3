Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbaAMKFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:05:15 -0500
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:32716
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751426AbaAMKFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:05:12 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <kuninori.morimoto.gx@renesas.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] ASoC: simple-card: use snd_soc_card_set/get_drvdata
Date: Mon, 13 Jan 2014 17:08:08 +0800
Message-ID: <1389604088-16536-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove asoc_simple_get_card_info macro and use snd_soc_card_set_drvdata
and snd_soc_card_get_drvdata instead.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/generic/simple-card.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index dbd93cc..c025b6d 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -14,9 +14,6 @@
 #include <linux/module.h>
 #include <sound/simple_card.h>
 
-#define asoc_simple_get_card_info(p) \
-	container_of(p->dai_link, struct asoc_simple_card_info, snd_link)
-
 static int __asoc_simple_card_dai_init(struct snd_soc_dai *dai,
 				       struct asoc_simple_dai *set,
 				       unsigned int daifmt)
@@ -41,7 +38,8 @@ static int __asoc_simple_card_dai_init(struct snd_soc_dai *dai,
 
 static int asoc_simple_card_dai_init(struct snd_soc_pcm_runtime *rtd)
 {
-	struct asoc_simple_card_info *info = asoc_simple_get_card_info(rtd);
+	struct asoc_simple_card_info *info =
+				snd_soc_card_get_drvdata(rtd->card);
 	struct snd_soc_dai *codec = rtd->codec_dai;
 	struct snd_soc_dai *cpu = rtd->cpu_dai;
 	unsigned int daifmt = info->daifmt;
@@ -268,6 +266,8 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 	cinfo->snd_card.dai_link	= &cinfo->snd_link;
 	cinfo->snd_card.num_links	= 1;
 
+	snd_soc_card_set_drvdata(&cinfo->snd_card, cinfo);
+
 	return devm_snd_soc_register_card(&pdev->dev, &cinfo->snd_card);
 }
 
-- 
1.8.4


