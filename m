Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab3EIWNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:13:34 -0400
Received: from longford.logfs.org ([213.229.74.203]:59114 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab3EIWNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:13:32 -0400
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>,
        Joern Engel <joern@logfs.org>
Subject: [PATCH 05/14] blockconsole: use CON_ALLDATA
Date: Thu,  9 May 2013 16:43:03 -0400
Message-Id: <1368132193-25817-8-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1368132193-25817-1-git-send-email-joern@logfs.org>
References: <1368132193-25817-1-git-send-email-joern@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Blockconsole should really see every message ever printed.  The
alternative is to try debugging with information like this:
[166135.633974] Stack:
[166135.634016] Call Trace:
[166135.634029]  <IRQ>
[166135.634156]  <EOI>
[166135.634177] Code: 00 00 55 48 89 e5 0f 1f 44 00 00 ff 15 31 49 80 00 c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 1f 44 00 00
[166135.634384]  48 8b 14 25 98 24 01 00 48 8d 14 92 48 8d 04 bd 00 00 00 00

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/block/blockconsole.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/blockconsole.c b/drivers/block/blockconsole.c
index 7f8ac5b..32f6c62 100644
--- a/drivers/block/blockconsole.c
+++ b/drivers/block/blockconsole.c
@@ -481,7 +481,7 @@ static int bcon_create(const char *devname)
 	strlcpy(bc->devname, devname, sizeof(bc->devname));
 	spin_lock_init(&bc->end_io_lock);
 	strcpy(bc->console.name, "bcon");
-	bc->console.flags = CON_PRINTBUFFER | CON_ENABLED;
+	bc->console.flags = CON_PRINTBUFFER | CON_ENABLED | CON_ALLDATA;
 	bc->console.write = bcon_write;
 	bc->bdev = blkdev_get_by_path(devname, mode, NULL);
 #ifndef MODULE
-- 
1.7.10.4

