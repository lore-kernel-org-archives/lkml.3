Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaAYPhk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 10:37:40 -0500
Received: from netrider.rowland.org ([192.131.102.5]:44995 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752010AbaAYPhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 10:37:38 -0500
Date: Sat, 25 Jan 2014 10:37:37 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Josh Boyer <jwboyer@fedoraproject.org>
cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <valentine.barshak@cogentembedded.com>
Subject: Re: [PATCH] usb: phy: Quiet unable to find transceiver message
In-Reply-To: <20140125150559.GN16455@hansolo.jdub.homelinux.org>
Message-ID: <Pine.LNX.4.44L0.1401251035570.7061-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Jan 2014, Josh Boyer wrote:

> commit 1ae5799ef6317 ("usb: hcd: Initialize USB phy if needed") allows
> the USB layer to initialize external PHYs if needed.  However, a PHY is
> not needed in all cases.  The usb_get_phy_device function will print
> an error message, "unable to find transceiver" but everything still
> functions normally.
> 
> Drop the severity of this message to pr_debug.
> 
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> ---
>  drivers/usb/phy/phy.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
> index e6f61e4..c7fe880 100644
> --- a/drivers/usb/phy/phy.c
> +++ b/drivers/usb/phy/phy.c
> @@ -228,7 +228,7 @@ struct usb_phy *usb_get_phy_dev(struct device *dev, u8 index)
>  
>  	phy = __usb_find_phy_dev(dev, &phy_bind_list, index);
>  	if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
> -		pr_err("unable to find transceiver\n");
> +		pr_debug("unable to find transceiver\n");
>  		goto err0;
>  	}

Wouldn't it make more sense to change this to dev_debug?  As it stands, 
the user has no idea which device is lacking a transceiver.

(The same is probably true for other log messages in this source file.)

Alan Stern

