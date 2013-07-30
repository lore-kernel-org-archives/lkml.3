Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab3G3Jdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:33:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53276 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525Ab3G3Jdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:32 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eldad Zack <eldad@fogrefinery.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 073/106] ALSA: usb-audio: 6fire: return correct XRUN indication
Date: Tue, 30 Jul 2013 10:31:32 +0100
Message-Id: <1375176725-5825-74-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eldad Zack <eldad@fogrefinery.com>

commit be2f93a4c4981b3646b6f98f477154411b8516cb upstream.

Return SNDRV_PCM_POS_XRUN (snd_pcm_uframes_t) instead of
SNDRV_PCM_STATE_XRUN (snd_pcm_state_t) from the pointer
function of 6fire, as expected by snd_pcm_update_hw_ptr0().

Caught by sparse.

Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/usb/6fire/pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/6fire/pcm.c b/sound/usb/6fire/pcm.c
index 3143d9c..7c4f311 100644
--- a/sound/usb/6fire/pcm.c
+++ b/sound/usb/6fire/pcm.c
@@ -540,7 +540,7 @@ static snd_pcm_uframes_t usb6fire_pcm_pointer(
 	snd_pcm_uframes_t ret;
 
 	if (rt->panic || !sub)
-		return SNDRV_PCM_STATE_XRUN;
+		return SNDRV_PCM_POS_XRUN;
 
 	spin_lock_irqsave(&sub->lock, flags);
 	ret = sub->dma_off;
-- 
1.8.3.2

