Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbaAOWD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:03:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41476 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311AbaAOWAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:00:49 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: JongHo Kim <furmuwon@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 077/166] ALSA: Add SNDRV_PCM_STATE_PAUSED case in wait_for_avail function
Date: Wed, 15 Jan 2014 13:51:31 -0800
Message-Id: <1389822780-4729-78-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: JongHo Kim <furmuwon@gmail.com>

commit ed697e1aaf7237b1a62af39f64463b05c262808d upstream.

When the process is sleeping at the SNDRV_PCM_STATE_PAUSED
state from the wait_for_avail function, the sleep process will be woken by
timeout(10 seconds). Even if the sleep process wake up by timeout, by this
patch, the process will continue with sleep and wait for the other state.

Signed-off-by: JongHo Kim <furmuwon@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/core/pcm_lib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index c4840ff..4be58d2 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1904,6 +1904,8 @@ static int wait_for_avail(struct snd_pcm_substream *substream,
 		case SNDRV_PCM_STATE_DISCONNECTED:
 			err = -EBADFD;
 			goto _endloop;
+		case SNDRV_PCM_STATE_PAUSED:
+			continue;
 		}
 		if (!tout) {
 			snd_printd("%s write error (DMA or IRQ trouble?)\n",
-- 
1.8.3.2

