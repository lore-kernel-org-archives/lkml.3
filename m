Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaBXPkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:40:21 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:45479 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbaBXPkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:40:17 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jens Axboe <axboe@fb.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 05/11] smp: Remove unused list_head from csd
Date: Mon, 24 Feb 2014 16:39:56 +0100
Message-Id: <1393256402-16907-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1393256402-16907-1-git-send-email-fweisbec@gmail.com>
References: <1393256402-16907-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

Now that we got rid of all the remaining code which fiddled with csd.list,
lets remove it.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jens Axboe <axboe@fb.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/smp.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 6ae004e..4991c6b 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -17,10 +17,7 @@ extern void cpu_idle(void);
 
 typedef void (*smp_call_func_t)(void *info);
 struct call_single_data {
-	union {
-		struct list_head list;
-		struct llist_node llist;
-	};
+	struct llist_node llist;
 	smp_call_func_t func;
 	void *info;
 	u16 flags;
-- 
1.8.3.1

