Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab3C1Pn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:43:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab3C1Pnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:43:55 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: [PATCH 1/2] hugetlbfs: stop setting VM_DONTDUMP in initializing vma(VM_HUGETLB)
Date: Thu, 28 Mar 2013 11:42:37 -0400
Message-Id: <1364485358-8745-2-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1364485358-8745-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1364485358-8745-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we fail to include any data on hugepages into coredump,
because VM_DONTDUMP is set on hugetlbfs's vma. This behavior was recently
introduced by commit 314e51b98 "mm: kill vma flag VM_RESERVED and
mm->reserved_vm counter". This looks to me a serious regression,
so let's fix it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 fs/hugetlbfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git v3.9-rc3.orig/fs/hugetlbfs/inode.c v3.9-rc3/fs/hugetlbfs/inode.c
index 84e3d85..523464e 100644
--- v3.9-rc3.orig/fs/hugetlbfs/inode.c
+++ v3.9-rc3/fs/hugetlbfs/inode.c
@@ -110,7 +110,7 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	 * way when do_mmap_pgoff unwinds (may be important on powerpc
 	 * and ia64).
 	 */
-	vma->vm_flags |= VM_HUGETLB | VM_DONTEXPAND | VM_DONTDUMP;
+	vma->vm_flags |= VM_HUGETLB | VM_DONTEXPAND;
 	vma->vm_ops = &hugetlb_vm_ops;
 
 	if (vma->vm_pgoff & (~huge_page_mask(h) >> PAGE_SHIFT))
-- 
1.7.11.7

