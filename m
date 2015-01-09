Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750AbbAIN7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 08:59:49 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58994 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757730AbbAIN7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 08:59:48 -0500
Date: Fri, 9 Jan 2015 13:59:07 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Anatol Pomozov <anatol.pomozov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, John Stultz <john.stultz@linaro.org>,
        Paul Walmsley <paul@pwsan.com>, marc.zyngier@arm.com
Subject: Re: [PATCH] timekeeping: Move persistent clock registration code
 from ARM to kernel
Message-ID: <20150109135907.GF12942@leverpostej>
References: <1415388855-35074-1-git-send-email-anatol.pomozov@gmail.com>
 <20141110095325.GC12126@ulmo>
 <CAOMFOmXpAm5iKCLFyorTW+n9YmgZMmrDGGe736tJX8C6BYQv-A@mail.gmail.com>
 <alpine.DEB.2.11.1411132334400.3935@nanos>
 <CAOMFOmVziftM=pWGG-L9J-E6AHYAK7k9bmBcpS1adPboLciX9g@mail.gmail.com>
 <alpine.DEB.2.11.1411150115390.3909@nanos>
 <CAOMFOmV5=tes6Ak1eUKb2qircp8ba6jt6v-bg66Kp_-jYk9m2w@mail.gmail.com>
 <alpine.DEB.2.11.1411150154280.3909@nanos>
 <alpine.DEB.2.11.1411150212210.3909@nanos>
 <20150109094913.GB27845@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150109094913.GB27845@ulmo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 09:49:14AM +0000, Thierry Reding wrote:
> On Sat, Nov 15, 2014 at 02:38:00AM +0100, Thomas Gleixner wrote:
> > On Sat, 15 Nov 2014, Thomas Gleixner wrote:
> > > On Fri, 14 Nov 2014, Anatol Pomozov wrote:
> > > > On Fri, Nov 14, 2014 at 4:18 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > > > >> So what I suppose to do with my patch? If it does not work could
> > > > >> anyone provide patch that removes ARM arch dependency from
> > > > >> tegra20_timer.c?
> > > > >
> > > > > Huch? You want other people to solve your problems?
> > > > 
> > > > This is not the point. I provided patch that fixes the issue. Other
> > > > people said that they have ideas how to do it different (and better)
> > > > way. So I am asking to share these ideas represented as a patch.
> > > 
> > > That's not the way it works.
> > > 
> > > You sent a patch to solve an problem which you are facing.
> > > 
> > > Now the people who review the patch think that there is a better
> > > approach than moving code from arm/ to the timekeeping core code.
> > > 
> > > So it's up to you to come up with a patch which solves the problem in
> > > the right way.
> > 
> > And just for the record this whole thing is just hilarious.
> > 
> > ARM64 selects ARM_ARCH_TIMER which registers the architected timer as
> > the primary clocksource.
> > 
> > Now that timer has the following flag set:
> > 
> >     CLOCK_SOURCE_SUSPEND_NONSTOP
> > 
> > And that flag causes the core timekeeping code to use the clocksource
> > to figure out the time which the machine spent in suspend.
> 
> As I understand it the architected timer will be turned off along with
> the rest of the CPU complex on Tegra. I'm not sure if that's specific to
> Tegra or something that other SoCs may do as well.

That doesn't sound right to me: the architecture specifies that the
system counter must be implemented in an always-on power domain.

Note that that only applies to the counter, not the timers (as the
comparators can be turned off with the CPUs).

Mark.
