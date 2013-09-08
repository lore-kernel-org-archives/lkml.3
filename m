Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab3IHDp6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:45:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55972 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755645Ab3IHDTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.807946451@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [024/121] vm: add no-mmu vm_iomap_memory() stub
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 3c0b9de6d37a481673e81001c57ca0e410c72346 upstream.

I think we could just move the full vm_iomap_memory() function into
util.h or similar, but I didn't get any reply from anybody actually
using nommu even to this trivial patch, so I'm not going to touch it any
more than required.

Here's the fairly minimal stub to make the nommu case at least
potentially work.  It doesn't seem like anybody cares, though.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/nommu.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1825,6 +1825,16 @@ int remap_pfn_range(struct vm_area_struc
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

