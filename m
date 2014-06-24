Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965244AbaFXP5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:57:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33445 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965210AbaFXP46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:56:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zhang Dongxing <dongxing.zhang@intel.com>,
        xiaoming wang <xiaoming.wang@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.15 50/61] ALSA: compress: Cancel the optimization of compiler and fix the size of struct for all platform.
Date: Tue, 24 Jun 2014 11:51:33 -0400
Message-Id: <20140624154955.070701541@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154952.751713761@linuxfoundation.org>
References: <20140624154952.751713761@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/sound/compress_offload.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


