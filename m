Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbbAERop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:44:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbbAERoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:44:44 -0500
From: Rafael Aquini <aquini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, jweiner@redhat.com, dave.hansen@linux.intel.com,
        rientjes@google.com, linux-mm@kvack.org
Subject: [PATCH v2] fs: proc: task_mmu: show page size in /proc/<pid>/numa_maps
Date: Mon,  5 Jan 2015 12:44:31 -0500
Message-Id: <734bca19b3a8f4e191ccc9055ad4740744b5b2b6.1420464466.git.aquini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces 'kernelpagesize_kB' line element to /proc/<pid>/numa_maps
report file in order to help identifying the size of pages that are backing
memory areas mapped by a given task. This is specially useful to
help differentiating between HUGE and GIGANTIC page backed VMAs.

This patch is based on Dave Hansen's proposal and reviewer's follow-ups
taken from the following dicussion threads:
 * https://lkml.org/lkml/2011/9/21/454
 * https://lkml.org/lkml/2014/12/20/66

Signed-off-by: Rafael Aquini <aquini@redhat.com>
---
* v2 changelog:
  . print kernel page size unconditionally (jweiner, dhansen)
  . rename pagesize to match smaps terminology (dhansen, drientjes)

 fs/proc/task_mmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 246eae8..3688d64 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1533,6 +1533,8 @@ static int show_numa_map(struct seq_file *m, void *v, int is_pid)
 	if (!md->pages)
 		goto out;
 
+	seq_printf(m, " kernelpagesize_kB=%lu", vma_kernel_pagesize(vma) >> 10);
+
 	if (md->anon)
 		seq_printf(m, " anon=%lu", md->anon);
 
-- 
1.9.3

