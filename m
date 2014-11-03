Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbaKCOsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:48:15 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:42004 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbaKCOsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:48:13 -0500
X-Originating-IP: 50.43.41.112
Date: Mon, 3 Nov 2014 06:48:01 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: sparse@chrisli.org, Mark Rustad <mark.d.rustad@intel.com>,
        linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH] compiler: Correct macro parameter expansion problem
Message-ID: <20141103144800.GA23094@thin>
References: <1415025253-15976-1-git-send-email-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415025253-15976-1-git-send-email-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 06:34:13AM -0800, Jeff Kirsher wrote:
> From: Mark Rustad <mark.d.rustad@intel.com>
> 
> The macro __compiletime_error_fallback has an error in that it
> lacks parens around the expansion of an expression. It also
> lacks a conversion to a boolean value. The first problem can
> result in a mis-evaluation. The second problem can also result
> in an error if the value comes out negative. That would thwart
> the intended error generation. That is, the error being asserted
> would not in fact generate an error. Fix both problems by adding
> !!() to the expansion.
> 
> Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
> Tested-by: Aaron Brown <aaron.f.brown@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Good catch.

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  include/linux/compiler.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index d5ad7b1..59dc611 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -331,7 +331,7 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
>   */
>  # ifndef __CHECKER__
>  #  define __compiletime_error_fallback(condition) \
> -	do { ((void)sizeof(char[1 - 2 * condition])); } while (0)
> +	do { ((void)sizeof(char[1 - 2 * !!(condition)])); } while (0)
>  # endif
>  #endif
>  #ifndef __compiletime_error_fallback
> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sparse" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
