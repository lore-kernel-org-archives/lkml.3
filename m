Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab3CDDvi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:51:38 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33109 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757124Ab3CDDoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:38 -0500
Message-Id: <20130304033711.938419756@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:51 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Denis Efremov <yefremov.denis@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 044/153] ALSA: rme32.c irq enabling after spin_lock_irq
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/rme32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/rme32.c
+++ b/sound/pci/rme32.c
@@ -1017,7 +1017,7 @@ static int snd_rme32_capture_close(struc
 	spin_lock_irq(&rme32->lock);
 	rme32->capture_substream = NULL;
 	rme32->capture_periodsize = 0;
-	spin_unlock(&rme32->lock);
+	spin_unlock_irq(&rme32->lock);
 	return 0;
 }
 


