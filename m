Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaBQSSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 13:18:37 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33940 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbaBQSSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 13:18:35 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of: Turn of_match_node into a static inline when CONFIG_OF isn't set
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>
In-Reply-To: <1392122211-11422-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1392122211-11422-1-git-send-email-laurent.pinchart@ ideasonboard.com>
Date: Mon, 17 Feb 2014 18:18:29 +0000
Message-Id: <20140217181829.B5F80C40372@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014 13:36:51 +0100, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> when CONFIG_OF is disabled of_match_node is defined as a macro that
> evaluates to NULL. This breaks compilation of drivers that dereference
> the function's return value directly. Fix it by turning the macro into a
> static inline function that returns NULL.

Is it not more problematic that code is dereferencing the return value
directly *without* checking to see if it is NULL first? I suppose it
will cause a runtime oops on all platforms except no-mmu, but still.
Compile time catches are better.

g.

> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  include/linux/of.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 70c64ba..719e69f 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -560,7 +560,13 @@ static inline const char *of_prop_next_string(struct property *prop,
>  }
>  
>  #define of_match_ptr(_ptr)	NULL
> -#define of_match_node(_matches, _node)	NULL
> +
> +static inline const struct of_device_id *of_match_node(
> +	const struct of_device_id *matches, const struct device_node *node)
> +{
> +	return NULL;
> +}
> +
>  #endif /* CONFIG_OF */
>  
>  #if defined(CONFIG_OF) && defined(CONFIG_NUMA)
> -- 
> Regards,
> 
> Laurent Pinchart
> 

