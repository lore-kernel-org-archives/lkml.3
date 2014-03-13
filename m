Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbaCMRMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 13:12:35 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:40597 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213AbaCMRMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 13:12:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
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
Subject: Re: [GIT PULL] Move device tree graph parsing helpers to drivers/of
Date: Thu, 13 Mar 2014 18:13:46 +0100
Message-ID: <6341585.ZqkoDDr3Wb@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1394708896.3577.21.camel@paszta.hi.pengutronix.de>
References: <1394126000.3622.66.camel@paszta.hi.pengutronix.de> <20140310143758.3734FC405FA@trevor.secretlab.ca> <1394708896.3577.21.camel@paszta.hi.pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On Thursday 13 March 2014 12:08:16 Philipp Zabel wrote:
> Am Montag, den 10.03.2014, 14:37 +0000 schrieb Grant Likely:
> > > > Nak. I made comments that haven't been resolved yet. I've replied with
> > > > more detail tonight. The big issues are how drivers handle the
> > > > optional 'ports' node and I do not agree to the double-linkage in the
> > > > binding description.
> 
> so as I understand it, nobody is against dropping the double-linkage *if* we
> can agree on a way to recreate the backlinks in the kernel.

I'm not sure about "nobody", but even though it might not be my favorite 
option I'd be OK with that.

> My current suggestion would be to parse the complete device tree into an
> internal graph structure once, at boot to achieve this. This code could
> look for the optional 'ports' node if and only if the parent device node
> contains #address-cells != <1> or #size-cells != <0> properties.

With backlinks in DT we can assume that, if a node is the target of a link, it 
will be compatible with the of-graph bindings, and thus parse the node to 
locate other ports and other links. This allows parsing the full graph without 
help of individual drivers.

Without backlinks in DT we need to parse the full DT to reconstruct backlinks 
in the kernel. One possible issue with that is that we can't know whether a 
node implements the of-graph bindings. We can use the heuristic you've 
described above, but I wonder if it could lead to problems. Grant pointed out 
that the compatibility string defines what binding a node uses, and that we 
can't thus look for properties randomly. I don't think there's a risk to 
interpret an unrelated node as part of a graph though.

> People completely disagree about the direction the phandle links should
> point in. I am still of the opinion that the generic binding should describe
> just the topology, that the endpoint links in the kernel should represent an
> undirected graph and the direction of links should not matter at all for the
> generic graph bindings.

I would also not mandate a specific direction at the of-graph level and leave 
it to subsystems (or possibly drivers) to specify the direction.

> There's also no consensus about the simplified bindings, but this is an
> issue I'd like to separate from this series.
> 
> > > If I understood well, you're requesting to revert all those six patches
> > > that were imported via git pull from my tree (and from Greg and
> > > Russell), right?
> > > 
> > > E. g. reverting those changesets:
> > > 	d484700a3695 f2a575f67695 4329b93b283c 6ff60d397b17 4d56ed5a009b
> > > 	fd9fdb78a9bf
> > > as it seems that there's no easy way to revert a git pull.
> > 
> > All trees containing the branch would need to be reverted.
> > 
> > > I suspect that this will likely cause some harm when merging from our
> > > trees upstream.
> > 
> > It means any tree containing that branch *must* be rewound. See my reply
> > to rmk.
> > 
> > I've made a proposal on how I could be happy with leaving the branches
> > alone. I'm not particularly happy, but there is a way to resolve things
> > without reverts or rewinds.
> 
> I'm not sure if maybe I misunderstood or missed a mail, but I haven't seen a
> proposal to resolve the situation without rewinds. Given that Mauro already
> reverted the media tree and applied conflicting changes, that's probably not
> going to happen?

-- 
Regards,

Laurent Pinchart


