Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbaICUdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 16:33:47 -0400
Received: from 6.77.broadband6.iol.cz ([88.101.77.6]:41600 "EHLO
	dhcp-27-160.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756327AbaICUdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 16:33:45 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] blk-mq: Eliminate superfluous check of BLK_MQ_S_TAG_ACTIVE flag
Date: Wed,  3 Sep 2014 22:33:06 +0200
Message-Id: <871ad1488e7050fa53412b891bf3d0a46dea8bcd.1409775956.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1409775956.git.agordeev@redhat.com>
References: <cover.1409775956.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-mq-tag.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 4953b64..d1eb579 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -60,8 +60,7 @@ static inline void bt_index_atomic_inc(atomic_t *index)
  */
 void __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
 {
-	if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state) &&
-	    !test_and_set_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
+	if (!test_and_set_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
 		atomic_inc(&hctx->tags->active_queues);
 }
 
-- 
1.9.3

