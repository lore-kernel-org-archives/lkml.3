Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab3GWOvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 10:51:03 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52083 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255Ab3GWOu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 10:50:59 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-72-51ee98503551
From: Tomasz Figa <t.figa@samsung.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        broonie@kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
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
Date: Tue, 23 Jul 2013 16:50:52 +0200
Message-id: <2147402.ggVzZLIPLp@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-reply-to: <Pine.LNX.4.44L0.1307231017290.1304-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1307231017290.1304-100000@iolanthe.rowland.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA02SW0iTYRjHeb/TPq3l5zq9SQcYLVNKDbx4kJDqQt5OkAQV3dTUZeI8tGVk
	VjPXOgyPq5HpOpizYFTLac5FqFNzQ/FALTPKIk0yD+tgB0utnHbh3e/58/s/z83D0xItG8Qn
	pR5VqFLlSinnz7T9cXWv31XsjY3oHV4HJutdDqYMLSKoLLayYLxk58D5VgPGd+85uD62Am40
	d7DQ6rzDQsNkLQJtuZWDZ2VPWci7+ZyDroFcDtpzRkRwscgsAlt/Nwtl58wMuPM/s/DskYmD
	3AcPWSg1FzBQ3FlHwa3bOhrq8x5Q0PpibPq03cZA08h5FgonujjouXKWhSHnOWb6toMCy6NJ
	BPWebZukZOK3AZEf3w0McZT0ikjphasssVkucuR192OOuIsnGFJ/7a6IVJk1xOPOYUme1suR
	gqkIUto7jkh+tQURV4+dImO2lbsC9/tvTFAok44pVOHRB/0PT93zcOlvZce//uijs9Gr5Xrk
	x2MhEtf0aulZXoK73lg5PfLnJUIFwoXNnv+DnsKfXCbWZ3HCGjyW3cf5eJEQiqtyPtI+iRae
	irDJWzezaqGwBY/qRmaYEWTY9qKd8rFYCMH6M0OMjwOEYOytGZjOeX6xEIMLv6T5Yj9hJ3Zf
	dSIfS4QdWFdn+l8NxOOX3sxUaWEVrqs3srMciq0OF1WIAkvmaCVztJI52k1EW9BiRUZ8ujou
	MWVDmFqeos5ITQyLT0uxodnH+VaLyluiGpHAI+l88dbto7ESVn5MnZnSiDBPSxeJK4K8sRJx
	gjzzhEKVdkCVoVSoGxHF+wVlo9z0D2VNJ/eFX9FGthXErdHt7C8IqByVbx7eLZ6nHKeyyvvc
	azsVyUvQ5Ya4GONSQ/CT1kZdrOwIkawuEvbwnZkafchU1TXnZK7Sb1ly/Cr7aVlWRcjL6kOJ
	P4vWB9zf83ew4ZQr5mt+SHrUCgjr6N+7wLFyvj0ZNLX2wWBx9C8poz4s3xBKq9Tyf7AkTB8W	AwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 of July 2013 10:37:05 Alan Stern wrote:
> On Tue, 23 Jul 2013, Tomasz Figa wrote:
> > On Tuesday 23 of July 2013 09:29:32 Tomasz Figa wrote:
> > > Hi Alan,
> 
> Thanks for helping to clarify the issues here.
> 
> > > > Okay.  Are PHYs _always_ platform devices?
> > > 
> > > They can be i2c, spi or any other device types as well.
> 
> In those other cases, presumably there is no platform data associated
> with the PHY since it isn't a platform device.  Then how does the
> kernel know which controller is attached to the PHY?  Is this spelled
> out in platform data associated with the PHY's i2c/spi/whatever parent?
> 
> > > > > > 	PHY.  Currently this information is represented by name or
> > 
> > ID
> > 
> > > > > > 	strings embedded in platform data.
> > > > > 
> > > > > right. It's embedded in the platform data of the controller.
> > > > 
> > > > It must also be embedded in the PHY's platform data somehow.
> > > > Otherwise, how would the kernel know which PHY to use?
> > > 
> > > By using a PHY lookup as Stephen and I suggested in our previous
> > > replies. Without any extra data in platform data. (I have even posted
> > > a
> > > code example.)
> 
> I don't understand, because I don't know what "a PHY lookup" does.

