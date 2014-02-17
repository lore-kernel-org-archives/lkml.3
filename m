Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbaBQBRJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 20:17:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:57673 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbaBQBRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 20:17:07 -0500
Message-ID: <1392599810.24061.20.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Mon, 17 Feb 2014 12:16:50 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3-0ubuntu3~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are some more powerpc fixes for 3.14

The main one is a nasty issue with the NUMA balancing support
which requires a small generic change and the addition of a new
accessor to set _PAGE_NUMA. Both have been reviewed and acked by
Mel and Rik.

The changelog should have plenty of details but basically,
without this fix, we get random user segfaults and/or
corruptions due to missing TLB/hash flushes. Aneesh series
of 3 patches fixes it.

We have some vDSO vs. perf fixes from Anton, some small EEH
fixes from Gavin, a ppc32 regression vs. the stack overflow
detector, and a fix for the way we handle PCIe host bridge
speed settings on pseries (which is needed for proper
operations of AMD graphics cards on Power8).

Cheers,
Ben.

The following changes since commit cd15b048445d0a54f7147c35a86c5a16ef231554:

  powerpc/powernv: Add iommu DMA bypass support for IODA2 (2014-02-11 16:07:37 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to 66f9af83e56bfa12964d251df9d60fb571579913:

  powerpc/eeh: Disable EEH on reboot (2014-02-17 11:19:39 +1100)

----------------------------------------------------------------
Aneesh Kumar K.V (3):
      powerpc/mm: Add new "set" flag argument to pte/pmd update function
      mm: Dirty accountable change only apply to non prot numa case
      mm: Use ptep/pmdp_set_numa() for updating _PAGE_NUMA bit

Anton Blanchard (2):
      powerpc: Link VDSOs at 0x0
      powerpc: Use unstripped VDSO image for more accurate profiling data

Gavin Shan (3):
      powerpc/powernv: Rework EEH reset
      powerpc/eeh: Cleanup on eeh_subsystem_enabled
      powerpc/eeh: Disable EEH on reboot

Kevin Hao (1):
      powerpc: Set the correct ksp_limit on ppc32 when switching to irq stack

Kleber Sacilotto de Souza (2):
      powerpc/pseries: Fix regression on PCI link speed
      powerpc/pseries: Add Gen3 definitions for PCIE link speed

 arch/powerpc/include/asm/eeh.h               | 21 +++++++++++++--
 arch/powerpc/include/asm/hugetlb.h           |  2 +-
 arch/powerpc/include/asm/pgtable-ppc64.h     | 26 +++++++++++--------
 arch/powerpc/include/asm/pgtable.h           | 22 ++++++++++++++++
 arch/powerpc/include/asm/vdso.h              |  6 ++---
 arch/powerpc/kernel/eeh.c                    | 32 ++++++++++++++++++-----
 arch/powerpc/kernel/misc_32.S                |  5 +++-
 arch/powerpc/kernel/vdso32/vdso32_wrapper.S  |  2 +-
 arch/powerpc/kernel/vdso64/vdso64_wrapper.S  |  2 +-
 arch/powerpc/mm/pgtable_64.c                 | 12 +++++----
 arch/powerpc/mm/subpage-prot.c               |  2 +-
 arch/powerpc/platforms/powernv/eeh-ioda.c    | 32 +++++------------------
 arch/powerpc/platforms/powernv/eeh-powernv.c |  2 +-
 arch/powerpc/platforms/pseries/eeh_pseries.c |  2 +-
 arch/powerpc/platforms/pseries/pci.c         | 22 +++++++++++-----
 include/asm-generic/pgtable.h                | 39 ++++++++++++++++++++++++++++
 mm/huge_memory.c                             |  9 ++-----
 mm/mprotect.c                                | 25 ++++++------------
 18 files changed, 172 insertions(+), 91 deletions(-)


