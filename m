Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697Ab3BKPub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 10:50:31 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:35717 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757643Ab3BKPu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 10:50:29 -0500
From: Denis Efremov <yefremov.denis@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Denis Efremov <yefremov.denis@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, linux-kernel@vger.kernel.org
Subject: [PATCH] ALSA: ali5451: remove irq enabling in pointer callback
Date: Mon, 11 Feb 2013 19:49:48 +0400
Message-Id: <1360597788-25614-1-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

snd_ali_pointer function is called with local
interrupts disabled. However it seems very strange to
reenable them in such way.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 sound/pci/ali5451/ali5451.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/ali5451/ali5451.c b/sound/pci/ali5451/ali5451.c
index 136a393..e760af9 100644
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

