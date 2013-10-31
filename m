Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab3JaMz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 08:55:27 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:55323 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab3JaMzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:55:21 -0400
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH 1/2] mm: fix the incorrect function name in alloc_low_pages()
Date: Thu, 31 Oct 2013 20:52:32 +0800
Message-Id: <1383223953-28803-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103112-0928-0000-0000-0000031E8171
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 arch/x86/mm/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 04664cd..64d860f 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -53,12 +53,12 @@ __ref void *alloc_low_pages(unsigned int num)
 	if ((pgt_buf_end + num) > pgt_buf_top || !can_use_brk_pgt) {
 		unsigned long ret;
 		if (min_pfn_mapped >= max_pfn_mapped)
-			panic("alloc_low_page: ran out of memory");
+			panic("alloc_low_pages: ran out of memory");
 		ret = memblock_find_in_range(min_pfn_mapped << PAGE_SHIFT,
 					max_pfn_mapped << PAGE_SHIFT,
 					PAGE_SIZE * num , PAGE_SIZE);
 		if (!ret)
-			panic("alloc_low_page: can not alloc memory");
+			panic("alloc_low_pages: can not alloc memory");
 		memblock_reserve(ret, PAGE_SIZE * num);
 		pfn = ret >> PAGE_SHIFT;
 	} else {
-- 
1.7.11.7

