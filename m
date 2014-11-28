Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbaK1MaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 07:30:09 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34310 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750984AbaK1MaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 07:30:07 -0500
Date: Fri, 28 Nov 2014 12:30:03 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "cooloney@gmail.com" <cooloney@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "sakari.ailus@iki.fi" <sakari.ailus@iki.fi>,
        "s.nawrocki@samsung.com" <s.nawrocki@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH/RFC v8 08/14] DT: Add documentation for exynos4-is
 'flashes' property
Message-ID: <20141128123003.GE25883@leverpostej>
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
 <1417166286-27685-9-git-send-email-j.anaszewski@samsung.com>
 <20141128111404.GB25883@leverpostej>
 <547865EA.5010700@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547865EA.5010700@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 12:09:14PM +0000, Jacek Anaszewski wrote:
> On 11/28/2014 12:14 PM, Mark Rutland wrote:
> > On Fri, Nov 28, 2014 at 09:18:00AM +0000, Jacek Anaszewski wrote:
> >> This patch adds a description of 'flashes' property
> >> to the samsung-fimc.txt.
> >>
> >> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> >> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >> Cc: Rob Herring <robh+dt@kernel.org>
> >> Cc: Pawel Moll <pawel.moll@arm.com>
> >> Cc: Mark Rutland <mark.rutland@arm.com>
> >> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> >> Cc: Kumar Gala <galak@codeaurora.org>
> >> Cc: <devicetree@vger.kernel.org>
> >> ---
> >>   .../devicetree/bindings/media/samsung-fimc.txt     |    7 +++++++
> >>   1 file changed, 7 insertions(+)
> >>
> >> diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
> >> index 922d6f8..4b7ed03 100644
> >> --- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
> >> +++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
> >> @@ -40,6 +40,12 @@ should be inactive. For the "active-a" state the camera port A must be activated
> >>   and the port B deactivated and for the state "active-b" it should be the other
> >>   way around.
> >>
> >> +Optional properties:
> >> +
> >> +- flashes - array of strings with flash led names; the name has to
> >> +	    be same with the related led label
> >> +	    (see Documentation/devicetree/bindings/leds/common.txt)
> >> +
> >
> > Why is this not an array of phandles to the LED nodes? That's much
> > better than strings.
> 
> This is because a single flash led device can control many sub-leds,
> which are represented by child nodes in the Device Tree.
> Every sub-led is registered as a separate LED Flash class device
> in the LED subsystem, but in fact they share the same struct device
> and thus have access only to the parent's phandle.

But that's a Linux infrastrcture issue, no? You don't have to use the
node from the struct device to find the relevant phandle.

> The LED Flash
> class devices are wrapped by V4L2 sub-devices and register
> asynchronously within a media device. Since the v4l2_subdev structure
> has a 'name' field, it is convenient to initialize it with
> parsed 'label' property of a child led node and match the
> sub-devices in the media device basing on it.

While that might be convenient, I don't think it's fantastic to use that
to describe the relationship, as this leaks Linux internals (e.g. I can
refer to a name that doesn't exist in the DT but happens to be what
Linux used, and it would work). Also, are the labels guaranteed to be
globally unique?

Using phandles is much better for the binding. I appreciate that this
may require more code, but IMO it's worth that for the safety and
uniformity given by the use of phandles for referring to nodes.

> > Also, I only seem to have recevied the documentation patches and none of
> > the code -- in future when posting RFC DT patches, please Cc for the
> > code too as it's useful context.
> 
> Of course, I'll keep it in mind.

Thanks!

Mark.
