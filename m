Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965292AbaGCJsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:48:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52215 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030223AbaGCJXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:23:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Zhang Dongxing <dongxing.zhang@intel.com>,
        xiaoming wang <xiaoming.wang@intel.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 126/198] ALSA: compress: Cancel the optimization of compiler and fix the size of struct for all platform.
Date: Thu,  3 Jul 2014 10:19:29 +0100
Message-Id: <1404379241-8590-127-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Wang, Xiaoming" <xiaoming.wang@intel.com>

commit 2bd0ae464a6cf7363bbf72c8545e0aa43caa57f0 upstream.

Cancel the optimization of compiler for struct snd_compr_avail
which size will be 0x1c in 32bit kernel while 0x20 in 64bit
kernel under the optimizer. That will make compaction between
32bit and 64bit. So add packed to fix the size of struct
snd_compr_avail to 0x1c for all platform.

Signed-off-by: Zhang Dongxing <dongxing.zhang@intel.com>
Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>
Acked-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/uapi/sound/compress_offload.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/sound/compress_offload.h b/include/uapi/sound/compress_offload.h
index 5759810e1c1b..21eed488783f 100644
--- a/include/uapi/sound/compress_offload.h
+++ b/include/uapi/sound/compress_offload.h
@@ -80,7 +80,7 @@ struct snd_compr_tstamp {
 struct snd_compr_avail {
 	__u64 avail;
 	struct snd_compr_tstamp tstamp;
-};
+} __attribute__((packed));
 
 enum snd_compr_direction {
 	SND_COMPRESS_PLAYBACK = 0,
-- 
1.9.1

