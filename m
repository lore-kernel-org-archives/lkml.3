Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760055Ab3BZX5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:57:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41738 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756969Ab3BZX5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Denis Efremov <yefremov.denis@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 012/150] ALSA: ali5451: remove irq enabling in pointer callback
Date: Tue, 26 Feb 2013 15:54:29 -0800
Message-Id: <20130226235525.433681787@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Efremov <yefremov.denis@gmail.com>

commit dacae5a19b4cbe1b5e3a86de23ea74cbe9ec9652 upstream.

snd_ali_pointer function is called with local
interrupts disabled. However it seems very strange to
reenable them in such way.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


