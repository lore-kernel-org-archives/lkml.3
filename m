Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab3GYE4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 00:56:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207Ab3GYE4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 00:56:06 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [PATCH v4 0/8] extend hugepage migration
Date: Thu, 25 Jul 2013 00:54:55 -0400
Message-Id: <1374728103-17468-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the 4th version of hugepage migration patchset.
I added Reviewed/Acked tags and applied the feedbacks in the previous discussion
(thank you, all reviewers!):
 - fixed macro (1/8)
 - improved comment and readability (1/8, 3/8, 4/8, 7/8)
 - improved node choice in allocating destination hugepage (7/8)

TODOs: (likely to be done after this work)
 - split page table lock for pmd/pud based hugepage (maybe applicable to thp)
 - improve alloc_migrate_target (especially in node choice)
 - using page walker in check_range

I hope that this series is becoming ready to be merge to -mm tree.
Andrew, could you review and judge this?

Thanks,
Naoya Horiguchi
---
GitHub:
  git://github.com/Naoya-Horiguchi/linux.git extend_hugepage_migration.v4

Test code:
  git://github.com/Naoya-Horiguchi/test_hugepage_migration_extension.git

Naoya Horiguchi (8):
      migrate: make core migration code aware of hugepage
      soft-offline: use migrate_pages() instead of migrate_huge_page()
      migrate: add hugepage migration code to migrate_pages()
      migrate: add hugepage migration code to move_pages()
      mbind: add hugepage migration code to mbind()
      migrate: remove VM_HUGETLB from vma flag check in vma_migratable()
      memory-hotplug: enable memory hotplug to handle hugepage
      prepare to remove /proc/sys/vm/hugepages_treat_as_movable

 Documentation/sysctl/vm.txt |  13 +----
 include/linux/hugetlb.h     |  15 +++++
 include/linux/mempolicy.h   |   2 +-
 include/linux/migrate.h     |   5 --
 mm/hugetlb.c                | 134 +++++++++++++++++++++++++++++++++++++++-----
 mm/memory-failure.c         |  15 ++++-
 mm/memory.c                 |  17 +++++-
 mm/memory_hotplug.c         |  42 +++++++++++---
 mm/mempolicy.c              |  46 +++++++++++++--
 mm/migrate.c                |  51 ++++++++---------
 mm/page_alloc.c             |  12 ++++
 mm/page_isolation.c         |  14 +++++
 12 files changed, 288 insertions(+), 78 deletions(-)
