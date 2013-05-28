Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229Ab3E1Hbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 03:31:38 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:51879 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759074Ab3E1Hbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 03:31:35 -0400
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: koverstreet@google.com
Cc: neilb@suse.de, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] md: bcache: io.c: fix a potential NULL pointer dereference
Date: Tue, 28 May 2013 00:31:15 -0700
Message-Id: <1369726275-5424-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bio_alloc_bioset returns NULL on failure. This fix adds a missing check
for potential NULL pointer dereferencing.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/md/bcache/io.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index 29f344b..4be2a07 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -98,6 +98,8 @@ struct bio *bch_bio_split(struct bio *bio, int sectors,
 
 	if (bio->bi_rw & REQ_DISCARD) {
 		ret = bio_alloc_bioset(gfp, 1, bs);
+		if (!ret)
+			return NULL;
 		idx = 0;
 		goto out;
 	}
-- 
1.7.10.4

