Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbaE1CFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 22:05:37 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:36395 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaE1CFe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 22:05:34 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Viresh Kumar" <viresh.kumar@linaro.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <9956925.Qsz2bH3rDg@vostro.rjw.lan>
Cc: =?utf-8?q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        =?utf-8?q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Stephen Boyd" <sboyd@codeaurora.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Michal Simek" <michal.simek@xilinx.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <20140521073457.GD31687@pengutronix.de>
 <00f65d1c-a375-40e7-b30a-cd8cb3ca87fc@BN1BFFO11FD020.protection.gbl>
 <CAKohpomb+h6ZNDgJ8AwJ_J9DjMB7AP_v-cp8coG3CACo5Wt4vQ@mail.gmail.com>
 <9956925.Qsz2bH3rDg@vostro.rjw.lan>
Message-ID: <20140528020531.7816.5349@quantum>
User-Agent: alot/0.3.5
Subject: Re: [RFC PATCH 2/5] clk: Introduce 'clk_round_rate_nearest()'
Date: Tue, 27 May 2014 19:05:31 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Rafael J. Wysocki (2014-05-26 04:22:32)
> On Monday, May 26, 2014 11:59:09 AM Viresh Kumar wrote:
> > On 23 May 2014 21:44, Sören Brinkmann <soren.brinkmann@xilinx.com> wrote:
> > > Viresh: Could you imagine something similar for cpufreq? You suggested
> > > migrating to Hz resolution. I guess that would ideally mean to follow
> > > the CCF to a 64-bit type for frequencies and increasing the resolution.
> > > I have a messy patch migrating cpufreq and OPP to Hz and unsigned long
> > > that works on Zynq. But cpufreq has so many users that it would become
> > > quite an undertaking.
> > > And we'd need some new/amended OPP DT binding.
> > 
> > If we are going to migrate to Hz from KHz, I think we must consider the
> > 64 bit stuff right now, otherwise it will bite us later.
> > 
> > @Rafael: What do you think?
> 
> I agree as far as the 64-bit thing goes, but is switching to Hz really
> necessary?

Rafael,

Why should CPUfreq migrate to 64-bit if not switching to Hz? CPU clock
rates are specified as KHz in CPUfreq via an unsigned int. On 32-bit
systems that comes out to a max of 4.29THz (terahertz!)!

Or maybe you meant, "I agree that the clock framework should switch to
the 64-bit thing"?

Personally I'd like to see the clock framework and cpufreq get on the
same page (data type) for specifying clock rates, and the clock
framework really should not use a granularity like KHz. In fact we have
some fractional rates like 13.25Hz ...

Thanks,
Mike

> 
> Rafael
> 
