Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab3CYN4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 09:56:41 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:36047 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974Ab3CYN4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 09:56:40 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] sound: oss: sb_common: Used kmemdup instead of kmalloc and memcpy
Date: Mon, 25 Mar 2013 15:50:34 +0200
Message-Id: <1364219434-11920-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used kmemdup instead of replicating it's behaviour with kmalloc followed
by memcpy.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 sound/oss/sb_common.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/oss/sb_common.c b/sound/oss/sb_common.c
index 7d42c54..851a1da 100644
--- a/sound/oss/sb_common.c
+++ b/sound/oss/sb_common.c
@@ -626,13 +626,12 @@ int sb_dsp_detect(struct address_info *hw_config, int pci, int pciio, struct sb_
 	 */
 
 
-	detected_devc = kmalloc(sizeof(sb_devc), GFP_KERNEL);
+	detected_devc = kmemdup(devc, sizeof(sb_devc), GFP_KERNEL);
 	if (detected_devc == NULL)
 	{
 		printk(KERN_ERR "sb: Can't allocate memory for device information\n");
 		return 0;
 	}
-	memcpy(detected_devc, devc, sizeof(sb_devc));
 	MDB(printk(KERN_INFO "SB %d.%02d detected OK (%x)\n", devc->major, devc->minor, hw_config->io_base));
 	return 1;
 }
-- 
1.7.9.5

