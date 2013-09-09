Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab3IIVlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 17:41:07 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39650 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755673Ab3IIVlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 17:41:05 -0400
Date: Tue, 10 Sep 2013 00:40:59 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Camera drivers for Nokia RX-51
Message-ID: <20130909214058.GB2057@valkosipuli.retiisi.org.uk>
References: <201302171616.50152@pali>
 <20130403222228.GE10541@valkosipuli.retiisi.org.uk>
 <2135333.iYIDmYH7CC@avalon>
 <201309062235.18603@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201309062235.18603@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pali,

On Fri, Sep 06, 2013 at 10:35:18PM +0200, Pali Rohár wrote:
> On Thursday 04 April 2013 15:11:27 Laurent Pinchart wrote:
> > Hi Sakari,
> > 
> > On Thursday 04 April 2013 01:22:28 Sakari Ailus wrote:
> > > On Tue, Mar 26, 2013 at 12:07:01AM +0100, Laurent Pinchart 
> wrote:
> > > > On Sunday 24 March 2013 23:46:01 Sakari Ailus wrote:
> > > > > Pali Rohár wrote:
> > > > > > On Thursday 07 March 2013 23:18:27 Sakari Ailus wrote:
> > > > > >> On Wed, Mar 06, 2013 at 10:44:41PM +0100, Sebastian 
> Reichel wrote:
> > > > > >>> On Wed, Mar 06, 2013 at 09:20:16PM +0100, Pali Rohár 
> wrote:
> > > > > >>>> On Wednesday 06 March 2013 21:12:06 Pali Rohár 
> wrote:
> > > > > >>>>> On Sunday 17 February 2013 20:03:03 Aaro Koskinen 
> wrote:
> > > > > >>>>>> On Sun, Feb 17, 2013 at 04:16:49PM +0100, Pali 
> Rohár wrote:
> > > > > >>>>>>> +/*
> > > > > >>>>>>> + * arch/arm/mach-omap2/board-rx51-camera.c
> > > > > >>>>>>> + *
> > > > > >>>>>>> + * Copyright (C) 2008 Nokia Corporation
> > > > > >>>>>>> + *
> > > > > >>>>>>> + * Contact: Sakari Ailus
> > > > > >>>>>>> <sakari.ailus@nokia.com> + *          Tuukka
> > > > > >>>>>>> Toivonen <tuukka.o.toivonen@nokia.com>
> > > > > >>>>>> 
> > > > > >>>>>> You should put these people to CC... Just to see
> > > > > >>>>>> if the addresses are still valid (which I
> > > > > >>>>>> doubt).
> > > > > >>>>> 
> > > > > >>>>> Ok, trying :-)
> > > > > >>>> 
> > > > > >>>> I got "Delivery Status Notification (Failure)" for
> > > > > >>>> both addresses.
> > > > > >> 
> > > > > >> This is expected.
> > > > > >> 
> > > > > >>> Sakari Ailus hosts some code on github [0], which
> > > > > >>> has the following email address:
> > > > > >>> sakari.ailus+gitorious@retiisi.org.uk
> > > > > >>> 
> > > > > >>> I added it to this mail's CC.
> > > > > >>> 
> > > > > >>> [0] https://gitorious.org/~sailus
> > > > > >> 
> > > > > >> Nice to hear people are interested in this. ;-)
> > > > > >> 
> > > > > >> The primary reason I haven't tried submitting this to
> > > > > >> mainline is that ARM board code has a bad reputation
> > > > > >> these days. The N900 does not have yet support for
> > > > > >> device tree (AFAIK), which also would require a few
> > > > > >> bits and pieces on the flash driver to work.
> > > > > >> 
> > > > > >> Also the sensor and lens drivers would need at least
> > > > > >> some work before being ready for submission to
> > > > > >> mainline for camera to be usable. Unfortunately I
> > > > > >> haven't had recently time to work on this. N9(50)
> > > > > >> support has higher priority for myself. That, too,
> > > > > >> is pending the DT support for the device.
> > > > > >> 
> > > > > >> There's indeed more up-to-date code in my repository.
> > > > > >> Even if it's not too close to mainline anymore it
> > > > > >> should be a better starting point than the old
> > > > > >> kernel from MeeGo.
> > > > > >> 
> > > > > >> <URL:https://gitorious.org/omap3camera/pages/Home>
> > > > > > 
> > > > > > Hi,
> > > > > > 
> > > > > > this board code is same in your git repository and on
> > > > > > meego obs.
> > > > > > 
> > > > > > Patch only adding support for adp1653 driver which is
> > > > > > already in upstream kernel.
> > > > > > 
> > > > > > Are there any other problems with this patch to go for
> > > > > > upstream?
> > > > > 
> > > > > A few more things comes to mind. We depend a little bit
> > > > > on actual board code; it's not only static data. That's
> > > > > the configuration of the external clock from the ISP to
> > > > > the sensor. That should move to the common clock
> > > > > framework so that the ISP registers the clock and the
> > > > > sensor driver can then use it. AFAIR Laurent has done
> > > > > some work on that.
> > > > 
> > > > Yes. I hope to get the patches in v3.10.
> > > 
> > > Cool! :)
> > 
> > The patches have been posted to the linux-media mailing list.
> > If the dependencies make it to v3.10 the OMAP3 ISP patches
> > should get there too.
> > 
> > > > > The peculiar detail of the rx51 is that there's a switch
> > > > > on the camera CCP2 bus that selects either sensor
> > > > > (primary or secondary). Both sensors are connected to
> > > > > the same receiver. That isn't properly modelled
> > > > > currently at all, so that's why we have
> > > > > rx51_camera_set_xshutdown(). I guess it'd still work if
> > > > > you only power (i.e. open) either of the devices at a
> > > > > time, though.
> > > > 
> > > > Have you thought about how we could model that ?
> > > 
> > > Well, the two dependent gpios could be modelled as two
> > > independent ones ( for sensor drivers), but setting the
> > > state of those gpios could fail, gpio_set_value() still
> > > returns void. This isn't pretty perhaps but as a result the
> > > initialisation of the secondary sensor to be powered up at
> > > the same time will fail since it's in reset: the xshutdown
> > > of both sensors is controlled by the same gpio as is the
> > > mux (AFAIR).
> > > 
> > > So one N900 camera specific gpio driver would be needed.
> > > It'd be a very simple driver. What do you think?
> > 
> > I think I'll need to see how the GPIOs are wired up on the
> > board.
> 
> Hello, after months, what is state of drivers now?

I have no choice except to say, much to my regret, that it's not really
better than it was half a year ago. That said, I have not taken that off my
to-do list.

Please keep in mind that the user space interface used by the omap3camd (and
implemented by omap34xxcam) is entirely unsupported in the mainline kernel.
A wrapper would need to be implemented to mimic the old interface to that
binary blob --- all the equivalent functionality is there, albeit much
better but quite different. Or it could be re-implemented.

Having working drivers is a pre-dependency to that; I agree.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
