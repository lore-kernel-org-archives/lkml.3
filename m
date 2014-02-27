Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbaB0Ej4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 23:39:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbaB0Ejz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 23:39:55 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] fixes on page table walker and hugepage rmapping
Date: Wed, 26 Feb 2014 23:39:34 -0500
Message-Id: <1393475977-3381-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sasha, could you test if the bug you reported recently [1] reproduces
on the latest next tree with this patchset? (I'm not sure of this
because the problem looks differently in my own testing...)

[1] http://thread.gmane.org/gmane.linux.kernel.mm/113374/focus=113
---
Summary:

Naoya Horiguchi (3):
      mm/pagewalk.c: fix end address calculation in walk_page_range()
      mm, hugetlbfs: fix rmapping for anonymous hugepages with page_pgoff()
      mm: call vma_adjust_trans_huge() only for thp-enabled vma

 include/linux/pagemap.h | 13 +++++++++++++
 mm/huge_memory.c        |  2 +-
 mm/hugetlb.c            |  5 +++++
 mm/memory-failure.c     |  4 ++--
 mm/mmap.c               |  3 ++-
 mm/pagewalk.c           |  5 +++--
 mm/rmap.c               |  8 ++------
 7 files changed, 28 insertions(+), 12 deletions(-)
