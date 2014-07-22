Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbaGVQfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:35:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49717 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755888AbaGVQfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:35:04 -0400
Date: Tue, 22 Jul 2014 18:35:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Stuart Hayes <stuart.w.hayes@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, bpetkov@suse.com, matt.fleming@intel.com
Subject: Re: [PATCH] x86: Allow kernel_map_pages_in_pgd() to work when NX is
 disabled
Message-ID: <20140722163501.GF6462@pd.tnic>
References: <53BC7130.1010105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53BC7130.1010105@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 05:31:12PM -0500, Stuart Hayes wrote:
> The function kernel_map_pages_in_pgd() will not map pages if NX is
> disabled, which causes a lot of problems booting in EFI mode
> (efi_map_region() and other functions depend on this).  This patch
> just makes sure that the NX flag doesn't get set in the page tables
> if NX is disabled, rather than not mapping the pages at all.
> 
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> ---
> --- linux-3.16-rc3/arch/x86/mm/pageattr.c.orig	2014-07-02 12:04:49.244288159 -0400
> +++ linux-3.16-rc3/arch/x86/mm/pageattr.c	2014-07-02 12:05:55.808290437 -0400
> @@ -1862,10 +1862,7 @@ int kernel_map_pages_in_pgd(pgd_t *pgd,
>  		.flags = 0,
>  	};
>  
> -	if (!(__supported_pte_mask & _PAGE_NX))
> -		goto out;

arch/x86/mm/pageattr.c: In function ‘kernel_map_pages_in_pgd’:
arch/x86/mm/pageattr.c:1873:1: warning: label ‘out’ defined but not used [-Wunused-label]

> -
> -	if (!(page_flags & _PAGE_NX))
> +	if ((!(__supported_pte_mask & _PAGE_NX)) || !(page_flags & _PAGE_NX))
>  		cpa.mask_clr = __pgprot(_PAGE_NX);
>  
>  	cpa.mask_set = __pgprot(_PAGE_PRESENT | page_flags);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
