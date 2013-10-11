Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab3JKLED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:04:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58500 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab3JKKnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:43:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 036/100] ALSA: compress: Fix compress device unregister.
Date: Fri, 11 Oct 2013 11:41:06 +0100
Message-Id: <1381488130-30235-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liam Girdwood <liam.r.girdwood@linux.intel.com>

commit 4028b6c4c03f213260e9290ff3a6b5439aad07ce upstream.

snd_unregister_device() should return the device type and not stream
direction.

Signed-off-by: Liam Girdwood <liam.r.girdwood@linux.intel.com>
Acked-by: Vinod Koul <vinod.koul@intel.com>
Tested-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/core/compress_offload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index 956c75d..794f37a 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -665,7 +665,8 @@ static int snd_compress_dev_disconnect(struct snd_device *device)
 	struct snd_compr *compr;
 
 	compr = device->device_data;
-	snd_unregister_device(compr->direction, compr->card, compr->device);
+	snd_unregister_device(SNDRV_DEVICE_TYPE_COMPRESS, compr->card,
+		compr->device);
 	return 0;
 }
 
-- 
1.8.3.2

