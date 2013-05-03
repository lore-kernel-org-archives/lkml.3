Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934127Ab3ECRbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 13:31:03 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61328 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933803Ab3ECRbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 13:31:01 -0400
Date: Fri, 3 May 2013 18:30:55 +0100
From: Will Deacon <will.deacon@arm.com>
To: Christian Daudt <csd@broadcom.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@wwwdotorg.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "csd_b@daudt.org" <csd_b@daudt.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] ARM: bcm281xx: Add L2 support for Rev A2 chips
Message-ID: <20130503173055.GA19154@mudshark.cambridge.arm.com>
References: <1367542653-955-1-git-send-email-csd@broadcom.com>
 <20130503085100.GA6188@mudshark.cambridge.arm.com>
 <5183F046.9020802@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5183F046.9020802@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 06:13:42PM +0100, Christian Daudt wrote:
> On 13-05-03 01:51 AM, Will Deacon wrote:
> > On Fri, May 03, 2013 at 01:57:33AM +0100, Christian Daudt wrote:
> >> Rev A2 SoCs have an unorthodox memory re-mapping and this needs
> >> to be reflected in the cache operations.
> >> This patch adds new outer cache functions for the l2x0 driver
> >> to support this SoC revision. It also adds a new compatible
> >> value for the cache to enable this functionality.
> >>
> >> Updates from V1:
> >> - remove section 1 altogether and note that in comments
> >> - simplify section selection caused by section 1 removal
> >> - BUG_ON just in case section 1 shows up
> > Looking much better now :)
> >
> >> diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
> >> index c465fac..d70e0ab 100644
> >> --- a/arch/arm/mm/cache-l2x0.c
> >> +++ b/arch/arm/mm/cache-l2x0.c
> >> @@ -523,6 +523,147 @@ static void aurora_flush_range(unsigned long start, unsigned long end)
> >>   	}
> >>   }
> >>   
> >> +/*
> >> + * For certain Broadcom SoCs, depending on the address range, different offsets
> >> + * need to be added to the address before passing it to L2 for
> >> + * invalidation/clean/flush
> >> + *
> >> + * Section Address Range              Offset        EMI
> >> + *   1     0x00000000 - 0x3FFFFFFF    0x80000000    VC
> >> + *   2     0x40000000 - 0xBFFFFFFF    0x40000000    SYS
> >> + *   3     0xC0000000 - 0xFFFFFFFF    0x80000000    VC
> > I don't think you answered last time (or I missed it) but where is the RAM
> > in the physical memory map for boards with this L2 controller? Do you
> > actually have 3GB@0x40000000?
> There can be up to 1G for VC and 1G for SYS. Usually that translates to 
> 0x80000000-0xFFFFFFFF

Ok, in which case:

  Reviewed-by: Will Deacon <will.deacon@arm.com>

Will
