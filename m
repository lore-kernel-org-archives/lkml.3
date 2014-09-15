Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbaIOWNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:13:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50758 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327AbaIOWNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:13:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Qiao Zhou <zhouqiao@marvell.com>, Mark Brown <broonie@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 055/187] ASoC: pcm: fix dpcm_path_put in dpcm runtime update
Date: Mon, 15 Sep 2014 15:07:45 -0700
Message-Id: <1410818997-9432-56-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiao Zhou <zhouqiao@marvell.com>

commit 7ed9de76ff342cbd717a9cf897044b99272cb8f8 upstream.

we need to release dapm widget list after dpcm_path_get in
soc_dpcm_runtime_update. otherwise, there will be potential memory
leak. add dpcm_path_put to fix it.

Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/soc-pcm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 891b9a9..e683959 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1908,6 +1908,7 @@ int soc_dpcm_runtime_update(struct snd_soc_card *card)
 			dpcm_be_disconnect(fe, SNDRV_PCM_STREAM_PLAYBACK);
 		}
 
+		dpcm_path_put(&list);
 capture:
 		/* skip if FE doesn't have capture capability */
 		if (!fe->cpu_dai->driver->capture.channels_min)
-- 
1.9.1

