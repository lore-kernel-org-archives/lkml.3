Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab3HPAPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 20:15:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44185 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3HPAPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 20:15:41 -0400
Date: Thu, 15 Aug 2013 17:17:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>, sarah.a.sharp@linux.intel.com
Cc: linux-kernel@vger.kernel.org, sarah.a.sharp@linux.intel.com,
        dmitry.kasatkin@gmail.com
Subject: Re: [PATCH 2/2] xhci:prevent "callbacks suppressed" when debug is
 not enabled
Message-ID: <20130816001716.GA7367@kroah.com>
References: <71bb3fcd9f1a99aa7bd8f6dd1fb6267173db51d2.1376582695.git.d.kasatkin@samsung.com>
 <70b3564625bbda6247cc5627041344fef8a762ae.1376582695.git.d.kasatkin@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70b3564625bbda6247cc5627041344fef8a762ae.1376582695.git.d.kasatkin@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 07:04:55PM +0300, Dmitry Kasatkin wrote:
> When debug is not enabled and dev_dbg() will expand to nothing,
> log might be flooded with "callbacks suppressed". If it was not
> done on purpose, better to use dev_dbg_ratelimited() instead.
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> ---
>  drivers/usb/host/xhci-ring.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)


Sarah, does this patch conflict with the trace debug patches being
worked on?  I'll hold off on applying it for now, let me know if it's ok
or not.

thanks,

greg k-h
> 
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index 5b08cd8..5298232 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -3060,8 +3060,7 @@ int xhci_queue_intr_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
>  	 * to set the polling interval (once the API is added).
>  	 */
>  	if (xhci_interval != ep_interval) {
> -		if (printk_ratelimit())
> -			dev_dbg(&urb->dev->dev, "Driver uses different interval"
> +		dev_dbg_ratelimited(&urb->dev->dev, "Driver uses different interval"
>  					" (%d microframe%s) than xHCI "
>  					"(%d microframe%s)\n",
>  					ep_interval,
> @@ -3849,8 +3848,7 @@ int xhci_queue_isoc_tx_prepare(struct xhci_hcd *xhci, gfp_t mem_flags,
>  	 * to set the polling interval (once the API is added).
>  	 */
>  	if (xhci_interval != ep_interval) {
> -		if (printk_ratelimit())
> -			dev_dbg(&urb->dev->dev, "Driver uses different interval"
> +		dev_dbg_ratelimited(&urb->dev->dev, "Driver uses different interval"
>  					" (%d microframe%s) than xHCI "
>  					"(%d microframe%s)\n",
>  					ep_interval,
> -- 
> 1.8.1.2
