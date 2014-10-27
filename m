Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaJ0NSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:18:32 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:64968 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752572AbaJ0NSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:18:31 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18uPfYKk4ryKeDIHslJTK0kB2rQIoo2X+w=
X-DKIM: OpenDKIM Filter v2.0.1 titan EF6226093C9
Date: Mon, 27 Oct 2014 09:18:25 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Eric Rost <eric.rost@mybabylon.net>
Cc: gregkh@linuxfoundation.org, jake@lwn.net, antonysaraev@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 7/7] staging: skein: Removes skein_debug include
Message-ID: <20141027131825.GA15252@titan.lakedaemon.net>
References: <cover.1414189566.git.eric.rost@mybabylon.net>
 <11468e1b3923e05c6683dd388136b9ba925aff10.1414189566.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11468e1b3923e05c6683dd388136b9ba925aff10.1414189566.git.eric.rost@mybabylon.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 05:34:56PM -0500, Eric Rost wrote:
> Removes skein_debug.h include since skein_debug.h is nonexistent.
> 
> Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
> ---
>  drivers/staging/skein/skein_base.h | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/skein/skein_base.h b/drivers/staging/skein/skein_base.h
> index 0111fa4..5b69e5a 100644
> --- a/drivers/staging/skein/skein_base.h
> +++ b/drivers/staging/skein/skein_base.h
> @@ -15,10 +15,6 @@
>  **
>  ** The "default" note explains what happens when the switch is not defined.
>  **
> -**  SKEIN_DEBUG            -- make callouts from inside Skein code
> -**                            to examine/display intermediate values.
> -**                            [default: no callouts (no overhead)]
> -**
>  **  SKEIN_ERR_CHECK        -- how error checking is handled inside Skein
>  **                            code. If not defined, most error checking
>  **                            is disabled (for performance). Otherwise,
> @@ -282,15 +278,12 @@ int skein_1024_output(struct skein_1024_ctx *ctx, u8 *hash_val);
>  /*****************************************************************
>  ** "Internal" Skein definitions for debugging and error checking
>  ******************************************************************/
> -#ifdef SKEIN_DEBUG             /* examine/display intermediate values? */
> -#include "skein_debug.h"
> -#else                           /* default is no callouts */
>  #define skein_show_block(bits, ctx, x, blk_ptr, w_ptr, ks_event_ptr, ks_odd_ptr)
>  #define skein_show_round(bits, ctx, r, x)
>  #define skein_show_r_ptr(bits, ctx, r, x_ptr)
>  #define skein_show_final(bits, ctx, cnt, out_ptr)
>  #define skein_show_key(bits, ctx, key, key_bytes)

Are these called anywhere (sorry, away from dev box atm)?  If so, we
should remove those as well.

We shouldn't let this hold up the rest of the series, though.  I'll R-b
the rest and we'll keep working on this one.

thx,

Jason.

> -#endif
> +
>  
>  /* ignore all asserts, for performance */
>  #define skein_assert_ret(x, ret_code)
> -- 
> 2.1.1
> 
