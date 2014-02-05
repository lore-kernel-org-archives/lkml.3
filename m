Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbaBEUvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:51:33 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48242 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbaBEUGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:00 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Wen Congyang <wency@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 097/213] tracing: Don't call page_to_pfn() if page is NULL
Date: Wed, 5 Feb 2014 15:00:52 -0500
Message-ID: <1391630568-49251-98-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wen Congyang <wency@cn.fujitsu.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 85f2a2ef1d0ab99523e0b947a2b723f5650ed6aa upstream.

When allocating memory fails, page is NULL. page_to_pfn() will
cause the kernel panicked if we don't use sparsemem vmemmap.

Link: http://lkml.kernel.org/r/505AB1FF.8020104@cn.fujitsu.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/trace/events/kmem.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index 3adca0ca9dbe..2018784c931a 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -250,7 +250,7 @@ TRACE_EVENT(mm_page_alloc,
 
 	TP_printk("page=%p pfn=%lu order=%d migratetype=%d gfp_flags=%s",
 		__entry->page,
-		page_to_pfn(__entry->page),
+		__entry->page ? page_to_pfn(__entry->page) : 0,
 		__entry->order,
 		__entry->migratetype,
 		show_gfp_flags(__entry->gfp_flags))
@@ -276,7 +276,7 @@ DECLARE_EVENT_CLASS(mm_page,
 
 	TP_printk("page=%p pfn=%lu order=%u migratetype=%d percpu_refill=%d",
 		__entry->page,
-		page_to_pfn(__entry->page),
+		__entry->page ? page_to_pfn(__entry->page) : 0,
 		__entry->order,
 		__entry->migratetype,
 		__entry->order == 0)
-- 
1.8.5.2

