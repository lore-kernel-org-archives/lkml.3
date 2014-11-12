Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792AbaKLENA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:13:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58591 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbaKLBWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:22:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Mack <daniel@zonque.org>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.17 035/319] ASoC: soc-pcm: fix sig_bits determination in soc_pcm_apply_msb()
Date: Wed, 12 Nov 2014 10:12:53 +0900
Message-Id: <20141112010958.483493797@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <daniel@zonque.org>

commit 5e63dfccf34d4dbf21429c4919f33c028ff49991 upstream.

In the SNDRV_PCM_STREAM_CAPTURE branch in soc_pcm_apply_msb(), look at
sig_bits of the capture stream, not the playback one.

Spotted by coverity.

Signed-off-by: Daniel Mack <daniel@zonque.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-pcm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -352,7 +352,7 @@ static void soc_pcm_apply_msb(struct snd
 	} else {
 		for (i = 0; i < rtd->num_codecs; i++) {
 			codec_dai = rtd->codec_dais[i];
-			if (codec_dai->driver->playback.sig_bits == 0) {
+			if (codec_dai->driver->capture.sig_bits == 0) {
 				bits = 0;
 				break;
 			}


