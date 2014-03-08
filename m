Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaCHMZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 07:25:42 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:60010 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaCHMZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 07:25:38 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v4 3/3] Documentation: of: Document graph bindings
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
In-Reply-To: <531AE46A.2060808@ti.com>
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de>	 < 1393340304-19005-4-git-send-email-p.zabel@pengutronix.de>	 <530DE8A9. 9050809@ti.com> <1393426623.3248.70.camel@paszta.hi.pengutronix.de> < 530DFF4C.8080807@ti.com> <20140307181132.B2D71C40A88@trevor.secretlab.ca> < 531AE46A.2060808@ti.com>
Date: Sat, 08 Mar 2014 12:25:32 +0000
Message-Id: <20140308122532.1AED9C40612@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Mar 2014 11:35:38 +0200, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> On 07/03/14 20:11, Grant Likely wrote:
> 
> >>> Any board not using that port can just leave the endpoint disconnected.
> >>
> >> Hmm I see. I'm against that.
> >>
> >> I think the SoC dtsi should not contain endpoint node, or even port node
> >> (at least usually). It doesn't know how many endpoints, if any, a
> >> particular board has. That part should be up to the board dts.
> > 
> > Why? We have established precedence for unused devices still being in
> > the tree. I really see no issue with it.
> 
> I'm fine with having ports defined in the SoC dtsi. A port is a physical
> thing, a group of pins, for example.
> 
> But an endpoint is a description of the other end of a link. To me, a
> single endpoint makes no sense, there has to be a pair of endpoints. The
> board may need 0 to n endpoints, and the SoC dtsi cannot know how many
> are needed.
> 
> If the SoC dtsi defines a single endpoint for a port, and the board
> needs to use two endpoints for that port, it gets really messy: one
> endpoint is defined in the SoC dtsi, and used in the board dts. The
> second endpoint for the same port needs to be defined separately in the
> board file. I.e. something like:

Sure. If endpoints are logical, then only create the ones actually
hooked up. No problem there. But nor do I see any issue with having
empty connections if the board author things it makes sense to have them
in the dtsi.

> 
> /* the first ep */
> &port1_ep {
> 	remote-endpoint = <&..>;
> };
> 
> &port1 {
> 	/* the second ep */
> 	endpoint@2 {
> 		remote-endpoint = <&..>;
> 	};
> };
> 
> Versus:
> 
> &port1 {
> 	/* the first ep */
> 	endpoint@1 {
> 		remote-endpoint = <&..>;
> 	};
> 
> 	/* the second ep */
> 	endpoint@2 {
> 		remote-endpoint = <&..>;
> 	};
> };
> 
>  Tomi
> 
> 

