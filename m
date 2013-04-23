Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab3DWWR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:17:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411Ab3DWVwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:52:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 08/42] hugetlbfs: stop setting VM_DONTDUMP in initializing vma(VM_HUGETLB)
Date: Tue, 23 Apr 2013 14:52:06 -0700
Message-Id: <20130423215206.402011262@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215205.523980967@linuxfoundation.org>
References: <20130423215205.523980967@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

commit a2fce9143057f4eb7675a21cca1b6beabe585c8b upstream.

Currently we fail to include any data on hugepages into coredump,
because VM_DONTDUMP is set on hugetlbfs's vma.  This behavior was
recently introduced by commit 314e51b9851b ("mm: kill vma flag
VM_RESERVED and mm->reserved_vm counter").

This looks to me a serious regression, so let's fix it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/hugetlbfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -110,7 +110,7 @@ static int hugetlbfs_file_mmap(struct fi
 	 * way when do_mmap_pgoff unwinds (may be important on powerpc
 	 * and ia64).
 	 */
-	vma->vm_flags |= VM_HUGETLB | VM_DONTEXPAND | VM_DONTDUMP;
+	vma->vm_flags |= VM_HUGETLB | VM_DONTEXPAND;
 	vma->vm_ops = &hugetlb_vm_ops;
 
 	if (vma->vm_pgoff & (~huge_page_mask(h) >> PAGE_SHIFT))


