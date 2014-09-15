Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935AbaIOWu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:50:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51032 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758046AbaIOWRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:17:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Scott Jiang <scott.jiang.linux@gmail.com>, Mark Brown <broonie@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 081/187] ASoC: blackfin: use samples to set silence
Date: Mon, 15 Sep 2014 15:08:11 -0700
Message-Id: <1410818997-9432-82-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Jiang <scott.jiang.linux@gmail.com>

commit 30443408fd7201fd1911b09daccf92fae3cc700d upstream.

The third parameter for snd_pcm_format_set_silence needs the number
of samples instead of sample bytes.

Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/blackfin/bf5xx-i2s-pcm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/blackfin/bf5xx-i2s-pcm.c b/sound/soc/blackfin/bf5xx-i2s-pcm.c
index 2a5b434..8cbcbf0 100644
--- a/sound/soc/blackfin/bf5xx-i2s-pcm.c
+++ b/sound/soc/blackfin/bf5xx-i2s-pcm.c
@@ -293,19 +293,19 @@ static int bf5xx_pcm_silence(struct snd_pcm_substream *substream,
 	unsigned int sample_size = runtime->sample_bits / 8;
 	void *buf = runtime->dma_area;
 	struct bf5xx_i2s_pcm_data *dma_data;
-	unsigned int offset, size;
+	unsigned int offset, samples;
 
 	dma_data = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
 
 	if (dma_data->tdm_mode) {
 		offset = pos * 8 * sample_size;
-		size = count * 8 * sample_size;
+		samples = count * 8;
 	} else {
 		offset = frames_to_bytes(runtime, pos);
-		size = frames_to_bytes(runtime, count);
+		samples = count * runtime->channels;
 	}
 
-	snd_pcm_format_set_silence(runtime->format, buf + offset, size);
+	snd_pcm_format_set_silence(runtime->format, buf + offset, samples);
 
 	return 0;
 }
-- 
1.9.1

