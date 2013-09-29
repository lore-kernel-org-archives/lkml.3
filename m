Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab3I2TaF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:30:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146Ab3I2T3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kent Overstreet <koverstreet@google.com>, Jens Axboe <axboe@kernel.dk>,
        Jonghwan Choi <jhbird.choi@gmail.com>
Subject: [ 63/71] bio-integrity: Fix use of bs->bio_integrity_pool after free
Date: Sun, 29 Sep 2013 12:28:15 -0700
Message-Id: <20130929192647.840758285@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit adbe6991efd36104ac9eaf751993d35eaa7f493a upstream.

This fixes a copy and paste error introduced by 9f060e2231
("block: Convert integrity to bvec_alloc_bs()").

Found by Coverity (CID 1020654).

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Jonghwan Choi <jhbird.choi@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/bio-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -734,7 +734,7 @@ void bioset_integrity_free(struct bio_se
 		mempool_destroy(bs->bio_integrity_pool);
 
 	if (bs->bvec_integrity_pool)
-		mempool_destroy(bs->bio_integrity_pool);
+		mempool_destroy(bs->bvec_integrity_pool);
 }
 EXPORT_SYMBOL(bioset_integrity_free);
 


