Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809AbaLAW6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:58:17 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:51202 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932768AbaLAW6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:58:09 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>,
        Michel Lespinasse <walken@google.com>, Jan Kara <jack@suse.cz>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 2/3] mm: memory: remove ->vm_file check on shared writable vmas
Date: Mon,  1 Dec 2014 17:58:01 -0500
Message-Id: <1417474682-29326-2-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417474682-29326-1-git-send-email-hannes@cmpxchg.org>
References: <1417474682-29326-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only way a VMA can have shared and writable semantics is with a
backing file.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memory.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 73220eb6e9e3..2a2e3648ed65 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2167,9 +2167,7 @@ reuse:
 				balance_dirty_pages_ratelimited(mapping);
 			}
 
-			/* file_update_time outside page_lock */
-			if (vma->vm_file)
-				file_update_time(vma->vm_file);
+			file_update_time(vma->vm_file);
 		}
 		put_page(dirty_page);
 		if (page_mkwrite) {
@@ -3025,8 +3023,7 @@ static int do_shared_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		balance_dirty_pages_ratelimited(mapping);
 	}
 
-	/* file_update_time outside page_lock */
-	if (vma->vm_file && !vma->vm_ops->page_mkwrite)
+	if (!vma->vm_ops->page_mkwrite)
 		file_update_time(vma->vm_file);
 
 	return ret;
-- 
2.1.3

