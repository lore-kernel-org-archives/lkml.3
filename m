Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab3CDDwm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:52:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33092 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757065Ab3CDDoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:34 -0500
Message-Id: <20130304033712.039880700@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:52 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Denis Efremov <yefremov.denis@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 045/153] ALSA: ali5451: remove irq enabling in pointer callback
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

commit dacae5a19b4cbe1b5e3a86de23ea74cbe9ec9652 upstream.

snd_ali_pointer function is called with local
interrupts disabled. However it seems very strange to
reenable them in such way.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/ali5451/ali5451.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/ali5451/ali5451.c
+++ b/sound/pci/ali5451/ali5451.c
@@ -1435,7 +1435,7 @@ static snd_pcm_uframes_t snd_ali_pointer
 
 	spin_lock(&codec->reg_lock);
 	if (!pvoice->running) {
-		spin_unlock_irq(&codec->reg_lock);
+		spin_unlock(&codec->reg_lock);
 		return 0;
 	}
 	outb(pvoice->number, ALI_REG(codec, ALI_GC_CIR));


