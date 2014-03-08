Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaCHPmW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 10:42:22 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:60477 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbaCHPmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 10:42:20 -0500
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
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v4 3/3] Documentation: of: Document graph bindings
Date: Sat, 08 Mar 2014 16:43:50 +0100
Message-ID: <2496453.qPbng50cuV@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140308122532.1AED9C40612@trevor.secretlab.ca>
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de> <531AE46A.2060808@ti.com> <20140308122532.1AED9C40612@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Saturday 08 March 2014 12:25:32 Grant Likely wrote:
> On Sat, 8 Mar 2014 11:35:38 +0200, Tomi Valkeinen wrote:
> > On 07/03/14 20:11, Grant Likely wrote:
> > >>> Any board not using that port can just leave the endpoint
> > >>> disconnected.
> > >> 
> > >> Hmm I see. I'm against that.
> > >> 
> > >> I think the SoC dtsi should not contain endpoint node, or even port
> > >> node (at least usually). It doesn't know how many endpoints, if any, a
> > >> particular board has. That part should be up to the board dts.
> > > 
> > > Why? We have established precedence for unused devices still being in
> > > the tree. I really see no issue with it.
> > 
> > I'm fine with having ports defined in the SoC dtsi. A port is a physical
> > thing, a group of pins, for example.
> > 
> > But an endpoint is a description of the other end of a link. To me, a
> > single endpoint makes no sense, there has to be a pair of endpoints. The
> > board may need 0 to n endpoints, and the SoC dtsi cannot know how many
> > are needed.
> > 
> > If the SoC dtsi defines a single endpoint for a port, and the board
> > needs to use two endpoints for that port, it gets really messy: one
> > endpoint is defined in the SoC dtsi, and used in the board dts. The
> > second endpoint for the same port needs to be defined separately in the
> > board file. I.e. something like:
>
> Sure. If endpoints are logical, then only create the ones actually hooked
> up. No problem there. But nor do I see any issue with having empty
> connections if the board author things it makes sense to have them in the
> dtsi.

I don't mind allowing board authors to add empty connections if they want to, 
but I think it's a good practice not to include them given that endpoint are 
logical. I would at least not include them in the of-graph DT bindings 
examples.

> > /* the first ep */
> > &port1_ep {
> > 	remote-endpoint = <&..>;
> > };
> > 
> > &port1 {
> > 	/* the second ep */
> > 	endpoint@2 {
> > 		remote-endpoint = <&..>;
> > 	};
> > };
> > 
> > Versus:
> > 
> > &port1 {
> > 	/* the first ep */
> > 	endpoint@1 {
> > 		remote-endpoint = <&..>;
> > 	};
> > 	
> > 	/* the second ep */
> > 	endpoint@2 {
> > 		remote-endpoint = <&..>;
> > 	};
> > };

-- 
Regards,

Laurent Pinchart

