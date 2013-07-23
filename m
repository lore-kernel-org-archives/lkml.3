Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab3GWLNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 07:13:22 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39518 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755827Ab3GWLNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 07:13:21 -0400
Date: Tue, 23 Jul 2013 12:12:47 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v2 1/3] drivers: clocksource: configure event stream for
 ARM arch timer
Message-ID: <20130723111247.GG3748@MacBook-Pro.local>
References: <1371575223-21702-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1374492082-13686-2-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <20130723102334.GC3748@MacBook-Pro.local>
 <20130723103333.GB30942@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723103333.GB30942@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 11:33:33AM +0100, Will Deacon wrote:
> On Tue, Jul 23, 2013 at 11:23:34AM +0100, Catalin Marinas wrote:
> > On Mon, Jul 22, 2013 at 12:21:20PM +0100, Sudeep KarkadaNagesha wrote:
> > > From: Will Deacon <will.deacon@arm.com>
> > > 
> > > The ARM architected timer can generate events (used for waking up
> > > CPUs executing the wfe instruction) at a frequency represented as a
> > > power-of-2 divisor of the clock rate.
> > > 
> > > This patch configures the event stream, aiming for a period of 100us
> > > between events. This can be used to implement wfe-based timeouts for
> > > userspace locking implementations.
> > ...
> > > --- a/include/clocksource/arm_arch_timer.h
> > > +++ b/include/clocksource/arm_arch_timer.h
> > > @@ -29,6 +29,8 @@
> > >  #define ARCH_TIMER_PHYS_ACCESS		0
> > >  #define ARCH_TIMER_VIRT_ACCESS		1
> > >  
> > > +#define ARCH_TIMER_EVT_STREAM_FREQ	10000	/* 100us */
> > 
> > BTW, if user-space starts using this, it will become an ABI. Is this the
> > right frequency?
> 
> It doesn't quite become ABI; not all platforms will use the architected
> timers and not all timers can support an arbitrary frequency. The best we
> can do is calculate something as close to the target value as possible.

ABI in the sense that if it is available and advertised by the kernel as
such, people may use it.

> I spoke to both tools developers and some HSA driver guys about the frequency,
> and this is what ended up being suggested.
> 
> > In addition, do we want to expose this via hwcap? Something like
> > HWCAP_EVSTR100US?
> 
> Hmm, maybe, but we don't want people to try and use this for any accurate
> time measurements, so I wouldn't include the period.

Definitely not for accurate time but some user-space may find the delay
too small or too large. I'm fine without specifying the period, maybe
add a comment in the kernel like /* currently 100us */.

-- 
Catalin
