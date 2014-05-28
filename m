Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbaE1QAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:00:08 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50521 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752044AbaE1QAE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:00:04 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mike Turquette <mturquette@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        =?ISO-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 2/5] clk: Introduce 'clk_round_rate_nearest()'
Date: Wed, 28 May 2014 18:17:10 +0200
Message-ID: <1731476.hDvqXAW3JF@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140528020531.7816.5349@quantum>
References: <20140521073457.GD31687@pengutronix.de> <9956925.Qsz2bH3rDg@vostro.rjw.lan> <20140528020531.7816.5349@quantum>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 27, 2014 07:05:31 PM Mike Turquette wrote:
> Quoting Rafael J. Wysocki (2014-05-26 04:22:32)
> > On Monday, May 26, 2014 11:59:09 AM Viresh Kumar wrote:
> > > On 23 May 2014 21:44, Sören Brinkmann <soren.brinkmann@xilinx.com> wrote:
> > > > Viresh: Could you imagine something similar for cpufreq? You suggested
> > > > migrating to Hz resolution. I guess that would ideally mean to follow
> > > > the CCF to a 64-bit type for frequencies and increasing the resolution.
> > > > I have a messy patch migrating cpufreq and OPP to Hz and unsigned long
> > > > that works on Zynq. But cpufreq has so many users that it would become
> > > > quite an undertaking.
> > > > And we'd need some new/amended OPP DT binding.
> > > 
> > > If we are going to migrate to Hz from KHz, I think we must consider the
> > > 64 bit stuff right now, otherwise it will bite us later.
> > > 
> > > @Rafael: What do you think?
> > 
> > I agree as far as the 64-bit thing goes, but is switching to Hz really
> > necessary?
> 
> Rafael,
> 
> Why should CPUfreq migrate to 64-bit if not switching to Hz? CPU clock
> rates are specified as KHz in CPUfreq via an unsigned int. On 32-bit
> systems that comes out to a max of 4.29THz (terahertz!)!
> 
> Or maybe you meant, "I agree that the clock framework should switch to
> the 64-bit thing"?

That should have been something like "If we were to switch to Hz
resolution, it would be necessary to switch over to 64-bit too".

> Personally I'd like to see the clock framework and cpufreq get on the
> same page (data type) for specifying clock rates, and the clock
> framework really should not use a granularity like KHz. In fact we have
> some fractional rates like 13.25Hz ...

Well, as I said.  There's a cost to that and it is not particularly
clear to me whether or not that cost is justifiable.  And some architectures
don't even use the clock framework for cpufreq, mind you.  How many of them
do, actually?

Rafael

