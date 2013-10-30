Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab3J3Ofr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:35:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53749 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754473Ab3J3Ofq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:35:46 -0400
Date: Wed, 30 Oct 2013 10:35:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Cohen <david.a.cohen@linux.intel.com>
cc: balbi@ti.com, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH v2 1/3] usb: gadget: add quirks field to struct
 usb_gadget
In-Reply-To: <1383083578-16447-2-git-send-email-david.a.cohen@linux.intel.com>
Message-ID: <Pine.LNX.4.44L0.1310301033040.1312-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Oct 2013, David Cohen wrote:

> Due to USB controllers may have different restrictions, usb gadget layer
> needs to provide a generic way to inform gadget functions to complain
> with non-standard requirements.
> 
> This patch adds 'quirks' field to struct usb_gadget and the first quirk
> called USB_GADGET_QUIRK_EP_OUT_ALIGNED_SIZE necessary to inform when
> controller's epout requires buffer size to be aligned to MaxPacketSize.
> 
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>  include/linux/usb/gadget.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
> index 942ef5e..7014ad9 100644
> --- a/include/linux/usb/gadget.h
> +++ b/include/linux/usb/gadget.h
> @@ -540,6 +540,11 @@ struct usb_gadget {
>  	struct device			dev;
>  	unsigned			out_epnum;
>  	unsigned			in_epnum;
> +
> +	u32				quirks;
> +/* epout requires buffer size to be aligned to MaxPacketSize */
> +#define USB_GADGET_QUIRK_EP_OUT_ALIGNED_SIZE		(1 << 0)

If you decide to go through with this, it might be better to define a 
series of single-bit flags instead of a single "quirks" field.  For 
example:

	unsigned			quirk_ep_out_aligned_size:1;

Yes, other people (including me!) have done it your way in the past,
but now this seems to make more sense.

Alan Stern

