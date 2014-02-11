Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbaBKVA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:00:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64549 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814AbaBKVAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:00:20 -0500
Date: Tue, 11 Feb 2014 22:00:04 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core
 to drivers/of
In-Reply-To: <20140212024119.7fc96f30.m.chehab@samsung.com>
Message-ID: <Pine.LNX.4.64.1402112158230.521@axis700.grange>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de>
 <CAL_Jsq+U9zU1i+STLHMBjY5BeEP6djYnJVE5X1ix-D2q_zWztQ@mail.gmail.com>
 <20140211145248.GI26684@n2100.arm.linux.org.uk> <8648675.AIXYyYlgXy@avalon>
 <1392136617.6943.33.camel@pizza.hi.pengutronix.de> <52FA5C5A.1090008@samsung.com>
 <20140212024119.7fc96f30.m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:D6FtkmbwVG9Nelko6bGusVDh9eKRukiZB6MFBKHyzmn
 vvE0t6oib/oAIYwt5FYgaPnlg65zmX3crEcJH2axhl+rUWrSUZ
 L8ngcc4LaUoVUG2z48/ZrvcgueiXeYPW/s6nijT5rVcpl1JSmZ
 tfTIv6exmvXWBQdf9dvIuABajbrh90G9uMQDv9HIkYPCzjxYTs
 SUJC3HR31rG+4e/YUHE8quYZMZHzbrrpIPogEBqouTTglwFTfG
 gt8mhmKtOpsQ8gZ3Rhh8PrzTUW5T6Q8E/oD/AP7jD8c3Xj8zLl
 Aid7zJoFiWRCzc1cGYncwnWxfNmCDvc8FdVBqnL28rFQjnFAce
 59CZTxrjcnNQXkzNHFCWMbm7xSTJfOzNThPn+DNLk3EMnfqLPa
 wa9k5fi/0arGw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Feb 2014, Mauro Carvalho Chehab wrote:

> Em Tue, 11 Feb 2014 18:22:34 +0100
> Sylwester Nawrocki <s.nawrocki@samsung.com> escreveu:
> 
> > (adding Guennadi to Cc)
> > 
> > On 11/02/14 17:36, Philipp Zabel wrote:
> > > Am Dienstag, den 11.02.2014, 16:23 +0100 schrieb Laurent Pinchart:
> > >> Hi Russell,
> > >>
> > >> On Tuesday 11 February 2014 14:52:48 Russell King - ARM Linux wrote:
> > >>> On Tue, Feb 11, 2014 at 07:56:33AM -0600, Rob Herring wrote:
> > >>>> On Tue, Feb 11, 2014 at 5:45 AM, Philipp Zabel wrote:
> > >>>>> This allows to reuse the same parser code from outside the V4L2
> > >>>>> framework, most importantly from display drivers. There have been
> > >>>>> patches that duplicate the code (and I am going to send one of my own),
> > >>>>> such as
> > >>>>> http://lists.freedesktop.org/archives/dri-devel/2013-August/043308.html
> > >>>>> and others that parse the same binding in a different way:
> > >>>>> https://www.mail-archive.com/linux-omap@vger.kernel.org/msg100761.html
> > >>>>>
> > >>>>> I think that all common video interface parsing helpers should be moved
> > >>>>> to a single place, outside of the specific subsystems, so that it can
> > >>>>> be reused by all drivers.
> > >>>>
> > >>>> Perhaps that should be done rather than moving to drivers/of now and
> > >>>> then again to somewhere else.
> > >>>
> > >>> Do you have a better suggestion where it should move to?
> > >>>
> > >>> drivers/gpu/drm - no, because v4l2 wants to use it
> > >>> drivers/media/video - no, because DRM drivers want to use it
> > >>> drivers/video - no, because v4l2 and drm drivers want to use it
> > >>
> > >> Just pointing out a missing location (which might be rejected due to similar 
> > >> concerns), there's also drivers/media, which isn't V4L-specific.
> > > 
> > > Since drivers/Makefile has media/ in obj-y, moving the graph helpers to
> > > drivers/media should technically work.
> > > 
> > >>> Maybe drivers/of-graph/ ?  Or maybe it's just as good a place to move it
> > >>> into drivers/of ?
> > > 
> > > include/media/of_graph.h,
> > > drivers/media/of_graph.c?
> > 
> > drivers/media sounds like a good alternative to me.
> 
> From my side, I'm ok with putting them at drivers/media. You may add my acked-by
> for such change:
> 
> Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

Cannot see any problems with this

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> > I would just remove also v4l2_of_{parse/get}* and update the users
> > to call of_graph_* directly, there should not be many of them.
> > 
> > --
> > Thanks,
> > Sylwester
> 
> -- 
> 
> Cheers,
> Mauro
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
