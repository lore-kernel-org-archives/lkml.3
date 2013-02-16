Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab3BPMxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 07:53:18 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44414 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab3BPMxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 07:53:17 -0500
Date: Sat, 16 Feb 2013 12:52:05 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        js1304@gmail.com, Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v6 3/3] ARM: mm: use static_vm for managing static
	mapped areas
Message-ID: <20130216125205.GO17833@n2100.arm.linux.org.uk>
References: <1360142010-10598-1-git-send-email-iamjoonsoo.kim@lge.com> <1360142010-10598-4-git-send-email-iamjoonsoo.kim@lge.com> <201302161249.08597.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201302161249.08597.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2013 at 12:49:08PM +0000, Arnd Bergmann wrote:
> 8<-----
> ARM: mm: remove unused variables in pci_reserve_io
> 
> Patch "ARM: 7646/1: mm: use static_vm for managing static mapped areas"
> removed code from pci_reserve_io but left variable declarations
> in place that are now unused, as gcc correctly warns.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> index c6fe15a..c6d45c8 100644
> --- a/arch/arm/mm/mmu.c
> +++ b/arch/arm/mm/mmu.c
> @@ -901,8 +901,6 @@ static void __init fill_pmd_gaps(void)
>  #if defined(CONFIG_PCI) && !defined(CONFIG_NEED_MACH_IO_H)
>  static void __init pci_reserve_io(void)
>  {
> -	struct vm_struct *vm;
> -	unsigned long addr;
>  	struct static_vm *svm;
>  
>  	svm = find_static_vm_vaddr((void *)PCI_IO_VIRT_BASE);

I already have such a patch in my tree - may not have pushed it out
as I've been ill (and am still recovering.)
