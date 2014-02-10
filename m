Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbaBJK3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:29:41 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:25514 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751564AbaBJK3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:29:40 -0500
Date: Mon, 10 Feb 2014 10:29:35 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Kees Cook <keescook@chromium.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        Steven Capper <steve.capper@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Cyril Chemparathy <cyril@ti.com>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: mm: report both sections from PMD
Message-ID: <20140210102935.GC25305@arm.com>
References: <20140209221826.GA30556@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140209221826.GA30556@www.outflux.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 10:18:26PM +0000, Kees Cook wrote:
> diff --git a/arch/arm/mm/dump.c b/arch/arm/mm/dump.c
> index 1f7b1e13d945..ff1559f9200c 100644
> --- a/arch/arm/mm/dump.c
> +++ b/arch/arm/mm/dump.c
> @@ -264,6 +264,9 @@ static void walk_pmd(struct pg_state *st, pud_t *pud, unsigned long start)
>  			note_page(st, addr, 3, pmd_val(*pmd));
>  		else
>  			walk_pte(st, pmd, addr);
> +
> +		if (SECTION_SIZE < PMD_SIZE && pmd_sect(*pmd))
> +			note_page(st, addr + SECTION_SIZE, 3, pmd_val(pmd[1]));

You can  use pmd_large() here as well.

But I think this function is broken (the "for" statement not shown
here). The pmd_t is 32-bit with classic MMU and it uses pmd++ while the
address grows by PMD_SIZE (two pmd_t entries).

-- 
Catalin
