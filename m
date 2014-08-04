Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbaHDAWB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 20:22:01 -0400
Received: from s87.loopia.se ([194.9.94.112]:61806 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857AbaHDAV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 20:21:59 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: clemens@ladisch.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 19/19] alsa: riptide: fix %d confusingly prefixed with 0x in format strings
Date: Sun,  3 Aug 2014 17:21:25 -0700
Message-Id: <1407111685-15351-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 sound/firewire/fireworks/fireworks_proc.c | 4 ++--
 sound/pci/riptide/riptide.c               | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/firewire/fireworks/fireworks_proc.c b/sound/firewire/fireworks/fireworks_proc.c
index 02bf394..23bb274 100644
--- a/sound/firewire/fireworks/fireworks_proc.c
+++ b/sound/firewire/fireworks/fireworks_proc.c
@@ -64,7 +64,7 @@ proc_read_hwinfo(struct snd_info_entry *entry, struct snd_info_buffer *buffer)
 		    hwinfo->phys_in_grp_count);
 	for (i = 0; i < hwinfo->phys_in_grp_count; i++) {
 		snd_iprintf(buffer,
-			    "phys in grp[0x%d]: type 0x%d, count 0x%x\n",
+			    "phys in grp[0x%x]: type 0x%x, count 0x%x\n",
 			    i, hwinfo->phys_out_grps[i].type,
 			    hwinfo->phys_out_grps[i].count);
 	}
@@ -73,7 +73,7 @@ proc_read_hwinfo(struct snd_info_entry *entry, struct snd_info_buffer *buffer)
 		    hwinfo->phys_out_grp_count);
 	for (i = 0; i < hwinfo->phys_out_grp_count; i++) {
 		snd_iprintf(buffer,
-			    "phys out grps[0x%d]: type 0x%d, count 0x%x\n",
+			    "phys out grps[0x%x]: type 0x%x, count 0x%x\n",
 			    i, hwinfo->phys_out_grps[i].type,
 			    hwinfo->phys_out_grps[i].count);
 	}
diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
index b4a8278..f0315c3 100644
--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -941,7 +941,7 @@ setmixer(struct cmdif *cif, short num, unsigned short rval, unsigned short lval)
 	union cmdret rptr = CMDRET_ZERO;
 	int i = 0;
 
-	snd_printdd("sent mixer %d: 0x%d 0x%d\n", num, rval, lval);
+	snd_printdd("sent mixer %d: 0x%x 0x%x\n", num, rval, lval);
 	do {
 		SEND_SDGV(cif, num, num, rval, lval);
 		SEND_RDGV(cif, num, num, &rptr);
@@ -1080,7 +1080,7 @@ getmixer(struct cmdif *cif, short num, unsigned short *rval,
 		return -EIO;
 	*rval = rptr.retwords[0];
 	*lval = rptr.retwords[1];
-	snd_printdd("got mixer %d: 0x%d 0x%d\n", num, *rval, *lval);
+	snd_printdd("got mixer %d: 0x%x 0x%x\n", num, *rval, *lval);
 	return 0;
 }
 
-- 
2.0.0.526.g5318336

