Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbaGARHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 13:07:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758555AbaGARHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 13:07:50 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [PATCH v4 00/13] pagewalk: improve vma handling, apply to new users
Date: Tue,  1 Jul 2014 13:07:18 -0400
Message-Id: <1404234451-21695-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is ver.4 of page table walker patchset.
I reflected comments in the previous version (thanks Kirill, Jerome).
And rebased onto v3.16-rc3. Recently code around queue_pages_range()
is changed by commit d05f0cdcbe63 "mm: fix crashes from mbind() merging
vma", which affects this series a little.

Thanks,
Naoya Horiguchi

Tree: git@github.com:Naoya-Horiguchi/linux.git
Branch: v3.16-rc3/page_table_walker.ver4
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
 fs/proc/task_mmu.c             | 150 ++++++++++++++++-----------
 include/linux/mm.h             |  22 ++--
 mm/huge_memory.c               |  20 ----
 mm/memcontrol.c                |  49 +++------
 mm/mempolicy.c                 | 224 ++++++++++++++++------------------------
 mm/mincore.c                   | 173 +++++++++++--------------------
 mm/pagewalk.c                  | 228 ++++++++++++++++++++++++-----------------
 8 files changed, 409 insertions(+), 463 deletions(-)
