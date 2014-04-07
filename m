Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbaDGPLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 11:11:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755758AbaDGPKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 11:10:50 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Noonan <steven@uplinklabs.net>, Rik van Riel <riel@redhat.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        Linux-X86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 0/3] Use an alternative to _PAGE_PROTNONE for _PAGE_NUMA
Date: Mon,  7 Apr 2014 16:10:40 +0100
Message-Id: <1396883443-11696-1-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aliasing _PAGE_NUMA and _PAGE_PROTNONE had some convenient properties but
it ultimately gave Xen a headache and pisses almost everybody off that
looks closely at it. Two discussions on "why this makes sense" is one
discussion too many so rather than having a third there is this series.

Conceptually it's simple -- use an unused physical address bit for _PAGE_NUMA
and make it a 64-bit only feature on x86. This had been avoided before
because if the physical address space expands we are back to square one
but lets worry about that when it happens unless the x86 maintainers or
hardware people warn us that we're about to run headlong into a wall.

Testing was minimal -- short lived JVM and autonumabench tests that trigger
the relevant paths for NUMA balancing. Functionally it did not die miserably.
Performance looks as expected with no major changes.

 arch/x86/Kconfig                     |  2 +-
 arch/x86/include/asm/pgtable.h       |  8 +++----
 arch/x86/include/asm/pgtable_types.h | 44 ++++++++++++++++++++----------------
 mm/memory.c                          | 12 ----------
 4 files changed, 29 insertions(+), 37 deletions(-)

-- 
1.8.4.5

