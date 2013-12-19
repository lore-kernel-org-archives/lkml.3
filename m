Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab3LSEy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 23:54:27 -0500
Received: from [65.55.88.13] ([65.55.88.13]:25801 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750866Ab3LSEy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 23:54:26 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <perex@perex.cz>, <tiwai@suse.de>
CC: <kuninori.morimoto.gx@renesas.com>, <fabio.estevam@freescale.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ASoC: simple-card: Use devm_snd_soc_register_card()
Date: Thu, 19 Dec 2013 11:59:54 +0800
Message-ID: <1387425594-32469-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes the code slightly shorter.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/generic/simple-card.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 7a9b6b4..3d190d0 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -234,14 +234,7 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 	cinfo->snd_card.num_links	= 1;
 	cinfo->snd_card.dev		= &pdev->dev;
 
-	return snd_soc_register_card(&cinfo->snd_card);
-}
-
-static int asoc_simple_card_remove(struct platform_device *pdev)
-{
-	struct asoc_simple_card_info *cinfo = pdev->dev.platform_data;
-
-	return snd_soc_unregister_card(&cinfo->snd_card);
+	return devm_snd_soc_register_card(&pdev->dev, &cinfo->snd_card);
 }
 
 static const struct of_device_id asoc_simple_of_match[] = {
@@ -257,7 +250,6 @@ static struct platform_driver asoc_simple_card = {
 		.of_match_table = asoc_simple_of_match,
 	},
 	.probe		= asoc_simple_card_probe,
-	.remove		= asoc_simple_card_remove,
 };
 
 module_platform_driver(asoc_simple_card);
-- 
1.8.4


