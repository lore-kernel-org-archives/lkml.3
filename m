Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbaHVMKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:10:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51103 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaHVMKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:10:09 -0400
Message-ID: <1408709398.1274.17.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 5/8] of: Add of_graph_get_port_by_id function
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, kernel@pengutronix.de
Date: Fri, 22 Aug 2014 14:09:58 +0200
In-Reply-To: <2335139.eKsPusnO4R@avalon>
References: <1408453366-1366-1-git-send-email-p.zabel@pengutronix.de>
	 <1408453366-1366-6-git-send-email-p.zabel@pengutronix.de>
	 <2335139.eKsPusnO4R@avalon>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Thank you for the comments.

Am Mittwoch, den 20.08.2014, 22:13 +0200 schrieb Laurent Pinchart:
[...]
> > +	struct device_node *port = NULL;
> > +	int port_id;
> > +
> > +	while (true) {
> > +		port = of_get_next_child(node, port);
> > +		if (!port)
> > +			return NULL;
> > +		if (of_node_cmp(port->name, "port") != 0)
> > +			continue;
> > +		if (of_property_read_u32(port, "reg", &port_id)) {
> > +			if (!id)
> > +				return port;
> > +		} else {
> > +			if (id == port_id)
> > +				return port;
> > +		}
> 
> Nitpicking here, I would have written this
> 
> 		int port_id = 0;
> 
> 		port = of_get_next_child(node, port);
> 		if (!port)
> 			return NULL;
> 		if (of_node_cmp(port->name, "port") != 0)
> 			continue;
> 		of_property_read_u32(port, "reg", &port_id);
> 		if (id == port_id)
> 			return port;
> 
> That saves 8 bytes with my ARM cross-compiler (at the expense of using two 
> extra local registers).
> 
> Please free to ignore this is you find your code layout easier to read.

No, that does look sensible to me. I'll follow your suggestions and
resend the series.

regards
Philipp

