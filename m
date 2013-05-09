Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3EIWOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:14:08 -0400
Received: from longford.logfs.org ([213.229.74.203]:59129 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab3EIWOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:14:04 -0400
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>,
        Joern Engel <joern@logfs.org>
Subject: [PATCH 13/14] bcon: Fix wrap-around behaviour
Date: Thu,  9 May 2013 16:43:11 -0400
Message-Id: <1368132193-25817-16-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1368132193-25817-1-git-send-email-joern@logfs.org>
References: <1368132193-25817-1-git-send-email-joern@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This seems to have broken around the introduction of format 1.1.  When
wrapping around, we should increment the wrap counter before writing it
out, not after.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/block/blockconsole.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/blockconsole.c b/drivers/block/blockconsole.c
index 01ddbc6..65f8ace 100644
--- a/drivers/block/blockconsole.c
+++ b/drivers/block/blockconsole.c
@@ -229,8 +229,8 @@ static void bcon_advance_write_bytes(struct blockconsole *bc, int bytes)
 	bc->write_bytes += bytes;
 	if (bc->write_bytes >= bc->max_bytes) {
 		bc->write_bytes = 0;
-		bcon_init_first_page(bc);
 		bc->round++;
+		bcon_init_first_page(bc);
 	}
 }
 
-- 
1.7.10.4

