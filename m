Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab3GVOkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 10:40:05 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52104 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755992Ab3GVOkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:40:03 -0400
Date: Mon, 22 Jul 2013 15:39:20 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Julien Grall <julien.grall@linaro.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH v3] xen/arm: enable PV control for ARM
Message-ID: <20130722143920.GC32221@e106331-lin.cambridge.arm.com>
References: <1374490654-13373-1-git-send-email-julien.grall@linaro.org>
 <20130722134934.GB32221@e106331-lin.cambridge.arm.com>
 <alpine.DEB.2.02.1307221459200.4893@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307221459200.4893@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 03:09:35PM +0100, Stefano Stabellini wrote:
> On Mon, 22 Jul 2013, Mark Rutland wrote:
> > Hi,
> > 
> > [Adding Catalin to Cc]
> > 
> > On Mon, Jul 22, 2013 at 11:57:34AM +0100, Julien Grall wrote:
> > > Enable power management from the toolstack for ARM guest.
> > > 
> > > Signed-off-by: Julien Grall <julien.grall@linaro.org>
> > > 
> > > ---
> > >     Changes in v3:
> > >         - Fix condition to compile cpu_hotplug.o
> > >     Changes in v2:
> > >         - Don't compile xen/cpu_hotplug.o with ARM64
> > 
> > My arm64 cpu hotplug series is going to be dependent on not compiling
> > xen/cpu_hotplug.o. Currently I'm not able to compile an arm64 kernel
> > with my patches and Xen support.
> > 
> > How do you intend to push this? I'd like to ensure my cpu hotplug series
> > is able to go in for the next merge window.
> 
> This patch does exactly that: it makes sure cpu_hotplug is not compiled
> on ARM64.

Sorry, what I meant was that my series is going to be entirely dependent
on this patch or it'll break bisection. That'll make merging things a
little painful as I'll need a stable branch with this patch to base my
series upon.

Another option would be to split this patch into two parts, one enabling
power management and one fixing things up for HOTPLUG_CPU on arm64. That
way I could take the arm64 HOTPLUG_CPU fix in my series adding arm64
HOTPLUG_CPU support.

Would that be acceptable? Have I missed something?

> Given that this patch is for drivers/xen/Makefile, normally it goes via
> Konrad's tree.
> 
> 
> > > ---
> > >  drivers/xen/Makefile |    5 ++---
> > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> > > index 2bf461a..f185e8d 100644
> > > --- a/drivers/xen/Makefile
> > > +++ b/drivers/xen/Makefile
> > > @@ -1,9 +1,8 @@
> > > -ifneq ($(CONFIG_ARM),y)
> > > -obj-y	+= manage.o
> > > +ifeq ($(filter y, $(CONFIG_ARM) $(CONFIG_ARM64)),)
> > >  obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
> > >  endif
> > 
> > Might it make sense to enable this based on a list the architectures
> > that actually need this, rather than disabling it based on the list of
> > architectures that don't?
> 
> This is more philosophical than practical, but I would expect this
> limitation to go away soon, and be able to compile cpu_hotplug without
> issues on ARM and ARM64 too.
> 

Ok, that's fine then.

Thanks,
Mark.
