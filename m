Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbaEVUUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 16:20:12 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:59368 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaEVUUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 16:20:10 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sound: soc: samsung: dma.c:  Fix to remove null pointer checks that could never happen
Date: Thu, 22 May 2014 22:21:00 +0200
Message-Id: <1400790060-10977-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removal of null pointer checks that could never happen

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 sound/soc/samsung/dma.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/samsung/dma.c b/sound/soc/samsung/dma.c
index dc09b71..0f17ae0 100644
--- a/sound/soc/samsung/dma.c
+++ b/sound/soc/samsung/dma.c
@@ -124,8 +124,7 @@ static void audio_buffdone(void *data)
 		if (prtd->dma_pos >= prtd->dma_end)
 			prtd->dma_pos = prtd->dma_start;
 
-		if (substream)
-			snd_pcm_period_elapsed(substream);
+		snd_pcm_period_elapsed(substream);
 
 		spin_lock(&prtd->lock);
 		if (!samsung_dma_has_circular()) {
-- 
1.7.10.4

