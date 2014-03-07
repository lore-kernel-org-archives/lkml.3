Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbaCHFhw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 00:37:52 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:35598 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaCHFaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 00:30:20 -0500
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
In-Reply-To: <530DFF4C.8080807@ti.com>
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de>	 < 1393340304-19005-4-git-send-email-p.zabel@pengutronix.de>	 <530DE8A9. 9050809@ti.com> <1393426623.3248.70.camel@paszta.hi.pengutronix.de> < 530DFF4C.8080807@ti.com>
Date: Fri, 07 Mar 2014 18:11:32 +0000
Message-Id: <20140307181132.B2D71C40A88@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014 16:50:52 +0200, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> On 26/02/14 16:57, Philipp Zabel wrote:
> > Hi Tomi,
> > 
> > Am Mittwoch, den 26.02.2014, 15:14 +0200 schrieb Tomi Valkeinen:
> >> On 25/02/14 16:58, Philipp Zabel wrote:
> >>
> >>> +Optional endpoint properties
> >>> +----------------------------
> >>> +
> >>> +- remote-endpoint: phandle to an 'endpoint' subnode of a remote device node.
> >>
> >> Why is that optional? What use is an endpoint, if it's not connected to
> >> something?
> > 
> > This allows to include the an empty endpoint template in a SoC dtsi for
> > the convenience of board dts writers. Also, the same property is
> > currently listed as optional in video-interfaces.txt.
> > 
> >   soc.dtsi:
> > 	display-controller {
> > 		port {
> > 			disp0: endpoint { };
> > 		};
> > 	};
> > 
> >   board.dts:
> > 	#include "soc.dtsi"
> > 	&disp0 {
> > 		remote-endpoint = <&panel_input>;
> > 	};
> > 	panel {
> > 		port {
> > 			panel_in: endpoint {
> > 				remote-endpoint = <&disp0>;
> > 			};
> > 		};
> > 	};
> > 
> > Any board not using that port can just leave the endpoint disconnected.
> 
> Hmm I see. I'm against that.
> 
> I think the SoC dtsi should not contain endpoint node, or even port node
> (at least usually). It doesn't know how many endpoints, if any, a
> particular board has. That part should be up to the board dts.

Why? We have established precedence for unused devices still being in
the tree. I really see no issue with it.

g.

