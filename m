Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbaEMXiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 19:38:18 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:47410 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752032AbaEMXiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 19:38:16 -0400
Date: Wed, 14 May 2014 00:36:45 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Doug Anderson <dianders@chromium.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Will Deacon <will.deacon@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        David Riley <davidriley@chromium.org>,
        "olof@lixom.net" <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shawn Guo <shawn.guo@linaro.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: Don't ever downscale loops_per_jiffy in SMP
	systems#
Message-ID: <20140513233645.GN3693@n2100.arm.linux.org.uk>
References: <alpine.LFD.2.11.1405082058130.980@knanqh.ubzr> <20140509091824.GL3693@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1405091245070.980@knanqh.ubzr> <20140509182245.GM3693@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1405091640090.980@knanqh.ubzr> <CAD=FV=UJK1nSPjH-au-KtbnOZk2nC7usLD8L9neMedj6WHUp8g@mail.gmail.com> <CAD=FV=XM2URyJjV9gaE=mrp7LAEGtvi9wQGhGJi3_HYp_XzYWg@mail.gmail.com> <5372998F.6020502@wwwdotorg.org> <alpine.LFD.2.11.1405131908260.980@knanqh.ubzr> <alpine.LFD.2.11.1405131922580.980@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1405131922580.980@knanqh.ubzr>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 07:29:52PM -0400, Nicolas Pitre wrote:
> On Tue, 13 May 2014, Nicolas Pitre wrote:
> 
> > On Tue, 13 May 2014, Stephen Warren wrote:
> > 
> > > On 05/13/2014 03:50 PM, Doug Anderson wrote:
> > > ...
> > > > ...but then I found the true problem shows up when we transition
> > > > between very low frequencies on exynos, like between 200MHz and
> > > > 300MHz.  While transitioning between frequencies the system
> > > > temporarily bumps over to the "switcher" PLL running at 800MHz while
> > > > waiting for the main PLL to stabilize.  No CPUFREQ notification is
> > > > sent for that.  That means there's a period of time when we're running
> > > > at 800MHz but loops_per_jiffy is calibrated at between 200MHz and
> > > > 300MHz.
> > > > 
> > > > 
> > > > I'm welcome to any suggestions for how to address this.  It sorta
> > > > feels like it would be a common thing to have a temporary PLL during
> > > > the transition, ...
> > > 
> > > We definitely do that on Tegra for some cpufreq transitions.
> > 
> > Ouch...  If this is a common strategy to use a third frequency during a 
> > transition phase, especially if that frequency is way off (800MHz vs 
> > 200-300MHz) then it is something the cpufreq layer must capture and 
> > advertise.
> 
> Of course if only the loops_per_jiffy scaling does care about frequency 
> changes these days, and if in those cases udelay() can instead be moved 
> to a timer source on those hick-up prone platforms, then all this is 
> fairly theoretical and may not be worth pursuing.

As I've been saying... use a bloody timer. :)

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
