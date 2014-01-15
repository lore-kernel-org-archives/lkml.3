Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbaAOWMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:12:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41296 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbaAOV7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:59:36 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 032/166] ALSA: compress: Fix 64bit ABI incompatibility
Date: Wed, 15 Jan 2014 13:50:46 -0800
Message-Id: <1389822780-4729-33-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 6733cf572a9e20db2b7580a5dd39d5782d571eec upstream.

snd_pcm_uframes_t is defined as unsigned long so it would take
different sizes depending on 32 or 64bit architectures.  As we don't
want this ABI incompatibility, and there is no real 64bit user yet,
let's make it the fixed size with __u32.

Also bump the protocol version number to 0.1.2.

Acked-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/uapi/sound/compress_offload.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/sound/compress_offload.h b/include/uapi/sound/compress_offload.h
index 05341a4..9aa8624 100644
--- a/include/uapi/sound/compress_offload.h
+++ b/include/uapi/sound/compress_offload.h
@@ -30,7 +30,7 @@
 #include <sound/compress_params.h>
 
 
-#define SNDRV_COMPRESS_VERSION SNDRV_PROTOCOL_VERSION(0, 1, 0)
+#define SNDRV_COMPRESS_VERSION SNDRV_PROTOCOL_VERSION(0, 1, 2)
 /**
  * struct snd_compressed_buffer: compressed buffer
  * @fragment_size: size of buffer fragment in bytes
@@ -67,8 +67,8 @@ struct snd_compr_params {
 struct snd_compr_tstamp {
 	__u32 byte_offset;
 	__u32 copied_total;
-	snd_pcm_uframes_t pcm_frames;
-	snd_pcm_uframes_t pcm_io_frames;
+	__u32 pcm_frames;
+	__u32 pcm_io_frames;
 	__u32 sampling_rate;
 };
 
-- 
1.8.3.2

