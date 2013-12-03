Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab3LCIwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:52:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49398 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab3LCIwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:52:04 -0500
From: Mel Gorman <mgorman@suse.de>
To: Alex Thorlton <athorlton@sgi.com>
Cc: Rik van Riel <riel@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 00/14] NUMA balancing segmentation faults candidate fix on large machines
Date: Tue,  3 Dec 2013 08:51:47 +0000
Message-Id: <1386060721-3794-1-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Thorlton reported segementation faults when NUMA balancing is enabled
on large machines. There is no obvious explanation from the console what the
problem is so this series is based on code review.

The series is against 3.12. In the event it addresses the problem the
patches will need to be forward-ported and retested. The series is not
against the latest mainline as changes to PTE scan rates may mask the bug.

 arch/x86/mm/gup.c       |  13 ++++
 include/linux/hugetlb.h |  10 ++--
 include/linux/migrate.h |  27 ++++++++-
 kernel/sched/fair.c     |  16 ++++-
 mm/huge_memory.c        |  58 ++++++++++++++----
 mm/hugetlb.c            |  51 ++++++----------
 mm/memory.c             |  93 ++---------------------------
 mm/mempolicy.c          |   2 +
 mm/migrate.c            | 155 ++++++++++++++++++++++++++++++++++++++++++++----
 mm/mprotect.c           |  50 ++++------------
 mm/pgtable-generic.c    |   3 +
 mm/swap.c               | 143 +++++++++++++++++++++++++-------------------
 12 files changed, 371 insertions(+), 250 deletions(-)

-- 
1.8.4

