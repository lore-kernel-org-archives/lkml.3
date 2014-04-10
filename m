Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681AbaDJSN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:13:27 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:34800 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaDJSNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:13:24 -0400
Date: Thu, 10 Apr 2014 21:09:06 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, tony@atomide.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 05/13] extcon: extcon-class: improve extcon client API
Message-ID: <20140410180906.GD15736@drone.musicnaut.iki.fi>
References: <1397135811-12866-1-git-send-email-r.baldyga@samsung.com>
 <1397135811-12866-6-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397135811-12866-6-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Apr 10, 2014 at 03:16:43PM +0200, Robert Baldyga wrote:
> +struct extcon_cable *extcon_get_cable_by_name(struct device *dev,
> +						 const char *name)
> +{
> +	return of_extcon_get_cable_by_name(dev->of_node, name);
> +}
> +EXPORT_SYMBOL_GPL(extcon_get_cable_by_name);

[...]

> @@ -96,17 +95,13 @@ static int omap_otg_probe(struct platform_device *pdev)
>  {
>  	const struct omap_usb_config *config = pdev->dev.platform_data;
                                                         ^^^^^^^^^^^^^

[...]

> -	ret = extcon_register_interest(&otg_dev->id_dev, config->extcon,
> -				       "USB-HOST", &otg_dev->id_nb);
> +	cable_id = extcon_get_cable_by_name(&pdev->dev, "USB-HOST");

NACK. OMAP1 is not using DT, so this driver would stop working
with this series.

A.
