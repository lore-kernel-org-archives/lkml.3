Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730AbaGQOzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:55:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54773 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932865AbaGQOzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:55:33 -0400
Date: Thu, 17 Jul 2014 10:55:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Amit Virdi <amit.virdi@st.com>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rdunlap@infradead.org>,
        <ming.lei@canonical.com>, <hdegoede@redhat.com>,
        <hsi-ss-sw-devel@lists.codex.cro.st.com>
Subject: Re: [PATCH] usb: core: allow zero packet flag for interrupt urbs
In-Reply-To: <5255a576a562f60c185e89b5937357290242fe1e.1405586653.git.amit.virdi@st.com>
Message-ID: <Pine.LNX.4.44L0.1407171053330.1517-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014, Amit Virdi wrote:

> Section 4.4.7.2 of the USB3.0 spec says:
> 	A zero-length data payload is a valid transfer and may be useful for
> 	some implementations.
> 
> So, extend the logic of allowing URB_ZERO_PACKET to interrupt urbs too.
> Otherwise, the kernel throws error of BOGUS transfer flags.
> 
> Signed-off-by: Amit Virdi <amit.virdi@st.com>
> ---
>  drivers/usb/core/urb.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
> index 991386c..a136246 100644
> --- a/drivers/usb/core/urb.c
> +++ b/drivers/usb/core/urb.c
> @@ -460,6 +460,10 @@ int usb_submit_urb(struct urb *urb, gfp_t mem_flags)
>  	case USB_ENDPOINT_XFER_CONTROL:
>  		allowed |= URB_NO_FSBR;	/* only affects UHCI */
>  		/* FALLTHROUGH */
> +	case USB_ENDPOINT_XFER_INT:
> +		if (is_out)
> +			allowed |= URB_ZERO_PACKET;
> +		/* FALLTHROUGH */
>  	default:			/* all non-iso endpoints */
>  		if (!is_out)
>  			allowed |= URB_SHORT_NOT_OK;

I can't say this is actually wrong, but have you ever encountered a 
situation where this would be needed?  How often does anyone need to do 
a multi-packet transfer over an interrupt endpoint?

Alan Stern

