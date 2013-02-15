Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161105Ab3BODyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 22:54:31 -0500
Received: from ozlabs.org ([203.10.76.45]:48622 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932773Ab3BODy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 22:54:28 -0500
Date: Fri, 15 Feb 2013 14:13:35 +1100
From: Paul Mackerras <paulus@samba.org>
To: aik@ozlabs.ru
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Graf <agraf@suse.de>,
        Michael Ellerman <michael@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH 1/4] powerpc: lookup_linux_pte has been made public
Message-ID: <20130215031335.GA25015@drongo>
References: <1360584763-21988-1-git-send-email-a>
 <5118e055.22ca320a.1f08.ffffe2e5@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5118e055.22ca320a.1f08.ffffe2e5@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 11:12:40PM +1100, aik@ozlabs.ru wrote:
> From: Alexey Kardashevskiy <aik@ozlabs.ru>
> 
> The lookup_linux_pte() function returns a linux PTE which
> is required to convert KVM guest physical address into host real
> address in real mode.
> 
> This convertion will be used by upcoming support of H_PUT_TCE_INDIRECT
> as TCE list address comes from the guest directly so it is a guest
> physical.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> ---
>  arch/powerpc/include/asm/pgtable-ppc64.h |    3 +++
>  arch/powerpc/kvm/book3s_hv_rm_mmu.c      |    4 ++--
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/pgtable-ppc64.h b/arch/powerpc/include/asm/pgtable-ppc64.h
> index 0182c20..ddcc898 100644
> --- a/arch/powerpc/include/asm/pgtable-ppc64.h
> +++ b/arch/powerpc/include/asm/pgtable-ppc64.h
> @@ -377,6 +377,9 @@ static inline pte_t *find_linux_pte_or_hugepte(pgd_t *pgdir, unsigned long ea,
>  }
>  #endif /* !CONFIG_HUGETLB_PAGE */
>  
> +pte_t lookup_linux_pte(pgd_t *pgdir, unsigned long hva,
> +		int writing, unsigned long *pte_sizep);
> +

This seems a slightly odd place to put the declaration of a function
which is defined in the KVM code.  kvm-ppc.h might be a better place.

Paul.
