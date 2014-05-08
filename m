Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaEHMl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 08:41:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:26151 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbaEHMly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 08:41:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1010,1389772800"; 
   d="scan'208";a="535857208"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterz@infradead.org,
        mingo@kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2 0/2] remap_file_pages() decommission
Date: Thu,  8 May 2014 15:41:26 +0300
Message-Id: <1399552888-11024-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew and Linus,

These two patches demonstrate how we can get rid nonlinear mappings.

The first patch documents remap_file_pages(2) deprecation and add printk
into syscall code. The patch could be propagated through stable kernel if
the approach with remap_file_pages() emulation is okay.

The second patch replaces remap_file_pages(2) with and emulation. I didn't
find any real code (apart LTP) to test it on. So I wrote simple test case.
See commit message for numbers.

I will prepare separate patchset to cleanup all nonlinear mappings
leftovers if the approach with emulation is desirable.

Comments?

Kirill A. Shutemov (2):
  mm: mark remap_file_pages() syscall as deprecated
  mm: replace remap_file_pages() syscall with emulation

 Documentation/vm/remap_file_pages.txt |  27 ++++
 include/linux/fs.h                    |   8 +-
 mm/Makefile                           |   2 +-
 mm/fremap.c                           | 282 ----------------------------------
 mm/mmap.c                             |  66 ++++++++
 mm/nommu.c                            |   8 -
 6 files changed, 100 insertions(+), 293 deletions(-)
 create mode 100644 Documentation/vm/remap_file_pages.txt
 delete mode 100644 mm/fremap.c

-- 
2.0.0.rc2

