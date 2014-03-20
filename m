Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759692AbaCTSvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 14:51:09 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:35476 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757901AbaCTSvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 14:51:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core to drivers/of
Date: Thu, 20 Mar 2014 19:52:53 +0100
Message-ID: <12151803.GHyzFUphWh@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140320184816.7AB02C4067A@trevor.secretlab.ca>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> <20140320153804.35d5b835@samsung.com> <20140320184816.7AB02C4067A@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 March 2014 18:48:16 Grant Likely wrote:
> On Thu, 20 Mar 2014 15:38:04 -0300, Mauro Carvalho Chehab wrote:
> > Em Thu, 20 Mar 2014 17:54:31 +0000 Grant Likely escreveu:
> > > On Wed, 12 Mar 2014 10:25:56 +0000, Russell King - ARM Linux wrote:
> > > > On Mon, Mar 10, 2014 at 02:52:53PM +0100, Laurent Pinchart wrote:
> > > > > In theory unidirectional links in DT are indeed enough. However,
> > > > > let's not forget the following.
> > > > > 
> > > > > - There's no such thing as single start points for graphs. Sure, in
> > > > > some simple cases the graph will have a single start point, but
> > > > > that's not a generic rule. For instance the camera graphs
> > > > > http://ideasonboard.org/media/omap3isp.ps and
> > > > > http://ideasonboard.org/media/eyecam.ps have two camera sensors, and
> > > > > thus two starting points from a data flow point of view.
> > > > 
> > > > I think we need to stop thinking of a graph linked in terms of data
> > > > flow - that's really not useful.
> > > > 
> > > > Consider a display subsystem.  The CRTC is the primary interface for
> > > > the CPU - this is the "most interesting" interface, it's the interface
> > > > which provides access to the picture to be displayed for the CPU. 
> > > > Other interfaces are secondary to that purpose - reading the I2C DDC
> > > > bus for the display information is all secondary to the primary
> > > > purpose of displaying a picture.
> > > > 
> > > > For a capture subsystem, the primary interface for the CPU is the
> > > > frame grabber (whether it be an already encoded frame or not.)  The
> > > > sensor devices are all secondary to that.
> > > > 
> > > > So, the primary software interface in each case is where the data for
> > > > the primary purpose is transferred.  This is the point at which these
> > > > graphs should commence since this is where we would normally start
> > > > enumeration of the secondary interfaces.
> > > > 
> > > > V4L2 even provides interfaces for this: you open the capture device,
> > > > which then allows you to enumerate the capture device's inputs, and
> > > > this in turn allows you to enumerate their properties.  You don't open
> > > > a particular sensor and work back up the tree.
> > > > 
> > > > I believe trying to do this according to the flow of data is just
> > > > wrong. You should always describe things from the primary device for
> > > > the CPU towards the peripheral devices and never the opposite
> > > > direction.
> > > 
> > > Agreed.
> > 
> > I don't agree, as what's the primary device is relative.
> > 
> > Actually, in the case of a media data flow, the CPU is generally not
> > the primary device.
> > 
> > Even on general purpose computers, if the full data flow is taken into
> > the account, the CPU is a mere device that will just be used to copy
> > data either to GPU and speakers or to disk, eventually doing format
> > conversions, when the hardware is cheap and don't provide format
> > converters.
> > 
> > On more complex devices, like the ones we want to solve with the
> > media controller, like an embedded hardware like a TV or a STB, the CPU
> > is just an ancillary component that could even hang without stopping
> > TV reception, as the data flow can be fully done inside the chipset.
> 
> We're talking about wiring up device drivers here, not data flow. Yes, I
> completely understand that data flow is often not even remotely
> cpu-centric. However, device drivers are, and the kernel needs to know
> the dependency graph for choosing what devices depend on other devices.

Then we might not be talking about the same thing. I'm talking about DT 
bindings to represent the topology of the device, not how drivers are wired 
together. The latter isn't a property of the hardware.

-- 
Regards,

Laurent Pinchart

