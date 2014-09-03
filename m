Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbaICUdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 16:33:49 -0400
Received: from 6.77.broadband6.iol.cz ([88.101.77.6]:41603 "EHLO
	dhcp-27-160.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756356AbaICUds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 16:33:48 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] blk-mq: Fix formula to calculate fair share of tags
Date: Wed,  3 Sep 2014 22:33:07 +0200
Message-Id: <e8d8cf4c5c0491eabb6d1dba6fd44a3964837132.1409775956.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1409775956.git.agordeev@redhat.com>
References: <cover.1409775956.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fair share of tags is number of tags diveded on number
of users. Not sure why it is different.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-mq-tag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index d1eb579..1b9c949 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -127,7 +127,7 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
 	/*
 	 * Allow at least some tags
 	 */
-	depth = max((bt->depth + users - 1) / users, 4U);
+	depth = max(bt->depth / users, 4U);
 	return atomic_read(&hctx->nr_active) < depth;
 }
 
-- 
1.9.3

