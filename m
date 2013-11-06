Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab3KFQGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 11:06:09 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:44891 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754227Ab3KFQGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 11:06:08 -0500
Date: Wed, 6 Nov 2013 11:06:07 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Cohen <david.a.cohen@linux.intel.com>
cc: balbi@ti.com, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4.1 2/4] usb: gadget: add quirk_ep_out_aligned_size
 field to struct usb_gadget
In-Reply-To: <1383695147-18389-1-git-send-email-david.a.cohen@linux.intel.com>
Message-ID: <Pine.LNX.4.44L0.1311061105290.1220-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Nov 2013, David Cohen wrote:

> Due to USB controllers may have different restrictions, usb gadget layer
> needs to provide a generic way to inform gadget functions to complain
> with non-standard requirements.
> 
> This patch adds 'quirk_ep_out_aligned_size' field to struct usb_gadget
> to inform when controller's epout requires buffer size to be aligned to
> MaxPacketSize. A helper is also provided to align buffer size when
> necessary.
> 
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
> 
> Changes from v4 to v4.1:
>  - Simplified usb_ep_align_maxpacketsize() macro as per Alen Stern's request
> 
>  include/linux/usb/gadget.h | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
> index 23b3bfd0a842..41e8834af57d 100644
> --- a/include/linux/usb/gadget.h
> +++ b/include/linux/usb/gadget.h
> @@ -441,6 +441,19 @@ static inline void usb_ep_fifo_flush(struct usb_ep *ep)
>  		ep->ops->fifo_flush(ep);
>  }
>  
> +/**
> + * usb_ep_align_maxpacketsize - returns @len aligned to ep's maxpacketsize
> + * @ep: the endpoint whose maxpacketsize is used to align @len
> + * @len: buffer size's length to align to @ep's maxpacketsize
> + *
> + * This helper is used in case it's required for any reason to align buffer's
> + * size to an ep's maxpacketsize.
> + */
> +static inline size_t usb_ep_align_maxpacketsize(struct usb_ep *ep, size_t len)
> +{
> +	return round_up(len, (size_t)ep->desc->wMaxPacketSize);
> +}
> +
>  
>  /*-------------------------------------------------------------------------*/
>  
> @@ -502,6 +515,8 @@ struct usb_gadget_ops {
>   *	only supports HNP on a different root port.
>   * @b_hnp_enable: OTG device feature flag, indicating that the A-Host
>   *	enabled HNP support.
> + * @quirk_ep_out_aligned_size: epout requires buffer size to be aligned to
> + *	MaxPacketSize.
>   *
>   * Gadgets have a mostly-portable "gadget driver" implementing device
>   * functions, handling all usb configurations and interfaces.  Gadget
> @@ -541,6 +556,7 @@ struct usb_gadget {
>  	unsigned			b_hnp_enable:1;
>  	unsigned			a_hnp_support:1;
>  	unsigned			a_alt_hnp_support:1;
> +	unsigned			quirk_ep_out_aligned_size:1;
>  };
>  #define work_to_gadget(w)	(container_of((w), struct usb_gadget, work))

This looks good now.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

