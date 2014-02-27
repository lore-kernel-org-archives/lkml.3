Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbaB0C3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 21:29:08 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:38847 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbaB0C3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 21:29:05 -0500
X-Originating-IP: 50.43.14.201
Date: Wed, 26 Feb 2014 18:28:57 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-sparse@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sparse: Allow override of sizeof(bool) warning
Message-ID: <20140227022857.GC23659@thin>
References: <530E6F76.1070605@zytor.com>
 <1393462087.24588.50.camel@joe-AO722>
 <530E8C2E.7080307@zytor.com>
 <1393466619.24588.65.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393466619.24588.65.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 06:03:39PM -0800, Joe Perches wrote:
> Allow an override to emit or not the sizeof(bool) warning
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Seems reasonable.  However, please document the new flag in the manpage.

>  evaluate.c | 3 ++-
>  lib.c      | 2 ++
>  lib.h      | 1 +
>  3 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/evaluate.c b/evaluate.c
> index 6655615..a45f59b 100644
> --- a/evaluate.c
> +++ b/evaluate.c
> @@ -2057,7 +2057,8 @@ static struct symbol *evaluate_sizeof(struct expression *expr)
>  	}
>  
>  	if (size == 1 && is_bool_type(type)) {
> -		warning(expr->pos, "expression using sizeof bool");
> +		if (Wsizeof_bool)
> +			warning(expr->pos, "expression using sizeof bool");
>  		size = bits_in_char;
>  	}
>  
> diff --git a/lib.c b/lib.c
> index bf3e91c..676b72e 100644
> --- a/lib.c
> +++ b/lib.c
> @@ -225,6 +225,7 @@ int Wone_bit_signed_bitfield = 1;
>  int Wparen_string = 0;
>  int Wptr_subtraction_blows = 0;
>  int Wreturn_void = 0;
> +int Wsizeof_bool = 1;
>  int Wshadow = 0;
>  int Wtransparent_union = 0;
>  int Wtypesign = 0;
> @@ -437,6 +438,7 @@ static const struct warning {
>  	{ "paren-string", &Wparen_string },
>  	{ "ptr-subtraction-blows", &Wptr_subtraction_blows },
>  	{ "return-void", &Wreturn_void },
> +	{ "sizeof-bool", &Wsizeof_bool },
>  	{ "shadow", &Wshadow },
>  	{ "transparent-union", &Wtransparent_union },
>  	{ "typesign", &Wtypesign },
> diff --git a/lib.h b/lib.h
> index f09b338..7e3432f 100644
> --- a/lib.h
> +++ b/lib.h
> @@ -119,6 +119,7 @@ extern int Wone_bit_signed_bitfield;
>  extern int Wparen_string;
>  extern int Wptr_subtraction_blows;
>  extern int Wreturn_void;
> +extern int Wsizeof_bool;
>  extern int Wshadow;
>  extern int Wtransparent_union;
>  extern int Wtypesign;
> -- 
> 1.8.1.2.459.gbcd45b4.dirty
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sparse" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
