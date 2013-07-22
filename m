Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab3GVPEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 11:04:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930Ab3GVPEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:04:44 -0400
Date: Mon, 22 Jul 2013 08:04:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, kyungmin.park@samsung.com,
        balbi@ti.com, jg1.han@samsung.com, s.nawrocki@samsung.com,
        kgene.kim@samsung.com, grant.likely@linaro.org, tony@atomide.com,
        arnd@arndb.de, swarren@nvidia.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, akpm@linux-foundation.org,
        balajitk@ti.com, george.cherian@ti.com, nsekhar@ti.com
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
Message-ID: <20130722150458.GA18181@kroah.com>
References: <Pine.LNX.4.44L0.1307211453450.19133-100000@netrider.rowland.org>
 <51ECDE5E.3050104@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ECDE5E.3050104@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 12:55:18PM +0530, Kishon Vijay Abraham I wrote:
> > 	The issue (or one of the issues) in this discussion is that 
> > 	Greg does not like the idea of using names or IDs to associate
> > 	PHYs with controllers, because they are too prone to
> > 	duplications or other errors.  Pointers are more reliable.
> > 
> > 	But pointers to what?  Since the only data known to be 
> > 	available to both the PHY driver and controller driver is the
> > 	platform data, the obvious answer is a pointer to platform data
> > 	(either for the PHY or for the controller, or maybe both).
> 
> hmm.. it's not going to be simple though as the platform device for the PHY and
> controller can be created in entirely different places. e.g., in some cases the
> PHY device is a child of some mfd core device (the device will be created in
> drivers/mfd) and the controller driver (usually) is created in board file. I
> guess then we have to come up with something to share a pointer in two
> different files.

What's wrong with using the platform_data structure that is unique to
all boards (see include/platform_data/ for examples)?  Isn't that what
this structure is there for?

greg k-h
