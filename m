Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933766AbaKMPOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:14:34 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:32809 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933726AbaKMPOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:14:30 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ALSA: ice1712: remove unused variable
Date: Thu, 13 Nov 2014 20:44:17 +0530
Message-Id: <1415891657-7244-2-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1415891657-7244-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1415891657-7244-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

these variable were initialized with some value, but never used.
and so they are safe to be deleted.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

i have not given Jaroslav Kysela <perex@perex.cz> in the To list,
as in my last mail, all mails bounced with the error:
"cant create user output file"

 sound/pci/ice1712/ice1712.c | 3 +--
 sound/pci/ice1712/revo.c    | 9 +++------
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index b97a0f9..8f27357 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -620,10 +620,9 @@ static int snd_ice1712_playback_ds_prepare(struct snd_pcm_substream *substream)
 {
 	struct snd_ice1712 *ice = snd_pcm_substream_chip(substream);
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	u32 period_size, buf_size, rate, tmp, chn;
+	u32 period_size, rate, tmp, chn;
 
 	period_size = snd_pcm_lib_period_bytes(substream) - 1;
-	buf_size = snd_pcm_lib_buffer_bytes(substream) - 1;
 	tmp = 0x0064;
 	if (snd_pcm_format_width(runtime->format) == 16)
 		tmp &= ~0x04;
diff --git a/sound/pci/ice1712/revo.c b/sound/pci/ice1712/revo.c
index 1112ec1..1f40dab 100644
--- a/sound/pci/ice1712/revo.c
+++ b/sound/pci/ice1712/revo.c
@@ -481,7 +481,6 @@ static int ap192_ak4114_init(struct snd_ice1712 *ice)
 	static const unsigned char ak4114_init_txcsb[] = {
 		0x41, 0x02, 0x2c, 0x00, 0x00
 	};
-	int err;
 
 	struct revo51_spec *spec;
 	spec = kzalloc(sizeof(*spec), GFP_KERNEL);
@@ -489,11 +488,9 @@ static int ap192_ak4114_init(struct snd_ice1712 *ice)
 		return -ENOMEM;
 	ice->spec = spec;
 
-	err = snd_ak4114_create(ice->card,
-				 ap192_ak4114_read,
-				 ap192_ak4114_write,
-				 ak4114_init_vals, ak4114_init_txcsb,
-				 ice, &spec->ak4114);
+	snd_ak4114_create(ice->card, ap192_ak4114_read, ap192_ak4114_write,
+			  ak4114_init_vals, ak4114_init_txcsb, ice,
+			  &spec->ak4114);
 	/* AK4114 in Revo cannot detect external rate correctly.
 	 * No reason to stop capture stream due to incorrect checks */
 	spec->ak4114->check_flags = AK4114_CHECK_NO_RATE;
-- 
1.8.1.2

