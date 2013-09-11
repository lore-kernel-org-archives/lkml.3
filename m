Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab3IKEat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:30:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18020 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab3IKE2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:28:55 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=_X1XP23eJ1IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=X_FKZ6x0-HIA:10 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=0kPLrQdw3YYA:10 a=WwgC8nHKvroA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042853.349930856@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mark Brown <broonie@linaro.org>, Takashi Iwai <tiwai@suse.de>
Subject: [007/251] ALSA: pxa2xx: Fix unlocked snd_pcm_stop() call
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0007-ALSA-pxa2xx-Fix-unlocked-snd_pcm_stop-call.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 46f6c1aaf790be9ea3c8ddfc8f235a5f677d08e2 ]

snd_pcm_stop() must be called in the PCM substream lock context.

Cc: <stable@vger.kernel.org>
Acked-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/arm/pxa2xx-pcm-lib.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/arm/pxa2xx-pcm-lib.c b/sound/arm/pxa2xx-pcm-lib.c
index 76e0d56..823359e 100644
--- a/sound/arm/pxa2xx-pcm-lib.c
+++ b/sound/arm/pxa2xx-pcm-lib.c
@@ -166,7 +166,9 @@ void pxa2xx_pcm_dma_irq(int dma_ch, void *dev_id)
 	} else {
 		printk(KERN_ERR "%s: DMA error on channel %d (DCSR=%#x)\n",
 			rtd->params->name, dma_ch, dcsr);
+		snd_pcm_stream_lock(substream);
 		snd_pcm_stop(substream, SNDRV_PCM_STATE_XRUN);
+		snd_pcm_stream_unlock(substream);
 	}
 }
 EXPORT_SYMBOL(pxa2xx_pcm_dma_irq);
-- 
1.7.10.4


