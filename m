Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbaIWCy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:54:29 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45772 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaIWCy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:54:26 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: akpm@linuxfoundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] mm: build error in dump_mm without CONFIG_COMPACTION
Date: Mon, 22 Sep 2014 22:54:15 -0400
Message-Id: <1411440855-27430-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of CONFIG_NUMA_BALANCING set and CONFIG_COMPACTION isn't,
we'd fail to put a "," at the end of the formatting string and cause
a build failure.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 mm/debug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/debug.c b/mm/debug.c
index 544d8f6..8fbc417 100644
--- a/mm/debug.c
+++ b/mm/debug.c
@@ -192,9 +192,9 @@ void dump_mm(const struct mm_struct *mm)
 		"numa_next_scan %lu numa_scan_offset %lu numa_scan_seq %d\n"
 #endif
 #if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
-		"tlb_flush_pending %d\n",
+		"tlb_flush_pending %d\n"
 #endif
-		mm, mm->mmap, mm->vmacache_seqnum, mm->task_size,
+		, mm, mm->mmap, mm->vmacache_seqnum, mm->task_size,
 #ifdef CONFIG_MMU
 		mm->get_unmapped_area,
 #endif
-- 
1.7.10.4

