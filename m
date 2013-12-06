Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215Ab3LFX3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:29:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48958 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161563Ab3LFXUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:20:33 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 029/152] ALSA: 6fire: Fix probe of multiple cards
Date: Fri,  6 Dec 2013 15:09:13 -0800
Message-Id: <1386371476-2477-30-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 9b389a8a022110b4bc055a19b888283544d9eba6 upstream.

The probe code of snd-usb-6fire driver overrides the devices[] pointer
wrongly without checking whether it's already occupied or not.  This
would screw up the device disconnection later.

Spotted by coverity CID 141423.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/usb/6fire/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/6fire/chip.c b/sound/usb/6fire/chip.c
index 4394ae7..0716ba6 100644
--- a/sound/usb/6fire/chip.c
+++ b/sound/usb/6fire/chip.c
@@ -101,7 +101,7 @@ static int usb6fire_chip_probe(struct usb_interface *intf,
 			usb_set_intfdata(intf, chips[i]);
 			mutex_unlock(&register_mutex);
 			return 0;
-		} else if (regidx < 0)
+		} else if (!devices[i] && regidx < 0)
 			regidx = i;
 	}
 	if (regidx < 0) {
-- 
1.8.3.2

