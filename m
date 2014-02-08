Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaBHQVG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 11:21:06 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:56240 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbaBHQSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 11:18:53 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jens Axboe <jens.axboe@oracle.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 05/11] smp: Remove unused list_head from csd
Date: Sat,  8 Feb 2014 17:18:34 +0100
Message-Id: <1391876320-25068-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1391876320-25068-1-git-send-email-fweisbec@gmail.com>
References: <1391876320-25068-1-git-send-email-fweisbec@gmail.com>
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
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/smp.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 3834f43..9a1b8ba 100644
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

