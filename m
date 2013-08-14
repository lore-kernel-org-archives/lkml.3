Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638Ab3HNKv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:51:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34544 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377Ab3HNKhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:37:54 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vinod Koul <vinod.koul@intel.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 37/75] ALSA: compress: fix the return value for SNDRV_COMPRESS_VERSION
Date: Wed, 14 Aug 2013 11:36:26 +0100
Message-Id: <1376476624-10011-38-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinod Koul <vinod.koul@intel.com>

commit a8d30608eaed6cc759b8e2e8a8bbbb42591f797f upstream.

the return value of SNDRV_COMPRESS_VERSION always return default -ENOTTY as the
return value was never updated for this call
assign return value from put_user()

Reported-by: Haynes <hgeorge@codeaurora.org>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/core/compress_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index 54b422e..956c75d 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -584,7 +584,7 @@ static long snd_compr_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 	mutex_lock(&stream->device->lock);
 	switch (_IOC_NR(cmd)) {
 	case _IOC_NR(SNDRV_COMPRESS_IOCTL_VERSION):
-		put_user(SNDRV_COMPRESS_VERSION,
+		retval = put_user(SNDRV_COMPRESS_VERSION,
 				(int __user *)arg) ? -EFAULT : 0;
 		break;
 	case _IOC_NR(SNDRV_COMPRESS_GET_CAPS):
-- 
1.8.3.2

