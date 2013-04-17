Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966596Ab3DQOPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:15:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54432 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S966464Ab3DQOPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:15:07 -0400
Date: Wed, 17 Apr 2013 10:15:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: gregkh@linuxfoundation.org, <balbi@ti.com>, <holler@ahsoftware.de>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] USB: ehci-omap: Improve PHY error handling
In-Reply-To: <1366187065-10795-1-git-send-email-rogerq@ti.com>
Message-ID: <Pine.LNX.4.44L0.1304171014540.1623-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Apr 2013, Roger Quadros wrote:

> As the USB PHY layer never returns NULL we don't need
> to check for that condition.
> 
> CC: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/usb/host/ehci-omap.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
> index 5de3e43..3d1491b 100644
> --- a/drivers/usb/host/ehci-omap.c
> +++ b/drivers/usb/host/ehci-omap.c
> @@ -175,12 +175,12 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
>  			phy = devm_usb_get_phy_by_phandle(dev, "phys", i);
>  		else
>  			phy = devm_usb_get_phy_dev(dev, i);
> -		if (IS_ERR(phy) || !phy) {
> +		if (IS_ERR(phy)) {
>  			/* Don't bail out if PHY is not absolutely necessary */
>  			if (pdata->port_mode[i] != OMAP_EHCI_PORT_MODE_PHY)
>  				continue;
>  
> -			ret = IS_ERR(phy) ? PTR_ERR(phy) : -ENODEV;
> +			ret = PTR_ERR(phy);
>  			dev_err(dev, "Can't get PHY device for port %d: %d\n",
>  					i, ret);
>  			goto err_phy;

Acked-by: Alan Stern <stern@rowland.harvard.edu>

