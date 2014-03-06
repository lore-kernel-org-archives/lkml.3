Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaCFLQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 06:16:01 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:35143 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaCFLP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 06:15:59 -0500
From: Choi Gi-yong <yong@gnoy.org>
To: cl@linux-foundation.org
Cc: agshew@gmail.com, linux-kernel@vger.kernel.org,
        Choi Gi-yong <yong@gnoy.org>
Subject: [PATCH] mm: Fix 'ERROR: do not initialise globals to 0 or NULL' and coding style
Date: Thu,  6 Mar 2014 20:15:50 +0900
Message-Id: <1394104550-13915-1-git-send-email-yong@gnoy.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Choi Gi-yong <yong@gnoy.org>
---
 mm/nommu.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 8740213..78970d2 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -296,7 +296,7 @@ long vwrite(char *buf, char *addr, unsigned long count)
 		count = -(unsigned long) addr;
 
 	memcpy(addr, buf, count);
-	return(count);
+	return count;
 }
 
 /*
@@ -1003,8 +1003,7 @@ static int validate_mmap_request(struct file *file,
 
 			/* we mustn't privatise shared mappings */
 			capabilities &= ~BDI_CAP_MAP_COPY;
-		}
-		else {
+		} else {
 			/* we're going to read the file into private memory we
 			 * allocate */
 			if (!(capabilities & BDI_CAP_MAP_COPY))
@@ -1035,23 +1034,20 @@ static int validate_mmap_request(struct file *file,
 		if (file->f_path.mnt->mnt_flags & MNT_NOEXEC) {
 			if (prot & PROT_EXEC)
 				return -EPERM;
-		}
-		else if ((prot & PROT_READ) && !(prot & PROT_EXEC)) {
+		} else if ((prot & PROT_READ) && !(prot & PROT_EXEC)) {
 			/* handle implication of PROT_EXEC by PROT_READ */
 			if (current->personality & READ_IMPLIES_EXEC) {
 				if (capabilities & BDI_CAP_EXEC_MAP)
 					prot |= PROT_EXEC;
 			}
-		}
-		else if ((prot & PROT_READ) &&
+		} else if ((prot & PROT_READ) &&
 			 (prot & PROT_EXEC) &&
 			 !(capabilities & BDI_CAP_EXEC_MAP)
 			 ) {
 			/* backing file is not executable, try to copy */
 			capabilities &= ~BDI_CAP_MAP_DIRECT;
 		}
-	}
-	else {
+	} else {
 		/* anonymous mappings are always memory backed and can be
 		 * privately mapped
 		 */
@@ -1659,7 +1655,7 @@ int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
 	/* find the first potentially overlapping VMA */
 	vma = find_vma(mm, start);
 	if (!vma) {
-		static int limit = 0;
+		static int limit;
 		if (limit < 5) {
 			printk(KERN_WARNING
 			       "munmap of memory not mmapped by process %d"
-- 
1.8.3.2

