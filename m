Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbaKKLgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:36:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbaKKLgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:36:20 -0500
Date: Tue, 11 Nov 2014 19:36:08 +0800
From: Minfei Huang <mhuang@redhat.com>
To: Minfei Huang <mnfhuang@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mm: Give the correct initail value to the pmd_idx
Message-ID: <20141111113608.GA3531@dhcp-17-108.nay.redhat.com>
References: <1415252513-6453-1-git-send-email-mnfhuang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415252513-6453-1-git-send-email-mnfhuang@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could someone who help me review my patch?

Thanks
Minfei

On 11/06/14 at 01:41pm, Minfei Huang wrote:
> The variable value is undefined from the stack eara. So it makes sense to
> init the variable to run process correctly.
> 
> If the variable pmd_idx inits the value more than PTRS_PER_PMD, the
> count may be smaller than the correct value, and the allocated page may
> be not enough for pte entry.
> 
> The kernel may panic cause by the undefine variable which is allocated
> from stack.
> 
> Signed-off-by: Minfei Huang <mnfhuang@gmail.com>
> ---
>  arch/x86/mm/init_32.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index c8140e1..c23ab1e 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -137,6 +137,7 @@ page_table_range_init_count(unsigned long start, unsigned long end)
>  
>  	vaddr = start;
>  	pgd_idx = pgd_index(vaddr);
> +	pmd_idx = pmd_index(vaddr);
>  
>  	for ( ; (pgd_idx < PTRS_PER_PGD) && (vaddr != end); pgd_idx++) {
>  		for (; (pmd_idx < PTRS_PER_PMD) && (vaddr != end);
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
