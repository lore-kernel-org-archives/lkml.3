Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaEETvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 15:51:45 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36624 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbaEETvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 15:51:43 -0400
Date: Mon, 5 May 2014 12:51:39 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Sebastian Reichel <sre@kernel.org>, Sebastian Reichel <sre@ring0.de>,
        linux-input@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/5] Input: add common DT binding for touchscreens
Message-ID: <20140505195139.GA26978@core.coreip.homeip.net>
References: <1398470179-20880-1-git-send-email-sre@kernel.org>
 <1398470179-20880-2-git-send-email-sre@kernel.org>
 <20140505194125.GD25949@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505194125.GD25949@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 12:41:26PM -0700, Tony Lindgren wrote:
> * Sebastian Reichel <sre@kernel.org> [140425 16:56]:
> > Add common DT binding documentation for touchscreen devices and
> > implement input_parse_touchscreen_of_params, which parses the common
> > properties and configures the input device accordingly.
> > 
> > The method currently does not interpret the axis inversion properties,
> > since there is no matching flag in the generic linux input device.
> > 
> > Signed-off-by: Sebastian Reichel <sre@kernel.org>
> > ---
> >  .../bindings/input/touchscreen/touchscreen.txt     | 27 +++++++++++++++++
> >  drivers/input/input.c                              | 34 ++++++++++++++++++++++
> >  include/linux/input.h                              |  8 +++++
> >  3 files changed, 69 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/input/touchscreen/touchscreen.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/input/touchscreen/touchscreen.txt b/Documentation/devicetree/bindings/input/touchscreen/touchscreen.txt
> > new file mode 100644
> > index 0000000..d8e0616
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/input/touchscreen/touchscreen.txt
> > @@ -0,0 +1,27 @@
> > +General Touchscreen Properties:
> > +
> > +Optional properties for Touchscreens:
> > + - touchscreen-size-x		: horizontal resolution of touchscreen
> > +				  (in pixels)
> > + - touchscreen-size-y		: vertical resolution of touchscreen
> > +				  (in pixels)
> > + - touchscreen-max-pressure	: maximum reported pressure (arbitrary range
> > +				  dependent on the controller)
> > + - touchscreen-fuzz-x		: horizontal noise value of the absolute input
> > +				  device (in pixels)
> > + - touchscreen-fuzz-y		: vertical noise value of the absolute input
> > +				  device (in pixels)
> > + - touchscreen-fuzz-pressure	: pressure noise value of the absolute input
> > +				  device (arbitrary range dependent on the
> > +				  controller)

Fuzz seems like linux-specific property, not generic one.


> > + - touchscreen-inverted-x	: X axis is inverted (boolean)
> > + - touchscreen-inverted-y	: Y axis is inverted (boolean)
> 
> We probably also need something to swap x and y depending on the
> display orientation in addition to the touchscreen-inverted-x and y.
> Just swapping x and y is not enough depending if we rotate by 270
> degrees instead of 90 degrees.
> 
> Naturally that part can be added later.

So far we've been relying on upper layers (such as tslib) to perform
such transformations rather than re-implementing it in every driver. Are
we saying that we need to implement this in input core?

Thanks.

-- 
Dmitry
