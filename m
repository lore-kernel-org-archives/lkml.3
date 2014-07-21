Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795AbaGUOGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:06:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40645 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932526AbaGUOGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:06:38 -0400
Date: Mon, 21 Jul 2014 10:06:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Amit Virdi <amit.virdi@st.com>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rdunlap@infradead.org>,
        <ming.lei@canonical.com>, <hdegoede@redhat.com>,
        <spear-devel@list.st.com>
Subject: Re: [PATCH V2] usb: core: allow zero packet flag for interrupt urbs
In-Reply-To: <c6287280f42a976eed5c3fe46901f40e3f5db816.1405919768.git.amit.virdi@st.com>
Message-ID: <Pine.LNX.4.44L0.1407211006190.875-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2014, Amit Virdi wrote:

> Section 4.4.7.2 "Interrupt Transfer Bandwidth Requirements" of the USB3.0 spec
> says:
> 	A zero-length data payload is a valid transfer and may be useful for
> 	some implementations.
> 
> So, extend the logic of allowing URB_ZERO_PACKET to interrupt urbs too.
> Otherwise, the kernel throws warning of BOGUS transfer flags.
> 
> Signed-off-by: Amit Virdi <amit.virdi@st.com>
> Acked-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/usb/core/urb.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
> index 991386ceb4ec..c9e8ee81b6b7 100644
> --- a/drivers/usb/core/urb.c
> +++ b/drivers/usb/core/urb.c
> @@ -454,6 +454,7 @@ int usb_submit_urb(struct urb *urb, gfp_t mem_flags)
>  			URB_FREE_BUFFER);
>  	switch (xfertype) {
>  	case USB_ENDPOINT_XFER_BULK:
> +	case USB_ENDPOINT_XFER_INT:
>  		if (is_out)
>  			allowed |= URB_ZERO_PACKET;
>  		/* FALLTHROUGH */

Acked-by: Alan Stern <stern@rowland.harvard.edu>

