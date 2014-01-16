Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbaAPJmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 04:42:43 -0500
Received: from mail-db9lp0253.outbound.messaging.microsoft.com ([213.199.154.253]:33753
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752567AbaAPJmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 04:42:39 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzdchd2iz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h2487h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <lars@metafoo.de>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <perex@perex.cz>, <tiwai@suse.de>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] ASoC: core: Use devm_kzalloc() instead kzalloc()
Date: Thu, 16 Jan 2014 16:44:47 +0800
Message-ID: <1389861887-32721-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes the code slightly shorter

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/soc-generic-dmaengine-pcm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/soc-generic-dmaengine-pcm.c b/sound/soc/soc-generic-dmaengine-pcm.c
index 5bace12..bfb012f 100644
--- a/sound/soc/soc-generic-dmaengine-pcm.c
+++ b/sound/soc/soc-generic-dmaengine-pcm.c
@@ -388,7 +388,7 @@ int snd_dmaengine_pcm_register(struct device *dev,
 	struct dmaengine_pcm *pcm;
 	int ret;
 
-	pcm = kzalloc(sizeof(*pcm), GFP_KERNEL);
+	pcm = devm_kzalloc(dev, sizeof(*pcm), GFP_KERNEL);
 	if (!pcm)
 		return -ENOMEM;
 
@@ -408,7 +408,6 @@ int snd_dmaengine_pcm_register(struct device *dev,
 
 err_free_dma:
 	dmaengine_pcm_release_chan(pcm);
-	kfree(pcm);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_register);
@@ -433,7 +432,6 @@ void snd_dmaengine_pcm_unregister(struct device *dev)
 
 	snd_soc_remove_platform(platform);
 	dmaengine_pcm_release_chan(pcm);
-	kfree(pcm);
 }
 EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_unregister);
 
-- 
1.8.4


