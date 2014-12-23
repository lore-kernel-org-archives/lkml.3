Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbaLWMCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 07:02:21 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47230 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbaLWMCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 07:02:19 -0500
Date: Tue, 23 Dec 2014 13:01:37 +0100
From: Philipp Zabel <pza@pengutronix.de>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@pengutronix.de, Russell King <rmk+kernel@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v6 3/3] of: Add of_graph_get_port_by_id function
Message-ID: <20141223120137.GA26129@pengutronix.de>
References: <1419261091-29888-1-git-send-email-p.zabel@pengutronix.de>
 <1419261091-29888-4-git-send-email-p.zabel@pengutronix.de>
 <54994D88.3000009@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54994D88.3000009@samsung.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:55:18 up 28 days,  2:58, 63 users,  load average: 0,15, 0,36,
 0,36
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: pza@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrzej,

On Tue, Dec 23, 2014 at 12:10:00PM +0100, Andrzej Hajda wrote:
[...]
> >  /**
> > + * of_graph_get_port_by_id() - get the port matching a given id
> > + * @parent: pointer to the parent device node
> 
> Here you have 'parent' and 'node' in the code.
[...]
> Maybe I miss something but it does not handle optional 'ports' node.

You missed nothing, thank you for the comments! I'll fix both issues
like this:

struct device_node *of_graph_get_port_by_id(struct device_node *parent, u32 id)
{
	struct device_node *node, *port;

	node = of_get_child_by_name(parent, "ports");
	if (node)
		parent = node;

	for_each_child_of_node(parent, port) {
		u32 port_id = 0;

		if (of_node_cmp(port->name, "port") != 0)
			continue;
		of_property_read_u32(port, "reg", &port_id);
		if (id == port_id)
			break;
	}

	of_node_put(node);

	return port;
}

regards
Philipp
