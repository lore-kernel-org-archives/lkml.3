Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab3BESax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 13:30:53 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:49083 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621Ab3BESar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 13:30:47 -0500
Date: Tue, 5 Feb 2013 13:30:08 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: Re: linux-next: build failure after merge of the xen-two tree
Message-ID: <20130205183007.GA5652@konrad-lan.dumpdata.com>
References: <20130204151456.ea053895a487a19013e4991f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204151456.ea053895a487a19013e4991f@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 03:14:56PM +1100, Stephen Rothwell wrote:
> Hi Konrad,
> 
> After merging the xen-two tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> arch/x86/xen/mmu.c: In function 'xen_init_mmu_ops':
> arch/x86/xen/mmu.c:2213:10: error: 'struct x86_init_ops' has no member named 'mapping'
> arch/x86/xen/mmu.c:2213:39: error: 'xen_mapping_pagetable_reserve' undeclared (first use in this function)
> 
> Caused by commit 8154d7a6b9b9 ("xen/pvh: Implement MMU changes for PVH")
> from the xen-two tree interacting with commit 6f80b68e9e51 ("x86, mm,
> Xen: Remove mapping_pagetable_reserve()") from the tip tree.  The
> automatic merge left the moved version of the above line intact while it
> should have been removed (I assume).
> 
> I have added the following merge fix patch and can carry the fix as
> necessary.

Ah yes. Please do. I will fix it up once I am back on the box that has
access to the kernel.org. Thanks again!

> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 4 Feb 2013 15:08:33 +1100
> Subject: [PATCH] xen: fix bad merge of arch/x86/xen/mmu.c
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/x86/xen/mmu.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 824706a..3228600 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -2210,7 +2210,6 @@ void __init xen_init_mmu_ops(void)
>  		pv_mmu_ops.flush_tlb_others = xen_flush_tlb_others;
>  		return;
>  	}
> -	x86_init.mapping.pagetable_reserve = xen_mapping_pagetable_reserve;
>  	pv_mmu_ops = xen_mmu_ops;
>  
>  	memset(dummy_mapping, 0xff, PAGE_SIZE);
> -- 
> 1.8.1
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


