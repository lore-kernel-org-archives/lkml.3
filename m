Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbaCDKMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:12:40 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45161 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682AbaCDKMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:12:37 -0500
Message-ID: <1393927933.3917.4.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v5 3/7] of: Warn if of_graph_get_next_endpoint is called
 with the root node
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Date: Tue, 04 Mar 2014 11:12:13 +0100
In-Reply-To: <5310FB05.4000307@gmail.com>
References: <1393522540-22887-1-git-send-email-p.zabel@pengutronix.de>
	 <1393522540-22887-4-git-send-email-p.zabel@pengutronix.de>
	 <5310FB05.4000307@gmail.com>
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

Am Freitag, den 28.02.2014, 22:09 +0100 schrieb Sylwester Nawrocki:
> On 02/27/2014 06:35 PM, Philipp Zabel wrote:
> > If of_graph_get_next_endpoint is given a parentless node instead of an
> > endpoint node, it is clearly a bug.
> >
> > Signed-off-by: Philipp Zabel<p.zabel@pengutronix.de>
> > ---
> >   drivers/of/base.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/of/base.c b/drivers/of/base.c
> > index b2f223f..6e650cf 100644
> > --- a/drivers/of/base.c
> > +++ b/drivers/of/base.c
> > @@ -2028,8 +2028,8 @@ struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
> >   		of_node_put(node);
> >   	} else {
> >   		port = of_get_parent(prev);
> > -		if (!port)
> > -			/* Hm, has someone given us the root node ?... */
> > +		if (WARN_ONCE(!port, "%s(): endpoint has no parent node\n",
> > +			      __func__))
> 
> Perhaps we can add more information to this error log, e.g.
>
> 		if (WARN_ONCE(!port, "%s(): endpoint %s has no parent node\n",
> 			      __func__, prev->full_name))
> ?

Yes, I'll include this change next time.

thanks
Philipp

