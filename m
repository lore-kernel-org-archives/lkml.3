Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab3CLP56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:57:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37807 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932101Ab3CLP55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:57:57 -0400
Date: Tue, 12 Mar 2013 11:57:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>, Felipe Balbi <balbi@ti.com>
cc: gregkh@linuxfoundation.org, <b-cousson@ti.com>, <mark.rutland@arm.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 11/12] USB: ehci-omap: Try to get PHY even if not in PHY
 mode
In-Reply-To: <1363085090-24676-12-git-send-email-rogerq@ti.com>
Message-ID: <Pine.LNX.4.44L0.1303121155540.2153-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Mar 2013, Roger Quadros wrote:

> Even when not in PHY mode, the USB device on the port (e.g. HUB)
> might need resources like RESET which can be modelled as a PHY
> device. So try to get the PHY device in any case.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> CC: Alan Stern <stern@rowland.harvard.edu>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

>  		/* get the PHY device */
>  		if (dev->of_node)
>  			phy = devm_usb_get_phy_by_phandle(dev, "phys", i);
>  		else
>  			phy = devm_usb_get_phy_dev(dev, i);
>  		if (IS_ERR(phy) || !phy) {
> +			/* Don't bail out if PHY is not absolutely necessary */
> +			if (pdata->port_mode[i] != OMAP_EHCI_PORT_MODE_PHY)
> +				continue;
> +
>  			ret = IS_ERR(phy) ? PTR_ERR(phy) : -ENODEV;
>  			dev_err(dev, "Can't get PHY device for port %d: %d\n",
>  					i, ret);

Felipe, this is a strange interface.  Why do we sometimes get an 
error-pointer and sometimes get just NULL?  Why not always an 
error-pointer?

Alan Stern

