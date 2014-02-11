Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaBKOxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 09:53:06 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:32794 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751015AbaBKOxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 09:53:04 -0500
Date: Tue, 11 Feb 2014 14:52:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rob Herring <robherring2@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from
	drivers/media/v4l2-core to drivers/of
Message-ID: <20140211145248.GI26684@n2100.arm.linux.org.uk>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> <CAL_Jsq+U9zU1i+STLHMBjY5BeEP6djYnJVE5X1ix-D2q_zWztQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+U9zU1i+STLHMBjY5BeEP6djYnJVE5X1ix-D2q_zWztQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 07:56:33AM -0600, Rob Herring wrote:
> On Tue, Feb 11, 2014 at 5:45 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > This allows to reuse the same parser code from outside the V4L2 framework,
> > most importantly from display drivers. There have been patches that duplicate
> > the code (and I am going to send one of my own), such as
> > http://lists.freedesktop.org/archives/dri-devel/2013-August/043308.html
> > and others that parse the same binding in a different way:
> > https://www.mail-archive.com/linux-omap@vger.kernel.org/msg100761.html
> >
> > I think that all common video interface parsing helpers should be moved to a
> > single place, outside of the specific subsystems, so that it can be reused
> > by all drivers.
> 
> Perhaps that should be done rather than moving to drivers/of now and
> then again to somewhere else.

Do you have a better suggestion where it should move to?

drivers/gpu/drm - no, because v4l2 wants to use it
drivers/media/video - no, because DRM drivers want to use it
drivers/video - no, because v4l2 and drm drivers want to use it

Maybe drivers/of-graph/ ?  Or maybe it's just as good a place to move it
into drivers/of ?

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
