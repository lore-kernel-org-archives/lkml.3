Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbaCDKEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:04:43 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41292 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640AbaCDKEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:04:40 -0500
Message-ID: <1393927459.3917.2.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v5 6/7] of: Implement simplified graph binding for
 single port devices
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Date: Tue, 04 Mar 2014 11:04:19 +0100
In-Reply-To: <53159791.5080205@ti.com>
References: <1393522540-22887-1-git-send-email-p.zabel@pengutronix.de>
	 <1393522540-22887-7-git-send-email-p.zabel@pengutronix.de>
	 <53159791.5080205@ti.com>
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

Am Dienstag, den 04.03.2014, 11:06 +0200 schrieb Tomi Valkeinen:
> On 27/02/14 19:35, Philipp Zabel wrote:
> > For simple devices with only one port, it can be made implicit.
> > The endpoint node can be a direct child of the device node.
> 
> <snip>
> 
> > @@ -2105,9 +2112,11 @@ struct device_node *of_graph_get_remote_port_parent(
> >  	/* Get remote endpoint node. */
> >  	np = of_parse_phandle(node, "remote-endpoint", 0);
> >  
> > -	/* Walk 3 levels up only if there is 'ports' node. */
> > +	/* Walk 3 levels up only if there is 'ports' node */
> >  	for (depth = 3; depth && np; depth--) {
> >  		np = of_get_next_parent(np);
> > +		if (depth == 3 && of_node_cmp(np->name, "port"))
> > +			break;
> >  		if (depth == 2 && of_node_cmp(np->name, "ports"))
> >  			break;
> >  	}
> 
> This function becomes a bit funny. Would it be clearer just to do
> something like:
> 
> 	np = of_parse_phandle(node, "remote-endpoint", 0);
> 
> 	np = of_get_next_parent(np);
> 	if (of_node_cmp(np->name, "port") != 0)
> 		return np;
> 
> 	np = of_get_next_parent(np);
> 	if (of_node_cmp(np->name, "ports") != 0)
> 		return np;
> 
> 	np = of_get_next_parent(np);
> 	return np;

I'm not sure if this was initially crafted to reduce the number of
function calls, but rolled out it certainly is easier to read. I'll
change this as you suggest.

thanks
Philipp

