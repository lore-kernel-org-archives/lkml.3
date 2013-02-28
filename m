Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab3B1Or2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:47:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42040 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3B1OrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:47:22 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Denis Efremov <yefremov.denis@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 039/139] ALSA: ali5451: remove irq enabling in pointer callback
Date: Thu, 28 Feb 2013 14:43:09 +0000
Message-Id: <1362062689-2567-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Efremov <yefremov.denis@gmail.com>

commit dacae5a19b4cbe1b5e3a86de23ea74cbe9ec9652 upstream.

snd_ali_pointer function is called with local
interrupts disabled. However it seems very strange to
reenable them in such way.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/ali5451/ali5451.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/ali5451/ali5451.c b/sound/pci/ali5451/ali5451.c
index 9dfc27b..2c4dd6b 100644
--- a/sound/pci/ali5451/ali5451.c
+++ b/sound/pci/ali5451/ali5451.c
@@ -1435,7 +1435,7 @@ static snd_pcm_uframes_t snd_ali_pointer(struct snd_pcm_substream *substream)
 
 	spin_lock(&codec->reg_lock);
 	if (!pvoice->running) {
-		spin_unlock_irq(&codec->reg_lock);
+		spin_unlock(&codec->reg_lock);
 		return 0;
 	}
 	outb(pvoice->number, ALI_REG(codec, ALI_GC_CIR));
-- 
1.8.1.2

