Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947AbaFLIhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:37:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:27214 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932757AbaFLIhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:37:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,463,1400050800"; 
   d="scan'208";a="527320062"
Subject: [PATCH] ALSA: compress: Cancel the optimization of compiler and
 fix the size of struct for all platform.
From: "Wang, Xiaoming" <xiaoming.wang@intel.com>
To: tiwai@suse.de, vinod.koul@intel.com, jeeja.kp@intel.com,
        dhowells@redhat.com, arnd@arndb.de, tglx@linutronix.de,
        mtk.manpages@gmail.com, paulmck@linux.vnet.ibm.com, davej@redhat.com,
        linux-kernel@vger.kernel.org
Cc: dongxing.zhang@intel.com, xiaoming.wang@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Jun 2014 18:47:07 -0400
Message-ID: <1402613227.8326.13.camel@wxm-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cancel the optimization of compiler for struct snd_compr_avail
which size will be 0x1c in 32bit kernel while 0x20 in 64bit
kernel under the optimizer. That will make compaction between
32bit and 64bit. So add packed to fix the size of struct
snd_compr_avail to 0x1c for all platform.

Signed-off-by: Zhang Dongxing <dongxing.zhang@intel.com>
Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>
---
 include/uapi/sound/compress_offload.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/uapi/sound/compress_offload.h b/include/uapi/sound/compress_offload.h
index 5759810..21eed48 100644
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
1.7.1

