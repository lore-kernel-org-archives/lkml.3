Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbbAVGaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 01:30:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbbAVGam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 01:30:42 -0500
From: WANG Chao <chaowang@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm, vmacache: Add kconfig VMACACHE_SHIFT
Date: Thu, 22 Jan 2015 14:29:49 +0800
Message-Id: <1421908189-18938-1-git-send-email-chaowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new kconfig option VMACACHE_SHIFT (as a power of 2) to specify the
number of slots vma cache has for each thread. Range is chosen 0-4 (1-16
slots) to consider both overhead and performance penalty. Default is 2
(4 slots) as it originally is, which provides good enough balance.

Signed-off-by: WANG Chao <chaowang@redhat.com>
---
 include/linux/sched.h | 2 +-
 mm/Kconfig            | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8db31ef..56fd96d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -134,7 +134,7 @@ struct perf_event_context;
 struct blk_plug;
 struct filename;
 
-#define VMACACHE_BITS 2
+#define VMACACHE_BITS CONFIG_VMACACHE_SHIFT
 #define VMACACHE_SIZE (1U << VMACACHE_BITS)
 #define VMACACHE_MASK (VMACACHE_SIZE - 1)
 
diff --git a/mm/Kconfig b/mm/Kconfig
index 1d1ae6b..7b82a52 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -618,3 +618,10 @@ config MAX_STACK_SIZE_MB
 	  changed to a smaller value in which case that is used.
 
 	  A sane initial value is 80 MB.
+
+config VMACACHE_SHIFT
+	int "Number of slots in per-thread VMA cache (as a power of 2)"
+	range 0 4
+	default 2
+	help
+	  This is the number of slots VMA cache has for each thread.
-- 
2.1.0

