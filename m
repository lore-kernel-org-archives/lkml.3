Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaBZPTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:19:49 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46217 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbaBZPTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:19:47 -0500
Message-ID: <1393429676.3248.110.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v4 3/3] Documentation: of: Document graph bindings
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date: Wed, 26 Feb 2014 16:47:56 +0100
In-Reply-To: <530DFF4C.8080807@ti.com>
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de>
		 <1393340304-19005-4-git-send-email-p.zabel@pengutronix.de>
		 <530DE8A9.9050809@ti.com>
	 <1393426623.3248.70.camel@paszta.hi.pengutronix.de>
	 <530DFF4C.8080807@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 26.02.2014, 16:50 +0200 schrieb Tomi Valkeinen:
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
> (at least usually).

Well, at least the port is a physical thing. I see no reason not to have
it in the dtsi.

> It doesn't know how many endpoints, if any, a
> particular board has. That part should be up to the board dts.

...

> I've done this with OMAP as (much simplified):
> 
> SoC.dtsi:
> 
> dss: dss@58000000 {
> 	status = "disabled";
> };
> 
> Nothing else (relevant here). The binding documentation states that dss
> has one port, and information what data is needed for the port and endpoint.
> 
> board.dts:
> 
> &dss {
>         status = "ok";
> 
>         pinctrl-names = "default";
>         pinctrl-0 = <&dss_dpi_pins>;
> 
>         dpi_out: endpoint {
> 
>                 remote-endpoint = <&tfp410_in>;
>                 data-lines = <24>;
>         };
> };
> 
> That's using the shortened version without port node.

Ok, that looks compact enough. I still don't see the need to change make
the remote-endpoint property required to achieve this, though. On the
other hand, I wouldn't object to making it mandatory either.

> Of course, it's up to the developer how his dts looks like. But to me it
> makes sense to require the remote-endpoint property, as the endpoint, or
> even the port, doesn't make much sense if there's nothing to connect to.

Please let's not make it mandatory for a port node to contain an
endpoint. For any device with multiple ports we can't use the simplified
form above, and only adding the (correctly numbered) port in all the
board device trees would be a pain.

regards
Philipp

