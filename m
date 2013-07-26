Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131Ab3GZUzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:55:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51029 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933060Ab3GZUyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:54:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eldad Zack <eldad@fogrefinery.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 59/59] ALSA: usb-audio: 6fire: return correct XRUN indication
Date: Fri, 26 Jul 2013 13:53:23 -0700
Message-Id: <20130726205020.147187537@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726205013.795696531@linuxfoundation.org>
References: <20130726205013.795696531@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eldad Zack <eldad@fogrefinery.com>

commit be2f93a4c4981b3646b6f98f477154411b8516cb upstream.

Return SNDRV_PCM_POS_XRUN (snd_pcm_uframes_t) instead of
SNDRV_PCM_STATE_XRUN (snd_pcm_state_t) from the pointer
function of 6fire, as expected by snd_pcm_update_hw_ptr0().

Caught by sparse.

Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/6fire/pcm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/6fire/pcm.c
+++ b/sound/usb/6fire/pcm.c
@@ -540,7 +540,7 @@ static snd_pcm_uframes_t usb6fire_pcm_po
 	snd_pcm_uframes_t ret;
 
 	if (rt->panic || !sub)
-		return SNDRV_PCM_STATE_XRUN;
+		return SNDRV_PCM_POS_XRUN;
 
 	spin_lock_irqsave(&sub->lock, flags);
 	ret = sub->dma_off;


