Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934055AbaE3Qob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:44:31 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:25134 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932189AbaE3Qoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:44:30 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AskNAGa0iFNXQxV9/2dsb2JhbABZgwerRgaYGoEJF3SCUy8jgRo3iEYB1wkXhVWIfR2EKgEDj0WKOYsbiBKDOjs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/proc/task_mmu.c: replace seq_printf by seq_puts
Date: Fri, 30 May 2014 18:44:30 +0200
Message-Id: <1401468270-8565-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/proc/task_mmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 442177b..916ab5c 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1408,10 +1408,10 @@ static int show_numa_map(struct seq_file *m, void *v, int is_pid)
 	seq_printf(m, "%08lx %s", vma->vm_start, buffer);
 
 	if (file) {
-		seq_printf(m, " file=");
+		seq_puts(m, " file=");
 		seq_path(m, &file->f_path, "\n\t= ");
 	} else if (vma->vm_start <= mm->brk && vma->vm_end >= mm->start_brk) {
-		seq_printf(m, " heap");
+		seq_puts(m, " heap");
 	} else {
 		pid_t tid = vm_is_stack(task, vma, is_pid);
 		if (tid != 0) {
@@ -1421,14 +1421,14 @@ static int show_numa_map(struct seq_file *m, void *v, int is_pid)
 			 */
 			if (!is_pid || (vma->vm_start <= mm->start_stack &&
 			    vma->vm_end >= mm->start_stack))
-				seq_printf(m, " stack");
+				seq_puts(m, " stack");
 			else
 				seq_printf(m, " stack:%d", tid);
 		}
 	}
 
 	if (is_vm_hugetlb_page(vma))
-		seq_printf(m, " huge");
+		seq_puts(m, " huge");
 
 	walk_page_range(vma->vm_start, vma->vm_end, &walk);
 
-- 
1.8.4.5

