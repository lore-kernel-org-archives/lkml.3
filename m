Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab3AVJcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 04:32:01 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:65523 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab3AVJbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:31:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
Date: Tue, 22 Jan 2013 09:31:24 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Matt Sealey <matt@genesi-usa.com>, LKML <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben@simtec.co.uk>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <20130121232322.GK15361@atomide.com> <50FE307F.9000701@ti.com>
In-Reply-To: <50FE307F.9000701@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301220931.24570.arnd@arndb.de>
X-Provags-ID: V02:K0:yMft+Q+SAMxynJm4tGOUC7K5OUWemQkJvGrdvgm9zyl
 sVACTdRmWKJM4JkithzqDu5Hc2FBI6JfY5JdnGgyenlYOrrdyY
 FPNnonzM/89AAJBtGwxxbR366Z6n34qbDL296urCFnGSH+HbAc
 y+xo2SwkNdeS4ycncdkVMCSooe9vmJOX32IDlwtQO7ytb7ZFsN
 12W1Ru+YXWq7LeClrGO9Ynvhs4Skw2eHCFRWyvV2ZiNQe3b6ro
 WdBlCle/YkeWBoZeen1y626PdHrwBCLHlD+8Ws8wu5R7EfeWGy
 +5ywjx4m3nL4WTs+PkhpiMOETMiyQaUMeslsAkdLYnjHcHojA0
 VqUOZ7A8Dzajrf18Ffio=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2013, Santosh Shilimkar wrote:
> On Tuesday 22 January 2013 04:53 AM, Tony Lindgren wrote:
> > * Russell King - ARM Linux <linux@arm.linux.org.uk> [130121 13:07]:
> >>
> >> As for Samsung and the rest I can't comment.  The original reason OMAP
> >> used this though was because the 32768Hz counter can't produce 100Hz
> >> without a .1% error - too much error under pre-clocksource
> >> implementations for timekeeping.  Whether that's changed with the
> >> clocksource/clockevent support needs to be checked.
> >
> > Yes that's why HZ was originally set to 128. That value (or some multiple)
> > still makes sense when the 32 KiHZ clock source is being used. Of course
> > we should rely on the local timer when running for the SoCs that have
> > them.
> >
> This is right. It was only because of the drift associated when clocked
> with 32KHz. Even on SOCs where local timers are available for power
> management reasons we need to switch to 32KHz clocked device in
> low power states. Hence the HZ value should be multiple of 32 on
> OMAP.

I need some help understanding what the two of you are saying, because
it sounds to me that you imply we cannot have a multiplatform kernel
that includes OMAP and another platform that needs (or wants) a different
HZ value.

However, I also thought that when using a proper clocksource driver,
the HZ setting has absolutely no impact on the drift of the wall clock,
because those two are decoupled.

Even when using the HZ based clocksource (for whatever reason you
would want to do that), I thought there should be no drift as long
as the CLOCK_TICK_RATE (in older kernels) or the register_refined_jiffies()
(in older kernels) setting matches the hardware timer frequency.

What am I missing?

	Arnd
