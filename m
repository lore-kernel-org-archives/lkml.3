Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596Ab3LIHJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 02:09:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40117 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546Ab3LIHJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 02:09:16 -0500
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 00/18] NUMA balancing segmentation fault fixes and misc followups v3
Date: Mon,  9 Dec 2013 07:08:54 +0000
Message-Id: <1386572952-1191-1-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Thorlton reported segementation faults when NUMA balancing is enabled
on large machines. There is no obvious explanation from the console what the
problem but similar problems have been observed by Rik van Riel and myself
if migration was aggressive enough. Alex, this series is against 3.13-rc2,
a verification that the fix addresses your problem would be appreciated.

This series starts with a range of patches aimed at addressing the
segmentation fault problem while offsetting some of the cost to avoid badly
regressing performance in -stable. Those that are cc'd to stable (patches
1-12) should be merged ASAP. The rest of the series is relatively minor
stuff that fell out during the course of development that is ok to wait
for the next merge window but should help with the continued development
of NUMA balancing.

 arch/sparc/include/asm/pgtable_64.h |   4 +-
 arch/x86/include/asm/pgtable.h      |  11 +++-
 arch/x86/mm/gup.c                   |  13 +++++
 include/asm-generic/pgtable.h       |   2 +-
 include/linux/migrate.h             |   9 ++++
 include/linux/mm_types.h            |  44 +++++++++++++++
 include/linux/mmzone.h              |   5 +-
 include/trace/events/migrate.h      |  26 +++++++++
 include/trace/events/sched.h        |  93 ++++++++++++++++++++++++++++++++
 kernel/fork.c                       |   1 +
 kernel/sched/core.c                 |   2 +
 kernel/sched/fair.c                 |  15 +++++-
 mm/huge_memory.c                    |  45 ++++++++++++----
 mm/migrate.c                        | 103 ++++++++++++++++++++++++++++--------
 mm/mprotect.c                       |  15 ++++--
 mm/pgtable-generic.c                |   8 ++-
 16 files changed, 348 insertions(+), 48 deletions(-)

-- 
1.8.4

