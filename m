Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbbALIXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 03:23:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41680 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbbALIXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 03:23:41 -0500
Message-ID: <54B3848A.7040002@suse.com>
Date: Mon, 12 Jan 2015 09:23:38 +0100
From: =?windows-1252?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, David Vrabel <david.vrabel@citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>, xen-devel@lists.xenproject.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH] x86: xen: mmu: Remove unused function
References: <1421015741-25110-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1421015741-25110-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2015 11:35 PM, Rickard Strandqvist wrote:
> Remove the function set_pte_mfn() that is not used anywhere.
>
> This was partially found by using a static code analysis program called cppcheck.

Sorry, you seem not to have checked the newest kernel.

Used by:

xen_do_set_identity_and_remap_chunk()
xen_remap_memory()

So: Nak.


Juergen

>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   arch/x86/xen/mmu.c |    9 ---------
>   arch/x86/xen/mmu.h |    2 --
>   2 files changed, 11 deletions(-)
>
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index a8a1a3d..6959550 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -281,15 +281,6 @@ static void xen_set_pmd(pmd_t *ptr, pmd_t val)
>   	xen_set_pmd_hyper(ptr, val);
>   }
>
> -/*
> - * Associate a virtual page frame with a given physical page frame
> - * and protection flags for that frame.
> - */
> -void set_pte_mfn(unsigned long vaddr, unsigned long mfn, pgprot_t flags)
> -{
> -	set_pte_vaddr(vaddr, mfn_pte(mfn, flags));
> -}
> -
>   static bool xen_batched_set_pte(pte_t *ptep, pte_t pteval)
>   {
>   	struct mmu_update u;
> diff --git a/arch/x86/xen/mmu.h b/arch/x86/xen/mmu.h
> index 73809bb..f2dcf79 100644
> --- a/arch/x86/xen/mmu.h
> +++ b/arch/x86/xen/mmu.h
> @@ -13,8 +13,6 @@ enum pt_level {
>
>   bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn);
>
> -void set_pte_mfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags);
> -
>   pte_t xen_ptep_modify_prot_start(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
>   void  xen_ptep_modify_prot_commit(struct mm_struct *mm, unsigned long addr,
>   				  pte_t *ptep, pte_t pte);
>

