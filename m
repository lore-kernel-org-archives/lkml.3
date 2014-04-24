Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbaDXKWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:22:45 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:38690 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbaDXKWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:22:37 -0400
Date: Thu, 24 Apr 2014 11:22:29 +0100
From: Steve Capper <steve.capper@linaro.org>
To: linux@arm.linux.org.uk, akpm@linux-foundation.org
Cc: will.deacon@arm.com, catalin.marinas@arm.com, robherring2@gmail.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gerald.schaefer@de.ibm.com
Subject: Re: [PATCH V2 0/5] Huge pages for short descriptors on ARM
Message-ID: <20140424102229.GA28014@linaro.org>
References: <1397648803-15961-1-git-send-email-steve.capper@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397648803-15961-1-git-send-email-steve.capper@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 12:46:38PM +0100, Steve Capper wrote:
> Hello,
> This series brings HugeTLB pages and Transparent Huge Pages (THP) to
> ARM on short descriptors.
> 
> Russell, Andrew,
> I would like to get this in next (and hopefully 3.16 if no problems
> arise) if that sounds reasonable?
> 
> There's one patch at the beginning of the series for mm:
>   mm: hugetlb: Introduce huge_pte_{page,present,young}
> This has been tested on ARM and s390 and should compile out for other
> architectures.
> 
> The rest of the series targets arch/arm.
> 
> I've bumped the series to V2 as it was rebased (and tested against)
> v3.15-rc1. On ARM the libhugetlbfs test suite, some THP PROT_NONE
> tests and the recursive execve test all passed successfully.
> 
> Thanks,
> --
> Steve

Hello,
Just a ping on this...

I would really like to get huge page support for short descriptors on
ARM merged as I've been carrying around these patches for a long time.

Recently I've had no issues raised about the code. The patches have
been tested and found to be both beneficial to system performance and
stable.

There are two parts to the series, the first patch is a core mm/ patch
that introduces some huge_pte_ helper functions that allows for a much
simpler ARM (without LPAE) implementation. The second part is the
actual arch/arm code.

I'm not sure how to proceed with these patches. I was thinking that
they could be picked up into linux-next? If that sounds reasonable;
Andrew, would you like to take the mm/ patch and Russell could you
please take the arch/arm patches?

Also, I was hoping to get these into 3.16. Are there any objections to
that?

Thank you,
-- 
Steve

> 
> 
> Steve Capper (5):
>   mm: hugetlb: Introduce huge_pte_{page,present,young}
>   arm: mm: Adjust the parameters for __sync_icache_dcache
>   arm: mm: Make mmu_gather aware of huge pages
>   arm: mm: HugeTLB support for non-LPAE systems
>   arm: mm: Add Transparent HugePage support for non-LPAE
> 
>  arch/arm/Kconfig                      |   4 +-
>  arch/arm/include/asm/hugetlb-2level.h | 136 ++++++++++++++++++++++++++++++++++
>  arch/arm/include/asm/hugetlb-3level.h |   6 ++
>  arch/arm/include/asm/hugetlb.h        |  10 +--
>  arch/arm/include/asm/pgtable-2level.h | 129 +++++++++++++++++++++++++++++++-
>  arch/arm/include/asm/pgtable-3level.h |   3 +-
>  arch/arm/include/asm/pgtable.h        |   9 +--
>  arch/arm/include/asm/tlb.h            |  14 +++-
>  arch/arm/kernel/head.S                |  10 ++-
>  arch/arm/mm/fault.c                   |  13 ----
>  arch/arm/mm/flush.c                   |   9 +--
>  arch/arm/mm/fsr-2level.c              |   4 +-
>  arch/arm/mm/hugetlbpage.c             |   2 +-
>  arch/arm/mm/mmu.c                     |  51 +++++++++++++
>  arch/s390/include/asm/hugetlb.h       |  15 ++++
>  include/asm-generic/hugetlb.h         |  15 ++++
>  mm/hugetlb.c                          |  22 +++---
>  17 files changed, 399 insertions(+), 53 deletions(-)
>  create mode 100644 arch/arm/include/asm/hugetlb-2level.h
> 
> -- 
> 1.8.1.4
> 
