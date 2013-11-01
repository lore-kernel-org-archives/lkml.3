Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab3KAFIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 01:08:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:52059 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab3KAFIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 01:08:53 -0400
Message-ID: <1383282516.28909.36.camel@pasglop>
Subject: Re: Strange location and name for platform  devices when
 device-tree is used.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: NeilBrown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Date: Fri, 01 Nov 2013 16:08:36 +1100
In-Reply-To: <20131101160329.37f3707b@notabene.brown>
References: <20131101145925.66e22f73@notabene.brown>
	 <1383279744.28909.26.camel@pasglop> <1383280054.28909.30.camel@pasglop>
	 <20131101160329.37f3707b@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-01 at 16:03 +1100, NeilBrown wrote:

> Do you mean we could allow multiple devices on the one bus to have the same
> name, but get sysfs to notice and de-duplicate by mangling one name?  I don't
> think I like that but I might have misunderstood.

What other option do we have ?

> On my device I seem to have some platform devices registered through
> device-tree, and some registered through platform_device_add (e.g.
> 'alarmtimer').  Guaranteeing they remain disjoint sets if the kernel is
> allowed to evolve independently of the devicetree might be tricky....
> Maybe we need "/sys/devices/platform" and "/sys/devices/dt_platform" ??

No, I think device-tree created platform devices should go
to /sys/devices/platform like the "classic" ones.

The problem is really how to deal with potential name duplication. We
could try to register, if we get -EEXIST (assuming sysfs returns the
right stuff), try again with ".1" etc...

> Hoping someone who understands the device model better than me will help.

Greg ? :-)

 .../...

> The  'backlight' device is a virtual device.  It uses a 'pwm' device to
> provide the variable brightness to the back light.
> 
> The 'pwm' device itself is virtual, making use of a 'dmtimer' to provide the
> timing...  The timer device (timer11 in omap3.dtsi) has a 'reg' property.
> 
> A random example from current mainline is 
>   arch/arm/boot/dts/am335x-evmsk.dts
> which has 'backlight' as a virtual device compatible with pwm-backlight.
> It also has  'gpio-keys', 'gpio-leds', and 'regulator-fixed' compatible
> virtual devices.  They seem fairly common.

Ok.

Cheers,
Ben.

> Thanks,
> NeilBrown
> 
> 
> > 
> > Cheers,
> > Ben.
> > 
> > > Cheers,
> > > Ben.
> > > 
> > > > Any help understanding and/or fixing this discrepancy greatly appreciated.
> > > > 
> > > > The change of name is particularly annoying to me because one of my platform
> > > > devices is a pwm_bl.c backlight.  With a boardfile I
> > > > get /sys/class/pwm_backlight.  With devicetree the best I can get
> > > > is /sys/class/pwm_backlight.23 (or similar).  It would be really nice to have
> > > > a more stable and sensible name here.
> > > 
> > 
> 


