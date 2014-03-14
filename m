Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbaCNMUA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 08:20:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44372 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbaCNMT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 08:19:59 -0400
Message-ID: <1394799579.3710.24.camel@paszta.hi.pengutronix.de>
Subject: Re: [GIT PULL] Move device tree graph parsing helpers to drivers/of
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Date: Fri, 14 Mar 2014 13:19:39 +0100
In-Reply-To: <6341585.ZqkoDDr3Wb@avalon>
References: <1394126000.3622.66.camel@paszta.hi.pengutronix.de>
	 <20140310143758.3734FC405FA@trevor.secretlab.ca>
	 <1394708896.3577.21.camel@paszta.hi.pengutronix.de>
	 <6341585.ZqkoDDr3Wb@avalon>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Am Donnerstag, den 13.03.2014, 18:13 +0100 schrieb Laurent Pinchart:
> Hi Philipp,
> 
> On Thursday 13 March 2014 12:08:16 Philipp Zabel wrote:
> > Am Montag, den 10.03.2014, 14:37 +0000 schrieb Grant Likely:
> > > > > Nak. I made comments that haven't been resolved yet. I've replied with
> > > > > more detail tonight. The big issues are how drivers handle the
> > > > > optional 'ports' node and I do not agree to the double-linkage in the
> > > > > binding description.
> > 
> > so as I understand it, nobody is against dropping the double-linkage *if* we
> > can agree on a way to recreate the backlinks in the kernel.
> 
> I'm not sure about "nobody", but even though it might not be my favorite 
> option I'd be OK with that.

Ok, I make that assumption going by the discussion about link direction
that ensued.

> > My current suggestion would be to parse the complete device tree into an
> > internal graph structure once, at boot to achieve this. This code could
> > look for the optional 'ports' node if and only if the parent device node
> > contains #address-cells != <1> or #size-cells != <0> properties.
> 
> With backlinks in DT we can assume that, if a node is the target of a link, it 
> will be compatible with the of-graph bindings, and thus parse the node to 
> locate other ports and other links. This allows parsing the full graph without 
> help of individual drivers.

Yes.

> Without backlinks in DT we need to parse the full DT to reconstruct backlinks 
> in the kernel. One possible issue with that is that we can't know whether a 
> node implements the of-graph bindings. We can use the heuristic you've 
> described above, but I wonder if it could lead to problems. Grant pointed out 
> that the compatibility string defines what binding a node uses, and that we 
> can't thus look for properties randomly. I don't think there's a risk to 
> interpret an unrelated node as part of a graph though.

False positives would just take up a bit of space in the endpoint lists,
but otherwise should be no problem, as they would only be used when
either a driver implementing the bindings is bound, or when they are
connected to other endpoints. Whether or not we scan the whole tree,
using this heuristic, is more a matter of principle.

> > People completely disagree about the direction the phandle links should
> > point in. I am still of the opinion that the generic binding should describe
> > just the topology, that the endpoint links in the kernel should represent an
> > undirected graph and the direction of links should not matter at all for the
> > generic graph bindings.
> 
> I would also not mandate a specific direction at the of-graph level and leave 
> it to subsystems (or possibly drivers) to specify the direction.

Thank you. Can everybody live with this?

regards
Philipp

