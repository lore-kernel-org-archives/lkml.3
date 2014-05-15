Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbaEOOTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:19:41 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:56447 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaEOOTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:19:38 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of: fix CONFIG_OF=n prototype of of_node_full_name()
To: Stephen Rothwell <sfr@canb.auug.org.au>, Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20140515144430.11ab033b@canb.auug.org.au>
References: <20140515144430.11ab033b@canb.auug.org.au>
Date: Thu, 15 May 2014 15:19:29 +0100
Message-Id: <20140515141929.8CA29C4095B@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014 14:44:30 +1000, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Make the CONFIG_OF=n prototpe of of_node_full_name() mateh the CONFIG_OF=y
> version.
> 
> Fixes compile warnings like this:
> 
> sound/soc/soc-core.c: In function 'soc_check_aux_dev':
> sound/soc/soc-core.c:1667:3: warning: passing argument 1 of 'of_node_full_name' discards 'const' qualifier from pointer target type [enabled by default]
>    codecname = of_node_full_name(aux_dev->codec_of_node);
> 
> when CONFIG_OF is not defined.

Good catch, thanks. Applied and will be sent to Linus shortly.

g.

> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  include/linux/of.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 3bad8d106e0e..e6f0988c1c68 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -349,7 +349,7 @@ int of_device_is_stdout_path(struct device_node *dn);
>  
>  #else /* CONFIG_OF */
>  
> -static inline const char* of_node_full_name(struct device_node *np)
> +static inline const char* of_node_full_name(const struct device_node *np)
>  {
>  	return "<no-node>";
>  }
> -- 
> 2.0.0.rc2
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au

