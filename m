Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab3KESMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 13:12:54 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:51615 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab3KESMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 13:12:53 -0500
Date: Tue, 5 Nov 2013 13:12:46 -0500
From: Matt Porter <matt.porter@linaro.org>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
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
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] OF: export of_property_notify
Message-ID: <20131105181246.GK7028@beef>
References: <1383673816-29293-1-git-send-email-panto@antoniou-consulting.com>
 <1383673816-29293-4-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383673816-29293-4-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 07:50:14PM +0200, Pantelis Antoniou wrote:
> of_property_notify can be utilized by other users too, export it.
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

EXPORT_SYMBOL[_GPL]?

-Matt
