Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaCMLIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 07:08:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49253 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbaCMLIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 07:08:37 -0400
Message-ID: <1394708896.3577.21.camel@paszta.hi.pengutronix.de>
Subject: Re: [GIT PULL] Move device tree graph parsing helpers to drivers/of
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Date: Thu, 13 Mar 2014 12:08:16 +0100
In-Reply-To: <20140310143758.3734FC405FA@trevor.secretlab.ca>
References: <1394126000.3622.66.camel@paszta.hi.pengutronix.de>
	 < 20140307182330.75168C40AE3@trevor.secretlab.ca>
	 <20140310102630.3cb1bcd7@ samsung.com>
	 <20140310143758.3734FC405FA@trevor.secretlab.ca>
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

Hi,

Am Montag, den 10.03.2014, 14:37 +0000 schrieb Grant Likely:
> > > Nak. I made comments that haven't been resolved yet. I've replied with
> > > more detail tonight. The big issues are how drivers handle the optional
> > > 'ports' node and I do not agree to the double-linkage in the binding
> > > description.

so as I understand it, nobody is against dropping the double-linkage
*if* we can agree on a way to recreate the backlinks in the kernel.
My current suggestion would be to parse the complete device tree into an
internal graph structure once, at boot to achieve this. This code could
look for the optional 'ports' node if and only if the parent device node
contains #address-cells != <1> or #size-cells != <0> properties.

People completely disagree about the direction the phandle links should
point in. I am still of the opinion that the generic binding should
describe just the topology, that the endpoint links in the kernel should
represent an undirected graph and the direction of links should not
matter at all for the generic graph bindings.

There's also no consensus about the simplified bindings, but this is an
issue I'd like to separate from this series.

> > If I understood well, you're requesting to revert all those six patches
> > that were imported via git pull from my tree (and from Greg and Russell),
> > right?
> > 
> > E. g. reverting those changesets:
> > 	d484700a3695 f2a575f67695 4329b93b283c 6ff60d397b17 4d56ed5a009b fd9fdb78a9bf
> > 
> > as it seems that there's no easy way to revert a git pull.
> 
> All trees containing the branch would need to be reverted.
>
> > I suspect that this will likely cause some harm when merging from our
> > trees upstream.
> 
> It means any tree containing that branch *must* be rewound. See my reply
> to rmk.

> I've made a proposal on how I could be happy with leaving the
> branches alone. I'm not particularly happy, but there is a way to
> resolve things without reverts or rewinds.

I'm not sure if maybe I misunderstood or missed a mail, but I haven't
seen a proposal to resolve the situation without rewinds. Given that
Mauro already reverted the media tree and applied conflicting changes,
that's probably not going to happen?

regards
Philipp

