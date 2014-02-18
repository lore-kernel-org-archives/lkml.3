Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422AbaBRQ0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:26:36 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41631 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbaBRQ0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:26:32 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core to drivers/of
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Rob Herring <robherring2@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
In-Reply-To: <20140218070624.GP17250@pengutronix.de>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> < CAL_Jsq+U9zU1i+STLHMBjY5BeEP6djYnJVE5X1ix-D2q_zWztQ@mail.gmail.com> < 20140217181451.7EB7FC4044D@trevor.secretlab.ca> <20140218070624.GP17250@ pengutronix.de>
Date: Tue, 18 Feb 2014 16:26:27 +0000
Message-Id: <20140218162627.32BA4C40517@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Feb 2014 08:06:24 +0100, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> Hi Grant,
> 
> On Mon, Feb 17, 2014 at 06:14:51PM +0000, Grant Likely wrote:
> > On Tue, 11 Feb 2014 07:56:33 -0600, Rob Herring <robherring2@gmail.com> wrote:
> > > On Tue, Feb 11, 2014 at 5:45 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > > > From: Philipp Zabel <philipp.zabel@gmail.com>
> > > >
> > > > This patch moves the parsing helpers used to parse connected graphs
> > > > in the device tree, like the video interface bindings documented in
> > > > Documentation/devicetree/bindings/media/video-interfaces.txt, from
> > > > drivers/media/v4l2-core to drivers/of.
> > > 
> > > This is the opposite direction things have been moving...
> > > 
> > > > This allows to reuse the same parser code from outside the V4L2 framework,
> > > > most importantly from display drivers. There have been patches that duplicate
> > > > the code (and I am going to send one of my own), such as
> > > > http://lists.freedesktop.org/archives/dri-devel/2013-August/043308.html
> > > > and others that parse the same binding in a different way:
> > > > https://www.mail-archive.com/linux-omap@vger.kernel.org/msg100761.html
> > > >
> > > > I think that all common video interface parsing helpers should be moved to a
> > > > single place, outside of the specific subsystems, so that it can be reused
> > > > by all drivers.
> > > 
> > > Perhaps that should be done rather than moving to drivers/of now and
> > > then again to somewhere else.
> > 
> > This is just parsing helpers though, isn't it? I have no problem pulling
> > helper functions into drivers/of if they are usable by multiple
> > subsystems. I don't really understand the model being used though. I
> > would appreciate a description of the usage model for these functions
> > for poor folks like me who can't keep track of what is going on in
> > subsystems.
> 
> You can find it under Documentation/devicetree/bindings/media/video-interfaces.txt

Okay, I think I'm okay with moving the helpers, but I will make one
requirement. I would like to have a short binding document describing
the pattern being used. The document above talks a lot about video
specific issues, but the helpers appear to be specifically about the
tree walking properties of the API.

g.
