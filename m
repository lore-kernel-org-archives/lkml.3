Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934292Ab3GWXKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 19:10:53 -0400
Received: from etezian.org ([198.101.225.253]:34975 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933386Ab3GWXKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 19:10:52 -0400
From: Andi Shyti <andi@etezian.org>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        andi@etezian.org
Subject: [PATCH] fs: bio-integrity: fix possible segmentation fault
Date: Wed, 24 Jul 2013 01:12:11 +0200
Message-Id: <1374621131-9938-1-git-send-email-andi@etezian.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free bvec_integrity_pool if it's allocated, not bio_integrity_pool

Signed-off-by: Andi Shyti <andi@etezian.org>
---
 fs/bio-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 8fb4291..45e944f 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -734,7 +734,7 @@ void bioset_integrity_free(struct bio_set *bs)
 		mempool_destroy(bs->bio_integrity_pool);
 
 	if (bs->bvec_integrity_pool)
-		mempool_destroy(bs->bio_integrity_pool);
+		mempool_destroy(bs->bvec_integrity_pool);
 }
 EXPORT_SYMBOL(bioset_integrity_free);
 
-- 
1.8.3.2

