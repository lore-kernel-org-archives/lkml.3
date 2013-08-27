Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab3H0Owg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 10:52:36 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:62890 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab3H0Owf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 10:52:35 -0400
MIME-Version: 1.0
In-Reply-To: <7a445b01abe657f0771a9c488e9afcf71d0a5d55.1377614854.git.d.kasatkin@samsung.com>
References: <7f53397d0aa93e644124037d44188da5067336fc.1377614854.git.d.kasatkin@samsung.com>
	<7a445b01abe657f0771a9c488e9afcf71d0a5d55.1377614854.git.d.kasatkin@samsung.com>
Date: Tue, 27 Aug 2013 17:52:33 +0300
Message-ID: <CACE9dm-kwwaafpR+fL5wDpHp6cGNR9-u-TTBv9ZhsQaB5L9EwQ@mail.gmail.com>
Subject: Re: [PATCHv2 2/2] xhci:prevent "callbacks suppressed" when debug is
 not enabled
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used vim "=" as Sarah suggested.

- Dmitry

On Tue, Aug 27, 2013 at 5:47 PM, Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:
> When debug is not enabled and dev_dbg() will expand to nothing,
> log might be flooded with "callbacks suppressed". If it was not
> done on purpose, better to use dev_dbg_ratelimited() instead.
>
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> ---
>  drivers/usb/host/xhci-ring.c | 24 ++++++++----------------
>  1 file changed, 8 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index 5b08cd8..3cbf1c0 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -3060,14 +3060,10 @@ int xhci_queue_intr_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
>          * to set the polling interval (once the API is added).
>          */
>         if (xhci_interval != ep_interval) {
> -               if (printk_ratelimit())
> -                       dev_dbg(&urb->dev->dev, "Driver uses different interval"
> -                                       " (%d microframe%s) than xHCI "
> -                                       "(%d microframe%s)\n",
> -                                       ep_interval,
> -                                       ep_interval == 1 ? "" : "s",
> -                                       xhci_interval,
> -                                       xhci_interval == 1 ? "" : "s");
> +               dev_dbg_ratelimited(&urb->dev->dev,
> +                               "Driver uses different interval (%d microframe%s) than xHCI (%d microframe%s)\n",
> +                               ep_interval, ep_interval == 1 ? "" : "s",
> +                               xhci_interval, xhci_interval == 1 ? "" : "s");
>                 urb->interval = xhci_interval;
>                 /* Convert back to frames for LS/FS devices */
>                 if (urb->dev->speed == USB_SPEED_LOW ||
> @@ -3849,14 +3845,10 @@ int xhci_queue_isoc_tx_prepare(struct xhci_hcd *xhci, gfp_t mem_flags,
>          * to set the polling interval (once the API is added).
>          */
>         if (xhci_interval != ep_interval) {
> -               if (printk_ratelimit())
> -                       dev_dbg(&urb->dev->dev, "Driver uses different interval"
> -                                       " (%d microframe%s) than xHCI "
> -                                       "(%d microframe%s)\n",
> -                                       ep_interval,
> -                                       ep_interval == 1 ? "" : "s",
> -                                       xhci_interval,
> -                                       xhci_interval == 1 ? "" : "s");
> +               dev_dbg_ratelimited(&urb->dev->dev,
> +                               "Driver uses different interval (%d microframe%s) than xHCI (%d microframe%s)\n",
> +                               ep_interval, ep_interval == 1 ? "" : "s",
> +                               xhci_interval, xhci_interval == 1 ? "" : "s");
>                 urb->interval = xhci_interval;
>                 /* Convert back to frames for LS/FS devices */
>                 if (urb->dev->speed == USB_SPEED_LOW ||
> --
> 1.8.1.2
>



-- 
Thanks,
Dmitry
