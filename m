Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964976AbaKNA0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:26:51 -0500
Received: from www.linutronix.de ([62.245.132.108]:49882 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964789AbaKNA0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:26:50 -0500
Date: Fri, 14 Nov 2014 01:26:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: Anatol Pomozov <anatol.pomozov@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] timekeeping: Move persistent clock registration code
 from ARM to kernel
In-Reply-To: <CALAqxLXYVLXZafNH_ag3WDFHkhMe5t23zLbvg7Sq+4_rTfy+Kw@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1411140123060.3935@nanos>
References: <1415388855-35074-1-git-send-email-anatol.pomozov@gmail.com> <20141110095325.GC12126@ulmo> <CAOMFOmXpAm5iKCLFyorTW+n9YmgZMmrDGGe736tJX8C6BYQv-A@mail.gmail.com> <alpine.DEB.2.11.1411132334400.3935@nanos>
 <CALAqxLXYVLXZafNH_ag3WDFHkhMe5t23zLbvg7Sq+4_rTfy+Kw@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014, John Stultz wrote:
> On Thu, Nov 13, 2014 at 2:46 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Aside of that I really wonder why we need that persistent_clock stuff
> > at all. We already have mechanisms to register persistent clocks AKA
> > RTCs after the early boot process and update the wall clock time
> > before we actually need it. Nothing in early boot depends on correct
> > wall clock at all.
> >
> > So instead of adding more extra persistent clock nonsense, can we just
> > move all of that to the place where it belongs, i.e. RTC?
> 
> Sigh.. I've got this on an eventual todo list.. The big problem though
> is that the RTC infrastructure can't be called with irqs off, so its
> not as optimal for measuring suspend time. Some of the suspend-time
> measurement with clocksources that don't halt is interesting here.
> 
> So we need to add to the RTC infrastructure special accessors that are
> safe when irqs are off, and we can then deprecate the persistent clock
> bits. There's still evaluation quirks with setting the time earlier in
> boot or not (possibly some rng effects as well there), but that could
> be worked out if we had the suspend timing via safe RTC interfaces
> sorted.

So we better work on this instead of creating more legacy enforcement
APIs....

Thanks,

	tglx
