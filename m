Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122AbaKBGez (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 01:34:55 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:42467 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaKBGey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 01:34:54 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: Intel: fix missing mutex
Date: Sun,  2 Nov 2014 12:04:41 +0530
Message-Id: <1414910081-2487-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on error in block prepare, we were returning the error code while still
holding the mutex. We are releasing the mutex in this patch before
return.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 sound/soc/intel/sst-firmware.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/sst-firmware.c b/sound/soc/intel/sst-firmware.c
index 35788ad..dca6d9a 100644
--- a/sound/soc/intel/sst-firmware.c
+++ b/sound/soc/intel/sst-firmware.c
@@ -1120,6 +1120,7 @@ int sst_block_alloc_scratch(struct sst_dsp *dsp)
 	ret = block_list_prepare(dsp, &dsp->scratch_block_list);
 	if (ret < 0) {
 		dev_err(dsp->dev, "error: scratch block prepare failed\n");
+		mutex_unlock(&dsp->mutex);
 		return ret;
 	}
 
-- 
1.8.1.2

