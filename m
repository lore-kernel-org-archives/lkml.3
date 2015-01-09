Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbbAITso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 14:48:44 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:43808 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbbAITsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 14:48:43 -0500
Date: Fri, 9 Jan 2015 19:48:42 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Thierry Reding <thierry.reding@gmail.com>
cc: Mark Rutland <mark.rutland@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Anatol Pomozov <anatol.pomozov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, John Stultz <john.stultz@linaro.org>,
        marc.zyngier@arm.com, pdeschrijver@nvidia.com
Subject: Re: [PATCH] timekeeping: Move persistent clock registration code
 from ARM to kernel
In-Reply-To: <20150109140902.GA7526@ulmo.nvidia.com>
Message-ID: <alpine.DEB.2.02.1501091709400.28771@utopia.booyaka.com>
References: <20141110095325.GC12126@ulmo> <CAOMFOmXpAm5iKCLFyorTW+n9YmgZMmrDGGe736tJX8C6BYQv-A@mail.gmail.com> <alpine.DEB.2.11.1411132334400.3935@nanos> <CAOMFOmVziftM=pWGG-L9J-E6AHYAK7k9bmBcpS1adPboLciX9g@mail.gmail.com> <alpine.DEB.2.11.1411150115390.3909@nanos>
 <CAOMFOmV5=tes6Ak1eUKb2qircp8ba6jt6v-bg66Kp_-jYk9m2w@mail.gmail.com> <alpine.DEB.2.11.1411150154280.3909@nanos> <alpine.DEB.2.11.1411150212210.3909@nanos> <20150109094913.GB27845@ulmo> <20150109135907.GF12942@leverpostej>
 <20150109140902.GA7526@ulmo.nvidia.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, 9 Jan 2015, Thierry Reding wrote:

> On Fri, Jan 09, 2015 at 01:59:07PM +0000, Mark Rutland wrote:
> > On Fri, Jan 09, 2015 at 09:49:14AM +0000, Thierry Reding wrote:
> >
> > > As I understand it the architected timer will be turned off along with
> > > the rest of the CPU complex on Tegra. I'm not sure if that's specific to
> > > Tegra or something that other SoCs may do as well.
> > 
> > That doesn't sound right to me: the architecture specifies that the
> > system counter must be implemented in an always-on power domain.
> > 
> > Note that that only applies to the counter, not the timers (as the
> > comparators can be turned off with the CPUs).
> 
> I'll let Paul comment on this, since I don't know the intimate details.

I believe Mark's comments are accurate.

In Linux terms, when deep CPU power management states are in use, the ARM 
architected "timer" is useful as a clocksource, but useless as a wakeup 
source (a clockevent device).

Regarding clocksources, my personal view is that the SoC timer IP 
blocks should be exposed as a clocksource option if the timer IP blocks 
are present in the hardware.  That written, I would expect that most 
production implementations will use the ARM architected "timer" as the 
clocksource.


- Paul
