Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab3JBOeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:34:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab3JBO26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:28:58 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 18/26] mm: Convert process_vm_rw_pages() to use get_user_pages_unlocked()
Date: Wed,  2 Oct 2013 16:27:59 +0200
Message-Id: <1380724087-13927-19-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380724087-13927-1-git-send-email-jack@suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/process_vm_access.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index fd26d0433509..c1bc47d8ed90 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -64,12 +64,8 @@ static int process_vm_rw_pages(struct task_struct *task,
 	*bytes_copied = 0;
 
 	/* Get the pages we're interested in */
-	down_read(&mm->mmap_sem);
-	pages_pinned = get_user_pages(task, mm, pa,
-				      nr_pages_to_copy,
-				      vm_write, 0, process_pages, NULL);
-	up_read(&mm->mmap_sem);
-
+	pages_pinned = get_user_pages_unlocked(task, mm, pa, nr_pages_to_copy,
+					       vm_write, 0, process_pages);
 	if (pages_pinned != nr_pages_to_copy) {
 		rc = -EFAULT;
 		goto end;
-- 
1.8.1.4

