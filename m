Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784AbaESTkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:40:01 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42832 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751502AbaESTj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:39:59 -0400
Date: Mon, 19 May 2014 15:39:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
cc: Felipe Balbi <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, <joe@perches.com>,
        <auttamchandani@logicube.com>
Subject: Re: [PATCH 3/5] usb: gadget: net2280: Pass checkpacth.pl test
In-Reply-To: <1400526693-29776-4-git-send-email-ricardo.ribalda@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1405191531010.1538-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014, Ricardo Ribalda Delgado wrote:

> Fix Code Style using checkpatch.pl criteria
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Not really necessary, although this doesn't hurt.

It's notable that scattered in amongst all the checkpatch-related
changes are a few things that actually alter the meaning of the code.  
Mixing things up like that isn't a good idea.

Also, there seem to be several questionable changes:

> @@ -236,7 +234,7 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
>  			return -ERANGE;
>  		}
>  	}
> -	ep->is_iso = (tmp == USB_ENDPOINT_XFER_ISOC) ? 1 : 0;
> +	ep->is_iso = !!(tmp == USB_ENDPOINT_XFER_ISOC);

Getting rid of the "? 1 : 0" part is fine, but why introduce the "!!"?  
Don't you realize that the equality test will always produce a 0 or 1 
result?

>  
>  /*-------------------------------------------------------------------------*/
>  
> -static struct usb_request *
> -net2280_alloc_request (struct usb_ep *_ep, gfp_t gfp_flags)
> +static struct usb_request *net2280_alloc_request(struct usb_ep *_ep,
> +							gfp_t gfp_flags)

What's with the extreme indentation on the continuation line?  The 
style used here is for continuation lines to be indented by two stops 
relative to the first line.

> @@ -613,20 +609,21 @@ write_fifo (struct net2280_ep *ep, struct usb_request *req)
>   * NOTE:  also used in cases where that erratum doesn't apply:
>   * where the host wrote "too much" data to us.
>   */
> -static void out_flush (struct net2280_ep *ep)
> +static void out_flush(struct net2280_ep *ep)
>  {
>  	u32	__iomem *statp;
>  	u32	tmp;
>  
> -	ASSERT_OUT_NAKING (ep);
> +	ASSERT_OUT_NAKING(ep);
>  
>  	statp = &ep->regs->ep_stat;
>  	writel(BIT(DATA_OUT_PING_TOKEN_INTERRUPT) |
>  		BIT(DATA_PACKET_RECEIVED_INTERRUPT)
>  		, statp);
>  	writel(BIT(FIFO_FLUSH), statp);
> -	mb ();
> -	tmp = readl (statp);
> +	/* Make sure stap is written before readded back */

If you're going to add a comment, add least use correct spelling and 
grammar.

Alan Stern

