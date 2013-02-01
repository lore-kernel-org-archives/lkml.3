Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab3BADfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 22:35:54 -0500
Received: from mail-qe0-f54.google.com ([209.85.128.54]:47709 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab3BADfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 22:35:51 -0500
Date: Thu, 31 Jan 2013 22:35:47 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Hui Wang <jason77.wang@gmail.com>
cc: Cyril Chemparathy <cyril@ti.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        marc.zyngier@arm.com, sboyd@codeaurora.org, linus.walleij@linaro.org,
        Will Deacon <will.deacon@arm.com>, Vitaly Andrianov <vitalya@ti.com>,
        Catalin Marinas <catalin.marinas@arm.com>, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH v4 02/13] ARM: LPAE: use phys_addr_t in
 alloc_init_pud()
In-Reply-To: <510B327E.3050502@gmail.com>
Message-ID: <alpine.LFD.2.02.1301312218270.6300@xanadu.home>
References: <1359669512-31276-1-git-send-email-cyril@ti.com> <1359669512-31276-3-git-send-email-cyril@ti.com> <510B327E.3050502@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2013, Hui Wang wrote:

> Cyril Chemparathy wrote:
> > From: Vitaly Andrianov <vitalya@ti.com>
> > 
> > This patch fixes the alloc_init_pud() function to use phys_addr_t instead of
> > unsigned long when passing in the phys argument.
> > 
> > This is an extension to commit 97092e0c56830457af0639f6bd904537a150ea4a
> > (ARM:
> > pgtable: use phys_addr_t for physical addresses), which applied similar
> > changes
> > elsewhere in the ARM memory management code.
> > 
> > Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
> > Signed-off-by: Cyril Chemparathy <cyril@ti.com>
> > Acked-by: Nicolas Pitre <nico@linaro.org>
> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> > ---
> >  arch/arm/mm/mmu.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> > index 9f06102..ef43689 100644
> > --- a/arch/arm/mm/mmu.c
> > +++ b/arch/arm/mm/mmu.c
> > @@ -612,7 +612,8 @@ static void __init alloc_init_section(pud_t *pud,
> > unsigned long addr,
> >  }
> >   static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
> > -	unsigned long end, unsigned long phys, const struct mem_type *type)
> > +				  unsigned long end, phys_addr_t phys,
> > +				  const struct mem_type *type)
> >   
> The change is correct but seems useless so far. This function only be called
> from map_lowmem and devicemaps_init, from i know neither lowmem nor device io
> registers of existing platforms exceed 32bit address.

It is not because you are not aware of any existing platforms with RAM 
or device IO above the 4GB mark that they don't exist.

For example, some LPAE systems have all their RAM located above the 4G 
physical address mark. A simple (potentially non DMA capable) alias 
exists in the low 32-bit address space to allow the system to boot and 
switch to the real physical RAM addresses once the MMU is turned on.  
Some of that RAM is still qualified as "low mem" i.e. the portion of RAM 
that the kernel keeps permanently mapped in the 32-bit virtual space 
even if all of it is above the 4G mark in physical space.


Nicolas
