Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaGZOGX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:06:23 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:63350 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaGZOGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:06:20 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Jens Axboe <axboe@kernel.dk>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] block: bsg.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:07:45 +0200
Message-Id: <1406383665-1670-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 block/bsg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bsg.c b/block/bsg.c
index ff46add..b2688c5 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -790,7 +790,7 @@ static struct bsg_device *bsg_add_device(struct inode *inode,
 	mutex_lock(&bsg_mutex);
 	hlist_add_head(&bd->dev_list, bsg_dev_idx_hash(iminor(inode)));
 
-	strncpy(bd->name, dev_name(rq->bsg_dev.class_dev), sizeof(bd->name) - 1);
+	strlcpy(bd->name, dev_name(rq->bsg_dev.class_dev), sizeof(bd->name));
 	dprintk("bound to <%s>, max queue %d\n",
 		format_dev_t(buf, inode->i_rdev), bd->max_queue);
 
-- 
1.7.10.4

