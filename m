Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab3HQADR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:03:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51770 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955Ab3HPWkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:40:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vinod Koul <vinod.koul@intel.com>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 065/133] ALSA: compress: fix the return value for SNDRV_COMPRESS_VERSION
Date: Fri, 16 Aug 2013 15:33:27 -0700
Message-Id: <1376692475-28413-66-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinod Koul <vinod.koul@intel.com>

commit a8d30608eaed6cc759b8e2e8a8bbbb42591f797f upstream.

the return value of SNDRV_COMPRESS_VERSION always return default -ENOTTY as the
return value was never updated for this call
assign return value from put_user()

Reported-by: Haynes <hgeorge@codeaurora.org>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/core/compress_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index ad11dc9..2401d06 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -608,7 +608,7 @@ static long snd_compr_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 	mutex_lock(&stream->device->lock);
 	switch (_IOC_NR(cmd)) {
 	case _IOC_NR(SNDRV_COMPRESS_IOCTL_VERSION):
-		put_user(SNDRV_COMPRESS_VERSION,
+		retval = put_user(SNDRV_COMPRESS_VERSION,
 				(int __user *)arg) ? -EFAULT : 0;
 		break;
 	case _IOC_NR(SNDRV_COMPRESS_GET_CAPS):
-- 
1.8.1.2

