Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbaDOUXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 16:23:50 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:32880 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaDOUXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 16:23:48 -0400
MIME-Version: 1.0
In-Reply-To: <1397576297-4785-1-git-send-email-linux@roeck-us.net>
References: <1397576297-4785-1-git-send-email-linux@roeck-us.net>
Date: Tue, 15 Apr 2014 15:23:47 -0500
Message-ID: <CAL_JsqKUwgWyv+AjyfyVdiArsLzrZo=OwDkbfLC+93e6BTxg3Q@mail.gmail.com>
Subject: Re: [PATCH] of: Clean up of_update_property
From: Rob Herring <robherring2@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 10:38 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> After searching for the old property, bail out with -ENODEV
> if it was not found.
>
> It is unnecessary to check if oldprop is NULL before removing
> its binary file; the check was already done before.
>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Applied. Thanks.

Rob

> ---
>  drivers/of/base.c |   10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index f72d19b..6d4ee22 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1828,17 +1828,13 @@ int of_update_property(struct device_node *np, struct property *newprop)
>                 next = &(*next)->next;
>         }
>         raw_spin_unlock_irqrestore(&devtree_lock, flags);
> -       if (rc)
> -               return rc;
> +       if (!found)
> +               return -ENODEV;
>
>         /* Update the sysfs attribute */
> -       if (oldprop)
> -               sysfs_remove_bin_file(&np->kobj, &oldprop->attr);
> +       sysfs_remove_bin_file(&np->kobj, &oldprop->attr);
>         __of_add_property_sysfs(np, newprop);
>
> -       if (!found)
> -               return -ENODEV;
> -
>         return 0;
>  }
>
> --
> 1.7.9.7
>
