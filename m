Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620AbaCTRyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:54:39 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:35617 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759267AbaCTRyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:54:37 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core to drivers/of
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
In-Reply-To: <20140312102556.GC21483@n2100.arm.linux.org.uk>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> < 20140226110114.CF2C7C40A89@trevor.secretlab.ca> <531D916C.2010903@ti.com> < 5427810.BUKJ3iUXnO@avalon> <20140312102556.GC21483@n2100.arm.linux.org.uk>
Date: Thu, 20 Mar 2014 17:54:31 +0000
Message-Id: <20140320175432.0559CC4067A@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014 10:25:56 +0000, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> On Mon, Mar 10, 2014 at 02:52:53PM +0100, Laurent Pinchart wrote:
> > In theory unidirectional links in DT are indeed enough. However, let's not 
> > forget the following.
> > 
> > - There's no such thing as single start points for graphs. Sure, in some 
> > simple cases the graph will have a single start point, but that's not a 
> > generic rule. For instance the camera graphs 
> > http://ideasonboard.org/media/omap3isp.ps and 
> > http://ideasonboard.org/media/eyecam.ps have two camera sensors, and thus two 
> > starting points from a data flow point of view.
> 
> I think we need to stop thinking of a graph linked in terms of data
> flow - that's really not useful.
> 
> Consider a display subsystem.  The CRTC is the primary interface for
> the CPU - this is the "most interesting" interface, it's the interface
> which provides access to the picture to be displayed for the CPU.  Other
> interfaces are secondary to that purpose - reading the I2C DDC bus for
> the display information is all secondary to the primary purpose of
> displaying a picture.
> 
> For a capture subsystem, the primary interface for the CPU is the frame
> grabber (whether it be an already encoded frame or not.)  The sensor
> devices are all secondary to that.
> 
> So, the primary software interface in each case is where the data for
> the primary purpose is transferred.  This is the point at which these
> graphs should commence since this is where we would normally start
> enumeration of the secondary interfaces.
> 
> V4L2 even provides interfaces for this: you open the capture device,
> which then allows you to enumerate the capture device's inputs, and
> this in turn allows you to enumerate their properties.  You don't open
> a particular sensor and work back up the tree.
> 
> I believe trying to do this according to the flow of data is just wrong.
> You should always describe things from the primary device for the CPU
> towards the peripheral devices and never the opposite direction.

Agreed.

g.
