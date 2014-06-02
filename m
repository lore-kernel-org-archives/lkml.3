Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbaFBViC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:38:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:31941 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbaFBVgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:36:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,959,1392192000"; 
   d="scan'208";a="548709697"
Subject: [PATCH 07/10] mm: pagewalk: kill check for hugetlbfs inside /proc pagemap code
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, kirill.shutemov@linux.intel.com,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 02 Jun 2014 14:36:53 -0700
References: <20140602213644.925A26D0@viggo.jf.intel.com>
In-Reply-To: <20140602213644.925A26D0@viggo.jf.intel.com>
Message-Id: <20140602213653.4520DC58@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

The page map code does not call the normal handlers for hugetlbfs
areas.  They are handled by ->hugetlb_entry exclusively, so
remove the check for it.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/fs/proc/task_mmu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~do-not-check-for-hugetlbfs-inside-pagemap-walker fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~do-not-check-for-hugetlbfs-inside-pagemap-walker	2014-06-02 14:20:20.693870160 -0700
+++ b/fs/proc/task_mmu.c	2014-06-02 14:20:20.697870340 -0700
@@ -1033,8 +1033,7 @@ static int pagemap_pte_range(pmd_t *pmd,
 
 		/* check that 'vma' actually covers this address,
 		 * and that it isn't a huge page vma */
-		if (vma && (vma->vm_start <= addr) &&
-		    !is_vm_hugetlb_page(vma)) {
+		if (vma && (vma->vm_start <= addr)) {
 			pte = pte_offset_map(pmd, addr);
 			pte_to_pagemap_entry(&pme, pm, vma, addr, *pte);
 			/* unmap before userspace copy */
_
