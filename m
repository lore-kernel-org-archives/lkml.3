Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbaGNOGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:06:50 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:47633 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796AbaGNOGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:06:43 -0400
Date: Mon, 14 Jul 2014 16:06:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org
Subject: Re: [RESEND][PATCH] sparc: use %s for unaligned panic
Message-ID: <20140714140617.GA18763@ravnborg.org>
References: <20140630203759.GA4764@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630203759.GA4764@www.outflux.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 01:37:59PM -0700, Kees Cook wrote:
> Since unaligned_panic() takes a literal string, make sure it can never
> accidentally be used as a format string.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/sparc/kernel/unaligned_32.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/sparc/kernel/unaligned_32.c b/arch/sparc/kernel/unaligned_32.c
> index c5c61b3c6b56..32b61d1b6379 100644
> --- a/arch/sparc/kernel/unaligned_32.c
> +++ b/arch/sparc/kernel/unaligned_32.c
> @@ -166,7 +166,7 @@ unsigned long safe_compute_effective_address(struct pt_regs *regs,
>  /* This is just to make gcc think panic does return... */
>  static void unaligned_panic(char *str)
>  {
> -	panic(str);
> +	panic("%s", str);
>  }
>  
>  /* una_asm.S */

The feedback last time was that this patch is silly.
panic() has only two callsites within the same file.

	Sam
