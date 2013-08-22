Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab3HVLxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:53:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42429 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab3HVLxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:53:32 -0400
Date: Thu, 22 Aug 2013 12:53:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rob Clark <robdclark@gmail.com>
Cc: Jean-Francois Moine <moinejf@free.fr>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        David Airlie <airlied@linux.ie>,
        Darren Etheridge <darren.etheridge@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/8] drm/i2c: tda998x: prepare for video input
	configuration
Message-ID: <20130822115314.GG6617@n2100.arm.linux.org.uk>
References: <20130821202646.47af66a5@armhf> <20130821223605.GA6617@n2100.arm.linux.org.uk> <20130822085313.2e8b1ae6@armhf> <CAF6AEGu6aFPaOTUPMZWhDgzCvG5L5Ok3Ld4QuJM4WZMtuVw6EQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF6AEGu6aFPaOTUPMZWhDgzCvG5L5Ok3Ld4QuJM4WZMtuVw6EQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 07:33:43AM -0400, Rob Clark wrote:
> On Thu, Aug 22, 2013 at 2:53 AM, Jean-Francois Moine <moinejf@free.fr> wrote:
> > On Wed, 21 Aug 2013 23:36:05 +0100
> > Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> >
> >> > AFAIK, the TI boards have no "pin-swapped", nor has the Cubox (there is
> >> > no need to set the bit CFG_GRA_SWAPRB of the register LCD_SPU_DMA_CTRL0
> >> > of the Dove lcd for RGB or YUV formats).
> >> >
> >> > Which board needs a special VIP configuration?
> >>
> >> If you run the NXP driver, and then run this driver, things get messed
> >> up - which has already been covered months ago when this patch was first
> >> brought up.
> >>
> >> It's there to ensure that the TDA998x is correctly configured no matter
> >> what it's previous state is, and prevent the thing being fragile as hell.
> >
> > The NXP driver will never go to the mainline, so, I don't see the
> > problem. If you want to use it to test some other drivers, you should
> > better patch it instead of adding useless code in the TDA998x driver.
> 
> I don't think it really matters for the end user if NXP isn't
> mainline.  If they are jumping between vendor kernel and mainline, and
> inheriting some state left over from the NXP driver in vendor kernel,
> it makes debugging very confusing.  It would be less of an issue if a
> warm reset actually reset the tda998x part, but that is not the case,
> it is better to rely less on the hw state when the driver is loaded,
> IMHO.

Absolutely right, thanks for backing up what I've said.  I've done exactly
that - switching between the NXP driver and the mainline driver to debug
other problems, and not having the TDA998x setup correctly just makes the
job much harder and time consuming.

I keep both drivers available in my internal git tree so that I can switch
between them when necessary.
