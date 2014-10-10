Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbaJJUB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 16:01:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56615 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaJJUB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 16:01:28 -0400
Date: Fri, 10 Oct 2014 16:01:24 -0400 (EDT)
Message-Id: <20141010.160124.1956398387876028909.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Oct 2014 13:01:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) Move to 4-level page tables on sparc64 and support up to 53-bits of
   physical addressing.  Kernel static image BSS size reduced by
   several megabytes.

2) M6/M7 cpu support, from Allan Pais.

3) Move to sparse IRQs, handle hypervisor TLB call errors more
   gracefully, and add T5 perf_event support.  From Bob Picco.

4) Recognize cdroms and compute geometry from capacity in virtual
   disk driver, also from Allan Pais.

5) Fix memset() return value on sparc32, from Andreas Larsson.

6) Respect gfp flags in dma_alloc_coherent on sparc32, from Daniel
   Hellstrom.

7) Fix handling of compound pages in virtual disk driver, from Dwight
   Engen.

8) Fix lockdep warnings in LDC layer by moving IRQ requesting to
   ldc_alloc() from ldc_bind().

9) Increase boot string length to 1024 bytes, from Dave Kleikamp.

Please pull, thanks a lot!

The following changes since commit 619df5d2870b80696fd32521376560e0a4223e44:

  Merge tag 'microblaze-3.17-rc5' of git://git.monstr.eu/linux-2.6-microblaze (2014-09-09 10:33:52 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to bdcf81b658ebc4c2640c3c2c55c8b31c601b6996:

  sparc64: Fix lockdep warnings on reboot on Ultra-5 (2014-10-10 15:49:16 -0400)

----------------------------------------------------------------
Allen Pais (5):
      sparc64: correctly recognise M6 and M7 cpu type
      sparc64: support M6 and M7 for building CPU distribution map
      sparc64: cpu hardware caps support for sparc M6 and M7
      sunvdc: add cdrom and v1.1 protocol support
      sunvdc: compute vdisk geometry from capacity

Andreas Larsson (3):
      sparc: Let memset return the address argument
      sparc: leon: Fix race condition between leon_cycles_offset and timer_interrupt
      sparc32, leon: Make leon_dma_ops avaiable when !CONFIG_PCI

Daniel Hellstrom (1):
      sparc32: dma_alloc_coherent must honour gfp flags

Dave Kleikamp (1):
      sparc64: Increase size of boot string to 1024 bytes

David L Stevens (1):
      sparc: VIO protocol version 1.6

David S. Miller (11):
      sparc64: Fix hibernation code refrence to PAGE_OFFSET.
      sparc64: Fix reversed start/end in flush_tlb_kernel_range()
      sparc64: Switch to 4-level page tables.
      sparc64: Define VA hole at run time, rather than at compile time.
      sparc64: Adjust KTSB assembler to support larger physical addresses.
      sparc64: Fix physical memory management regressions with large max_phys_bits.
      sparc64: Use kernel page tables for vmemmap.
      sparc64: Increase MAX_PHYS_ADDRESS_BITS to 53.
      sparc64: Adjust vmalloc region size based upon available virtual address bits.
      sparc64: Kill unnecessary tables and increase MAX_BANKS.
      sparc64: Fix lockdep warnings on reboot on Ultra-5

Dwight Engen (2):
      sunvdc: limit each sg segment to a page
      vio: fix reuse of vio_dring slot

Sowmini Varadhan (2):
      sparc64: Move request_irq() from ldc_bind() to ldc_alloc()
      sparc64: Add vio_set_intr() to enable/disable Rx interrupts

bob picco (5):
      sparc64: sun4v TLB error power off events
      sparc64: find_node adjustment
      sparc64: mem boot option correction
      sparc64: T5 PMU
      sparc64: sparse irq

 arch/sparc/Kconfig                      |   1 +
 arch/sparc/include/asm/dma-mapping.h    |   6 +-
 arch/sparc/include/asm/hypervisor.h     |  11 ++
 arch/sparc/include/asm/irq_64.h         |   7 +-
 arch/sparc/include/asm/ldc.h            |   5 +-
 arch/sparc/include/asm/page_64.h        |  33 ++---
 arch/sparc/include/asm/pgalloc_64.h     |  28 +++-
 arch/sparc/include/asm/pgtable_64.h     | 100 ++++++++-----
 arch/sparc/include/asm/spitfire.h       |   2 +
 arch/sparc/include/asm/thread_info_64.h |   1 +
 arch/sparc/include/asm/tsb.h            |  87 ++++++++----
 arch/sparc/include/asm/vio.h            |  60 +++++++-
 arch/sparc/kernel/cpu.c                 |  12 ++
 arch/sparc/kernel/cpumap.c              |   2 +
 arch/sparc/kernel/ds.c                  |   4 +-
 arch/sparc/kernel/head_64.S             |  12 ++
 arch/sparc/kernel/hvapi.c               |   1 +
 arch/sparc/kernel/hvcalls.S             |  16 +++
 arch/sparc/kernel/ioport.c              |   5 +-
 arch/sparc/kernel/irq_64.c              | 507 ++++++++++++++++++++++++++++++++++++++++++++----------------------
 arch/sparc/kernel/ktlb.S                | 125 ++---------------
 arch/sparc/kernel/ldc.c                 |  41 +++---
 arch/sparc/kernel/leon_kernel.c         |  31 ++++-
 arch/sparc/kernel/pcr.c                 |  47 ++++++-
 arch/sparc/kernel/perf_event.c          |   3 +-
 arch/sparc/kernel/setup_64.c            |  26 ++--
 arch/sparc/kernel/smp_64.c              |   7 +
 arch/sparc/kernel/sun4v_tlb_miss.S      |  35 +++--
 arch/sparc/kernel/traps_64.c            |  15 +-
 arch/sparc/kernel/vio.c                 |  13 +-
 arch/sparc/kernel/viohs.c               |  18 ++-
 arch/sparc/kernel/vmlinux.lds.S         |  10 +-
 arch/sparc/lib/memset.S                 |  18 ++-
 arch/sparc/mm/fault_64.c                |   3 +
 arch/sparc/mm/init_64.c                 | 603 +++++++++++++++++++++++++++++++++++++++++++------------------------------------
 arch/sparc/mm/init_64.h                 |  18 ---
 arch/sparc/power/hibernate_asm.S        |   4 +-
 arch/sparc/prom/bootstr_64.c            |   5 +-
 arch/sparc/prom/p1275.c                 |   7 +-
 drivers/block/sunvdc.c                  | 167 +++++++++++++++++-----
 drivers/net/ethernet/sun/sunvnet.c      |   4 +-
 41 files changed, 1302 insertions(+), 798 deletions(-)
