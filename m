Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab3EPO1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 10:27:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40614 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751770Ab3EPO1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 10:27:50 -0400
Date: Thu, 16 May 2013 10:27:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Wolfram Sang <wsa@the-dreams.de>
cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 23/33] drivers/usb/host: don't check resource with
 devm_ioremap_resource
In-Reply-To: <1368702961-4325-24-git-send-email-wsa@the-dreams.de>
Message-ID: <Pine.LNX.4.44L0.1305161027140.1096-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 May 2013, Wolfram Sang wrote:

> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>  drivers/usb/host/ohci-nxp.c |    6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/usb/host/ohci-nxp.c b/drivers/usb/host/ohci-nxp.c
> index f4988fb..f303cb0 100644
> --- a/drivers/usb/host/ohci-nxp.c
> +++ b/drivers/usb/host/ohci-nxp.c
> @@ -300,12 +300,6 @@ static int usb_hcd_nxp_probe(struct platform_device *pdev)
>  	}
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(&pdev->dev, "Failed to get MEM resource\n");
> -		ret =  -ENOMEM;
> -		goto out8;
> -	}
> -
>  	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(hcd->regs)) {
>  		ret = PTR_ERR(hcd->regs);
> 

Acked-by: Alan Stern <stern@rowland.harvard.edu>

