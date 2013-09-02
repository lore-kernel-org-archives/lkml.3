Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325Ab3IBJNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:13:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37642 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758279Ab3IBIyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:54:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 06/58] vm: add no-mmu vm_iomap_memory() stub
Date: Mon,  2 Sep 2013 09:53:51 +0100
Message-Id: <1378112083-9475-7-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/nommu.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/nommu.c b/mm/nommu.c
index a60db99..572c4c0 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1827,6 +1827,16 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
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
1.8.3.2

