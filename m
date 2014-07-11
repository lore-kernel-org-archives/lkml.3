Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbaGKSjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 14:39:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092AbaGKSgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 14:36:46 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [PATCH -mm v5 00/13] pagewalk: improve vma handling, apply to new users
Date: Fri, 11 Jul 2014 14:35:36 -0400
Message-Id: <1405103749-23506-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is ver.5 of page table walker patchset.
I fixed the buffer overflow problem in mincore().
And I rebased this onto mmotm-2014-07-09-17-08.
Trinity shows no bug at least in my environment.

Thanks,
Naoya Horiguchi

Tree: git@github.com:Naoya-Horiguchi/linux.git
Branch: mmotm-2014-07-09-17-08/page_table_walker.ver5
---
Summary:

Kirill A. Shutemov (1):
      mm: /proc/pid/clear_refs: avoid split_huge_page()

Naoya Horiguchi (12):
      mm/pagewalk: remove pgd_entry() and pud_entry()
      pagewalk: improve vma handling
      pagewalk: add walk_page_vma()
      smaps: remove mem_size_stats->vma and use walk_page_vma()
      clear_refs: remove clear_refs_private->vma and introduce clear_refs_test_walk()
      pagemap: use walk->vma instead of calling find_vma()
      numa_maps: fix typo in gather_hugetbl_stats
      numa_maps: remove numa_maps->vma
      memcg: cleanup preparation for page table walk
      arch/powerpc/mm/subpage-prot.c: use walk->vma and walk_page_vma()
      mempolicy: apply page table walker on queue_pages_range()
      mincore: apply page table walker on do_mincore()

 arch/powerpc/mm/subpage-prot.c |   6 +-
 fs/proc/task_mmu.c             | 151 ++++++++++++++++-----------
 include/linux/mm.h             |  22 ++--
 mm/huge_memory.c               |  20 ----
 mm/memcontrol.c                |  49 +++------
 mm/mempolicy.c                 | 224 ++++++++++++++++------------------------
 mm/mincore.c                   | 169 +++++++++++-------------------
 mm/pagewalk.c                  | 228 ++++++++++++++++++++++++-----------------
 8 files changed, 406 insertions(+), 463 deletions(-)
