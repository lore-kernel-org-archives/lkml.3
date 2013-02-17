Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab3BQNd4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 08:33:56 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:42828 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab3BQNdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 08:33:54 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: tiwai@suse.de
Cc: perex@perex.cz, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Damien Zammit <damien@zamaudio.com>
Subject: [PATCH] sound: usb/quirks, fix out-of-bounds access
Date: Sun, 17 Feb 2013 14:33:04 +0100
Message-Id: <1361107984-25163-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bootresponse in snd_usb_mbox2_boot_quirk is only 12 (decimal) u8's
long, but i9s passed to snd_usb_ctl_msg as it would be 0x12 (hexa)
long. Fix that by having proper size of the array, i.e. 0x12.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Damien Zammit <damien@zamaudio.com>
Cc: Takashi Iwai <tiwai@suse.de>
---
 sound/usb/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 2c97185..0115289 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -533,7 +533,7 @@ static int snd_usb_mbox2_boot_quirk(struct usb_device *dev)
 {
 	struct usb_host_config *config = dev->actconfig;
 	int err;
-	u8 bootresponse[12];
+	u8 bootresponse[0x12];
 	int fwsize;
 	int count;
 
-- 
1.8.1.2


