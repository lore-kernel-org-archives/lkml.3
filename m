Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3HUSkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:40:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:50508 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370Ab3HUSky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:40:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,929,1367996400"; 
   d="scan'208";a="366380434"
Date: Wed, 21 Aug 2013 11:40:42 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Julius Werner <jwerner@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Benson Leung <bleung@chromium.org>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] usb: xhci-plat: Enable USB 2.0 hardware LPM support for
 platform xHCs
Message-ID: <20130821184042.GC3577@xanatos>
References: <1377040909-18428-1-git-send-email-jwerner@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377040909-18428-1-git-send-email-jwerner@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julius,

Thanks for the patch!  Did you test with a USB analyzer to see if the
device was actually going into USB 2.0 Link PM?  I'd like to confirm we
really aren't breaking anything for DW3 hosts by enabling this.

Sarah Sharp

On Tue, Aug 20, 2013 at 04:21:49PM -0700, Julius Werner wrote:
> The driver methods required for hardware LPM have only been added to the
> PCI version of the XHCI driver, for no apparent reason. They seem to
> work just as well with the platform driver, so let's add them to give
> more devices the chance for additional power savings. Tested on the DWC3
> xHC of an Exynos5420.
> 
> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---
>  drivers/usb/host/xhci-plat.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> index 51e22bf..7f46b5d 100644
> --- a/drivers/usb/host/xhci-plat.c
> +++ b/drivers/usb/host/xhci-plat.c
> @@ -80,6 +80,10 @@ static const struct hc_driver xhci_plat_xhci_driver = {
>  	.hub_status_data =	xhci_hub_status_data,
>  	.bus_suspend =		xhci_bus_suspend,
>  	.bus_resume =		xhci_bus_resume,
> +
> +	/* LPM support */
> +	.update_device =	xhci_update_device,
> +	.set_usb2_hw_lpm =	xhci_set_usb2_hardware_lpm,
>  };
>  
>  static int xhci_plat_probe(struct platform_device *pdev)
> -- 
> 1.7.12.4
> 
