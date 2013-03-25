Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035Ab3CYXGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 19:06:15 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:56033 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab3CYXGO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 19:06:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ADP1653 board code for Nokia RX-51
Date: Tue, 26 Mar 2013 00:07:01 +0100
Message-ID: <2342477.1D1XZpYKqh@avalon>
User-Agent: KMail/4.10 (Linux/3.7.10-gentoo; KDE/4.10.0; x86_64; ; )
In-Reply-To: <514F7419.4010104@iki.fi>
References: <201302171616.50152@pali> <201303241519.49243@pali> <514F7419.4010104@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

On Sunday 24 March 2013 23:46:01 Sakari Ailus wrote:
> Pali Rohár wrote:
> > On Thursday 07 March 2013 23:18:27 Sakari Ailus wrote:
> >> On Wed, Mar 06, 2013 at 10:44:41PM +0100, Sebastian Reichel wrote:
> >>> On Wed, Mar 06, 2013 at 09:20:16PM +0100, Pali Rohár wrote:
> >>>> On Wednesday 06 March 2013 21:12:06 Pali Rohár wrote:
> >>>>> On Sunday 17 February 2013 20:03:03 Aaro Koskinen wrote:
> >>>>>> On Sun, Feb 17, 2013 at 04:16:49PM +0100, Pali Rohár wrote:
> >>>>>>> +/*
> >>>>>>> + * arch/arm/mach-omap2/board-rx51-camera.c
> >>>>>>> + *
> >>>>>>> + * Copyright (C) 2008 Nokia Corporation
> >>>>>>> + *
> >>>>>>> + * Contact: Sakari Ailus <sakari.ailus@nokia.com>
> >>>>>>> + *          Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
> >>>>>> 
> >>>>>> You should put these people to CC... Just to see if the addresses are
> >>>>>> still valid (which I doubt).
> >>>>> 
> >>>>> Ok, trying :-)
> >>>> 
> >>>> I got "Delivery Status Notification (Failure)" for both addresses.
> >> 
> >> This is expected.
> >> 
> >>> Sakari Ailus hosts some code on github [0], which has the following
> >>> email address:
> >>> sakari.ailus+gitorious@retiisi.org.uk
> >>> 
> >>> I added it to this mail's CC.
> >>> 
> >>> [0] https://gitorious.org/~sailus
> >> 
> >> Nice to hear people are interested in this. ;-)
> >> 
> >> The primary reason I haven't tried submitting this to mainline is that
> >> ARM board code has a bad reputation these days. The N900 does not have
> >> yet support for device tree (AFAIK), which also would require a few bits
> >> and pieces on the flash driver to work.
> >> 
> >> Also the sensor and lens drivers would need at least some work before
> >> being ready for submission to mainline for camera to be usable.
> >> Unfortunately I haven't had recently time to work on this. N9(50) support
> >> has higher priority for myself. That, too, is pending the DT support for
> >> the device.
> >> 
> >> There's indeed more up-to-date code in my repository. Even if it's not
> >> too close to mainline anymore it should be a better starting point than
> >> the old kernel from MeeGo.
> >> 
> >> <URL:https://gitorious.org/omap3camera/pages/Home>
> > 
> > Hi,
> > 
> > this board code is same in your git repository and on meego obs.
> > 
> > Patch only adding support for adp1653 driver which is already in upstream
> > kernel.
> > 
> > Are there any other problems with this patch to go for upstream?
> 
> A few more things comes to mind. We depend a little bit on actual board
> code; it's not only static data. That's the configuration of the external
> clock from the ISP to the sensor. That should move to the common clock
> framework so that the ISP registers the clock and the sensor driver can then
> use it. AFAIR Laurent has done some work on that.

Yes. I hope to get the patches in v3.10.

> The peculiar detail of the rx51 is that there's a switch on the camera CCP2
> bus that selects either sensor (primary or secondary). Both sensors are
> connected to the same receiver. That isn't properly modelled currently at
> all, so that's why we have rx51_camera_set_xshutdown(). I guess it'd still
> work if you only power (i.e. open) either of the devices at a time, though.

Have you thought about how we could model that ?

> That should be all.

-- 
Regards,

Laurent Pinchart

