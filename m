Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab3AVRMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:12:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33319 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab3AVRMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:12:40 -0500
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Simon Jeons <simon.jeons@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] Follow up work on NUMA Balancing
Date: Tue, 22 Jan 2013 17:12:36 +0000
Message-Id: <1358874762-19717-1-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series is a few follow-up patches left over from NUMA
balancing. The three three patches are tiny fixes. Patches 4 and 5 fold
page->_last_nid into page->flags and is entirely based on work from Peter
Zijlstra. The final patch is a cleanup by Hugh Dickins that he had marked
as a prototype but on examination and testing I could not find any problems
with it (famous last words).

 include/linux/mm.h                |   73 ++++++++++++---------------
 include/linux/mm_types.h          |    9 ++--
 include/linux/mmzone.h            |   22 +--------
 include/linux/page-flags-layout.h |   88 +++++++++++++++++++++++++++++++++
 include/linux/vmstat.h            |    2 +-
 mm/huge_memory.c                  |   28 ++++-------
 mm/memory.c                       |    4 ++
 mm/migrate.c                      |   99 +++++++++++++++++--------------------
 8 files changed, 186 insertions(+), 139 deletions(-)
 create mode 100644 include/linux/page-flags-layout.h

-- 
1.7.9.2

