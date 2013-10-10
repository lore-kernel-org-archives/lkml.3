Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab3JJPo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:44:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52649 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab3JJPoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:44:54 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 056/104] ALSA: compress: Fix compress device unregister.
Date: Thu, 10 Oct 2013 08:41:44 -0700
Message-Id: <1381419752-29733-57-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liam Girdwood <liam.r.girdwood@linux.intel.com>

commit 4028b6c4c03f213260e9290ff3a6b5439aad07ce upstream.

snd_unregister_device() should return the device type and not stream
direction.

Signed-off-by: Liam Girdwood <liam.r.girdwood@linux.intel.com>
Acked-by: Vinod Koul <vinod.koul@intel.com>
Tested-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/core/compress_offload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index 2401d06..a388a87 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -689,7 +689,8 @@ static int snd_compress_dev_disconnect(struct snd_device *device)
 	struct snd_compr *compr;
 
 	compr = device->device_data;
-	snd_unregister_device(compr->direction, compr->card, compr->device);
+	snd_unregister_device(SNDRV_DEVICE_TYPE_COMPRESS, compr->card,
+		compr->device);
 	return 0;
 }
 
-- 
1.8.1.2

