Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbaBUNY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:24:27 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:45732 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932692AbaBUNYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:24:22 -0500
Date: Fri, 21 Feb 2014 13:24:16 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joel Fernandes <joelf@ti.com>
Cc: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nsekhar@ti.com
Subject: Re: [PATCH] ARM: EDMA: Use platform_get_resource functions for DT
Message-ID: <20140221132416.GS27282@n2100.arm.linux.org.uk>
References: <1392956661-28787-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392956661-28787-1-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 10:24:21PM -0600, Joel Fernandes wrote:
> diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
> index dc95efc..ae0ccae 100644
> --- a/arch/arm/common/edma.c
> +++ b/arch/arm/common/edma.c
> @@ -1469,11 +1470,14 @@ static int edma_xbar_event_map(struct device *dev,
>  	if (!xbar_chans)
>  		return -ENOMEM;
>  
> -	ret = of_address_to_resource(node, 1, &res);
> -	if (ret)
> +	pdev = to_platform_device(dev);
> +	res = platform_get_resource_byname(pdev,
> +					   IORESOURCE_MEM,
> +					   "edma_xbar");
> +	if (!res)
>  		return -EIO;
>  
> -	xbar = devm_ioremap(dev, res.start, resource_size(&res));
> +	xbar = devm_ioremap(dev, res->start, resource_size(res));
>  	if (!xbar)
>  		return -ENOMEM;

Irrespective of what Mark said, this should be upgraded to use
devm_ioremap_resource() which does all the checking necessary (and
claims the resource.)  That can be done irrespective of this change.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
