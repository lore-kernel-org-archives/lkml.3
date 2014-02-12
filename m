Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaBLJ0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:26:14 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42060 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaBLJ0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:26:10 -0500
Message-ID: <1392197154.5536.26.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH v2] [media] of: move graph helpers from
 drivers/media/v4l2-core to drivers/media
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
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Philipp Zabel <philipp.zabel@gmail.com>
Date: Wed, 12 Feb 2014 10:25:54 +0100
In-Reply-To: <52FB1FA8.2070903@ti.com>
References: <1392154905-12007-1-git-send-email-p.zabel@pengutronix.de>
	 <52FB1FA8.2070903@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

Am Mittwoch, den 12.02.2014, 09:15 +0200 schrieb Tomi Valkeinen:
> Hi,
> 
> On 11/02/14 23:41, Philipp Zabel wrote:
> > From: Philipp Zabel <philipp.zabel@gmail.com>
> > 
> > This patch moves the parsing helpers used to parse connected graphs
> > in the device tree, like the video interface bindings documented in
> > Documentation/devicetree/bindings/media/video-interfaces.txt, from
> > drivers/media/v4l2-core to drivers/media.
> > 
> > This allows to reuse the same parser code from outside the V4L2
> > framework, most importantly from display drivers.
> > The functions v4l2_of_get_next_endpoint, v4l2_of_get_remote_port,
> > and v4l2_of_get_remote_port_parent are moved. They are renamed to
> > of_graph_get_next_endpoint, of_graph_get_remote_port, and
> > of_graph_get_remote_port_parent, respectively.
> > Since there are not that many current users, switch all of them
> > to the new functions right away.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> I don't think the graphs or the parsing code has anything video
> specific. It could well be used for anything, whenever there's need to
> describe connections between devices which are not handled by the normal
> child-parent relationships. So the code could well reside in some
> generic place, in my opinion.
> 
> Also, I have no problem with having it in drivers/media, but
> drivers/video should work also. We already have other, generic, video
> related things there like hdmi infoframes and display timings.

I agree. In case anybody wants to use this for audio in the future,
media already sounds more generic than video.

> And last, it's fine to move the funcs as-is in the first place, but I
> think they should be improved a bit before non-v4l2 users use them.

The get_remote_port(_parent) are fine, I think.

> There are a couple of things I tried to accomplish with the omapdss
> specific versions in
> https://www.mail-archive.com/linux-omap@vger.kernel.org/msg100761.html:
>
> - Iterating ports and endpoints separately. If a node has multiple
> ports, I would think that the driver needs to know which port and
> endpoint combination is the current one during iteration. It's not
> enough to just get the endpoint.

Yes, I'd already have a use-case for that in enumerating the
encoders/panels connected to a single display interface (port).

On the other hand if you just want to enumerate components from the
device tree, iterating over all endpoints of all ports is useful, too.

> - Simplify cases when there's just one port and one endpoint, in which
> case the port node can be omitted from the DT data.

Also, I'd like to drop the prev reference in get_next_endpoint, then a
for_each_endpoint macro could be made from that.

regards
Philipp

