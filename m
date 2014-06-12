Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751027AbaFLVsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 17:48:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbaFLVse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 17:48:34 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Dave Hansen <dave.hansen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org
Subject: [PATCH -mm v2 00/11] pagewalk: standardize current users, move pmd locking, apply to mincore
Date: Thu, 12 Jun 2014 17:48:00 -0400
Message-Id: <1402609691-13950-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is ver.2 of page table walker patchset.

I move forward on this cleanup work, and added some improvement from the
previous version. Major changes are:
 - removed walk->skip which becomes removable due to refactoring existing
   users
 - commonalized the argments of entry handlers (pte|pmd|hugetlb)_entry()
   which allows us to use the same function as multiple handlers.

This patchset is based on mmotm-2014-05-21-16-57.

Tree: git@github.com:Naoya-Horiguchi/linux.git
Branch: mmotm-2014-05-21-16-57/page_table_walker.v2

Thanks,
Naoya Horiguchi
---
Summary:

Naoya Horiguchi (11):
      pagewalk: remove pgd_entry() and pud_entry()
      madvise: cleanup swapin_walk_pmd_entry()
      memcg: separate mem_cgroup_move_charge_pte_range()
      pagewalk: move pmd_trans_huge_lock() from callbacks to common code
      pagewalk: remove mm_walk->skip
      pagewalk: add size to struct mm_walk
      pagewalk: change type of arg of callbacks
      pagewalk: update comment on walk_page_range()
      fs/proc/task_mmu.c: refactor smaps
      fs/proc/task_mmu.c: clean up gather_*_stats()
      mincore: apply page table walker on do_mincore()

 arch/openrisc/kernel/dma.c     |   6 +-
 arch/powerpc/mm/subpage-prot.c |   5 +-
 fs/proc/task_mmu.c             | 140 ++++++++---------------------
 include/linux/mm.h             |  21 ++---
 mm/huge_memory.c               |  20 -----
 mm/madvise.c                   |  55 +++++-------
 mm/memcontrol.c                | 170 +++++++++++++++++------------------
 mm/memory.c                    |   5 +-
 mm/mempolicy.c                 |  15 ++--
 mm/mincore.c                   | 195 ++++++++++++++---------------------------
 mm/pagewalk.c                  | 143 +++++++++++++-----------------
 11 files changed, 294 insertions(+), 481 deletions(-)
