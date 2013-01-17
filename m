Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab3AQPPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 10:15:54 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:32840 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756777Ab3AQPPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 10:15:52 -0500
Date: Thu, 17 Jan 2013 10:15:51 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: balbi@ti.com, <sameo@linux.intel.com>, <tony@atomide.com>, <kishon@ti.com>,
        <sshtylyov@mvista.com>, <bjorn@mork.no>, <linux@arm.linux.org.uk>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 18/22] USB: ehci-omap: Don't free gpios that we didn't
 request
In-Reply-To: <1358422231-24736-19-git-send-email-rogerq@ti.com>
Message-ID: <Pine.LNX.4.44L0.1301171015340.1339-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2013, Roger Quadros wrote:

> This driver does not request any gpios so don't free them.
> Fixes L3 bus error on multiple modprobe/rmmod of ehci_hcd
> with ehci-omap in use.
> 
> CC: Alan Stern <stern@rowland.harvard.edu>
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

> ---
>  drivers/usb/host/ehci-omap.c |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
> index 134c789..b96a4bf 100644
> --- a/drivers/usb/host/ehci-omap.c
> +++ b/drivers/usb/host/ehci-omap.c
> @@ -288,7 +288,6 @@ static int ehci_hcd_omap_remove(struct platform_device *pdev)
>  {
>  	struct device *dev				= &pdev->dev;
>  	struct usb_hcd *hcd				= dev_get_drvdata(dev);
> -	struct usbhs_omap_platform_data *pdata		= dev->platform_data;
>  
>  	usb_remove_hcd(hcd);
>  	disable_put_regulator(dev->platform_data);
> @@ -298,13 +297,6 @@ static int ehci_hcd_omap_remove(struct platform_device *pdev)
>  	pm_runtime_put_sync(dev);
>  	pm_runtime_disable(dev);
>  
> -	if (pdata->phy_reset) {
> -		if (gpio_is_valid(pdata->reset_gpio_port[0]))
> -			gpio_free(pdata->reset_gpio_port[0]);
> -
> -		if (gpio_is_valid(pdata->reset_gpio_port[1]))
> -			gpio_free(pdata->reset_gpio_port[1]);
> -	}
>  	return 0;
>  }
>  
> 

