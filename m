Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbaETOVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:21:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42514 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753651AbaETOVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:21:35 -0400
Date: Tue, 20 May 2014 10:21:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
cc: balbi@ti.com, <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <joe@perches.com>,
        <auttamchandani@logicube.com>
Subject: Re: [PATCH 2/9] usb: gadget: net2280: Dont use magic numbers
In-Reply-To: <1400534436-10913-3-git-send-email-ricardo.ribalda@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1405201020060.1176-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014, Ricardo Ribalda Delgado wrote:

> Instead of using magic numbers use #defines
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/usb/gadget/net2280.c | 68 +++++++++++++++++++++++---------------------
>  drivers/usb/gadget/net2280.h |  1 +
>  2 files changed, 36 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
> index 8112d91..ba1fdd8 100644
> --- a/drivers/usb/gadget/net2280.c
> +++ b/drivers/usb/gadget/net2280.c
> @@ -152,7 +152,7 @@ static inline void enable_pciirqenb(struct net2280_ep *ep)
>  {
>  	u32 tmp = readl(&ep->dev->regs->pciirqenb0);
>  
> -	if (ep->dev->pdev->vendor == 0x17cc)
> +	if (ep->dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)

You ought to be able to make this considerably smaller by using a 
quirk flag in ep->dev.  The flag can indicate whether or not the 
controller uses the LEGACY interface.

Alan Stern

