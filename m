Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab3JVWgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:36:03 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:33010 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab3JVWf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:35:59 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, linux-bcache@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH] bcache: Fixed incorrect order of arguments to bio_alloc_bioset()
Date: Tue, 22 Oct 2013 15:35:50 -0700
Message-Id: <1382481353-4300-1-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: linux-stable <stable@vger.kernel.org> # >= v3.10
---
 drivers/md/bcache/request.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index b6a74bc..2a7f0dd 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1000,7 +1000,7 @@ static void request_write(struct cached_dev *dc, struct search *s)
 
 		if (bio->bi_rw & REQ_FLUSH) {
 			/* Also need to send a flush to the backing device */
-			struct bio *flush = bio_alloc_bioset(0, GFP_NOIO,
+			struct bio *flush = bio_alloc_bioset(GFP_NOIO, 0,
 							     dc->disk.bio_split);
 
 			flush->bi_rw	= WRITE_FLUSH;
-- 
1.8.4.rc3

