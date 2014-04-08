Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbaDHNJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 09:09:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756601AbaDHNJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 09:09:39 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linux-X86 <x86@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Noonan <steven@uplinklabs.net>, Rik van Riel <riel@redhat.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 0/5] Use an alternative to _PAGE_PROTNONE for _PAGE_NUMA v2
Date: Tue,  8 Apr 2014 14:09:25 +0100
Message-Id: <1396962570-18762-1-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using unused physical bits is something that will break eventually.

Changelog since V1
o Reuse software-bits
o Use paravirt ops when modifying PTEs in the NUMA helpers

Aliasing _PAGE_NUMA and _PAGE_PROTNONE had some convenient properties but
it ultimately gave Xen a headache and pisses almost everybody off that
looks closely at it. Two discussions on "why this makes sense" is one
discussion too many so rather than having a third so here is this series.
This series reuses the PTE bits that are available to the programmer.
This adds some contraints on how and when automatic NUMA balancing can be
enabled but it should go away again when Xen stops using _PAGE_IOMAP.

The series also converts the NUMA helpers to use paravirt-friendly operations
but it needs a Tested-by from the Xen and powerpc people.

 arch/x86/Kconfig                     |  2 +-
 arch/x86/include/asm/pgtable.h       |  5 +++
 arch/x86/include/asm/pgtable_types.h | 66 ++++++++++++++++++++----------------
 include/asm-generic/pgtable.h        | 31 ++++++++++++-----
 mm/memory.c                          | 12 -------
 5 files changed, 66 insertions(+), 50 deletions(-)

-- 
1.8.4.5

