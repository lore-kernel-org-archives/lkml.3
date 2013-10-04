Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3JDTEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 15:04:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169Ab3JDTEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 15:04:14 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] smaps: show VM_SOFTDIRTY flag in VmFlags line
Date: Fri,  4 Oct 2013 15:02:14 -0400
Message-Id: <1380913335-17466-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag shows that soft dirty bit is not enabled yet.
You can enable it by "echo 4 > /proc/pid/clear_refs."

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 fs/proc/task_mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git v3.12-rc2-mmots-2013-09-24-17-03.orig/fs/proc/task_mmu.c v3.12-rc2-mmots-2013-09-24-17-03/fs/proc/task_mmu.c
index 7366e9d..c591928 100644
--- v3.12-rc2-mmots-2013-09-24-17-03.orig/fs/proc/task_mmu.c
+++ v3.12-rc2-mmots-2013-09-24-17-03/fs/proc/task_mmu.c
@@ -561,6 +561,9 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 		[ilog2(VM_NONLINEAR)]	= "nl",
 		[ilog2(VM_ARCH_1)]	= "ar",
 		[ilog2(VM_DONTDUMP)]	= "dd",
+#ifdef CONFIG_MEM_SOFT_DIRTY
+		[ilog2(VM_SOFTDIRTY)]	= "sd",
+#endif
 		[ilog2(VM_MIXEDMAP)]	= "mm",
 		[ilog2(VM_HUGEPAGE)]	= "hg",
 		[ilog2(VM_NOHUGEPAGE)]	= "nh",
-- 
1.8.3.1

