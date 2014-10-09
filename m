Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbaJIPFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 11:05:33 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:57558 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640AbaJIPFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 11:05:10 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Michael Neuling <mikey@neuling.org>, greg@kroah.com, arnd@arndb.de,
        mpe@ellerman.id.au, benh@kernel.crashing.org
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au1.ibm.com,
        cbe-oss-dev@lists.ozlabs.org
Subject: Re: [PATCH v4 05/16] powerpc/mm: Export mmu_kernel_ssize and mmu_linear_psize
In-Reply-To: <1412758505-23495-6-git-send-email-mikey@neuling.org>
References: <1412758505-23495-1-git-send-email-mikey@neuling.org> <1412758505-23495-6-git-send-email-mikey@neuling.org>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/24.3.91.1 (x86_64-unknown-linux-gnu)
Date: Thu, 09 Oct 2014 20:35:02 +0530
Message-ID: <871tqh2sip.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100915-0017-0000-0000-0000019056EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Neuling <mikey@neuling.org> writes:

> From: Ian Munsie <imunsie@au1.ibm.com>
>
> Export mmu_kernel_ssize and mmu_linear_psize.  These are needed by the cxl
> driver which has it's own MMU.  To setup the MMU cxl needs access to these.
>

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

> Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> ---
>  arch/powerpc/mm/hash_utils_64.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
> index 5c0738d..bbdb054 100644
> --- a/arch/powerpc/mm/hash_utils_64.c
> +++ b/arch/powerpc/mm/hash_utils_64.c
> @@ -98,6 +98,7 @@ unsigned long htab_size_bytes;
>  unsigned long htab_hash_mask;
>  EXPORT_SYMBOL_GPL(htab_hash_mask);
>  int mmu_linear_psize = MMU_PAGE_4K;
> +EXPORT_SYMBOL_GPL(mmu_linear_psize);
>  int mmu_virtual_psize = MMU_PAGE_4K;
>  int mmu_vmalloc_psize = MMU_PAGE_4K;
>  #ifdef CONFIG_SPARSEMEM_VMEMMAP
> @@ -105,6 +106,7 @@ int mmu_vmemmap_psize = MMU_PAGE_4K;
>  #endif
>  int mmu_io_psize = MMU_PAGE_4K;
>  int mmu_kernel_ssize = MMU_SEGSIZE_256M;
> +EXPORT_SYMBOL_GPL(mmu_kernel_ssize);
>  int mmu_highuser_ssize = MMU_SEGSIZE_256M;
>  u16 mmu_slb_size = 64;
>  EXPORT_SYMBOL_GPL(mmu_slb_size);
> -- 
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

