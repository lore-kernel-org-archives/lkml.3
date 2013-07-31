Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171Ab3GaNoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:44:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46991 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759762Ab3GaNZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:48 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mark Brown" <broonie@linaro.org>,
        "Takashi Iwai" <tiwai@suse.de>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.231898473@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [48/84] ASoC: s6000: Fix unlocked snd_pcm_stop() call
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 61be2b9a18ec70f3cbe3deef7a5f77869c71b5ae upstream.

snd_pcm_stop() must be called in the PCM substream lock context.

Acked-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/s6000/s6000-pcm.c | 2 ++
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
 

