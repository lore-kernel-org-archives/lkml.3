Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaIABgc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 21:36:32 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17213 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaIABgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 21:36:31 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: akpm@linux-foundation.org
Cc: kirill.shutemov@linux.intel.com, khlebnikov@openvz.org, riel@redhat.com,
        mgorman@suse.de, n-horiguchi@ah.jp.nec.com, mhocko@suse.cz,
        hughd@google.com, vbabka@suse.cz, walken@google.com,
        minchan@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] mm: use pgprot_val to access vm_page_prot
Date: Sun, 31 Aug 2014 21:35:56 -0400
Message-Id: <1409535356-30323-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pgprot is defined differently in every arch, use the per-arch pgprot_val
to access it.

This fixes a build failure on various arches such as tile and powerpc
caused by "mm: introduce dump_vma".

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index add97b8..1e1bd9a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6734,7 +6734,8 @@ void dump_vma(const struct vm_area_struct *vma)
 		"prot %lx anon_vma %p vm_ops %p\n"
 		"pgoff %lx file %p private_data %p\n",
 		vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->vm_next,
-		vma->vm_prev, vma->vm_mm, vma->vm_page_prot.pgprot,
+		vma->vm_prev, vma->vm_mm,
+		(unsigned long)pgprot_val(vma->vm_page_prot),
 		vma->anon_vma, vma->vm_ops, vma->vm_pgoff,
 		vma->vm_file, vma->vm_private_data);
 	dump_flags(vma->vm_flags, vmaflags_names, ARRAY_SIZE(vmaflags_names));
-- 
1.7.10.4

