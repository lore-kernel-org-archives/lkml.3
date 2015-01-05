Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbbAEOeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:34:37 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:60761 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbbAEOeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:34:36 -0500
Date: Mon, 5 Jan 2015 15:32:47 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arch: arm: mm: cache-feroceon-l2: Remove some unused
 functions
Message-ID: <20150105143247.GD9142@lunn.ch>
References: <1420134969-1892-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420134969-1892-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 01, 2015 at 06:56:09PM +0100, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> l2_inv_pa() l2_clean_pa()
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>


Acked-by: Andrew Lunn <andrew@lunn.ch>

Please could you submit this to Russell Kings patch tracker.

Thanks
	Andrew

> ---
>  arch/arm/mm/cache-feroceon-l2.c |   10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/arch/arm/mm/cache-feroceon-l2.c b/arch/arm/mm/cache-feroceon-l2.c
> index e028a7f..c2eac97 100644
> --- a/arch/arm/mm/cache-feroceon-l2.c
> +++ b/arch/arm/mm/cache-feroceon-l2.c
> @@ -65,11 +65,6 @@ static inline void l2_put_va(unsigned long vaddr)
>  #endif
>  }
>  
> -static inline void l2_clean_pa(unsigned long addr)
> -{
> -	__asm__("mcr p15, 1, %0, c15, c9, 3" : : "r" (addr));
> -}
> -
>  static inline void l2_clean_pa_range(unsigned long start, unsigned long end)
>  {
>  	unsigned long va_start, va_end, flags;
> @@ -96,11 +91,6 @@ static inline void l2_clean_inv_pa(unsigned long addr)
>  	__asm__("mcr p15, 1, %0, c15, c10, 3" : : "r" (addr));
>  }
>  
> -static inline void l2_inv_pa(unsigned long addr)
> -{
> -	__asm__("mcr p15, 1, %0, c15, c11, 3" : : "r" (addr));
> -}
> -
>  static inline void l2_inv_pa_range(unsigned long start, unsigned long end)
>  {
>  	unsigned long va_start, va_end, flags;
> -- 
> 1.7.10.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
