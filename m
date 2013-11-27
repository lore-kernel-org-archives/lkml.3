Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760561Ab3K0BxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:53:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757759Ab3K0A5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 31/80] ALSA: 6fire: Fix probe of multiple cards
Date: Tue, 26 Nov 2013 16:57:00 -0800
Message-Id: <20131127005643.091332010@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 9b389a8a022110b4bc055a19b888283544d9eba6 upstream.

The probe code of snd-usb-6fire driver overrides the devices[] pointer
wrongly without checking whether it's already occupied or not.  This
would screw up the device disconnection later.

Spotted by coverity CID 141423.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/6fire/chip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/6fire/chip.c
+++ b/sound/usb/6fire/chip.c
@@ -101,7 +101,7 @@ static int usb6fire_chip_probe(struct us
 			usb_set_intfdata(intf, chips[i]);
 			mutex_unlock(&register_mutex);
 			return 0;
-		} else if (regidx < 0)
+		} else if (!devices[i] && regidx < 0)
 			regidx = i;
 	}
 	if (regidx < 0) {


