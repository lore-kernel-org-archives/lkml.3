Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740AbaELMlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 08:41:10 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37653 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403AbaELMlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 08:41:09 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] mm: remap_file_pages: initialize populate before usage
Date: Mon, 12 May 2014 08:40:54 -0400
Message-Id: <1399898454-14915-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'populate' wasn't initialized before being used in error paths,
causing panics when mm_populate() would get called with invalid
values.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 84dcfc7..2a0e0a8 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2591,7 +2591,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	unsigned long populate;
+	unsigned long populate = 0;
 	unsigned long ret = -EINVAL;
 
 	pr_warn_once("%s (%d) uses deprecated remap_file_pages() syscall. "
-- 
1.7.10.4

