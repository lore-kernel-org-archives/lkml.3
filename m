Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbaF3MRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:17:34 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51945 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753248AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.12 002/181] Revert "bio-integrity: Fix bio_integrity_verify segment start bug"
Date: Mon, 30 Jun 2014 13:50:23 +0200
Message-Id: <63a97385b3919335ff2a1d502925de4dc3ef4fd4.1404128997.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

This reverts commit 7cbcb219e4113e10ce4b036118992abdbc4a8273,
misapplied upstream commit 5837c80e870bc3b12ac6a98cdc9ce7a9522a8fb6.

The upstream commit was applied twice to stable-3.12, the second time
to bio_integrity_generate. Revert this second application.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/bio-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index b5ee393e2e8d..76273c1d26a6 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -316,7 +316,7 @@ static void bio_integrity_generate(struct bio *bio)
 	bix.disk_name = bio->bi_bdev->bd_disk->disk_name;
 	bix.sector_size = bi->sector_size;
 
-	bio_for_each_segment_all(bv, bio, i) {
+	bio_for_each_segment(bv, bio, i) {
 		void *kaddr = kmap_atomic(bv->bv_page);
 		bix.data_buf = kaddr + bv->bv_offset;
 		bix.data_size = bv->bv_len;
-- 
2.0.0

