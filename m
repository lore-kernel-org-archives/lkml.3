Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbaBLRPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 12:15:17 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:53594 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaBLRPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 12:15:14 -0500
Date: Wed, 12 Feb 2014 09:15:09 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu, wim@iguana.be,
        linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 07/11] watchdog: xilinx: Use of_property_read_u32
Message-ID: <20140212171509.GB20012@roeck-us.net>
References: <cover.1392212059.git.michal.simek@xilinx.com>
 <7cbb10853a343c9d488346596f604909ab0668b9.1392212059.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cbb10853a343c9d488346596f604909ab0668b9.1392212059.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Wed, Feb 12, 2014 at 02:41:21PM +0100, Michal Simek wrote:
> Use of_property_read_u32 functions to clean probe function.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> ---
> 
> Changes in v3:
> - Remove one if checking and use variable directly
> 

Looks good.

Another comment/remark.

> 
> -	pfreq = (u32 *)of_get_property(pdev->dev.of_node,
> -					"clock-frequency", NULL);
> -
> -	if (pfreq == NULL) {
> +	rc = of_property_read_u32(pdev->dev.of_node, "clock-frequency", &pfreq);
> +	if (rc) {
>  		dev_warn(&pdev->dev,
>  			 "The watchdog clock frequency cannot be obtained\n");
>  		no_timeout = true;
>  	}
> 
> -	tmptr = (u32 *)of_get_property(pdev->dev.of_node,
> -					"xlnx,wdt-interval", NULL);
> -	if (tmptr == NULL) {
> +	rc = of_property_read_u32(pdev->dev.of_node, "xlnx,wdt-interval",
> +				  &xdev->wdt_interval);
> +	if (rc) {
>  		dev_warn(&pdev->dev,
>  			 "Parameter \"xlnx,wdt-interval\" not found\n");
>  		no_timeout = true;
> -	} else {
> -		xdev->wdt_interval = *tmptr;
>  	}
> 
> -	tmptr = (u32 *)of_get_property(pdev->dev.of_node,
> -					"xlnx,wdt-enable-once", NULL);
> -	if (tmptr == NULL) {
> +	rc = of_property_read_u32(pdev->dev.of_node, "xlnx,wdt-enable-once",
> +				  &enable_once);
> +	if (rc)
>  		dev_warn(&pdev->dev,
>  			 "Parameter \"xlnx,wdt-enable-once\" not found\n");
> -		watchdog_set_nowayout(xilinx_wdt_wdd, true);
> -	}

All the above properties are optional. Is a warning really
warranted in this case ? I usually associate a warning with
something that is wrong, which is not the case here.

I would encourage you to drop those warnings, but that should be
a separate patch.

Thanks,
Guenter
