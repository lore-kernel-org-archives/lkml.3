Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbaCKLGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 07:06:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41747 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423AbaCKLGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 07:06:52 -0400
Message-ID: <1394535990.3772.2.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v6 4/8] of: Reduce indentation in
 of_graph_get_next_endpoint
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Date: Tue, 11 Mar 2014 12:06:30 +0100
In-Reply-To: <1688746.6CaQoSDOni@avalon>
References: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de>
	 <31687163.hgTkcLrn0Z@avalon>
	 <1394214054.16309.45.camel@paszta.hi.pengutronix.de>
	 <1688746.6CaQoSDOni@avalon>
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

Am Montag, den 10.03.2014, 20:19 +0100 schrieb Laurent Pinchart:
> On Friday 07 March 2014 18:40:54 Philipp Zabel wrote:
> > While we look at of_graph_get_next_endpoint(), could you explain the
> > reason behind the extra reference count increase on the prev node:
> >
> > 	/*
> > 	 * Avoid dropping prev node refcount to 0 when getting the next
> > 	 * child below.
> > 	 */
> > 	of_node_get(prev);
> >
> > This unfortunately makes using the function in for_each style macros a
> > hassle. If that part wasn't there and all users that want to keep using
> > prev after the call were expected to increase refcount themselves,
> > we could have a
> >
> > #define of_graph_for_each_endpoint(parent, endpoint) \
> > 	for (endpoint = of_graph_get_next_endpoint(parent, NULL); \
> > 	     endpoint != NULL; \
> > 	     endpoint = of_graph_get_next_endpoint(parent, endpoint))
> 
> I don't know what the exact design decision was (Sylwester might know), but I 
> suspect it's mostly about historical reasons. I see no reason that would 
> prevent modifying the current behaviour to make a for-each loop easier to 
> implement.

Thanks, I'll include a patch to change this in the next round, then.

regards
Philipp

