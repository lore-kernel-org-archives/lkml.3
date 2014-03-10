Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbaCJTSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 15:18:14 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:47476 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbaCJTSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 15:18:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
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
Subject: Re: [PATCH v6 4/8] of: Reduce indentation in of_graph_get_next_endpoint
Date: Mon, 10 Mar 2014 20:19:44 +0100
Message-ID: <1688746.6CaQoSDOni@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1394214054.16309.45.camel@paszta.hi.pengutronix.de>
References: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de> <31687163.hgTkcLrn0Z@avalon> <1394214054.16309.45.camel@paszta.hi.pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On Friday 07 March 2014 18:40:54 Philipp Zabel wrote:
> Am Freitag, den 07.03.2014, 01:12 +0100 schrieb Laurent Pinchart:
> > Hi Philipp,
> > 
> > Thank you for the patch.
> > 
> > I've submitted a fix for the of_graph_get_next_endpoint() function, but it
> > hasn't been applied yet due to the patch series that contained it needing
> > more work.
> > 
> > The patch is available at https://patchwork.linuxtv.org/patch/21946/. I
> > can rebase it on top of this series, but I still wanted to let you know
> > about it in case you would like to integrate it.
> 
> Thank you for the pointer. A pity about the timing, this will mostly
> revert my indentation patch. I'd be glad if you could rebase on top of
> the merged series.
> 
> While we look at of_graph_get_next_endpoint(), could you explain the
> reason behind the extra reference count increase on the prev node:
>
> 	/*
> 	 * Avoid dropping prev node refcount to 0 when getting the next
> 	 * child below.
> 	 */
> 	of_node_get(prev);
>
> This unfortunately makes using the function in for_each style macros a
> hassle. If that part wasn't there and all users that want to keep using
> prev after the call were expected to increase refcount themselves,
> we could have a
>
> #define of_graph_for_each_endpoint(parent, endpoint) \
> 	for (endpoint = of_graph_get_next_endpoint(parent, NULL); \
> 	     endpoint != NULL; \
> 	     endpoint = of_graph_get_next_endpoint(parent, endpoint))

I don't know what the exact design decision was (Sylwester might know), but I 
suspect it's mostly about historical reasons. I see no reason that would 
prevent modifying the current behaviour to make a for-each loop easier to 
implement.

-- 
Regards,

Laurent Pinchart

