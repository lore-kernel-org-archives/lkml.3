Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbaDVOj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:39:58 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:46076 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502AbaDVOjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:39:55 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of: Clean up of_update_property
To: Guenter Roeck <linux@roeck-us.net>, devicetree@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <1397576297-4785-1-git-send-email-linux@roeck-us.net>
References: <1397576297-4785-1-git-send-email-linux@roeck-us.net>
Date: Tue, 22 Apr 2014 15:39:46 +0100
Message-Id: <20140422143946.197B0C40793@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014 08:38:17 -0700, Guenter Roeck <linux@roeck-us.net> wrote:
> After searching for the old property, bail out with -ENODEV
> if it was not found.
> 
> It is unnecessary to check if oldprop is NULL before removing
> its binary file; the check was already done before.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/of/base.c |   10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index f72d19b..6d4ee22 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1828,17 +1828,13 @@ int of_update_property(struct device_node *np, struct property *newprop)
>  		next = &(*next)->next;
>  	}
>  	raw_spin_unlock_irqrestore(&devtree_lock, flags);
> -	if (rc)
> -		return rc;
> +	if (!found)
> +		return -ENODEV;
>  
>  	/* Update the sysfs attribute */
> -	if (oldprop)
> -		sysfs_remove_bin_file(&np->kobj, &oldprop->attr);
> +	sysfs_remove_bin_file(&np->kobj, &oldprop->attr);

Hahaha. The funny think is that I had to put this change right back in
when picking up Xiubo's patch. The logic has become slightly different
with his fix though, so it doesn't make this patch incorrect.

g.

