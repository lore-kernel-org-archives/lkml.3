Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934834Ab3GWWnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:43:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41704 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934675Ab3GWW1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Brown <broonie@linaro.org>, Takashi Iwai <tiwai@suse.de>
Subject: [ 046/103] ASoC: s6000: Fix unlocked snd_pcm_stop() call
Date: Tue, 23 Jul 2013 15:25:57 -0700
Message-Id: <20130723220423.702388251@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 61be2b9a18ec70f3cbe3deef7a5f77869c71b5ae upstream.

snd_pcm_stop() must be called in the PCM substream lock context.

Acked-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/s6000/s6000-pcm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/s6000/s6000-pcm.c
+++ b/sound/soc/s6000/s6000-pcm.c
@@ -128,7 +128,9 @@ static irqreturn_t s6000_pcm_irq(int irq
 		    substream->runtime &&
 		    snd_pcm_running(substream)) {
 			dev_dbg(pcm->dev, "xrun\n");
+			snd_pcm_stream_lock(substream);
 			snd_pcm_stop(substream, SNDRV_PCM_STATE_XRUN);
+			snd_pcm_stream_unlock(substream);
 			ret = IRQ_HANDLED;
 		}
 


