Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab3EXOiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:38:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105Ab3EXOiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:38:06 -0400
Date: Fri, 24 May 2013 10:36:44 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH 0/2] kdump/mmap: Fix mmap of /proc/vmcore for s390
Message-ID: <20130524143644.GD18218@redhat.com>
References: <1369400889-11064-1-git-send-email-holzheu@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369400889-11064-1-git-send-email-holzheu@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 03:08:07PM +0200, Michael Holzheu wrote:
> Hello Vivek and Hatayama,
> 
> Currently the /proc/vmcore mmap patches are not working on s390. The
> problem is that on s390 the kernel in not relocatable and therefore
> always runs in the lower memory area. Therefore for kdump on s390 we
> swap the lower memory area with the crashkernel area before starting
> the kdump kernel:
> 
> [0 - OLDMEM_SIZE] is mapped to [OLDMEM_BASE - OLDMEM_BASE + OLDMEM_SIZE]
> 
> To fix /proc/vmcore mmap memory below OLDMEMSIZE needs to be mapped
> with OLDMEM_BASE as offset. To achieve that, a new weak function
> arch_oldmem_remap_pfn_range() is introduced.
> 
> If you agree with our approach, could you integrate the two patches
> into the mmap patch series?

Hi Michael, 

Sorry, I don't understand the problem. If we swapped low memory and crash
reserved memory, that should have been taken care by prepared ELF headers
so that we map the right pfns. In x86 we swap 640K of low memory with 640K
of memory in reserved and we take care of this by preparing elf headers
accordingly.

So why s390 can't do the same thing?

Thanks
Vivek

> 
> Best Regards,
> Michael
> 
> ---
> Jan Willeke (2):
>   kdump/mmap: Introduce arch_oldmem_remap_pfn_range()
>   s390/kdump/mmap: Implement arch_oldmem_remap_pfn_range() for s390
> 
>  arch/s390/kernel/crash_dump.c | 27 +++++++++++++++++++++++++++
>  fs/proc/vmcore.c              | 15 ++++++++++++++-
>  include/linux/crash_dump.h    |  5 +++++
>  3 files changed, 46 insertions(+), 1 deletion(-)
> 
> -- 
> 1.8.1.6
