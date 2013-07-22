Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab3GVOKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 10:10:13 -0400
Received: from smtp.citrix.com ([66.165.176.89]:23564 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213Ab3GVOKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:10:12 -0400
X-IronPort-AV: E=Sophos;i="4.89,719,1367971200"; 
   d="scan'208";a="38439508"
Date: Mon, 22 Jul 2013 15:09:35 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Mark Rutland <mark.rutland@arm.com>
CC: Julien Grall <julien.grall@linaro.org>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <catalin.marinas@arm.com>
Subject: Re: [PATCH v3] xen/arm: enable PV control for ARM
In-Reply-To: <20130722134934.GB32221@e106331-lin.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1307221459200.4893@kaball.uk.xensource.com>
References: <1374490654-13373-1-git-send-email-julien.grall@linaro.org> <20130722134934.GB32221@e106331-lin.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jul 2013, Mark Rutland wrote:
> Hi,
> 
> [Adding Catalin to Cc]
> 
> On Mon, Jul 22, 2013 at 11:57:34AM +0100, Julien Grall wrote:
> > Enable power management from the toolstack for ARM guest.
> > 
> > Signed-off-by: Julien Grall <julien.grall@linaro.org>
> > 
> > ---
> >     Changes in v3:
> >         - Fix condition to compile cpu_hotplug.o
> >     Changes in v2:
> >         - Don't compile xen/cpu_hotplug.o with ARM64
> 
> My arm64 cpu hotplug series is going to be dependent on not compiling
> xen/cpu_hotplug.o. Currently I'm not able to compile an arm64 kernel
> with my patches and Xen support.
> 
> How do you intend to push this? I'd like to ensure my cpu hotplug series
> is able to go in for the next merge window.

This patch does exactly that: it makes sure cpu_hotplug is not compiled
on ARM64.
Given that this patch is for drivers/xen/Makefile, normally it goes via
Konrad's tree.


> > ---
> >  drivers/xen/Makefile |    5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> > index 2bf461a..f185e8d 100644
> > --- a/drivers/xen/Makefile
> > +++ b/drivers/xen/Makefile
> > @@ -1,9 +1,8 @@
> > -ifneq ($(CONFIG_ARM),y)
> > -obj-y	+= manage.o
> > +ifeq ($(filter y, $(CONFIG_ARM) $(CONFIG_ARM64)),)
> >  obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
> >  endif
> 
> Might it make sense to enable this based on a list the architectures
> that actually need this, rather than disabling it based on the list of
> architectures that don't?

This is more philosophical than practical, but I would expect this
limitation to go away soon, and be able to compile cpu_hotplug without
issues on ARM and ARM64 too.
