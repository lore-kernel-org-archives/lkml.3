Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaKDNny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:43:54 -0500
Received: from gate.crashing.org ([63.228.1.57]:49911 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbaKDNnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:43:51 -0500
Message-ID: <1415108571.19220.13.camel@kernel.crashing.org>
Subject: Re: [PATCH] of/platform: Move platform devices under
 /sys/devices/platform
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 05 Nov 2014 00:42:51 +1100
In-Reply-To: <1415097920-30014-1-git-send-email-grant.likely@linaro.org>
References: <1415097920-30014-1-git-send-email-grant.likely@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-04 at 10:45 +0000, Grant Likely wrote:
> Currently the devices created by drivers/of/platform.c get created at
> the root of /sys/devices. This goes against the typical pattern for
> sysfs where the top level /sys/devices structure contains categories of
> devices, and the structure of devices is placed below that. To fix this,
> make the code in drivers/of/platform.c follow the drivers/base/platform.c
> behaviour, and use &platform_bus as the default parent for all new
> platform_devices and amba_devices.
> 
> This change has been discussed for a long time, but nobody has actually
> acted on it. Userspace code that expects to find devices under a fixed
> /sys/devices/... path will be affected. It isn't /supposed/ to do that,
> but if anyone complains then I'll add a default-off workaround option to
> put them back into the root.

Ack !

Cheers,
Ben.

> 
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
>  drivers/of/platform.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 3b64d0bf5bba..7c6771986c06 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -138,7 +138,7 @@ struct platform_device *of_device_alloc(struct device_node *np,
>  	}
>  
>  	dev->dev.of_node = of_node_get(np);
> -	dev->dev.parent = parent;
> +	dev->dev.parent = parent ? : &platform_bus;
>  
>  	if (bus_id)
>  		dev_set_name(&dev->dev, "%s", bus_id);
> @@ -291,7 +291,7 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
>  
>  	/* setup generic device info */
>  	dev->dev.of_node = of_node_get(node);
> -	dev->dev.parent = parent;
> +	dev->dev.parent = parent ? : &platform_bus;
>  	dev->dev.platform_data = platform_data;
>  	if (bus_id)
>  		dev_set_name(&dev->dev, "%s", bus_id);


