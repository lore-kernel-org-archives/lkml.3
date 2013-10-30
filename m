Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab3J3Vtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 17:49:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917Ab3J3Vqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 17:46:45 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
        Cliff Wickman <cpw@sgi.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Rik van Riel <riel@redhat.com>,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH 00/11 v2] update page table walker
Date: Wed, 30 Oct 2013 17:44:48 -0400
Message-Id: <1383169499-25144-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the ver.2 of page table walker patchset.
I rebased it onto the latest mmots (solved conflicts with split PMD locks),
and added a few small changes.

As for the motivation and/or brief summary, please refer to ver.1's cover letter.
http://article.gmane.org/gmane.linux.kernel.mm/108362

Thanks,
Naoya Horiguchi
---
GitHub:
  git://github.com/Naoya-Horiguchi/linux.git v3.12-rc7-mmots-2013-10-29-16-24/rewrite_pagewalker.v2

Test code:
  git://github.com/Naoya-Horiguchi/test_rewrite_page_table_walker.git
---
Summary:

Naoya Horiguchi (11):
      pagewalk: update page table walker core
      pagewalk: add walk_page_vma()
      smaps: redefine callback functions for page table walker
      clear_refs: redefine callback functions for page table walker
      pagemap: redefine callback functions for page table walker
      numa_maps: redefine callback functions for page table walker
      memcg: redefine callback functions for page table walker
      madvise: redefine callback functions for page table walker
      arch/powerpc/mm/subpage-prot.c: use walk_page_vma() instead of walk_page_range()
      pagewalk: remove argument hmask from hugetlb_entry()
      mempolicy: apply page table walker on queue_pages_range()

 arch/powerpc/mm/subpage-prot.c |   6 +-
 fs/proc/task_mmu.c             | 267 ++++++++++++-----------------
 include/linux/mm.h             |  24 ++-
 mm/madvise.c                   |  43 ++---
 mm/memcontrol.c                |  71 +++-----
 mm/mempolicy.c                 | 255 +++++++++++-----------------
 mm/pagewalk.c                  | 370 ++++++++++++++++++++++++++---------------
 7 files changed, 501 insertions(+), 535 deletions(-)