I have provided a code example in [1]. Feel free to ask questions about 
those code snippets.

[1] http://thread.gmane.org/gmane.linux.ports.arm.kernel/252813/focus=20889

> > > > In this case, it doesn't matter where the platform_device
> > > > structures
> > > > are created or where the driver source code is.  Let's take a
> > > > simple
> > > > example.  Suppose the system design includes a PHY named "foo". 
> > > > Then
> > > > the board file could contain:
> > > > 
> > > > struct phy_info { ... } phy_foo;
> > > > EXPORT_SYMBOL_GPL(phy_foo);
> > > > 
> > > > and a header file would contain:
> > > > 
> > > > extern struct phy_info phy_foo;
> > > > 
> > > > The PHY supplier could then call phy_create(&phy_foo), and the PHY
> > > > client could call phy_find(&phy_foo).  Or something like that; make
> > > > up
> > > > your own structure tags and function names.
> > > > 
> > > > It's still possible to have conflicts, but now two PHYs with the
> > > > same
> > > > name (or a misspelled name somewhere) will cause an error at link
> > > > time.
> > > 
> > > This is incorrect, sorry. First of all it's a layering violation -
> > > you
> > > export random driver-specific symbols from one driver to another.
> > > Then
> 
> No, that's not what I said.  Neither the PHY driver nor the controller
> driver exports anything to the other.  Instead, both drivers use data
> exported by the board file.

It's still a random, driver-specific global symbol exported from board file 
to drivers.

> > > imagine 4 SoCs - A, B, C, D. There are two PHY types PHY1 and PHY2
> > > and
> > > there are two types of consumer drivers (e.g. USB host controllers).
> > > Now
> > > consider following mapping:
> > > 
> > > SoC	PHY	consumer
> > > A	PHY1	HOST1
> > > B	PHY1	HOST2
> > > C	PHY2	HOST1
> > > D	PHY2	HOST2
> > > 
> > > So we have to be able to use any of the PHYs with any of the host
> > > drivers. This means you would have to export symbol with the same
> > > name
> > > from both PHY drivers, which obviously would not work in this case,
> > > because having both drivers enabled (in a multiplatform aware
> > > configuration) would lead to linking conflict.
> 
> You're right; the scheme was too simple.  Instead, the board file must
> export two types of data structures, one for PHYs and one for
> controllers.  Like this:
> 
> struct phy_info {
> 	/* Info for the controller attached to this PHY */
> 	struct controller_info	*hinfo;
> };
> 
> struct controller_info {
> 	/* Info for the PHY which this controller is attached to */
> 	struct phy_info		*pinfo;
> };
> 
> The board file for SoC A would contain:
> 
> struct phy_info phy1 = {&host1);
> EXPORT_SYMBOL(phy1);
> struct controller_info host1 = {&phy1};
> EXPORT_SYMBOL(host1);
> 
> The board file for SoC B would contain:
> 
> struct phy_info phy1 = {&host2);
> EXPORT_SYMBOL(phy1);
> struct controller_info host2 = {&phy1};
> EXPORT_SYMBOL(host2);
> 
> And so on.  This explicitly gives the connection between PHYs and
> controllers.  The PHY providers would use &phy1 or &phy2, and the PHY
> consumers would use &host1 or &host2.

This could work assuming that only one SoC and one board is supported in 
single kernel image. However it's not the case.

We've used to support multiple boards since a long time already and now for 
selected platforms we even support multiplatform, i.e. multiple SoCs in 
single zImage. Such solution will not work.

Best regards,
Tomasz

