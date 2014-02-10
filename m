Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaBJRi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:38:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672AbaBJR2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:28:09 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mtosatti@redhat.com, mgorman@suse.de, aarcange@redhat.com,
        andi@firstfloor.org, riel@redhat.com
Subject: [PATCH 0/4] hugetlb: add hugepagesnid= command-line option
Date: Mon, 10 Feb 2014 12:27:44 -0500
Message-Id: <1392053268-29239-1-git-send-email-lcapitulino@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HugeTLB command-line option hugepages= allows the user to specify how many
huge pages should be allocated at boot. On NUMA systems, this argument
automatically distributes huge pages allocation among nodes, which can
be undesirable.

The hugepagesnid= option introduced by this commit allows the user
to specify which NUMA nodes should be used to allocate boot-time HugeTLB
pages. For example, hugepagesnid=0,2,2G will allocate two 2G huge pages
from node 0 only. More details on patch 3/4 and patch 4/4.

Luiz capitulino (4):
  memblock: memblock_virt_alloc_internal(): alloc from specified node
    only
  memblock: add memblock_virt_alloc_nid_nopanic()
  hugetlb: add hugepagesnid= command-line option
  hugetlb: hugepagesnid=: add 1G huge page support

 Documentation/kernel-parameters.txt |   8 +++
 arch/x86/mm/hugetlbpage.c           |  35 ++++++++++++
 include/linux/bootmem.h             |   4 ++
 include/linux/hugetlb.h             |   2 +
 mm/hugetlb.c                        | 103 ++++++++++++++++++++++++++++++++++++
 mm/memblock.c                       |  41 ++++++++++++--
 6 files changed, 190 insertions(+), 3 deletions(-)

-- 
1.8.1.4
