Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab3HBODt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:03:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293Ab3HBODr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:03:47 -0400
Date: Fri, 2 Aug 2013 16:05:25 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Mike Christie <michaelc@cs.wisc.edu>, Shaohua Li <shli@fusionio.com>
Subject: [PATCH 1/3] blk-mq: Sanity check reserved tags
Message-ID: <772b43a459f07a8496f67e948e28cce88714e78a.1375451955.git.agordeev@redhat.com>
References: <cover.1375451955.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1375451955.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 block/blk-mq-tag.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index dcbc2a4..6718007 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -335,6 +335,8 @@ static void __blk_mq_put_reserved_tag(struct blk_mq_tags *tags,
 {
 	unsigned long flags;
 
+	BUG_ON(tag >= tags->reserved_tags);
+
 	spin_lock_irqsave(&tags->lock, flags);
 	tags->reservelist[tags->nr_reserved] = tag;
 	tags->nr_reserved++;
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
