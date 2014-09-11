Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbaIKQJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:09:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55157 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860AbaIKQJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:09:10 -0400
Date: Thu, 11 Sep 2014 17:09:08 +0100
From: Will Deacon <will.deacon@arm.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Christopher Covington <cov@codeaurora.org>,
        Olof Johansson <olof@lixom.net>, Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Nathan Lynch <Nathan_Lynch@mentor.com>
Subject: Re: [PATCH] clocksource: arch_timer: Allow the device tree to
 specify the physical timer
Message-ID: <20140911160908.GT6158@arm.com>
References: <1410450727-8182-1-git-send-email-dianders@chromium.org>
 <5411C68B.6090308@codeaurora.org>
 <CAD=FV=XPqma5sYbn65NLEAipZFq96t_HcX96ym_cEQrqTKddOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=XPqma5sYbn65NLEAipZFq96t_HcX96ym_cEQrqTKddOQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 05:04:11PM +0100, Doug Anderson wrote:
> On Thu, Sep 11, 2014 at 8:58 AM, Christopher Covington
> <cov@codeaurora.org> wrote:
> > On 09/11/2014 11:52 AM, Doug Anderson wrote:
> >> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> >> index 5163ec1..8ca07a9 100644
> >> --- a/drivers/clocksource/arm_arch_timer.c
> >> +++ b/drivers/clocksource/arm_arch_timer.c
> >> @@ -649,6 +649,9 @@ static void __init arch_timer_init(struct device_node *np)
> >>               arch_timer_ppi[i] = irq_of_parse_and_map(np, i);
> >>       arch_timer_detect_rate(NULL, np);
> >>
> >> +     if (of_property_read_bool(np, "arm,use-physical-timer"))
> >> +             arch_timer_use_virtual = false;

Can you #ifdef CONFIG_ARM here please?

> >>       /*
> >>        * If HYP mode is available, we know that the physical timer
> >>        * has been configured to be accessible from PL1. Use it, so
> >>
> >
> > How's the VDSO supposed to deal with this? It currently does:
> >
> > cycle_now = arch_counter_get_cntvct()
> 
> I don't see that line of code anywhere when I do a "git grep" on linux
> or linuxnext.  Can you give me a clearer pointer?

It's in the actual vdso code (arch/arm64/kernel/vdso/gettimeofday.S):

	/* Read the virtual counter. */
	isb
	mrs	x15, cntvct_el0

Will
