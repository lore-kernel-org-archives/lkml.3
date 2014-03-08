Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaCHPtE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 10:49:04 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:60533 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaCHPtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 10:49:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH v4 1/3] [media] of: move graph helpers from drivers/media/v4l2-core to drivers/of
Date: Sat, 08 Mar 2014 16:50:33 +0100
Message-ID: <3632624.gNVi6QOfGx@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140308122321.9D433C40612@trevor.secretlab.ca>
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de> <20140226113729.A9D5AC40A89@trevor.secretlab.ca> <20140308122321.9D433C40612@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Saturday 08 March 2014 12:23:21 Grant Likely wrote:
> On Sat, 8 Mar 2014 12:46:05 +0200, Tomi Valkeinen wrote:
> > On 07/03/14 19:18, Grant Likely wrote:
> > > From a pattern perspective I have no problem with that.... From an
> > > individual driver binding perspective that is just dumb! It's fine for
> > > the ports node to be optional, but an individual driver using the
> > > binding should be explicit about which it will accept. Please use either
> > > a flag or a separate wrapper so that the driver can select the
> > > behaviour.
> > 
> > Why is that? The meaning of the DT data stays the same, regardless of
> > the existence of the 'ports' node. The driver uses the graph helpers to
> > parse the port/endpoint data, so individual drivers don't even have to
> > care about the format used.
> 
> You don't want to give options to the device tree writer. It should work
> one way and one way only. Every different combination is a different
> permutation to get wrong. The only time we should be allowing for more
> than one way to do it is when there is an existing binding that has
> proven to be insufficient and it needs to be extended, such as was done
> with interrupts-extended to deal with deficiencies in the interrupts
> property.
> 
> > As I see it, the graph helpers should allow the drivers to iterate the
> > ports and the endpoints for a port. These should work the same way, no
> > matter which abbreviated format is used in the dts.
> > 
> > >> The helper should find the two endpoints in both cases.
> > >> 
> > >> Tomi suggests an even more compact form for devices with just one port:
> > >> 	device {
> > >> 	
> > >> 		endpoint { ... };
> > >> 		
> > >> 		some-other-child { ... };
> > >> 	
> > >> 	};
> > > 
> > > That's fine. In that case the driver would specifically require the
> > > endpoint to be that one node.... although the above looks a little weird
> > 
> > The driver can't require that. It's up to the board designer to decide
> > how many endpoints are used. A driver may say that it has a single input
> > port. But the number of endpoints for that port is up to the use case.
> 
> Come now, when you're writing a driver you know if it will ever be
> possible to have more than one port. If that is the case then the
> binding should be specifically laid out for that. If there will never be
> multiple ports and the binding is unambiguous, then, and only then,
> should the shortcut be used, and only the shortcut should be accepted.

Whether multiple nodes are possible for a device is indeed known to the driver 
author, but the number of endpoints depends on the board. In most cases 
multiple endpoints are possible. If we decide that the level of simplification 
should be set in stone in the device DT bindings (i.e. making the ports and/or 
port nodes required or forbidden, but not optional), then I believe this calls 
for always having a port node even when a single port is needed. I'm fine with 
leaving the ports node out, but having no port node might be too close to 
over-simplification.

> > > to me. I would recommend that if there are other non-port child nodes
> > > then the ports should still be encapsulated by a ports node.  The device
> > > binding should not be ambiguous about which nodes are ports.
> > 
> > Hmm, ambiguous in what way?
> 
> Parsing the binding now consists of a ladder of 'ifs' that gives three
> distinct different behaviours for no benefit. You don't want that in
> bindings because it makes it more difficult to get the parsing right in
> the first place, and to make sure that all users parse it in the same
> way (Linux, U-Boot, BSD, etc). Bindings should be as absolutely simple
> as possible.
> 
> Just to be clear, I have no problem with having the option in the
> pattern, but the driver needs to be specific about what layout it
> expects.

-- 
Regards,

Laurent Pinchart

