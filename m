Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330Ab3GQEeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 00:34:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:10856 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab3GQEeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 00:34:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,682,1367996400"; 
   d="scan'208";a="371541839"
Date: Tue, 16 Jul 2013 21:34:16 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: linux-usb <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xhci: Correct misplaced newlines
Message-ID: <20130717043416.GA14392@xanatos>
References: <1374027959.1949.65.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374027959.1949.65.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Joe, I'll apply this to my tree after the merge window closes.

Sarah Sharp

On Tue, Jul 16, 2013 at 07:25:59PM -0700, Joe Perches wrote:
> Logging messages end in newlines, not have
> them put in the middle of messages.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/usb/host/xhci.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index 2c49f00..87b5e65 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -3075,8 +3075,8 @@ static u32 xhci_calculate_no_streams_bitmask(struct xhci_hcd *xhci,
>  		/* Are streams already being freed for the endpoint? */
>  		if (ep_state & EP_GETTING_NO_STREAMS) {
>  			xhci_warn(xhci, "WARN Can't disable streams for "
> -					"endpoint 0x%x\n, "
> -					"streams are being disabled already.",
> +					"endpoint 0x%x, "
> +					"streams are being disabled already\n",
>  					eps[i]->desc.bEndpointAddress);
>  			return 0;
>  		}
> @@ -3084,8 +3084,8 @@ static u32 xhci_calculate_no_streams_bitmask(struct xhci_hcd *xhci,
>  		if (!(ep_state & EP_HAS_STREAMS) &&
>  				!(ep_state & EP_GETTING_STREAMS)) {
>  			xhci_warn(xhci, "WARN Can't disable streams for "
> -					"endpoint 0x%x\n, "
> -					"streams are already disabled!",
> +					"endpoint 0x%x, "
> +					"streams are already disabled!\n",
>  					eps[i]->desc.bEndpointAddress);
>  			xhci_warn(xhci, "WARN xhci_free_streams() called "
>  					"with non-streams endpoint\n");
> @@ -4353,7 +4353,7 @@ static u16 xhci_get_timeout_no_hub_lpm(struct usb_device *udev,
>  				state_name, sel);
>  	else
>  		dev_dbg(&udev->dev, "Device-initiated %s disabled "
> -				"due to long PEL %llu\n ms",
> +				"due to long PEL %llu ms\n",
>  				state_name, pel);
>  	return USB3_LPM_DISABLED;
>  }
> 
> 
