Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab3KASPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 14:15:49 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:46198 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab3KASPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 14:15:46 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: Strange location and name for platform  devices when device-tree is used.
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        NeilBrown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1383282516.28909.36.camel@pasglop>
References: <20131101145925.66e22f73@notabene.brown> <1383279744.28909.26.camel@pasglop> <1383280054.28909.30.camel@pasglop> <20131101160329.37f3707b@notabene.brown> <1383282516.28909.36.camel@pasglop>
Date: Fri, 01 Nov 2013 11:04:59 -0700
Message-Id: <20131101180459.81793C40A28@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Nov 2013 16:08:36 +1100, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> On Fri, 2013-11-01 at 16:03 +1100, NeilBrown wrote:
> 
> > Do you mean we could allow multiple devices on the one bus to have the same
> > name, but get sysfs to notice and de-duplicate by mangling one name?  I don't
> > think I like that but I might have misunderstood.
> 
> What other option do we have ?
> 
> > On my device I seem to have some platform devices registered through
> > device-tree, and some registered through platform_device_add (e.g.
> > 'alarmtimer').  Guaranteeing they remain disjoint sets if the kernel is
> > allowed to evolve independently of the devicetree might be tricky....
> > Maybe we need "/sys/devices/platform" and "/sys/devices/dt_platform" ??
> 
> No, I think device-tree created platform devices should go
> to /sys/devices/platform like the "classic" ones.
> 
> The problem is really how to deal with potential name duplication. We
> could try to register, if we get -EEXIST (assuming sysfs returns the
> right stuff), try again with ".1" etc...

I'd be fine with that approach. As long as the names get created
uniquely there shouldn't be a problem.

> > Hoping someone who understands the device model better than me will help.
> 
> Greg ? :-)

There are two problems here. First, making the change moves all the DT
populated devices under the /sys/devices/platform tree, not just
platform devices.

Second, I expect there is going to be userspace breakage to move them.
I've considered moving them before, but so far have felt that being
tidier hasn't been worth the potential breakage. Userspace /shouldn't/
be relying on the node name, but we all know that userspace always does
what it should, right?

That said, I'm mostly concerned about breakage on Power machines, not on
the ARM devices in this regard. If you are convinced that I'm worrying about
nothing, then I'm fine with making the change. If anyone complains
however then it will need to be reverted.

g.
