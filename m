Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbaFPHRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 03:17:47 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:41854 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbaFPHRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 03:17:45 -0400
From: Hoang Tran <hoangtran.gwr@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan <alan@linux.intel.com>, Garret Kelly <garret.kelly@gmail.com>,
        Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
        Jun Tian <jun.j.tian@intel.com>
Cc: Hoang Tran <hoangtran.gwr@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: goldfish: fix coding style.
Date: Mon, 16 Jun 2014 15:18:37 +0800
Message-Id: <1402903117-16073-1-git-send-email-hoangtran.gwr@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using an else following a break or return can unnecessarily
indent code blocks.

This patch fixes coding style reported by checkpatch.pl, a part
of eudyptula challenge.

Signed-off-by: Hoang Tran <hoangtran.gwr@gmail.com>
---
 drivers/staging/goldfish/goldfish_audio.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/goldfish/goldfish_audio.c b/drivers/staging/goldfish/goldfish_audio.c
index cbd4567..a166424 100644
--- a/drivers/staging/goldfish/goldfish_audio.c
+++ b/drivers/staging/goldfish/goldfish_audio.c
@@ -203,10 +203,10 @@ static int goldfish_audio_open(struct inode *ip, struct file *fp)
 					     AUDIO_INT_WRITE_BUFFER_2_EMPTY);
 		AUDIO_WRITE(audio_data, AUDIO_INT_ENABLE, AUDIO_INT_MASK);
 		return 0;
-	} else {
-		atomic_dec(&open_count);
-		return -EBUSY;
 	}
+
+	atomic_dec(&open_count);
+	return -EBUSY;
 }
 
 static int goldfish_audio_release(struct inode *ip, struct file *fp)
@@ -223,8 +223,8 @@ static long goldfish_audio_ioctl(struct file *fp, unsigned int cmd,
 	/* temporary workaround, until we switch to the ALSA API */
 	if (cmd == 315)
 		return -1;
-	else
-		return 0;
+
+	return 0;
 }
 
 static irqreturn_t goldfish_audio_interrupt(int irq, void *dev_id)
-- 
2.0.0

