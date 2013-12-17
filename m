Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab3LQIIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 03:08:22 -0500
Received: from mail-db9lp0253.outbound.messaging.microsoft.com ([213.199.154.253]:15807
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751060Ab3LQIIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 03:08:21 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzd2iz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <lars@metafoo.de>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <perex@perex.cz>, <tiwai@suse.de>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ASoC: dmaengine: Add config parameter NULL check.
Date: Tue, 17 Dec 2013 15:16:40 +0800
Message-ID: <1387264600-14225-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the "ASoC: dmaengine-pcm: Provide default config" has provided
us one defualt config of DMA. When using this, the config parameter of
devm_snd_dmaengine_pcm_register() will be NULL, so here we need to have
a check before using it.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/soc-generic-dmaengine-pcm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-generic-dmaengine-pcm.c b/sound/soc/soc-generic-dmaengine-pcm.c
index 7483922..2a6c569 100644
--- a/sound/soc/soc-generic-dmaengine-pcm.c
+++ b/sound/soc/soc-generic-dmaengine-pcm.c
@@ -299,7 +299,7 @@ static int dmaengine_pcm_request_chan_of(struct dmaengine_pcm *pcm,
 	    !dev->of_node)
 		return 0;
 
-	if (config->dma_dev) {
+	if (config && config->dma_dev) {
 		/*
 		 * If this warning is seen, it probably means that your Linux
 		 * device structure does not match your HW device structure.
@@ -317,7 +317,7 @@ static int dmaengine_pcm_request_chan_of(struct dmaengine_pcm *pcm,
 			name = "rx-tx";
 		else
 			name = dmaengine_pcm_dma_channel_names[i];
-		if (config->chan_names[i])
+		if (config && config->chan_names[i])
 			name = config->chan_names[i];
 		chan = dma_request_slave_channel_reason(dev, name);
 		if (IS_ERR(chan)) {
-- 
1.8.4


