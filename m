Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbaJBN3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:29:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbaJBN3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:29:22 -0400
From: Mel Gorman <mgorman@suse.de>
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        Kirill A Shutemov <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] NUMA balancing related fixlets
Date: Thu,  2 Oct 2014 14:29:14 +0100
Message-Id: <1412256558-9995-1-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following is in reaction to the thread "pipe/page fault oddness".
The first patch cleans up a lot of mess related to ARCH_USES_NUMA_PROT_NONE.
It's already in Andrew's tree but included here for context.

The second patch removes a race between migration and mprotect, particularly
from compaction context.

The third patch should have no real effect but it's an oversight that
should be corrected in case MPOL_MF_LAZY is exposed to userspace.

The fourth patch addresses a problem whereby a split_huge_page can leave
a pte_numa PTE in the wrong location and is one potential source of the
bug Dave observed.

Note that none of this prevents a pte_protnone approach being applied on
top or replacing patch 4 with it.  They should not be in conflict but if
patch 4 in particular addresses Dave's problem then it may be considerably
lower risk for 3.17.

 arch/powerpc/include/asm/pgtable.h    | 57 ++++++++---------------------------
 arch/powerpc/include/asm/pte-common.h |  5 +++
 arch/x86/Kconfig                      |  1 -
 arch/x86/include/asm/pgtable_types.h  | 14 +++++++++
 include/asm-generic/pgtable.h         | 27 ++++++-----------
 init/Kconfig                          | 11 -------
 mm/huge_memory.c                      |  2 --
 mm/mempolicy.c                        |  4 ++-
 mm/migrate.c                          |  4 ++-
 9 files changed, 46 insertions(+), 79 deletions(-)

-- 
1.8.4.5

