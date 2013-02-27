Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab3B0RVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:21:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36184 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760447Ab3B0RVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:21:04 -0500
Date: Wed, 27 Feb 2013 17:20:59 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Roger Quadros <rogerq@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [ 79/86] USB: ehci-omap: Dont free gpios that we didnt request
Message-ID: <20130227172059.GA5066@hercules>
References: <20130226235912.881663118@linuxfoundation.org>
 <20130226235921.105248169@linuxfoundation.org>
 <512DBB46.1080609@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512DBB46.1080609@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Wed, Feb 27, 2013 at 09:52:38AM +0200, Roger Quadros wrote:
> Hi Greg,
> 
> On 02/27/2013 02:08 AM, Greg Kroah-Hartman wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Roger Quadros <rogerq@ti.com>
> > 
> > commit 428525f97153505e83983460a8d08a3210aa6b8a upstream.
> > 
> > This driver does not request any gpios so don't free them.
> > Fixes L3 bus error on multiple modprobe/rmmod of ehci_hcd
> > with ehci-omap in use.
> 
> Please drop this patch from 3.4-stable.
> 
> In 3.4, the driver requests the gpios in probe() so they must be freed
> in remove() and this patch should not be applied. Thanks.

I believe this is also true for the 3.5 kernels.  Can you confirm this?

Cheers,
--
Luis

> 
> cheers, -roger
> 
> > 
> > Without this patch, EHCI will break on repeated insmod/rmmod
> > of ehci_hcd for all OMAP2+ platforms that use EHCI and
> > set 'phy_reset = true' in usbhs_omap_board_data.
> > i.e.
> > 
> > board-3430sdp.c:	.phy_reset  = true,
> > board-3630sdp.c:	.phy_reset  = true,
> > board-am3517crane.c:	.phy_reset  = true,
> > board-am3517evm.c:	.phy_reset  = true,
> > board-cm-t3517.c:	.phy_reset  = true,
> > board-cm-t35.c:	.phy_reset  = true,
> > board-devkit8000.c:	.phy_reset  = true,
> > board-igep0020.c:	.phy_reset = true,
> > board-igep0020.c:	.phy_reset = true,
> > board-omap3beagle.c:	.phy_reset  = true,
> > board-omap3evm.c:	.phy_reset  = true,
> > board-omap3pandora.c:	.phy_reset  = true,
> > board-omap3stalker.c:	.phy_reset = true,
> > board-omap3touchbook.c:	.phy_reset  = true,
> > board-omap4panda.c:	.phy_reset  = false,
> > board-overo.c:	.phy_reset  = true,
> > board-zoom.c:	.phy_reset		= true,
> > 
> > Signed-off-by: Roger Quadros <rogerq@ti.com>
> > Reviewed-by: Felipe Balbi <balbi@ti.com>
> > Acked-by: Alan Stern <stern@rowland.harvard.edu>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > ---
> >  drivers/usb/host/ehci-omap.c |    8 --------
> >  1 file changed, 8 deletions(-)
> > 
> > --- a/drivers/usb/host/ehci-omap.c
> > +++ b/drivers/usb/host/ehci-omap.c
> > @@ -288,7 +288,6 @@ static int ehci_hcd_omap_remove(struct p
> >  {
> >  	struct device *dev				= &pdev->dev;
> >  	struct usb_hcd *hcd				= dev_get_drvdata(dev);
> > -	struct ehci_hcd_omap_platform_data *pdata	= dev->platform_data;
> >  
> >  	usb_remove_hcd(hcd);
> >  	disable_put_regulator(dev->platform_data);
> > @@ -297,13 +296,6 @@ static int ehci_hcd_omap_remove(struct p
> >  	pm_runtime_put_sync(dev);
> >  	pm_runtime_disable(dev);
> >  
> > -	if (pdata->phy_reset) {
> > -		if (gpio_is_valid(pdata->reset_gpio_port[0]))
> > -			gpio_free(pdata->reset_gpio_port[0]);
> > -
> > -		if (gpio_is_valid(pdata->reset_gpio_port[1]))
> > -			gpio_free(pdata->reset_gpio_port[1]);
> > -	}
> >  	return 0;
> >  }
> >  
> > 
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
