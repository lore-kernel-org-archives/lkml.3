Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbaJWJ4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 05:56:47 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:42679 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaJWJ4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 05:56:43 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Thu, 23 Oct 2014 11:53:39 +0200
From: Johan Hovold <johan@kernel.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: devicetree@vger.kernel.org, broonie@kernel.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, heiko@sntech.de, grant.likely@linaro.org,
        robh@kernel.org, mark.rutland@arm.com, linux-pm@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>
Subject: Re: [RFC v3 PATCH 1/5] of: Add standard property for poweroff
 capability
Message-ID: <20141023095339.GC6641@localhost>
References: <1413268273-15151-1-git-send-email-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413268273-15151-1-git-send-email-romain.perier@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ +CC: Guenter, Lee, linux-pm ]

On Tue, Oct 14, 2014 at 06:31:09AM +0000, Romain Perier wrote:
> Several drivers create their own devicetree property when they register
> poweroff capabilities. This is for example the case for mfd, regulator
> or power drivers which define "vendor,system-power-controller" property.
> This patch adds support for a standard property "poweroff-source"

Shouldn't this property really be called "power-off-source" or even
"power-off-controller"?

The power-off handler call-chain infrastructure is about to be merged
and will be using power[-_ ]off (i.e. not "poweroff") consistently (at
least in its interface).

Furthermore, isn't "controller" as in "power-off-controller" more
appropriate than "source" in this case? We have wake-up sources, which
might appear analogous, but that really isn't the same thing.

I now this has already been merged to the regulator tree, but there's
still still time to fix this.

> which marks the device as able to shutdown the system.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> ---
>  include/linux/of.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 6545e7a..27b3ba1 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -866,4 +866,15 @@ static inline int of_changeset_update_property(struct of_changeset *ocs,
>  /* CONFIG_OF_RESOLVE api */
>  extern int of_resolve_phandles(struct device_node *tree);
>  
> +/**
> + * of_system_has_poweroff_source - Tells if poweroff-source is found for device_node
> + * @np: Pointer to the given device_node
> + *
> + * return true if present false otherwise
> + */
> +static inline bool of_system_has_poweroff_source(const struct device_node *np)

Why "system_has"? Shouldn't this be of_is_power_off_source (controller)?

> +{
> +	return of_property_read_bool(np, "poweroff-source");
> +}
> +
>  #endif /* _LINUX_OF_H */

Thanks,
Johan
