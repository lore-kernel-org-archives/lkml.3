Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606Ab3B0AIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:08:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42667 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933431Ab3B0AIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:08:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Denis Efremov <yefremov.denis@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 11/86] ALSA: rme32.c irq enabling after spin_lock_irq
Date: Tue, 26 Feb 2013 16:07:19 -0800
Message-Id: <20130226235914.076603976@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
 


