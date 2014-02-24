Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbaBXPnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:43:52 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35449 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbaBXPkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:40:12 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 02/11] block: Remove useless IPI struct initialization
Date: Mon, 24 Feb 2014 16:39:53 +0100
Message-Id: <1393256402-16907-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1393256402-16907-1-git-send-email-fweisbec@gmail.com>
References: <1393256402-16907-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rq_fifo_clear() reset the csd.list through INIT_LIST_HEAD for no clear
purpose. The csd.list doesn't need to be initialized as a list head
because it's only ever used as a list node.

Lets remove this useless initialization.

Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@fb.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/elevator.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 0bdfd46..df63bd3 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -203,10 +203,7 @@ enum {
 #define rb_entry_rq(node)	rb_entry((node), struct request, rb_node)
 
 #define rq_entry_fifo(ptr)	list_entry((ptr), struct request, queuelist)
-#define rq_fifo_clear(rq)	do {		\
-	list_del_init(&(rq)->queuelist);	\
-	INIT_LIST_HEAD(&(rq)->csd.list);	\
-	} while (0)
+#define rq_fifo_clear(rq)	list_del_init(&(rq)->queuelist)
 
 #else /* CONFIG_BLOCK */
 
-- 
1.8.3.1

