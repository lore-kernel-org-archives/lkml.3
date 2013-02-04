Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab3BDVLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 16:11:31 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:33096 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755076Ab3BDVLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 16:11:30 -0500
Date: Mon, 4 Feb 2013 16:11:29 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: tony@atomide.com, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 09/31] USB: ehci-omap: Use devm_ioremap_resource()
In-Reply-To: <1359988520-11996-1-git-send-email-rogerq@ti.com>
Message-ID: <Pine.LNX.4.44L0.1302041609290.1756-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2013, Roger Quadros wrote:

> Make use of devm_ioremap_resource() and correct comment.
> 
> CC: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/usb/host/ehci-omap.c |   21 ++++++---------------
>  1 files changed, 6 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
> index 30fc482..6b088a4 100644
> --- a/drivers/usb/host/ehci-omap.c
> +++ b/drivers/usb/host/ehci-omap.c
> @@ -216,23 +216,17 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
>  
>  	res =  platform_get_resource_byname(pdev,
>  				IORESOURCE_MEM, "ehci");
> -	if (!res) {
> -		dev_err(dev, "UHH EHCI get resource failed\n");
> -		return -ENODEV;
> -	}
> -
> -	regs = ioremap(res->start, resource_size(res));
> -	if (!regs) {
> -		dev_err(dev, "UHH EHCI ioremap failed\n");
> -		return -ENOMEM;
> +	regs = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(regs)) {
> +		dev_err(dev, "Resource request/ioremap failed\n");

According to Thierry Reding, devm_ioremap_resource() provides its own 
error messages.  Hence this one isn't needed.

Apart from this one issue,

Acked-by: Alan Stern <stern@rowland.harvard.edu>

