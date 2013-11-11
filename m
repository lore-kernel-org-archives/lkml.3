Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3KLCjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 21:39:25 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:64979 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab3KLChP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 21:37:15 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 3/5] OF: export of_property_notify
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <1383673816-29293-4-git-send-email-panto@antoniou-consulting.com>
References: <1383673816-29293-1-git-send-email-panto@antoniou-consulting.com> <1383673816-29293-4-git-send-email-panto@antoniou-consulting.com>
Date: Mon, 11 Nov 2013 16:06:49 +0000
Message-Id: <20131111160649.58E70C4230C@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  5 Nov 2013 19:50:14 +0200, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
> of_property_notify can be utilized by other users too, export it.

Please keep this patch in the series with the patch that actually uses
it.

g.

> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> ---
>  drivers/of/base.c  |  8 +-------
>  include/linux/of.h | 11 +++++++++++
>  2 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index ca10916..0ffc5a9 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1424,7 +1424,7 @@ int of_count_phandle_with_args(const struct device_node *np, const char *list_na
>  EXPORT_SYMBOL(of_count_phandle_with_args);
>  
>  #if defined(CONFIG_OF_DYNAMIC)
> -static int of_property_notify(int action, struct device_node *np,
> +int of_property_notify(int action, struct device_node *np,
>  			      struct property *prop)
>  {
>  	struct of_prop_reconfig pr;
> @@ -1433,12 +1433,6 @@ static int of_property_notify(int action, struct device_node *np,
>  	pr.prop = prop;
>  	return of_reconfig_notify(action, &pr);
>  }
> -#else
> -static int of_property_notify(int action, struct device_node *np,
> -			      struct property *prop)
> -{
> -	return 0;
> -}
>  #endif
>  
>  /**
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 786c4f6..6fec255 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -307,6 +307,17 @@ extern int of_parse_phandle_with_fixed_args(const struct device_node *np,
>  extern int of_count_phandle_with_args(const struct device_node *np,
>  	const char *list_name, const char *cells_name);
>  
> +#if defined(CONFIG_OF_DYNAMIC)
> +extern int of_property_notify(int action, struct device_node *np,
> +			      struct property *prop);
> +#else
> +static inline int of_property_notify(int action, struct device_node *np,
> +			      struct property *prop)
> +{
> +	return 0;
> +}
> +#endif
> +
>  extern void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align));
>  extern int of_alias_get_id(struct device_node *np, const char *stem);
>  
> -- 
> 1.7.12
> 

