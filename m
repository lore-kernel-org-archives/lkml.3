Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaBNRGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 12:06:09 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:52917 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaBNRGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 12:06:07 -0500
Date: Fri, 14 Feb 2014 17:05:59 +0000
From: Steve Capper <steve.capper@linaro.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ARM: mm: report both sections from PMD
Message-ID: <20140214170558.GA13608@linaro.org>
References: <20140213195230.GA15275@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140213195230.GA15275@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 11:52:30AM -0800, Kees Cook wrote:
> On 2-level page table systems, the PMD has 2 section entries. Report
> these, otherwise ARM_PTDUMP will miss reporting permission changes on
> odd section boundaries.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v3:
>  - re-reorganize, drop use of pmd_sect; suggested by Catalin Marinas.
> v2:
>  - reorganize, suggested by Catalin Marinas.
> ---
>  arch/arm/mm/dump.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm/mm/dump.c b/arch/arm/mm/dump.c
> index 2b342177f5de..61cc78ae9f21 100644
> --- a/arch/arm/mm/dump.c
> +++ b/arch/arm/mm/dump.c
> @@ -264,6 +264,9 @@ static void walk_pmd(struct pg_state *st, pud_t *pud, unsigned long start)
>  			note_page(st, addr, 3, pmd_val(*pmd));
>  		else
>  			walk_pte(st, pmd, addr);
> +
> +		if (SECTION_SIZE < PMD_SIZE && pmd_large(pmd[1]))
> +			note_page(st, addr + SECTION_SIZE, 3, pmd_val(pmd[1]));
>  	}
>  }
>  
> -- 
> 1.7.9.5

This picks up an odd megabyte aligned section on my Arndale board with
short descriptors on 3.14-rc2. Behaves as expected with long descriptors
too (does nothing).

FWIW:
Tested-by: Steve Capper <steve.capper@linaro.org>

Cheers,
-- 
Steve

> 
> 
> -- 
> Kees Cook
> Chrome OS Security
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
