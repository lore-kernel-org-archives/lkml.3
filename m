Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab3BKPES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 10:04:18 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:46446 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757120Ab3BKPER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 10:04:17 -0500
From: Denis Efremov <yefremov.denis@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Denis Efremov <yefremov.denis@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, linux-kernel@vger.kernel.org
Subject: [PATCH] [ALSA] sound: rme32.c irq enabling after spin_lock_irq
Date: Mon, 11 Feb 2013 19:04:06 +0400
Message-Id: <1360595046-25004-1-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the other code in this driver and similar
code in rme96 it seems, that spin_lock_irq in
snd_rme32_capture_close function should be paired
with spin_unlock_irq.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 sound/pci/rme32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/rme32.c b/sound/pci/rme32.c
index 2450663..0ecd410 100644
--- a/sound/pci/rme32.c
+++ b/sound/pci/rme32.c
@@ -1017,7 +1017,7 @@ static int snd_rme32_capture_close(struct snd_pcm_substream *substream)
 	spin_lock_irq(&rme32->lock);
 	rme32->capture_substream = NULL;
 	rme32->capture_periodsize = 0;
-	spin_unlock(&rme32->lock);
+	spin_unlock_irq(&rme32->lock);
 	return 0;
 }
 
-- 
1.8.1.2

