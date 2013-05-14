Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab3ENQgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:36:00 -0400
Received: from ra.se.axis.com ([195.60.68.13]:54890 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab3ENQf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:35:58 -0400
Date: Tue, 14 May 2013 18:35:57 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Denis Efremov <yefremov.denis@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>,
        "ldv-project@linuxtesting.org" <ldv-project@linuxtesting.org>
Subject: Re: [PATCH 17/21] CRISv32: remove inline marking of EXPORT_SYMBOL
 functions
Message-ID: <20130514163556.GR8853@axis.com>
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
 <1368095819-11011-6-git-send-email-yefremov.denis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368095819-11011-6-git-send-email-yefremov.denis@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 12:36:55PM +0200, Denis Efremov wrote:
> EXPORT_SYMBOL and inline directives are contradictory to each other.
> The patch fixes this inconsistency.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>

Yes, agreed.

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> ---
>  arch/cris/arch-v32/kernel/cache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/cris/arch-v32/kernel/cache.c b/arch/cris/arch-v32/kernel/cache.c
> index f38433b..876be53 100644
> --- a/arch/cris/arch-v32/kernel/cache.c
> +++ b/arch/cris/arch-v32/kernel/cache.c
> @@ -5,7 +5,7 @@
>  
>  /* This file is used to workaround a cache bug, Guinness TR 106. */
>  
> -inline void flush_dma_descr(struct dma_descr_data *descr, int flush_buf)
> +void flush_dma_descr(struct dma_descr_data *descr, int flush_buf)
>  {
>  	/* Flush descriptor to make sure we get correct in_eop and after. */
>  	asm volatile ("ftagd [%0]" :: "r" (descr));
> -- 
> 1.8.1.4

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
