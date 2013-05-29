Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935307Ab3E2WaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:30:07 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:62342 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935320Ab3E2W36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:29:58 -0400
Subject: [PATCH] bio-integrity: Fix use of bs->bio_integrity_pool after free
To: Alexander Viro <viro@zeniv.linux.org.uk>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 29 May 2013 16:29:55 -0600
Message-ID: <20130529222955.10627.50429.stgit@bhelgaas-glaptop>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a copy and paste error introduced by 9f060e2231
("block: Convert integrity to bvec_alloc_bs()").

Found by Coverity (CID 1020654).

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 fs/bio-integrity.c |    2 +-
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
 

