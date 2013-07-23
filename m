Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab3GWHzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:55:19 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53783 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab3GWHzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:55:16 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        broonie@kernel.org
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, kyungmin.park@samsung.com,
        balbi@ti.com, jg1.han@samsung.com, s.nawrocki@samsung.com,
        kgene.kim@samsung.com, grant.likely@linaro.org, tony@atomide.com,
        arnd@arndb.de, swarren@nvidia.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, akpm@linux-foundation.org,
        balajitk@ti.com, george.cherian@ti.com, nsekhar@ti.com, olof@lixom.net,
        Stephen Warren <swarren@wwwdotorg.org>, b.zolnierkie@samsung.com,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
Date: Tue, 23 Jul 2013 09:55:08 +0200
Message-ID: <3419798.aorxYv8pdo@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1714400.neMPBWOlzi@flatron>
References: <Pine.LNX.4.44L0.1307221028440.1495-100000@iolanthe.rowland.org> <1714400.neMPBWOlzi@flatron>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Fixed address of devicetree mailing list and added more people on CC.]

For reference, full thread can be found under following link:
http://thread.gmane.org/gmane.linux.ports.arm.kernel/252813

Best regards,
Tomasz

On Tuesday 23 of July 2013 09:29:32 Tomasz Figa wrote:
> Hi Alan,
> 
> On Monday 22 of July 2013 10:44:39 Alan Stern wrote:
> > On Mon, 22 Jul 2013, Kishon Vijay Abraham I wrote:
> > > > 	The PHY and the controller it is attached to are both 
physical
> > > > 	devices.
> > > > 	
> > > > 	The connection between them is hardwired by the system
> > > > 	manufacturer and cannot be changed by software.
> > > > 	
> > > > 	PHYs are generally described by fixed system-specific 
board
> > > > 	files or by Device Tree information.  Are they ever 
discovered
> > > > 	dynamically?
> > > 
> > > No. They are created just like any other platform devices are
> > > created.
> > 
> > Okay.  Are PHYs _always_ platform devices?
> 
> They can be i2c, spi or any other device types as well.
> 
> > > > 	Is the same true for the controllers attached to the PHYs?
> > > > 	If not -- if both a PHY and a controller are discovered
> > > > 	dynamically -- how does the kernel know whether they are
> > > > 	connected to each other?
> > > 
> > > No differences here. Both PHY and controller will have dt
> > > information
> > > or hwmod data using which platform devices will be created.
> > > 
> > > > 	The kernel needs to know which controller is attached to 
which
> > > > 	PHY.  Currently this information is represented by name or 
ID
> > > > 	strings embedded in platform data.
> > > 
> > > right. It's embedded in the platform data of the controller.
> > 
> > It must also be embedded in the PHY's platform data somehow.
> > Otherwise, how would the kernel know which PHY to use?
> 
> By using a PHY lookup as Stephen and I suggested in our previous
> replies. Without any extra data in platform data. (I have even posted a
> code example.)
> 
> > > > 	The PHY's driver (the supplier) uses the platform data to
> > > > 	construct a platform_device structure that represents the 
PHY.
> > > 
> > > Currently the driver assigns static labels (corresponding to the
> > > label
> > > used in the platform data of the controller).
> > > 
> > > > 	Until this is done, the controller's driver (the client) 
cannot
> > > > 	use the PHY.
> > > 
> > > right.
> > > 
> > > > 	Since there is no parent-child relation between the PHY 
and the
> > > > 	controller, there is no guarantee that the PHY's driver 
will be
> > > > 	ready when the controller's driver wants to use it.  A 
deferred
> > > > 	probe may be needed.
> > > 
> > > right.
> > > 
> > > > 	The issue (or one of the issues) in this discussion is 
that
> > > > 	Greg does not like the idea of using names or IDs to 
associate
> > > > 	PHYs with controllers, because they are too prone to
> > > > 	duplications or other errors.  Pointers are more reliable.
> > > > 	
> > > > 	But pointers to what?  Since the only data known to be
> > > > 	available to both the PHY driver and controller driver is 
the
> > > > 	platform data, the obvious answer is a pointer to platform 
data
> > > > 	(either for the PHY or for the controller, or maybe both).
> > > 
> > > hmm.. it's not going to be simple though as the platform device for
> > > the PHY and controller can be created in entirely different places.
> > > e.g., in some cases the PHY device is a child of some mfd core
> > > device
> > > (the device will be created in drivers/mfd) and the controller
> > > driver
> > > (usually) is created in board file. I guess then we have to come up
> > > with something to share a pointer in two different files.
> > 
> > The ability for two different source files to share a pointer to a
> > data
> > item defined in a third source file has been around since long before
> > the C language was invented.  :-)
> > 
> > In this case, it doesn't matter where the platform_device structures
> > are created or where the driver source code is.  Let's take a simple
> > example.  Suppose the system design includes a PHY named "foo".  Then
> > the board file could contain:
> > 
> > struct phy_info { ... } phy_foo;
> > EXPORT_SYMBOL_GPL(phy_foo);
> > 
> > and a header file would contain:
> > 
> > extern struct phy_info phy_foo;
> > 
> > The PHY supplier could then call phy_create(&phy_foo), and the PHY
> > client could call phy_find(&phy_foo).  Or something like that; make up
> > your own structure tags and function names.
> > 
> > It's still possible to have conflicts, but now two PHYs with the same
> > name (or a misspelled name somewhere) will cause an error at link
> > time.
> 
> This is incorrect, sorry. First of all it's a layering violation - you
> export random driver-specific symbols from one driver to another. Then
> imagine 4 SoCs - A, B, C, D. There are two PHY types PHY1 and PHY2 and
> there are two types of consumer drivers (e.g. USB host controllers). Now
> consider following mapping:
> 
> SoC	PHY	consumer
> A	PHY1	HOST1
> B	PHY1	HOST2
> C	PHY2	HOST1
> D	PHY2	HOST2
> 
> So we have to be able to use any of the PHYs with any of the host
> drivers. This means you would have to export symbol with the same name
> from both PHY drivers, which obviously would not work in this case,
> because having both drivers enabled (in a multiplatform aware
> configuration) would lead to linking conflict.
> 
> Best regards,
> Tomasz
