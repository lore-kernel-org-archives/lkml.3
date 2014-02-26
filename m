Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaBZOYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 09:24:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36519 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaBZOYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 09:24:07 -0500
Message-ID: <1393426623.3248.70.camel@paszta.hi.pengutronix.de>
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
Date: Wed, 26 Feb 2014 15:57:03 +0100
In-Reply-To: <530DE8A9.9050809@ti.com>
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de>
	 <1393340304-19005-4-git-send-email-p.zabel@pengutronix.de>
	 <530DE8A9.9050809@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

Am Mittwoch, den 26.02.2014, 15:14 +0200 schrieb Tomi Valkeinen:
> On 25/02/14 16:58, Philipp Zabel wrote:
> 
> > +Optional endpoint properties
> > +----------------------------
> > +
> > +- remote-endpoint: phandle to an 'endpoint' subnode of a remote device node.
> 
> Why is that optional? What use is an endpoint, if it's not connected to
> something?

This allows to include the an empty endpoint template in a SoC dtsi for
the convenience of board dts writers. Also, the same property is
currently listed as optional in video-interfaces.txt.

  soc.dtsi:
	display-controller {
		port {
			disp0: endpoint { };
		};
	};

  board.dts:
	#include "soc.dtsi"
	&disp0 {
		remote-endpoint = <&panel_input>;
	};
	panel {
		port {
			panel_in: endpoint {
				remote-endpoint = <&disp0>;
			};
		};
	};

Any board not using that port can just leave the endpoint disconnected.

On the other hand, the same could be achieved with Heiko Stübner's
conditional nodes dtc patch:

  soc.dtsi:
	display-controller {
		port {
			/delete-unreferenced/ disp0: endpoint { };
		};
	};

> Also, if this is being worked on, I'd like to propose the addition of
> simpler single-endpoint cases which I've been using with OMAP DSS. So if
> there's just a single endpoint for the device, which is very common, you
> can have just:
> 
> device {
> 	...
> 	endpoint { ... };
> };
> 
> However, I guess that the patch just keeps growing and growing, so maybe
> it's better to add such things later =).

Yes, that looks good. I'd be happy if we could add this in a second step
as a backwards compatible simplification.

regards
Philipp

