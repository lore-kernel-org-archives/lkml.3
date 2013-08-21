Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab3HUP0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:26:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab3HUP0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:26:47 -0400
Date: Wed, 21 Aug 2013 17:28:18 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Mike Christie <michaelc@cs.wisc.edu>, Shaohua Li <shli@fusionio.com>
Subject: [PATCH 5/5] blk-mq: Lower minimum queue depth from 4 to 1
Message-ID: <20130821152817.GC27943@dhcp-26-207.brq.redhat.com>
References: <cover.1375451955.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1375451955.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to limit minimum queue depth.
Indeed, some ATA devices ask for the depth of 1.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 block/blk-mq-tag.c |    2 +-
 block/blk-mq-tag.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index e74e18e..a115862 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -456,7 +456,7 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 	tags->nr_tags = total_tags;
 	tags->reserved_tags = reserved_tags;
 	tags->max_cache = nr_cache;
-	tags->batch_move = nr_cache / 2;
+	tags->batch_move = max(1u, nr_cache / 2);
 
 	/*
 	 * Reserved tags are first
diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
index 716ea79..947ba2c 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -14,7 +14,7 @@ extern bool blk_mq_has_free_tags(struct blk_mq_tags *tags);
 extern ssize_t blk_mq_tag_sysfs_show(struct blk_mq_tags *tags, char *page);
 
 enum {
-	BLK_MQ_TAG_CACHE_MIN	= 4,
+	BLK_MQ_TAG_CACHE_MIN	= 1,
 	BLK_MQ_TAG_CACHE_MAX	= 64,
 };
 
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
