Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342Ab3D3DRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 23:17:35 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:62343 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758152Ab3D3DRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 23:17:32 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Olivier Langlois <olivier@trillion01.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 02/10] vm: add no-mmu vm_iomap_memory() stub
Date: Mon, 29 Apr 2013 23:17:10 -0400
Message-Id: <1367291838-5490-3-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1367291838-5490-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1367291838-5490-1-git-send-email-kosaki.motohiro@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

I think we could just move the full vm_iomap_memory() function into
util.h or similar, but I didn't get any reply from anybody actually
using nommu even to this trivial patch, so I'm not going to touch it any
more than required.

Here's the fairly minimal stub to make the nommu case at least
potentially work.  It doesn't seem like anybody cares, though.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/nommu.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 2f3ea74..e001768 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1838,6 +1838,16 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(remap_pfn_range);
 
+int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len)
+{
+	unsigned long pfn = start >> PAGE_SHIFT;
+	unsigned long vm_len = vma->vm_end - vma->vm_start;
+
+	pfn += vma->vm_pgoff;
+	return io_remap_pfn_range(vma, vma->vm_start, pfn, vm_len, vma->vm_page_prot);
+}
+EXPORT_SYMBOL(vm_iomap_memory);
+
 int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
 			unsigned long pgoff)
 {
-- 
1.7.1

