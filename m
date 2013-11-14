Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab3KNXTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 18:19:09 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53716 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab3KNXTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 18:19:07 -0500
Date: Thu, 14 Nov 2013 18:19:04 -0500 (EST)
Message-Id: <20131114.181904.1534883503140584652.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 14 Nov 2013 15:19:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is a minor conflict with patches Andrew submitted to you today,
one of his patches is fixing the error handling in the sparc64 page
table SLAB handling, whereas the 47-bit physical address support patch
series in this pull request deletes all of the sparc64 page table SLAB
code entirely.

So just take the removal in your merge conflict resolution.

1) Implement support for up to 47-bit physical addresses on sparc64.

2) Support HAVE_CONTEXT_TRACKING on sparc64, from Kirill Tkhai.

3) Fix Simba bridge window calculations, from Kjetil Oftedal.

Please pull, thanks a lot!

The following changes since commit 10d0c9705e80bbd3d587c5fad24599aabaca6688:

  Merge tag 'devicetree-for-3.13' of git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux (2013-11-12 16:52:17 +0900)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next.git master

for you to fetch changes up to 812cb83a56a908729c453a7db3fb2c262119bc9d:

  sparc64: Implement HAVE_CONTEXT_TRACKING (2013-11-14 14:57:21 -0800)

----------------------------------------------------------------
David S. Miller (9):
      sparc64: Clean up 64-bit mmap exclusion defines.
      sparc64: Use PAGE_OFFSET instead of a magic constant.
      sparc64: Define PAGE_OFFSET in terms of physical address bits.
      sparc64: Document the shift counts used to validate linear kernel addresses.
      sparc64: Fix inconsistent max-physical-address defines.
      sparc64: Make PAGE_OFFSET variable.
      sparc64: Move from 4MB to 8MB huge pages.
      sparc64: Move to 64-bit PGDs and PMDs.
      sparc64: Encode huge PMDs using PTE encoding.

Kirill Tkhai (2):
      sparc64: Add self-IPI support for smp_send_reschedule()
      sparc64: Implement HAVE_CONTEXT_TRACKING

oftedal (1):
      sparc: PCI: Fix incorrect address calculation of PCI Bridge windows on Simba-bridges

 arch/sparc/Kconfig                      |   1 +
 arch/sparc/include/asm/mmu_64.h         |   1 -
 arch/sparc/include/asm/page_64.h        |  49 ++++++++++++---
 arch/sparc/include/asm/pgtable_64.h     | 209 +++++++++++++++++++++++++++++++++++++--------------------------
 arch/sparc/include/asm/sparsemem.h      |   6 +-
 arch/sparc/include/asm/thread_info_64.h |   3 +-
 arch/sparc/include/asm/tsb.h            | 105 +++++++-------------------------
 arch/sparc/kernel/entry.h               |   1 -
 arch/sparc/kernel/kgdb_64.c             |   5 +-
 arch/sparc/kernel/kprobes.c             |   7 ++-
 arch/sparc/kernel/ktlb.S                |  30 +++++++--
 arch/sparc/kernel/pci.c                 |   4 +-
 arch/sparc/kernel/process_64.c          |   2 +
 arch/sparc/kernel/ptrace_64.c           |  10 +++
 arch/sparc/kernel/rtrap_64.S            |   8 ++-
 arch/sparc/kernel/signal_64.c           |  13 +++-
 arch/sparc/kernel/smp_64.c              |   9 ++-
 arch/sparc/kernel/sun4v_tlb_miss.S      |   2 +-
 arch/sparc/kernel/sys_sparc_64.c        |   6 +-
 arch/sparc/kernel/syscalls.S            |   8 +--
 arch/sparc/kernel/traps_64.c            |  85 ++++++++++++++++++++------
 arch/sparc/kernel/tsb.S                 |   2 +-
 arch/sparc/kernel/unaligned_64.c        |  16 +++--
 arch/sparc/kernel/vmlinux.lds.S         |   5 ++
 arch/sparc/lib/clear_page.S             |   4 +-
 arch/sparc/lib/copy_page.S              |   4 +-
 arch/sparc/mm/fault_64.c                |  14 +++--
 arch/sparc/mm/gup.c                     |   9 ++-
 arch/sparc/mm/hugetlbpage.c             |   2 -
 arch/sparc/mm/init_64.c                 | 282 +++++++++++++++++++++++++++++++++++--------------------------------------------------
 arch/sparc/mm/init_64.h                 |   4 +-
 arch/sparc/mm/tlb.c                     |  13 ++--
 arch/sparc/mm/tsb.c                     |  13 +---
 arch/sparc/mm/ultra.S                   |  12 ++--
 34 files changed, 510 insertions(+), 434 deletions(-)
