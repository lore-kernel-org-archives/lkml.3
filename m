Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031253AbaLLRtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:49:50 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44666 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031011AbaLLRt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:49:26 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] staging:board: fix build errors and warnings
To: Tsung-Han Lin <tsunghan.tw@gmail.com>, gregkh@linuxfoundation.org
Cc: robh+dt@kernel.org, horms+renesas@verge.net.au, damm+renesas@opensource.se,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
In-Reply-To: <1418059449-15108-1-git-send-email-tsunghan.tw@gmail.com>
References: <1418059449-15108-1-git-send-email-tsunghan.tw@gmail.com>
Date: Fri, 12 Dec 2014 11:36:10 +0000
Message-Id: <20141212113610.C88F5C40872@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  9 Dec 2014 01:24:09 +0800
, Tsung-Han Lin <tsunghan.tw@gmail.com>
 wrote:
> Add dummy implementation of 'of_find_all_nodes',
> and remove the unnecessary 'of_can_translate_address',
> which is already removed in commit
> d9c6866be8a145e32da616d8dcbae806032d75b5 ("of: kill off
> of_can_translate_address"), to fix the build errors and warnings
> found by sparse.
> 
> Signed-off-by: Tsung-Han Lin <tsunghan.tw@gmail.com>

???

This code is just weird. If CONFIG_OF is not enabled, then board.c
shouldn't be compiled at all. You can do this with a patch to the
Kconfig and Makefile. Also, if the functions in
drivers/staging/board/board.c are needed for driver support, then please
propose a patch that moves them in into drivers/of/base.c so that they
can be reviewed properly. They are so short and simple that fixing them
up as part of the normal review process should be sufficient.

As for fixing the compile error, please drop the change to
include/linux/of.h and resubmit.

g.


> ---
>  drivers/staging/board/board.c | 3 +--
>  include/linux/of.h            | 5 +++++
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/board/board.c b/drivers/staging/board/board.c
> index 6050fbdfd31f..d5a6abc84519 100644
> --- a/drivers/staging/board/board.c
> +++ b/drivers/staging/board/board.c
> @@ -11,8 +11,7 @@ static bool find_by_address(u64 base_address)
>  	struct resource res;
>  
>  	while (dn) {
> -		if (of_can_translate_address(dn)
> -		    && !of_address_to_resource(dn, 0, &res)) {
> +		if (!of_address_to_resource(dn, 0, &res)) {
>  			if (res.start == base_address) {
>  				of_node_put(dn);
>  				return true;
> diff --git a/include/linux/of.h b/include/linux/of.h
> index dfde07e77a63..c2c5021c1ee4 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -616,6 +616,11 @@ static inline const char *of_prop_next_string(struct property *prop,
>  	return NULL;
>  }
>  
> +static inline struct device_node *of_find_all_nodes(struct device_node *prev)
> +{
> +	return NULL;
> +}
> +
>  #define of_match_ptr(_ptr)	NULL
>  #define of_match_node(_matches, _node)	NULL
>  #endif /* CONFIG_OF */
> -- 
> 2.1.0
> 

