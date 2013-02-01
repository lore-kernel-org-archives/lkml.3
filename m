Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab3BAUV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 15:21:57 -0500
Received: from mail-gh0-f169.google.com ([209.85.160.169]:43592 "EHLO
	mail-gh0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284Ab3BAUVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 15:21:55 -0500
X-Greylist: delayed 9652 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2013 15:21:55 EST
Message-ID: <510C23DD.9050601@gmail.com>
Date: Fri, 01 Feb 2013 12:21:49 -0800
From: Subash Patel <subashrp@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Cyril Chemparathy <cyril@ti.com>
CC: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, sboyd@codeaurora.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com, nico@linaro.org,
        catalin.marinas@arm.com, marc.zyngier@arm.com,
        linus.walleij@linaro.org
Subject: Re: [PATCH v4 00/13] ARM LPAE Fixes - Part 1
References: <1359669512-31276-1-git-send-email-cyril@ti.com>
In-Reply-To: <1359669512-31276-1-git-send-email-cyril@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyril,

Thanks for posting fixes patch set again. I have in fact used your 
previous patch series on a real LPAE system with split memory banks in 
both 32-bit and 36-bit physical addresses. I compared your below patches 
with previous version, and don't see significant changes. Hence you can use

Tested By: Subash Patel <subash.rp@samsung.com>

for this series as well. In the meantime, I have used the pa/va patching 
from v3, but haven't tested any performance numbers on it. But I will 
wait for your next reworked version.

Regards,
Subash

On Thursday 31 January 2013 01:58 PM, Cyril Chemparathy wrote:
> This series is a repost of the LPAE related changes in preparation for the
> introduction of the Keystone sub-architecture.  The original series has now
> been split, and this particular series excludes the earlier changes to the
> runtime code patching implementation.  Earlier versions of this series can be
> found at [1], [2], [3] and [4].
>
> These patches are also available in git:
> git://git.kernel.org/pub/scm/linux/kernel/git/cchemparathy/linux-keystone.git upstream/keystone-lpae-v4
>
> [1] http://comments.gmane.org/gmane.linux.kernel/1341497
> [2] http://comments.gmane.org/gmane.linux.kernel/1332069
> [3] http://comments.gmane.org/gmane.linux.kernel/1356716
> [4] http://comments.gmane.org/gmane.linux.kernel/1362529
>
> Series changelog:
>
> [01/13] ARM: LPAE: use signed arithmetic for mask
> [02/13] ARM: LPAE: use phys_addr_t in alloc_init_pud()
> [03/13] ARM: LPAE: use phys_addr_t in free_memmap()
>    (v4)	unchanged from v3
>    (v3)	unchanged from v2
>    (v2)	unchanged from v1
>
> [04/13] ARM: LPAE: use phys_addr_t for initrd location
>    (v4)	unchanged from v3
>    (v3)	unchanged from v2
>    (v2)	revert to unsigned long for initrd size
>
> [05/13] ARM: LPAE: use phys_addr_t in switch_mm()
>    (v4)  collapse shift and or into a single instruction
>    (v3)	remove unnecessary handling for !LPAE in proc-v7-3level
>    (v2)	use phys_addr_t instead of u64 in switch_mm()
>    (v2)	revert on changes to v6 and v7-2level
>    (v2)	fix register mapping for big-endian in v7-3level
>
> [06/13] ARM: LPAE: use 64-bit accessors for TTBR registers
>    (v4)  remove unnecessary condition code clobber
>    (v3)	remove unnecessary condition code clobber
>    (v2)	restore comment in cpu_set_reserved_ttbr0()
>
> [07/13] ARM: LPAE: define ARCH_LOW_ADDRESS_LIMIT for
>    (v4)	unchanged from v3
>    (v3)	unchanged from v2
>    (v2)	unchanged from v1
>
> [08/13] ARM: LPAE: factor out T1SZ and TTBR1 computations
>    (v4)  cleanup and move code comments
>    (v3)	unchanged from v2
>    (v2)	unchanged from v1
>
> [09/13] ARM: LPAE: accomodate >32-bit addresses for page
>    (v4)	unchanged from v3
>    (v3)	unchanged from v2
>    (v2)	apply arch_pgd_shift only on lpae
>    (v2)	move arch_pgd_shift definition to asm/memory.h
>    (v2)	revert on changes to non-lpae procs
>    (v2)	add check to ensure that the pgd physical address is aligned at an
> 	ARCH_PGD_SHIFT boundary
>
> [10/13] ARM: mm: use physical addresses in highmem sanity
> [11/13] ARM: mm: cleanup checks for membank overlap with
> [12/13] ARM: mm: clean up membank size limit checks
>    (v4)	unchanged from v3
>    (v3)	unchanged from v2
>    (v2)	unchanged from v1
>
> [13/13] ARM: fix type of PHYS_PFN_OFFSET to unsigned long
>    (v4)	introduced here
>
>
> Cyril Chemparathy (10):
>    ARM: LPAE: use signed arithmetic for mask definitions
>    ARM: LPAE: use phys_addr_t in switch_mm()
>    ARM: LPAE: use 64-bit accessors for TTBR registers
>    ARM: LPAE: define ARCH_LOW_ADDRESS_LIMIT for bootmem
>    ARM: LPAE: factor out T1SZ and TTBR1 computations
>    ARM: LPAE: accomodate >32-bit addresses for page table base
>    ARM: mm: use physical addresses in highmem sanity checks
>    ARM: mm: cleanup checks for membank overlap with vmalloc area
>    ARM: mm: clean up membank size limit checks
>    ARM: fix type of PHYS_PFN_OFFSET to unsigned long
>
> Vitaly Andrianov (3):
>    ARM: LPAE: use phys_addr_t in alloc_init_pud()
>    ARM: LPAE: use phys_addr_t in free_memmap()
>    ARM: LPAE: use phys_addr_t for initrd location
>
>   arch/arm/include/asm/memory.h               |   20 +++++++++-
>   arch/arm/include/asm/page.h                 |    2 +-
>   arch/arm/include/asm/pgtable-3level-hwdef.h |   20 ++++++++++
>   arch/arm/include/asm/pgtable-3level.h       |    6 +--
>   arch/arm/include/asm/proc-fns.h             |   26 +++++++++----
>   arch/arm/kernel/head.S                      |   10 ++---
>   arch/arm/kernel/smp.c                       |   11 +++++-
>   arch/arm/mm/context.c                       |    9 +----
>   arch/arm/mm/init.c                          |   19 +++++-----
>   arch/arm/mm/mmu.c                           |   49 +++++++++----------------
>   arch/arm/mm/proc-v7-3level.S                |   53 ++++++++++++++-------------
>   11 files changed, 132 insertions(+), 93 deletions(-)
>
