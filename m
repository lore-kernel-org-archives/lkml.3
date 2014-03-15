Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbaCOIHr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 04:07:47 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:52109 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaCOIHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 04:07:40 -0400
Date: Sat, 15 Mar 2014 09:07:09 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH] sparc: use %s for unaligned panic
Message-ID: <20140315080709.GA14405@ravnborg.org>
References: <20140311202446.GA24531@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140311202446.GA24531@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 01:24:46PM -0700, Kees Cook wrote:
> Since unaligned_panic() takes a literal string, make sure it can never
> accidentally be used as a format string.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/sparc/kernel/unaligned_32.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/sparc/kernel/unaligned_32.c b/arch/sparc/kernel/unaligned_32.c
> index c0ec89786193..892e399414e0 100644
> --- a/arch/sparc/kernel/unaligned_32.c
> +++ b/arch/sparc/kernel/unaligned_32.c
> @@ -162,7 +162,7 @@ unsigned long safe_compute_effective_address(struct pt_regs *regs,
>  /* This is just to make gcc think panic does return... */
>  static void unaligned_panic(char *str)
>  {
> -	panic(str);
> +	panic("%s", str);
>  }
>  
>  /* una_asm.S */

Another "fix" would be to align with sparc64 and call die_if_kernel()

	Sam
