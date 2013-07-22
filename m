Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab3GVOqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 10:46:40 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:61591 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343Ab3GVOqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:46:38 -0400
X-IronPort-AV: E=Sophos;i="4.89,719,1367971200"; 
   d="scan'208";a="36592929"
Date: Mon, 22 Jul 2013 15:46:34 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Mark Rutland <mark.rutland@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Julien Grall <julien.grall@linaro.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH v3] xen/arm: enable PV control for ARM
In-Reply-To: <20130722143920.GC32221@e106331-lin.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1307221545030.4893@kaball.uk.xensource.com>
References: <1374490654-13373-1-git-send-email-julien.grall@linaro.org> <20130722134934.GB32221@e106331-lin.cambridge.arm.com> <alpine.DEB.2.02.1307221459200.4893@kaball.uk.xensource.com> <20130722143920.GC32221@e106331-lin.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jul 2013, Mark Rutland wrote:
> On Mon, Jul 22, 2013 at 03:09:35PM +0100, Stefano Stabellini wrote:
> > On Mon, 22 Jul 2013, Mark Rutland wrote:
> > > Hi,
> > > 
> > > [Adding Catalin to Cc]
> > > 
> > > On Mon, Jul 22, 2013 at 11:57:34AM +0100, Julien Grall wrote:
> > > > Enable power management from the toolstack for ARM guest.
> > > > 
> > > > Signed-off-by: Julien Grall <julien.grall@linaro.org>
> > > > 
> > > > ---
> > > >     Changes in v3:
> > > >         - Fix condition to compile cpu_hotplug.o
> > > >     Changes in v2:
> > > >         - Don't compile xen/cpu_hotplug.o with ARM64
> > > 
> > > My arm64 cpu hotplug series is going to be dependent on not compiling
> > > xen/cpu_hotplug.o. Currently I'm not able to compile an arm64 kernel
> > > with my patches and Xen support.
> > > 
> > > How do you intend to push this? I'd like to ensure my cpu hotplug series
> > > is able to go in for the next merge window.
> > 
> > This patch does exactly that: it makes sure cpu_hotplug is not compiled
> > on ARM64.
> 
> Sorry, what I meant was that my series is going to be entirely dependent
> on this patch or it'll break bisection. That'll make merging things a
> little painful as I'll need a stable branch with this patch to base my
> series upon.
> 
> Another option would be to split this patch into two parts, one enabling
> power management and one fixing things up for HOTPLUG_CPU on arm64. That
> way I could take the arm64 HOTPLUG_CPU fix in my series adding arm64
> HOTPLUG_CPU support.
> 
> Would that be acceptable? Have I missed something?

As I am very sensitive to painful merging situations, I think we could
split the patch in two and send upstream the fix (not compiling
cpu_hotplug.o on ARM64) in 3.11-rc2 or rc3.  Konrad, what do you think?
