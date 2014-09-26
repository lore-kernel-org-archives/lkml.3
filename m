Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbaIZKYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:24:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842AbaIZJqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:12 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Scott Jiang <scott.jiang.linux@gmail.com>,
        Mark Brown <broonie@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 076/142] ASoC: blackfin: use samples to set silence
Date: Fri, 26 Sep 2014 11:44:47 +0200
Message-Id: <4bb4582d96337d181a560838fc9192899abfafbb.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Scott Jiang <scott.jiang.linux@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 30443408fd7201fd1911b09daccf92fae3cc700d upstream.

The third parameter for snd_pcm_format_set_silence needs the number
of samples instead of sample bytes.

Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/soc/blackfin/bf5xx-i2s-pcm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/blackfin/bf5xx-i2s-pcm.c b/sound/soc/blackfin/bf5xx-i2s-pcm.c
index 9cb4a80df98e..bc9983d38ff3 100644
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
2.1.0

