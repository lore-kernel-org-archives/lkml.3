Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab3JBSNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 14:13:55 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34454 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753547Ab3JBSNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 14:13:52 -0400
Date: Wed, 2 Oct 2013 19:13:47 +0100
From: Will Deacon <will.deacon@arm.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Barry Song <Baohua.Song@csr.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jingchang Lu <b35083@freescale.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH v4 00/17] 64-bit friendly generic sched_clock()
Message-ID: <20131002181347.GJ30298@mudshark.cambridge.arm.com>
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
 <51E88170.3080505@linaro.org>
 <20131002174700.GF30298@mudshark.cambridge.arm.com>
 <524C5FD2.5050406@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524C5FD2.5050406@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 07:02:58PM +0100, John Stultz wrote:
> On 10/02/2013 10:47 AM, Will Deacon wrote:
> > On Fri, Jul 19, 2013 at 12:59:44AM +0100, John Stultz wrote:
> >> On 07/18/2013 04:21 PM, Stephen Boyd wrote:
> >>> This patchset adds support for 64 bit counters in the generic
> >>> sched_clock code and converts drivers over to use it. Based
> >>> on v3.11-rc1.
> >>>
> >>> Changes since v3:
> >>>   * Move to use seqcount to fix issues with 64-bit cyc counters
> >>>   * Move to hrtimer to fix underflow/overflow errors in wraparound
> >>>     calculation
> >>>   * Use of 1 hour in clocks_calc_mult_shift
> >>>   * Converted over drivers in drivers/clocksource
> >> I've not been able to take a deep review yet, but this looks pretty much 
> >> like what we discussed last week, so I'm happy with it so far. Has this 
> >> gotten much testing (on both 32 and 64bit systems?)
> >>
> >> One detail: Most of this is likely to go in via tip/timers/core, but the 
> >> 5/17 "arch_timer: Move to generic sched_clock" will need some 
> >> synchronization with Catalin to make sure its ok to go in via tip. Not 
> >> sure what other arm64 changes are pending that would depend or collide 
> >> with that change.
> > I wouldn't expect anything more than a trivial Kconfig clash with the arm64
> > tree, if that.
> 
> So I also have a branch with these changes based on a branch with only
> the prereqs that are already merged, so I can provide a pull request
> that can go in via the aarch64 tree and won't collide with tip. Would
> that be preferrable?

I think it's simpler for us if you just take the lot via your tree, unless
you have any objections.

Cheers,

Will
