Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaK2K0L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 05:26:11 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:54833 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaK2K0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 05:26:09 -0500
MIME-Version: 1.0
In-Reply-To: <1417255998-8373-1-git-send-email-rkx1209@gmail.com>
References: <1417255998-8373-1-git-send-email-rkx1209@gmail.com>
Date: Sat, 29 Nov 2014 11:26:08 +0100
Message-ID: <CAFLxGvzH3yKWBATBYmxQteXgVZvY0mwEE7+Oi7Tx+ZkyV66LQA@mail.gmail.com>
Subject: Re: [PATCH] Fixed type id
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Ren Kimura <rkx1209@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2014 at 11:13 AM, Ren Kimura <rkx1209@gmail.com> wrote:
> From: RKX1209 <rkx1209@gmail.com>
>
> Signed-off-by: RKX1209 <rkx1209@gmail.com>

What issue does this fix?
On 32bit an address should fit into an integer.

> ---
>  arch/x86/mm/init_32.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index c8140e1..957f7f0 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -304,14 +304,14 @@ repeat:
>  #endif
>                 for (; pmd_idx < PTRS_PER_PMD && pfn < end_pfn;
>                      pmd++, pmd_idx++) {
> -                       unsigned int addr = pfn * PAGE_SIZE + PAGE_OFFSET;
> +                       unsigned long addr = pfn * PAGE_SIZE + PAGE_OFFSET;
>
>                         /*
>                          * Map with big pages if possible, otherwise
>                          * create normal page tables:
>                          */
>                         if (use_pse) {
> -                               unsigned int addr2;
> +                               unsigned long addr2;
>                                 pgprot_t prot = PAGE_KERNEL_LARGE;
>                                 /*
>                                  * first pass will use the same initial
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
