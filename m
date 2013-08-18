Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab3HRUdi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:33:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43595 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab3HRUde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:33:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 09/34] vm: add no-mmu vm_iomap_memory() stub
Date: Sun, 18 Aug 2013 13:34:22 -0700
Message-Id: <20130818203300.326339244@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203259.653403173@linuxfoundation.org>
References: <20130818203259.653403173@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/nommu.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1856,6 +1856,16 @@ int remap_pfn_range(struct vm_area_struc
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


