Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbbAFOR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:17:26 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:55973 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbbAFORZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:17:25 -0500
Date: Tue, 6 Jan 2015 14:17:01 +0000
From: Will Deacon <will.deacon@arm.com>
To: Min-Hua Chen <orca.chen@gmail.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: add ioremap physical address information
Message-ID: <20150106141701.GC3484@arm.com>
References: <CAHkaATSM=V+BNZvAXC+VG6NDjOK9m0ZP3Q=SUaoxtgDw4SKZog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHkaATSM=V+BNZvAXC+VG6NDjOK9m0ZP3Q=SUaoxtgDw4SKZog@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2014 at 04:52:10PM +0000, Min-Hua Chen wrote:
> In /proc/vmallocinfo, it's good to show the physical address
> of each ioremap in vmallocinfo. Add physical address information
> in arm64 ioremap.
> 
> 0xffffc900047f2000-0xffffc900047f4000    8192 _nv013519rm+0x57/0xa0
> [nvidia] phys=f8100000 ioremap
> 0xffffc900047f4000-0xffffc900047f6000    8192 _nv013519rm+0x57/0xa0
> [nvidia] phys=f8008000 ioremap
> 0xffffc90004800000-0xffffc90004821000  135168 e1000_probe+0x22c/0xb95
> [e1000e] phys=f4300000 ioremap
> 0xffffc900049c0000-0xffffc900049e1000  135168 _nv013521rm+0x4d/0xd0
> [nvidia] phys=e0140000 ioremap
> 
> Signed-off-by: Min-Hua Chen <orca.chen@gmail.com>
> ---

Thanks, this looks useful for debugging.

  Acked-by: Will Deacon <will.deacon@arm.com>

I assume this can wait for 3.20?

Will


>  arch/arm64/mm/ioremap.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
> index cbb99c8..01e88c8 100644
> --- a/arch/arm64/mm/ioremap.c
> +++ b/arch/arm64/mm/ioremap.c
> @@ -62,6 +62,7 @@ static void __iomem *__ioremap_caller(phys_addr_t
> phys_addr, size_t size,
>      if (!area)
>          return NULL;
>      addr = (unsigned long)area->addr;
> +    area->phys_addr = phys_addr;
> 
>      err = ioremap_page_range(addr, addr + size, phys_addr, prot);
>      if (err) {
> --
> 1.7.10.4
> 
