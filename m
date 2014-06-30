Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbaF3MM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:12:26 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51993 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753442AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        Zhang Dongxing <dongxing.zhang@intel.com>,
        Takashi Iwai <tiwai@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 074/181] ALSA: compress: Cancel the optimization of compiler and fix the size of struct for all platform.
Date: Mon, 30 Jun 2014 13:51:35 +0200
Message-Id: <363775222eac76447ce81ff7415e61fcae90a19b.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Wang, Xiaoming" <xiaoming.wang@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.0.0

