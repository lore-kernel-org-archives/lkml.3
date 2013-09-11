Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab3IKEbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:31:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26240 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab3IKE24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:28:56 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=YL5cmnmhms0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=twGUnw8mw1AA:10 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=0kPLrQdw3YYA:10 a=WwgC8nHKvroA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042854.457054109@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mark Brown <broonie@linaro.org>, Takashi Iwai <tiwai@suse.de>
Subject: [014/251] ASoC: s6000: Fix unlocked snd_pcm_stop() call
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0014-ASoC-s6000-Fix-unlocked-snd_pcm_stop-call.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 61be2b9a18ec70f3cbe3deef7a5f77869c71b5ae ]

snd_pcm_stop() must be called in the PCM substream lock context.

Cc: <stable@vger.kernel.org>
Acked-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/soc/s6000/s6000-pcm.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/s6000/s6000-pcm.c b/sound/soc/s6000/s6000-pcm.c
index 716da86..17f9348 100644
--- a/sound/soc/s6000/s6000-pcm.c
+++ b/sound/soc/s6000/s6000-pcm.c
@@ -128,7 +128,9 @@ static irqreturn_t s6000_pcm_irq(int irq, void *data)
 		    substream->runtime &&
 		    snd_pcm_running(substream)) {
 			dev_dbg(pcm->dev, "xrun\n");
+			snd_pcm_stream_lock(substream);
 			snd_pcm_stop(substream, SNDRV_PCM_STATE_XRUN);
+			snd_pcm_stream_unlock(substream);
 			ret = IRQ_HANDLED;
 		}
 
-- 
1.7.10.4


