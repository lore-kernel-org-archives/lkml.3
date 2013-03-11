Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab3CKPAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:00:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50201 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752646Ab3CKPAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:00:39 -0400
Date: Mon, 11 Mar 2013 11:00:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Paul Vlase <vlase.paul@gmail.com>
cc: gregkh@linuxfoundation.org, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: Use resource_size function
In-Reply-To: <1362923522-20842-1-git-send-email-vlase.paul@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1303111100270.2246-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Mar 2013, Paul Vlase wrote:

> Signed-off-by: Paul Vlase <vlase.paul@gmail.com>
> ---
>  drivers/usb/host/ehci-mv.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/host/ehci-mv.c b/drivers/usb/host/ehci-mv.c
> index 3065809..5cd9f96 100644
> --- a/drivers/usb/host/ehci-mv.c
> +++ b/drivers/usb/host/ehci-mv.c
> @@ -225,7 +225,7 @@ static int mv_ehci_probe(struct platform_device *pdev)
>  		(void __iomem *) ((unsigned long) ehci_mv->cap_regs + offset);
>  
>  	hcd->rsrc_start = r->start;
> -	hcd->rsrc_len = r->end - r->start + 1;
> +	hcd->rsrc_len = resource_size(r);
>  	hcd->regs = ehci_mv->op_regs;
>  
>  	hcd->irq = platform_get_irq(pdev, 0);

Acked-by: Alan Stern <stern@rowland.harvard.edu>

