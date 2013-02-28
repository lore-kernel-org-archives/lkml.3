Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760507Ab3B1PRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:17:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42035 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab3B1OrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:47:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Denis Efremov <yefremov.denis@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 038/139] ALSA: rme32.c irq enabling after spin_lock_irq
Date: Thu, 28 Feb 2013 14:43:08 +0000
Message-Id: <1362062689-2567-39-git-send-email-luis.henriques@canonical.com>
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

commit f49a59c4471d81a233e09dda45187cc44fda009d upstream.

According to the other code in this driver and similar
code in rme96 it seems, that spin_lock_irq in
snd_rme32_capture_close function should be paired
with spin_unlock_irq.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/rme32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/rme32.c b/sound/pci/rme32.c
index 46b3629..f1dec07 100644
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

