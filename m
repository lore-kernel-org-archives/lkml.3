Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab3AXVxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:53:37 -0500
Received: from fold.natur.cuni.cz ([195.113.57.32]:57969 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755688Ab3AXVx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:53:28 -0500
Message-ID: <5101AD55.2000008@fold.natur.cuni.cz>
Date: Thu, 24 Jan 2013 22:53:25 +0100
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20100101 Firefox/17.0 SeaMonkey/2.14.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] USB: XHCI: fix memory leak of URB-private data
References: <Pine.LNX.4.44L0.1301171031260.1339-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1301171031260.1339-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sarah and Alan,
  I just saw 3.7.5 patches announced by Greg but I don't see this path in there.
And, don't know but maybe this applies to older stable kernels as well?
Where will this patch posted originally to linux-usb land?

Ah, is that because the email was actually NOT sent to "stable@"? ;-)

Date:	Thu, 17 Jan 2013 10:32:16 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
  USB list <linux-usb@vger.kernel.org>
Subject: [PATCH] USB: XHCI: fix memory leak of URB-private data
Message-ID: <Pine.LNX.4.44L0.1301171031260.1339-100000@iolanthe.rowland.org>

Thank you,
Martin

Alan Stern wrote:
> This patch (as1640) fixes a memory leak in xhci-hcd.  The urb_priv
> data structure isn't always deallocated in the handle_tx_event()
> routine for non-control transfers.  The patch adds a kfree() call so
> that all paths end up freeing the memory properly.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Reported-and-tested-by: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
> CC: <stable@vger.kernel.org>
> 
> ---
> 
>  drivers/usb/host/xhci-ring.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: usb-3.7/drivers/usb/host/xhci-ring.c
> ===================================================================
> --- usb-3.7.orig/drivers/usb/host/xhci-ring.c
> +++ usb-3.7/drivers/usb/host/xhci-ring.c
> @@ -2580,6 +2580,8 @@ cleanup:
>  				(trb_comp_code != COMP_STALL &&
>  					trb_comp_code != COMP_BABBLE))
>  				xhci_urb_free_priv(xhci, urb_priv);
> +			else
> +				kfree(urb_priv);
>  
>  			usb_hcd_unlink_urb_from_ep(bus_to_hcd(urb->dev->bus), urb);
>  			if ((urb->actual_length != urb->transfer_buffer_length &&
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
