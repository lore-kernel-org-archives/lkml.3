Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaBKQh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:37:26 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34107 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbaBKQhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:37:22 -0500
Message-ID: <1392136617.6943.33.camel@pizza.hi.pengutronix.de>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from
 drivers/media/v4l2-core to drivers/of
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robherring2@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Date: Tue, 11 Feb 2014 17:36:57 +0100
In-Reply-To: <8648675.AIXYyYlgXy@avalon>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de>
	 <CAL_Jsq+U9zU1i+STLHMBjY5BeEP6djYnJVE5X1ix-D2q_zWztQ@mail.gmail.com>
	 <20140211145248.GI26684@n2100.arm.linux.org.uk> <8648675.AIXYyYlgXy@avalon>
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

Am Dienstag, den 11.02.2014, 16:23 +0100 schrieb Laurent Pinchart:
> Hi Russell,
> 
> On Tuesday 11 February 2014 14:52:48 Russell King - ARM Linux wrote:
> > On Tue, Feb 11, 2014 at 07:56:33AM -0600, Rob Herring wrote:
> > > On Tue, Feb 11, 2014 at 5:45 AM, Philipp Zabel wrote:
> > > > This allows to reuse the same parser code from outside the V4L2
> > > > framework, most importantly from display drivers. There have been
> > > > patches that duplicate the code (and I am going to send one of my own),
> > > > such as
> > > > http://lists.freedesktop.org/archives/dri-devel/2013-August/043308.html
> > > > and others that parse the same binding in a different way:
> > > > https://www.mail-archive.com/linux-omap@vger.kernel.org/msg100761.html
> > > > 
> > > > I think that all common video interface parsing helpers should be moved
> > > > to a single place, outside of the specific subsystems, so that it can
> > > > be reused by all drivers.
> > > 
> > > Perhaps that should be done rather than moving to drivers/of now and
> > > then again to somewhere else.
> > 
> > Do you have a better suggestion where it should move to?
> > 
> > drivers/gpu/drm - no, because v4l2 wants to use it
> > drivers/media/video - no, because DRM drivers want to use it
> > drivers/video - no, because v4l2 and drm drivers want to use it
> 
> Just pointing out a missing location (which might be rejected due to similar 
> concerns), there's also drivers/media, which isn't V4L-specific.

Since drivers/Makefile has media/ in obj-y, moving the graph helpers to
drivers/media should technically work.

> > Maybe drivers/of-graph/ ?  Or maybe it's just as good a place to move it
> > into drivers/of ?

include/media/of_graph.h,
drivers/media/of_graph.c?

regards
Philipp

