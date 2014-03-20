Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408AbaCTSiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 14:38:17 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:58519 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaCTSiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 14:38:15 -0400
X-AuditID: cbfec373-b7f4a6d000005e0a-90-532b35958b65
Date: Thu, 20 Mar 2014 15:38:04 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
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
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from
 drivers/media/v4l2-core to drivers/of
Message-id: <20140320153804.35d5b835@samsung.com>
In-reply-to: <20140320175432.0559CC4067A@trevor.secretlab.ca>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de>
 <20140226110114.CF2C7C40A89@trevor.secretlab.ca> <531D916C.2010903@ti.com>
 <5427810.BUKJ3iUXnO@avalon> <20140312102556.GC21483@n2100.arm.linux.org.uk>
 <20140320175432.0559CC4067A@trevor.secretlab.ca>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t/hEN2pptrBBhc3G1jMP3KO1eLAnx2M
	Fmeb3rBbdE5cwm5xedccNoueDVtZLW5f5rW4e+8Ei8XWeecYLVr3HmG3+P7tG5vF3+2bWCwO
	v2lntVg//xabA59HS3MPm8fOWXfZPWZ3zGT12LSqk83jzrU9bB79fw08+rasYvQ4fmM7k8fn
	TXIBnFFcNimpOZllqUX6dglcGdPPd7AXvBWv2H5Lr4HxsVAXIyeHhICJxOep/1ghbDGJC/fW
	s4HYQgJLGCUWHgWKcwHZPUwSF7rfsIAkWARUJd7MmA9WxCZgJPGqsQWsWURAS+LJnM9sIA3M
	Al9ZJLqu/wBrEBZIlVh7+DZYEa+AocSqqRvBbE4BW4kXz7oYITZMYZL4Pf8XG8QZThKvXk9m
	gmgQlPgx+R7YIGagDZu3NbFC2PISm9e8ZZ7AKDALSdksJGWzkJQtYGRexShaWpxcUJyUnmuk
	V5yYW1yal66XnJ+7iRESUcU7GF9ssDrEKMDBqMTDW8GpHSzEmlhWXJl7iFGCg1lJhPeaLlCI
	NyWxsiq1KD++qDQntfgQIxMHp1QD40z7e4Fck/jKbnuLWT9zXTfhUXF8YGORzQrH+Kyvwum/
	Aj02s3PofdrJ8Uvx0h1bl8jT73XjDe+J9cy83pL3XqhNMHnu7V9m0hLO00+HqBo070g3++Vj
	qrLj4YxHm7uzrGdxuL3JCfac3VyUG8K89V3+hfL0c90FVlrMp1l4y9+/uup+IUpaiaU4I9FQ
	i7moOBEAL0AmjIYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 20 Mar 2014 17:54:31 +0000
Grant Likely <grant.likely@linaro.org> escreveu:

> On Wed, 12 Mar 2014 10:25:56 +0000, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > On Mon, Mar 10, 2014 at 02:52:53PM +0100, Laurent Pinchart wrote:
> > > In theory unidirectional links in DT are indeed enough. However, let's not 
> > > forget the following.
> > > 
> > > - There's no such thing as single start points for graphs. Sure, in some 
> > > simple cases the graph will have a single start point, but that's not a 
> > > generic rule. For instance the camera graphs 
> > > http://ideasonboard.org/media/omap3isp.ps and 
> > > http://ideasonboard.org/media/eyecam.ps have two camera sensors, and thus two 
> > > starting points from a data flow point of view.
> > 
> > I think we need to stop thinking of a graph linked in terms of data
> > flow - that's really not useful.
> > 
> > Consider a display subsystem.  The CRTC is the primary interface for
> > the CPU - this is the "most interesting" interface, it's the interface
> > which provides access to the picture to be displayed for the CPU.  Other
> > interfaces are secondary to that purpose - reading the I2C DDC bus for
> > the display information is all secondary to the primary purpose of
> > displaying a picture.
> > 
> > For a capture subsystem, the primary interface for the CPU is the frame
> > grabber (whether it be an already encoded frame or not.)  The sensor
> > devices are all secondary to that.
> > 
> > So, the primary software interface in each case is where the data for
> > the primary purpose is transferred.  This is the point at which these
> > graphs should commence since this is where we would normally start
> > enumeration of the secondary interfaces.
> > 
> > V4L2 even provides interfaces for this: you open the capture device,
> > which then allows you to enumerate the capture device's inputs, and
> > this in turn allows you to enumerate their properties.  You don't open
> > a particular sensor and work back up the tree.
> > 
> > I believe trying to do this according to the flow of data is just wrong.
> > You should always describe things from the primary device for the CPU
> > towards the peripheral devices and never the opposite direction.
> 
> Agreed.

I don't agree, as what's the primary device is relative. 

Actually, in the case of a media data flow, the CPU is generally not
the primary device.

Even on general purpose computers, if the full data flow is taken into
the account, the CPU is a mere device that will just be used to copy
data either to GPU and speakers or to disk, eventually doing format
conversions, when the hardware is cheap and don't provide format
converters.

On more complex devices, like the ones we want to solve with the
media controller, like an embedded hardware like a TV or a STB, the CPU
is just an ancillary component that could even hang without stopping 
TV reception, as the data flow can be fully done inside the chipset.

Regards,
Mauro
