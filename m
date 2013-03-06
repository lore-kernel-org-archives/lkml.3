Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab3CFJdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 04:33:20 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58207 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365Ab3CFJdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 04:33:14 -0500
Message-ID: <51370D53.9060100@ti.com>
Date: Wed, 6 Mar 2013 11:33:07 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: Roger Quadros <rogerq@ti.com>, "Balbi, Felipe" <balbi@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>
Subject: Re: mfd: omap-usb-host: bug fix for 3.9
References: <512E120D.7000101@ti.com>
In-Reply-To: <512E120D.7000101@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On 02/27/2013 04:02 PM, Roger Quadros wrote:
> Hi Samuel,
> 
> One of my patch that I sent for 3.9 introduces a bug that fails to
> update the port mode hostconfig register. Because of that, the port modes will
> always be 0 (i.e. EHCI PHY mode) and other modes will not work. PHY mode will
> work, so beagle/panda have no issues.
> 
> Since my hardware setup uses only PHY mode, I couldn't catch this problem earlier.
> 
> Below is the fix.

Gentle reminder to pick this for 3.9-rc2. Thanks.

cheers,
-roger

> 
>>From 82466757a212bd8b54d806c9d56b1acccbd4d464 Mon Sep 17 00:00:00 2001
> From: Roger Quadros <rogerq@ti.com>
> Date: Wed, 27 Feb 2013 15:19:24 +0200
> Subject: [PATCH] mfd: omap-usb-host: Actually update hostconfig
> 
> The helper functions omap_usbhs_rev1_hostconfig()
> and omap_usbhs_rev2_hostconfig() don't write into
> the hostconfig register. Make sure that we write
> the return value into the hostconfig register.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/mfd/omap-usb-host.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index 6b5edf6..4febc5c 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -460,15 +460,15 @@ static void omap_usbhs_init(struct device *dev)
>  
>  	switch (omap->usbhs_rev) {
>  	case OMAP_USBHS_REV1:
> -		omap_usbhs_rev1_hostconfig(omap, reg);
> +		reg = omap_usbhs_rev1_hostconfig(omap, reg);
>  		break;
>  
>  	case OMAP_USBHS_REV2:
> -		omap_usbhs_rev2_hostconfig(omap, reg);
> +		reg = omap_usbhs_rev2_hostconfig(omap, reg);
>  		break;
>  
>  	default:	/* newer revisions */
> -		omap_usbhs_rev2_hostconfig(omap, reg);
> +		reg = omap_usbhs_rev2_hostconfig(omap, reg);
>  		break;
>  	}
>  
> 

