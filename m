Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab3LTW1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 17:27:13 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50022 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab3LTW1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 17:27:11 -0500
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, Olof Johansson <olof@lixom.net>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>
Subject: [PATCH] mm: fix build of split ptlock code
Date: Fri, 20 Dec 2013 14:28:05 -0800
Message-Id: <1387578485-11829-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 597d795a2a78 ('mm: do not allocate page->ptl dynamically, if
spinlock_t fits to long') restructures some allocators that are compiled
even if USE_SPLIT_PTLOCKS arn't used. It results in compilation failure:

mm/memory.c:4282:6: error: 'struct page' has no member named 'ptl'
mm/memory.c:4288:12: error: 'struct page' has no member named 'ptl'

Add in the missing ifdef.

Fixes: 597d795a2a78 ('mm: do not allocate page->ptl dynamically, if spinlock_t fits to long')
Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
---
 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index b6e211b..6768ce9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4271,7 +4271,7 @@ void copy_user_huge_page(struct page *dst, struct page *src,
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
-#if ALLOC_SPLIT_PTLOCKS
+#if USE_SPLIT_PTE_PTLOCKS && ALLOC_SPLIT_PTLOCKS
 bool ptlock_alloc(struct page *page)
 {
 	spinlock_t *ptl;
-- 
1.7.10.4

