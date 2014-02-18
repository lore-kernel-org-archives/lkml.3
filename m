Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbaBRNmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 08:42:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33130 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066AbaBRNmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 08:42:07 -0500
Message-ID: <1392730903.3606.35.camel@pizza.hi.pengutronix.de>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from
 drivers/media/v4l2-core to drivers/of
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>,
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
Date: Tue, 18 Feb 2014 14:41:43 +0100
In-Reply-To: <20140217181451.7EB7FC4044D@trevor.secretlab.ca>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de>
	 < CAL_Jsq+U9zU1i+STLHMBjY5BeEP6djYnJVE5X1ix-D2q_zWztQ@mail.gmail.com>
	 <20140217181451.7EB7FC4044D@trevor.secretlab.ca>
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

Hi Grant,

Am Montag, den 17.02.2014, 18:14 +0000 schrieb Grant Likely:
> On Tue, 11 Feb 2014 07:56:33 -0600, Rob Herring <robherring2@gmail.com> wrote:
> > On Tue, Feb 11, 2014 at 5:45 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > > From: Philipp Zabel <philipp.zabel@gmail.com>
> > >
> > > This patch moves the parsing helpers used to parse connected graphs
> > > in the device tree, like the video interface bindings documented in
> > > Documentation/devicetree/bindings/media/video-interfaces.txt, from
> > > drivers/media/v4l2-core to drivers/of.
> > 
> > This is the opposite direction things have been moving...
> > 
> > > This allows to reuse the same parser code from outside the V4L2 framework,
> > > most importantly from display drivers. There have been patches that duplicate
> > > the code (and I am going to send one of my own), such as
> > > http://lists.freedesktop.org/archives/dri-devel/2013-August/043308.html
> > > and others that parse the same binding in a different way:
> > > https://www.mail-archive.com/linux-omap@vger.kernel.org/msg100761.html
> > >
> > > I think that all common video interface parsing helpers should be moved to a
> > > single place, outside of the specific subsystems, so that it can be reused
> > > by all drivers.
> > 
> > Perhaps that should be done rather than moving to drivers/of now and
> > then again to somewhere else.
> 
> This is just parsing helpers though, isn't it? I have no problem pulling
> helper functions into drivers/of if they are usable by multiple
> subsystems. I don't really understand the model being used though. I
> would appreciate a description of the usage model for these functions
> for poor folks like me who can't keep track of what is going on in
> subsystems.

I have taken the liberty to put you on Cc: for the i.MX drm series that
I'd like to use these helpers in. The patch in question is
"[RFC PATCH v3 3/9] staging: imx-drm-core: Use OF graph to find
components and connections between encoder and crtcs"
(http://www.spinics.net/lists/arm-kernel/msg308542.html).
It currently uses local copies (s/of_graph/imx_drm_of/) of the
get_next_endpoint, get_remote_port, and get_remote_port_parent
functions to obtain all necessary components for the componentized
imx-drm device, and to map the connections between crtcs (display
interface ports) and encoders.

regards
Philipp

