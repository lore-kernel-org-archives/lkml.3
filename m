Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbaESToz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:44:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42849 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751435AbaESToy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:44:54 -0400
Date: Mon, 19 May 2014 15:44:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
cc: balbi@ti.com, <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <joe@perches.com>,
        <auttamchandani@logicube.com>
Subject: Re: [PATCH 5/5] usb: gadget: net2280: Use pr_* function
In-Reply-To: <1400526693-29776-6-git-send-email-ricardo.ribalda@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1405191543070.1538-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014, Ricardo Ribalda Delgado wrote:

> Driver was using custom functions WARNING, ERROR, DEBUG, instead of
>  pr_err, pr_dgb...

What's wrong with that, and why bother to change it?

> diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
> index e67ae96..11800bb 100644
> --- a/drivers/usb/gadget/net2280.c
> +++ b/drivers/usb/gadget/net2280.c
> @@ -210,7 +210,7 @@ static int net2280_enable(struct usb_ep *_ep,
>  	 * use it instead of troublesome (non-bulk) multi-packet DMA.
>  	 */
>  	if (ep->dma && (max % 4) != 0 && use_dma_chaining) {
> -		DEBUG(ep->dev, "%s, no dma for maxpacket %d\n",
> +		dev_dbg(GETDEV(ep->dev), "%s, no dma for maxpacket %d\n",

Don't you think that the new code is harder to read than the original?  
Why go to a lot of trouble just to make things worse?

Alan Stern

