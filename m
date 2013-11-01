Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab3KAUrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 16:47:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab3KAUru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 16:47:50 -0400
Date: Fri, 1 Nov 2013 13:47:49 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: NeilBrown <neilb@suse.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Strange location and name for platform  devices when device-tree
 is used.
Message-ID: <20131101204749.GA19662@kroah.com>
References: <20131101145925.66e22f73@notabene.brown>
 <1383279744.28909.26.camel@pasglop>
 <1383280054.28909.30.camel@pasglop>
 <20131101160329.37f3707b@notabene.brown>
 <1383282516.28909.36.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383282516.28909.36.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 04:08:36PM +1100, Benjamin Herrenschmidt wrote:
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

How can there be device name collisions?  All platform devices _should_
be named uniquely, if not, you have bigger problems...

thanks,

greg k-h
