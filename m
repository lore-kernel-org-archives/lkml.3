Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbaDPLqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 07:46:52 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:51247 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604AbaDPLqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 07:46:50 -0400
From: Steve Capper <steve.capper@linaro.org>
To: linux@arm.linux.org.uk, akpm@linux-foundation.org
Cc: will.deacon@arm.com, catalin.marinas@arm.com, robherring2@gmail.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gerald.schaefer@de.ibm.com,
        Steve Capper <steve.capper@linaro.org>
Subject: [PATCH V2 0/5] Huge pages for short descriptors on ARM
Date: Wed, 16 Apr 2014 12:46:38 +0100
Message-Id: <1397648803-15961-1-git-send-email-steve.capper@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
This series brings HugeTLB pages and Transparent Huge Pages (THP) to
ARM on short descriptors.

Russell, Andrew,
I would like to get this in next (and hopefully 3.16 if no problems
arise) if that sounds reasonable?

There's one patch at the beginning of the series for mm:
  mm: hugetlb: Introduce huge_pte_{page,present,young}
This has been tested on ARM and s390 and should compile out for other
architectures.

The rest of the series targets arch/arm.

I've bumped the series to V2 as it was rebased (and tested against)
v3.15-rc1. On ARM the libhugetlbfs test suite, some THP PROT_NONE
tests and the recursive execve test all passed successfully.

Thanks,
--
Steve


Steve Capper (5):
  mm: hugetlb: Introduce huge_pte_{page,present,young}
  arm: mm: Adjust the parameters for __sync_icache_dcache
  arm: mm: Make mmu_gather aware of huge pages
  arm: mm: HugeTLB support for non-LPAE systems
  arm: mm: Add Transparent HugePage support for non-LPAE

 arch/arm/Kconfig                      |   4 +-
 arch/arm/include/asm/hugetlb-2level.h | 136 ++++++++++++++++++++++++++++++++++
 arch/arm/include/asm/hugetlb-3level.h |   6 ++
 arch/arm/include/asm/hugetlb.h        |  10 +--
 arch/arm/include/asm/pgtable-2level.h | 129 +++++++++++++++++++++++++++++++-
 arch/arm/include/asm/pgtable-3level.h |   3 +-
 arch/arm/include/asm/pgtable.h        |   9 +--
 arch/arm/include/asm/tlb.h            |  14 +++-
 arch/arm/kernel/head.S                |  10 ++-
 arch/arm/mm/fault.c                   |  13 ----
 arch/arm/mm/flush.c                   |   9 +--
 arch/arm/mm/fsr-2level.c              |   4 +-
 arch/arm/mm/hugetlbpage.c             |   2 +-
 arch/arm/mm/mmu.c                     |  51 +++++++++++++
 arch/s390/include/asm/hugetlb.h       |  15 ++++
 include/asm-generic/hugetlb.h         |  15 ++++
 mm/hugetlb.c                          |  22 +++---
 17 files changed, 399 insertions(+), 53 deletions(-)
 create mode 100644 arch/arm/include/asm/hugetlb-2level.h

-- 
1.8.1.4

