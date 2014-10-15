Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaJOMlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 08:41:47 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54668 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaJOMlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 08:41:46 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC v3 PATCH 1/5] of: Add standard property for poweroff
 capability
To: Romain Perier <romain.perier@gmail.com>, devicetree@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        heiko@sntech.de, robh@kernel.org, mark.rutland@arm.com
In-Reply-To: <1413268273-15151-1-git-send-email-romain.perier@gmail.com>
References: <1413268273-15151-1-git-send-email-romain.perier@gmail.com>
Date: Wed, 15 Oct 2014 14:41:42 +0200
Message-Id: <20141015124142.92D0EC40B00@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2014 06:31:09 +0000
, Romain Perier <romain.perier@gmail.com>
 wrote:
> Several drivers create their own devicetree property when they register
> poweroff capabilities. This is for example the case for mfd, regulator
> or power drivers which define "vendor,system-power-controller" property.
> This patch adds support for a standard property "poweroff-source"
> which marks the device as able to shutdown the system.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>

Acked-by: Grant Likely <grant.likely@linaro.org>

And same for the documentation patches.

g.

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
> +{
> +	return of_property_read_bool(np, "poweroff-source");
> +}
> +
>  #endif /* _LINUX_OF_H */
> -- 
> 1.9.1
> 

