Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbaIOT1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:27:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbaIOT1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Scott Jiang <scott.jiang.linux@gmail.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.16 080/158] ASoC: blackfin: use samples to set silence
Date: Mon, 15 Sep 2014 12:25:19 -0700
Message-Id: <20140915192545.294463478@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Jiang <scott.jiang.linux@gmail.com>

commit 30443408fd7201fd1911b09daccf92fae3cc700d upstream.

The third parameter for snd_pcm_format_set_silence needs the number
of samples instead of sample bytes.

Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/blackfin/bf5xx-i2s-pcm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/sound/soc/blackfin/bf5xx-i2s-pcm.c
+++ b/sound/soc/blackfin/bf5xx-i2s-pcm.c
@@ -290,19 +290,19 @@ static int bf5xx_pcm_silence(struct snd_
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


