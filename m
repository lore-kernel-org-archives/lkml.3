Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbaFIGhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 02:37:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:42072 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbaFIGhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 02:37:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,1001,1392192000"; 
   d="scan'208";a="525385257"
Subject: [PATCH] ALSA: compress: Fix the mismatch size of struc between
 share lib(32bit) and kernel(64bit)
From: "Wang, Xiaoming" <xiaoming.wang@intel.com>
To: tiwai@suse.de, vinod.koul@intel.com, jeeja.kp@intel.com,
        dhowells@redhat.com, arnd@arndb.de, tglx@linutronix.de,
        mtk.manpages@gmail.com, paulmck@linux.vnet.ibm.com, davej@redhat.com,
        linux-kernel@vger.kernel.org
Cc: dongxing.zhang@intel.com, xiaoming.wang@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Jun 2014 16:46:32 -0400
Message-ID: <1402346792.30956.17.camel@wxm-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The size of struct snd_compr_avail is 0x1c in 32bit kernel,
while it is 0x20 in 64bit kernel 0x4 bytes added because of
alignment. It is OK when 32bit kernel met 32bit user space.
There exist stack corruption if 64bit kernel met 32bit user
space, because the size of struct snd_compr_avail is 0x1c
in 32bit user space which is smaller than it will get from
kernel. The extra 4 bytes can corrupt the stack, and
introduce unpredictable error.

Signed-off-by: Zhang Dongxing <dongxing.zhang@intel.com>
Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>
---
 include/uapi/sound/compress_offload.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/uapi/sound/compress_offload.h b/include/uapi/sound/compress_offload.h
index 5759810..766b416 100644
--- a/include/uapi/sound/compress_offload.h
+++ b/include/uapi/sound/compress_offload.h
@@ -70,6 +70,7 @@ struct snd_compr_tstamp {
 	__u32 pcm_frames;
 	__u32 pcm_io_frames;
 	__u32 sampling_rate;
+	__u32 reserved[1];
 };
 
 /**
-- 
1.7.1

