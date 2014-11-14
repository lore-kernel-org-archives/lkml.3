Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965204AbaKNKjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 05:39:25 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:44596 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965102AbaKNKjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 05:39:23 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] ALSA: ice1712: remove unused variable
Date: Fri, 14 Nov 2014 16:09:07 +0530
Message-Id: <1415961547-10330-3-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1415961547-10330-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1415961547-10330-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

buf_size was initialized with snd_pcm_lib_buffer_bytes,
but never used. and so it is safe to be deleted.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 sound/pci/ice1712/ice1712.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index 5975334..6525191 100644
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
-- 
1.8.1.2

