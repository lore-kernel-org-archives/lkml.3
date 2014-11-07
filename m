Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbaKGHvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 02:51:38 -0500
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:52435 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbaKGHva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 02:51:30 -0500
X-Greylist: delayed 2890 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Nov 2014 02:51:26 EST
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Feiner <pfeiner@google.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH -mm v7 00/13] pagewalk: improve vma handling, apply to new
 users
Thread-Topic: [PATCH -mm v7 00/13] pagewalk: improve vma handling, apply to
 new users
Thread-Index: AQHP+li1iZ2fO4R45E+w2Cfr9CkvTQ==
Date: Fri, 7 Nov 2014 07:01:51 +0000
Message-ID: <1415343692-6314-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.128.101.22]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is ver.7 of page table walker patchset.

I apologize about my long delay since previous version (I have moved to
Japan last month and no machine access for a while.)
I just rebased this onto mmotm-2014-11-05-16-01. I had some conflicts but
the resolution was not hard.
Trinity showed no bug at least in my environment.

Thanks,
Naoya Horiguchi

Tree: git@github.com:Naoya-Horiguchi/linux.git
Branch: mmotm-2014-11-05-16-01/page_table_walker.ver7
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
 fs/proc/task_mmu.c             | 206 ++++++++++++++++++-------------------
 include/linux/mm.h             |  22 ++--
 mm/huge_memory.c               |  20 ----
 mm/memcontrol.c                |  49 +++------
 mm/mempolicy.c                 | 228 +++++++++++++++++------------------------
 mm/mincore.c                   | 169 +++++++++++-------------------
 mm/pagewalk.c                  | 228 ++++++++++++++++++++++++-----------------
 8 files changed, 419 insertions(+), 509 deletions(-)